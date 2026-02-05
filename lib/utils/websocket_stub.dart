// class WebSocketPlatform {
//   static dynamic connect(String url, {Map<String, String>? headers}) {
//     throw UnsupportedError("Unsupported platform");
//   }
// }

// import 'dart:io';

// // websocket_stub.dart
// class WebSocketWrapper {
//   WebSocketWrapper(String url, {Map<String, String>? headers}) {
//     print('WebSocket not supported on this platform');
//   }
//   void send(String msg) {}
//   void close() {}
// }

// websocket_io.dart (mobile)

// class WebSocketWrapper {
//   late WebSocket _socket;
//   WebSocketWrapper(String url, {Map<String, String>? headers}) {
//     WebSocket.connect(url, headers: headers).then((socket) {
//       _socket = socket;
//       _socket.listen((msg) => print('Live data: $msg'));
//     });
//   }
//   void send(String msg) => _socket.add(msg);
//   void close() => _socket.close();
// }

// // websocket_web.dart (web)
// import 'dart:html' as html;
// class WebSocketWrapper {
//   late html.WebSocket _socket;
//   WebSocketWrapper(String url, {Map<String, String>? headers}) {
//     _socket = html.WebSocket(url);
//     if (headers != null && headers.containsKey('Cookie')) {
//       html.document.cookie = headers['Cookie']!;
//     }
//     _socket.onOpen.listen((_) => print('WebSocket connected'));
//     _socket.onMessage.listen((event) => print('Live data: ${event.data}'));
//   }
//   void send(String msg) => _socket.sendString(msg);
//   void close() => _socket.close();
// }






