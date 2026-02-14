import 'dart:async';
import 'package:flutter/material.dart';
import 'package:netdania/screens/services/socket_connection.dart';
import 'package:netdania/screens/chart/chart_controller.dart';

/// Handles WebSocket data streaming and processing
class WebSocketHandler {
  final LocalWebSocketService? webSocketService;
  final ChartController chartController;

  StreamSubscription<dynamic>? _webSocketSubscription;

  WebSocketHandler({
    required this.webSocketService,
    required this.chartController,
  });

  void setupListener() {
    if (webSocketService == null) {
      print('⚠️WARNING: No WebSocket service provided');
      return;
    }

    _webSocketSubscription = webSocketService!.stream.listen(
      _onData,
      onError: _onError,
      onDone: _onDone,
    );

    print('✅ WebSocket listener successfully attached!');
  }

  void _onData(dynamic data) {
    if (!chartController.isChartInitialized) {
      print('⚠️Chart not initialized yet, ignoring data');
      return;
    }

    if (data is Map<String, dynamic>) {
      _processWebSocketData(data);
    } else if (data is List) {
      print('📦 Processing batch of ${data.length} items');
      for (var item in data) {
        if (item is Map<String, dynamic>) {
          _processWebSocketData(item);
        }
      }
    }
  }

  void _onError(error) {
    print('│ WebSocket Error: $error');
  }

  void _onDone() {
    print('│ WebSocket connection closed for symbol: ${chartController.currentSymbol}');
  }

  void _processWebSocketData(Map<String, dynamic> data) {
    final symbol = (data['s'] ?? data['item_code'] ?? data['symbol'])
        ?.toString()
        .toUpperCase();

    if (symbol != chartController.currentSymbol.toUpperCase()) return;

    final bid = double.tryParse(data['bid']?.toString() ?? '') ?? 0.0;
    final ask = double.tryParse(data['ask']?.toString() ?? '') ?? 0.0;

    if (bid == 0 || ask == 0) return;

    chartController.updateCandle(
      bid: bid,
      ask: ask,
      timestamp: DateTime.now(),
    );
  }

  void dispose() {
    _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
  }
}