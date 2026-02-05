import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:get/get.dart';
import 'package:netdania/app/core/constants/urls.dart';
import 'package:netdania/app/getX/position_getx.dart';
import 'package:netdania/app/getX/order_getX.dart';
import 'package:netdania/app/getX/wallet_getX.dart';


class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;

  bool _isConnected = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);
  static const Duration _heartbeatInterval = Duration(seconds: 30);

  String? _token;

  void connect(String token) {
    _token = token;
    _shouldReconnect = true;
    _reconnectAttempts = 0;
    _connect();
  }

  void _connect() {
    try {
      if (_isConnected) {
        print("⚠ WebSocket already connected");
        return;
      }

      final wsUrlString = ApiUrl.wsUrl(_token!);
      print("🔌 Connecting to WebSocket: $wsUrlString");

      _channel = WebSocketChannel.connect(Uri.parse(wsUrlString));

      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      _isConnected = true;
      _reconnectAttempts = 0;
      print("✓ WebSocket connected successfully");

      _startHeartbeat();
    } catch (e) {
      print("✗ WebSocket connection error → $e");
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      print("📨 WebSocket message received: $data");
      final code = data['notification_code'];
      // Check for notification code 5002 (position update)
      if (code == 5002) {
        _handlePositionUpdate(data, action: 'add');
      } else if (code == 5022) {
        _handlePositionUpdate(data, action: 'update');
      } else if (code == 5001) {
        _handleOrderUpdate(data, action: 'add');
      } else if (code == 5011) {
        _handleOrderUpdate(data, action: 'update');
      } else if (code == 1001) {
        // Code 1001 = Balance update
        _handleWalletUpdate(data, field: 'balance');
      } else if (code == 1002) {
        // Code 1002 = Margin update
        _handleWalletUpdate(data, field: 'margin');
      }
    } catch (e) {
      print("✗ Error parsing WebSocket message → $e");
    }
  }

  void _handlePositionUpdate(
    Map<String, dynamic> data, {
    required String action,
  }) {
    try {
      print(
        "📊 Position $action received (code: ${data['notification_code']})",
      );

      final positionsController = Get.find<PositionsController>();

      if (data.containsKey('data')) {
        final positionData = data['data'];
        if (positionData is Map<String, dynamic>) {
          positionsController.handleWebSocketUpdate({
            'action': action,
            'position': positionData,
          });
        }
      } else {
        print("⚠ No 'data' field found in position update");
      }
    } catch (e) {
      print("✗ Error handling position $action → $e");
    }
  }

  void _handleOrderUpdate(Map<String, dynamic> data, {String? action}) {
    try {
      print(
        "📋 Order ${action ?? 'update'} received (code: ${data['notification_code']})",
      );

      if (!Get.isRegistered<OrderController>()) {
        print("⚠ OrderController not registered, skipping order update");
        return;
      }

      final orderController = Get.find<OrderController>();

      if (data.containsKey('data')) {
        final orderData = data['data'];
        if (orderData is Map<String, dynamic>) {
          String updateAction = action ?? 'add';

          final orderStatus = orderData['order_status'];
          if (orderStatus == 3 || orderStatus == 4) {
            updateAction = 'remove';
          } else if (orderStatus == 1) {
            updateAction = 'add';
          }

          orderController.handleWebSocketUpdate({
            'action': updateAction,
            'order': orderData,
            'pendingOrderId': orderData['order_id'],
          });
        }
      } else {
        print("⚠ No 'data' field found in order update");
      }
    } catch (e) {
      print("✗ Error handling order update → $e");
    }
  }

  void _handleWalletUpdate(Map<String, dynamic> data, {required String field}) {
    try {
      print(
        "💰 Wallet $field update received (code: ${data['notification_code']})",
      );

      // Check if WalletController is registered
      if (!Get.isRegistered<WalletController>()) {
        print("⚠ WalletController not registered, skipping wallet update");
        return;
      }

      final walletController = Get.find<WalletController>();

      // Call handleWebSocketUpdate which will fetch fresh wallet data
      walletController.handleWebSocketUpdate({'field': field});
    } catch (e) {
      print("✗ Error handling wallet update → $e");
    }
  }

  void _onError(dynamic error) {
    print("✗ WebSocket error → $error");
    _isConnected = false;
    _scheduleReconnect();
  }

  void _onDone() {
    print("🔌 WebSocket connection closed");
    _isConnected = false;
    _stopHeartbeat();

    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print("✗ Max reconnection attempts reached. Stopping reconnection.");
      return;
    }

    _reconnectAttempts++;
    print(
      "⏳ Scheduling reconnect attempt $_reconnectAttempts/$_maxReconnectAttempts in ${_reconnectDelay.inSeconds}s",
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (_shouldReconnect && !_isConnected) {
        _connect();
      }
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
      if (_isConnected) {
        try {
          _channel?.sink.add(
            jsonEncode({
              'type': 'ping',
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            }),
          );
          // print("💓 Heartbeat sent");
        } catch (e) {
          print("✗ Heartbeat failed → $e");
        }
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void send(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      try {
        _channel!.sink.add(jsonEncode(message));
        print("📤 WebSocket message sent: $message");
      } catch (e) {
        print("✗ Failed to send WebSocket message → $e");
      }
    } else {
      print("⚠ Cannot send message - WebSocket not connected");
    }
  }

  void disconnect() {
    print("🔌 Disconnecting WebSocket");
    _shouldReconnect = false;
    _isConnected = false;

    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();

    _channel = null;
    _subscription = null;
    print("✓ WebSocket disconnected");
  }

  bool get isConnected => _isConnected;

  void reconnect() {
    if (_token == null) {
      print("✗ Cannot reconnect - no token available");
      return;
    }

    disconnect();
    Future.delayed(const Duration(milliseconds: 500), () {
      connect(_token!);
    });
  }
}
