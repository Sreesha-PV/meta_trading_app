import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netdania/screens/services/authservices.dart';

class OHLCService {
  static const String baseUrl = 'https://uat.ax1systems.com/ohcl/api/v1';
  static final AuthService _authService = AuthService();

  /// Fetch OHLC data from API
  ///
  /// [symbol] - Trading symbol (e.g., 'AUDCAD', 'XAUUSD')
  /// [resolution] - Time resolution ('1m', '5m', '15m', '30m', '1h', '4h', '1d')
  /// [from] - Start timestamp (Unix seconds)
  /// [to] - End timestamp (Unix seconds)
  static Future<List<Map<String, dynamic>>> fetchOHLC({
    required String symbol,
    String resolution = '1m',
    int? from,
    int? to,
  }) async {
    try {
      final token = await _authService.getValidToken();
      if (token == null) {
        throw Exception('Session expired. Please login again.');
      }
      final toTimestamp = to ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final fromTimestamp =
          from ?? (toTimestamp - (5 * 60 * 60)); // Default: last 5 hours

      final url = Uri.parse(
        '$baseUrl/ohcl-limit-less?symbol=$symbol&resolution=$resolution&from=$fromTimestamp&to=$toTimestamp',
      );

      print('📡 Fetching OHLC data: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        List<dynamic> rawData = [];
        
        // Handle different response formats
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          rawData = jsonData['data'] as List<dynamic>;
        } else if (jsonData is List) {
          rawData = jsonData;
        }

        // Transform and validate the data
        final List<Map<String, dynamic>> transformedData = [];
        
        for (var item in rawData) {
          try {
            // Validate all required fields exist
            if (item['time'] == null || 
                item['open'] == null || 
                item['high'] == null || 
                item['low'] == null || 
                item['close'] == null) {
              print('⚠️ Skipping candle with missing fields: $item');
              continue;
            }

            // Parse and validate each value
            final time = _parseTime(item['time']);
            final open = _parseDouble(item['open']);
            final high = _parseDouble(item['high']);
            final low = _parseDouble(item['low']);
            final close = _parseDouble(item['close']);

            // Validate OHLC relationship (high >= low, etc.)
            if (high < low) {
              print('⚠️ Invalid OHLC: high < low for candle at time $time');
              continue;
            }

            if (open < low || open > high || close < low || close > high) {
              print('⚠️ Invalid OHLC: open/close outside high/low range at time $time');
              continue;
            }

            transformedData.add({
              'time': time,
              'open': open,
              'high': high,
              'low': low,
              'close': close,
            });
          } catch (e) {
            print('⚠️ Error parsing candle: $e - Item: $item');
            continue; // Skip invalid candles
          }
        }

        // Sort by time ascending (oldest to newest)
        transformedData.sort((a, b) => (a['time'] as int).compareTo(b['time'] as int));

        print('✅ Transformed ${transformedData.length} valid candles from ${rawData.length} raw candles');
        
        if (transformedData.isNotEmpty) {
          print('📊 First candle: ${transformedData.first}');
          print('📊 Last candle: ${transformedData.last}');
        } else {
          print('⚠️ No valid candles after transformation');
        }

        return transformedData;
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load OHLC data: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception fetching OHLC: $e');
      rethrow;
    }
  }

  /// Parse time value to int (Unix timestamp in seconds)
  static int _parseTime(dynamic value) {
    if (value == null) throw Exception('Time is null');
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.parse(value);
    throw Exception('Invalid time format: $value');
  }

  /// Parse double value safely
  static double _parseDouble(dynamic value) {
    if (value == null) throw Exception('Value is null');
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed == null) throw Exception('Cannot parse double from: $value');
      return parsed;
    }
    throw Exception('Invalid number format: $value');
  }

  /// Get available timeframes
  static List<Map<String, String>> getTimeframes() {
    return [
      {'label': '1m', 'value': '1m', 'seconds': '60'},
      {'label': '5m', 'value': '5m', 'seconds': '300'},
      {'label': '15m', 'value': '15m', 'seconds': '900'},
      {'label': '30m', 'value': '30m', 'seconds': '1800'},
      {'label': '1H', 'value': '1h', 'seconds': '3600'},
      {'label': '4H', 'value': '4h', 'seconds': '14400'},
      {'label': '1D', 'value': '1d', 'seconds': '86400'},
    ];
  }

  /// Get available indicators
  static List<Map<String, String>> getIndicators() {
    return [
      {'label': 'None', 'value': 'none'},
      {'label': 'SMA (20)', 'value': 'sma20'},
      {'label': 'SMA (50)', 'value': 'sma50'},
      {'label': 'EMA (20)', 'value': 'ema20'},
      {'label': 'Bollinger Bands', 'value': 'bb'},
      {'label': 'RSI', 'value': 'rsi'},
      {'label': 'MACD', 'value': 'macd'},
    ];
  }
}