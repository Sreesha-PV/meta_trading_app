import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:netdania/app/core/constants/urls.dart';

class LocalWebSocketService {
  late final WebSocketChannel _channel;
  final Function(Map<String, dynamic>) onData;
  final List<String> symbols;

  final StreamController<dynamic> _streamController =
      StreamController<dynamic>.broadcast();

  Stream<dynamic> get stream => _streamController.stream;

  LocalWebSocketService({
    required this.symbols,
    required this.onData,
    required String token,
  }) {
    final url = ApiUrl.wsTickerUrl(token);
    print('Connecting WebSocket to $url');

    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel.stream.listen(
      _handleMessage,
      onDone: () => print('WebSocket closed by server.'),
      onError: (error) => print('WebSocket error: $error'),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _subscribeToSymbols(symbols);
    });
  }

  void _handleMessage(dynamic data) {
    if (data is! String) return;

    final msg = data.trim();

    if (!msg.startsWith('{') && !msg.startsWith('[')) {
      print(' WS non-JSON message: $msg');
      return;
    }

    try {
      final parsed = jsonDecode(msg);

      // Emit to stream for chart
      _streamController.add(parsed);

      // Original callback handling
      if (parsed is List) {
        for (var item in parsed) {
          if (item is Map<String, dynamic>) {
            // print('📡 Raw WS data: $item');
            onData(item);
          }
        }
      } else if (parsed is Map<String, dynamic>) {
        onData(parsed);
      }
    } catch (e) {
      print(' WS parse error: $e');
    }
  }

  void _subscribeToSymbols(List<String> symbols) {
    _channel.sink.add(
      jsonEncode({
        'action': 'subscribe',
        'symbols': symbols.map((s) => s.toUpperCase()).toList(),
      }),
    );
  }

  void dispose() {
    _streamController.close();
    _channel.sink.close();
  }
}
