// import 'package:netdania/app/core/constants/urls.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   WebSocketChannel? _channel;

//   // Base URL without token
//   // final String baseWsUrl = 'ws://192.168.4.30:8500/notifications';

//   void connect(String token) {
//     try {
//       print("Token: $token");

//       // final uri = Uri.parse("$baseWsUrl?token=$token");
//       final uri = Uri.parse('${ApiUrl.wsUrl}?token=$token');


//       _channel = WebSocketChannel.connect(uri);

//       print("WebSocket connected");

//       _channel!.stream.listen(
//         (message) => print("Live notification: $message"),
//         onDone: () => print("WebSocket closed"),
//         onError: (err) => print("WebSocket error: $err"),
//       );
//     } catch (e) {
//       print("Failed to connect WebSocket: $e");
//     }
//   }

//   void disconnect() {
//     _channel?.sink.close();
//     print("WebSocket disconnected");
//   }
// }











// // import 'dart:async';
// // import 'dart:convert';

// // import 'package:web_socket_channel/web_socket_channel.dart';

// // class NotificationService {
// //   static final NotificationService _instance = NotificationService._internal();
// //   factory NotificationService() => _instance;
// //   NotificationService._internal();

// //   WebSocketChannel? _channel;
// //   final StreamController<Map<String, dynamic>> _notificationController = StreamController.broadcast();

// //   Stream<Map<String, dynamic>> get notifications => _notificationController.stream;

// //   final String baseWsUrl = 'ws://192.168.4.30:8500/notifications';

// //   void connect(String token) {
// //     final uri = Uri.parse("$baseWsUrl?token=$token");
// //     _channel = WebSocketChannel.connect(uri);

// //     // _channel!.stream.listen(
// //     //   (message) {
// //     //     try {
// //     //       final data = json.decode(message);
// //     //       _notificationController.add(data); 
// //     //     } catch (e) {
// //     //       print("Failed to parse message: $e");
// //     //     }
// //     //   },
// //     //   onDone: () => print("WebSocket closed"),
// //     //   onError: (err) => print("WebSocket error: $err"),
// //     // );
    
// // _channel!.stream.listen(
// //   (message) {
// //     print("Raw message: $message");

  
// //     Map<String, dynamic>? data;
// //     try {
// //       data = json.decode(message);
// //     } catch (_) {
     
// //       print("Plain text message: $message");
// //     }

// //     if (data != null) {
     
// //       if (data['type'] == 'order') {
// //         print("Order notification: ${data['orderId']} - ${data['status']}");
// //       } else {
// //         print("Other notification: $data");
// //       }
// //     }
// //   },
// // );
// //   }

// //   void disconnect() {
// //     _channel?.sink.close();
// //     print("WebSocket disconnected");
// //   }
// // }


// // import 'package:get/get.dart';
// // import 'dart:convert';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'order_model.dart'; 

// // class WebSocketController extends GetxController {
// //   // Observable lists for UI
// //   var watchlistOrders = <Order>[].obs;
// //   var activeOrders = <Order>[].obs;

// //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _initNotifications();
// //     _connectWebSocket();
// //   }

// //   void _initNotifications() async {
// //     var android = AndroidInitializationSettings('@mipmap/ic_launcher');
// //     var ios = IOSInitializationSettings();
// //     var initSettings = InitializationSettings(android: android, iOS: ios);
// //     await flutterLocalNotificationsPlugin.initialize(initSettings);
// //   }

// //   void _connectWebSocket() {
// //     // Your WebSocket setup here
// //     // Example: using WebSocketChannel
// //     // channel.stream.listen((message) => _handleMessage(message));
// //   }

// //   void _handleMessage(dynamic message) {
// //     final data = jsonDecode(message);

// //     // Update watchlist
// //     if (data['type'] == 'watchlist') {
// //       var orders = (data['orders'] as List)
// //           .map((e) => Order.fromJson(e))
// //           .toList();
// //       watchlistOrders.assignAll(orders);
// //     }

// //     // Update active orders
// //     if (data['type'] == 'order') {
// //       var orders = (data['orders'] as List)
// //           .map((e) => Order.fromJson(e))
// //           .toList();

// //       // Detect new order
// //       if (orders.length > activeOrders.length) {
// //         var newOrder = orders.firstWhere(
// //           (o) => !activeOrders.any((ao) => ao.id == o.id),
// //           orElse: () => null,
// //         );
// //         if (newOrder != null) {
// //           _showNotification(
// //               'New Order', '${newOrder.symbol} has been placed.');
// //         }
// //       }

// //       activeOrders.assignAll(orders);
// //     }
// //   }

// //   void _showNotification(String title, String body) async {
// //     var android = AndroidNotificationDetails(
// //         'channelId', 'channelName',
// //         importance: Importance.high);
// //     var platform = NotificationDetails(android: android);
// //     await flutterLocalNotificationsPlugin.show(0, title, body, platform);
// //   }
// // }


