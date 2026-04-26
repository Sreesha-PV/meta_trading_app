import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:netdania/app/services/authservices.dart';

class OHLCService {
  static const String baseUrl = 'https://uat.ax1systems.com/ohcl/api/v1';
  static final AuthService _authService = AuthService();
  static final StreamController<Map<String, dynamic>> _cacheUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();
  static Stream<Map<String, dynamic>> get onCacheUpdated =>
      _cacheUpdateController.stream;
  static GetStorage? _storageInstance;
  static GetStorage get _storage {
    _storageInstance ??= GetStorage('ohlc_cache');
    return _storageInstance!;
  }

  // Extended cache expiry - data stays fresh for 1 hour but remains accessible forever
  static const Duration _cacheFreshnessThreshold = Duration(hours: 1);
  static const int _maxCachedCandles = 1000;

  /// Fetch OHLC data from API with persistent caching
  ///
  /// [symbol] - Trading symbol (e.g., 'AUDCAD', 'XAUUSD')
  /// [resolution] - Time resolution ('1m', '5m', '15m', '30m', '1h', '4h', '1D')
  /// [from] - Start timestamp (Unix seconds)
  /// [to] - End timestamp (Unix seconds)
  /// [forceRefresh] - Force API call, skip cache
  static Future<List<Map<String, dynamic>>> fetchOHLC({
    required String symbol,
    String resolution = '15m',
    int? from,
    int? to,
    bool forceRefresh = false,
  }) async {
    final cacheKey = _getCacheKey(symbol, resolution);

    if (!forceRefresh) {
      final cachedData = _getCachedData(cacheKey);
      if (cachedData != null && cachedData.isNotEmpty) {
        final cacheInfo = getCacheInfo(symbol, resolution);
        final ageMinutes = (cacheInfo['age_seconds'] as int) ~/ 60;

        print(
          '📦 Using cached data for $symbol ($resolution): ${cachedData.length} candles (age: ${ageMinutes}m)',
        );

        // Only refresh in background if cache is getting stale (> 1 hour)
        if (cacheInfo['is_stale'] == true) {
          print('🔄 Cache is stale, refreshing in background');
          _refreshCacheInBackground(
            symbol: symbol,
            resolution: resolution,
            from: from,
            to: to,
            cacheKey: cacheKey,
          );
        }

        return cachedData;
      }
    }

    print('🌐 Fetching fresh data for $symbol ($resolution)');
    final data = await _fetchFromAPI(
      symbol: symbol,
      resolution: resolution,
      from: from,
      to: to,
    );

    if (data.isNotEmpty) {
      _cacheData(cacheKey, data);
    }

    return data;
  }

  static Future<List<Map<String, dynamic>>> _fetchFromAPI({
    required String symbol,
    String resolution = '15m',
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
          from ?? _calculateDefaultFrom(toTimestamp, resolution);

      final shouldIncludeResolution =
          !['1D', '1W', '1M', '3M', '6M', '1Y', '5Y'].contains(resolution);

      final url = Uri.parse(
        shouldIncludeResolution
            ? '$baseUrl/ohcl-limit-less?symbol=$symbol&resolution=$resolution&from=$fromTimestamp&to=$toTimestamp'
            : '$baseUrl/ohcl-limit-less?symbol=$symbol&resolution=$resolution',
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

        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          rawData = jsonData['data'] as List<dynamic>;
        } else if (jsonData is List) {
          rawData = jsonData;
        }

        final List<Map<String, dynamic>> transformedData = [];

        for (var item in rawData) {
          try {
            if (item['time'] == null ||
                item['open'] == null ||
                item['high'] == null ||
                item['low'] == null ||
                item['close'] == null) {
              print('⚠️ Skipping candle with missing fields: $item');
              continue;
            }

            final time = _parseTime(item['time']);
            final open = _parseDouble(item['open']);
            final high = _parseDouble(item['high']);
            final low = _parseDouble(item['low']);
            final close = _parseDouble(item['close']);

            if (high < low) {
              print('⚠️ Invalid OHLC: high < low for candle at time $time');
              continue;
            }

            if (open < low || open > high || close < low || close > high) {
              print(
                '⚠️ Invalid OHLC: open/close outside high/low range at time $time',
              );
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
            continue;
          }
        }

        transformedData.sort(
          (a, b) => (a['time'] as int).compareTo(b['time'] as int),
        );

        print(
          '✅ Transformed ${transformedData.length} valid candles from ${rawData.length} raw candles',
        );

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

  static String _getCacheKey(String symbol, String resolution) {
    return 'ohlc_${symbol}_$resolution';
  }

  /// Get cached data - NEVER expires, always returns if exists
  static List<Map<String, dynamic>>? _getCachedData(String cacheKey) {
    try {
      final cacheEntry = _storage.read(cacheKey);
      if (cacheEntry == null) {
        print('📭 No cache found for $cacheKey');
        return null;
      }

      final Map<String, dynamic> cached = Map<String, dynamic>.from(cacheEntry);

      // Check if data exists
      if (!cached.containsKey('data')) {
        print('⚠️ Cache corrupted for $cacheKey - missing data field');
        return null;
      }

      final List<dynamic> rawData = cached['data'] as List<dynamic>;
      final List<Map<String, dynamic>> data =
          rawData.map((item) => Map<String, dynamic>.from(item)).toList();

      // Calculate age for logging
      if (cached.containsKey('timestamp')) {
        final cachedTime = DateTime.parse(cached['timestamp'] as String);
        final age = DateTime.now().difference(cachedTime);
        final ageMinutes = age.inMinutes;

        if (age > _cacheFreshnessThreshold) {
          print(
            '📦 Cache exists but stale for $cacheKey (age: ${ageMinutes}m, ${data.length} candles)',
          );
        } else {
          print(
            '📦 Cache fresh for $cacheKey (age: ${ageMinutes}m, ${data.length} candles)',
          );
        }
      }

      return data;
    } catch (e) {
      print('⚠️ Error reading cache for $cacheKey: $e');
      return null;
    }
  }

  static void _cacheData(
    String cacheKey,
    List<Map<String, dynamic>> newData, {
    bool notify = false,
    String? symbol,
    String? resolution,
  }) {
    try {
      // Merge with existing cache instead of replacing
      final existing = _getCachedData(cacheKey) ?? [];

      // Build a map from existing data keyed by time
      final Map<int, Map<String, dynamic>> merged = {
        for (var c in existing) c['time'] as int: c,
      };

      // Overlay new candles (updates existing + adds new ones)
      for (var candle in newData) {
        merged[candle['time'] as int] = candle;
      }

      // Sort by time
      final List<Map<String, dynamic>> mergedList =
          merged.values.toList()
            ..sort((a, b) => (a['time'] as int).compareTo(b['time'] as int));

      final dataToCache =
          mergedList.length > _maxCachedCandles
              ? mergedList.sublist(mergedList.length - _maxCachedCandles)
              : mergedList;

      final cacheEntry = {
        'timestamp': DateTime.now().toIso8601String(),
        'cached_at_unix': DateTime.now().millisecondsSinceEpoch,
        'data': dataToCache,
        'version': 1,
      };

      _storage.write(cacheKey, cacheEntry);
      print('💾 Cached ${dataToCache.length} candles for $cacheKey');

      if (notify && symbol != null && resolution != null) {
        _cacheUpdateController.add({
          'symbol': symbol,
          'resolution': resolution,
          'data': dataToCache,
        });
      }
    } catch (e) {
      print('⚠️ Error caching data for $cacheKey: $e');
    }
  }

  static void _refreshCacheInBackground({
    required String symbol,
    required String resolution,
    int? from,
    int? to,
    required String cacheKey,
  }) {
    Future.microtask(() async {
      try {
        print('🔄 Background refresh started for $symbol ($resolution)');
        final freshData = await _fetchFromAPI(
          symbol: symbol,
          resolution: resolution,
          from: from,
          to: to,
        );

        if (freshData.isNotEmpty) {
          // Merge with existing instead of overwriting
          final existing = _getCachedData(cacheKey) ?? [];
          final Map<int, Map<String, dynamic>> merged = {
            for (var c in existing) c['time'] as int: c,
          };
          for (var candle in freshData) {
            merged[candle['time'] as int] = candle;
          }
          final mergedList =
              merged.values.toList()..sort(
                (a, b) => (a['time'] as int).compareTo(b['time'] as int),
              );

          _cacheData(cacheKey, mergedList);

          // 🔔 Notify listeners with new data
          _cacheUpdateController.add({
            'symbol': symbol,
            'resolution': resolution,
            'data': mergedList,
          });

          print(
            '✅ Background refresh completed + UI notified for $symbol ($resolution)',
          );
        }
      } catch (e) {
        print('⚠️ Background refresh failed for $symbol ($resolution): $e');
      }
    });
  }

  /// Clear cache for specific symbol and resolution
  static void clearCache(String symbol, String resolution) {
    final cacheKey = _getCacheKey(symbol, resolution);
    _storage.remove(cacheKey);
    print('🗑️ Cleared cache for $symbol ($resolution)');
  }

  /// Clear all OHLC cache (only on manual request)
  static void clearAllCache() {
    final keys = _storage.getKeys();
    int count = 0;
    for (var key in keys) {
      if (key.startsWith('ohlc_')) {
        _storage.remove(key);
        count++;
      }
    }
    print('🗑️ Cleared $count OHLC cache entries');
  }

  /// Get detailed cache information
  static Map<String, dynamic> getCacheInfo(String symbol, String resolution) {
    final cacheKey = _getCacheKey(symbol, resolution);
    final cacheEntry = _storage.read(cacheKey);

    if (cacheEntry == null) {
      return {'cached': false, 'exists': false};
    }

    try {
      final Map<String, dynamic> cached = Map<String, dynamic>.from(cacheEntry);
      final cachedTime = DateTime.parse(cached['timestamp'] as String);
      final List<dynamic> rawData = cached['data'] as List<dynamic>;
      final age = DateTime.now().difference(cachedTime);

      return {
        'cached': true,
        'exists': true,
        'timestamp': cached['timestamp'],
        'age_seconds': age.inSeconds,
        'age_minutes': age.inMinutes,
        'age_hours': age.inHours,
        'is_fresh': age <= _cacheFreshnessThreshold,
        'is_stale': age > _cacheFreshnessThreshold,
        'candle_count': rawData.length,
        'oldest_candle': rawData.isNotEmpty ? rawData.first : null,
        'newest_candle': rawData.isNotEmpty ? rawData.last : null,
      };
    } catch (e) {
      print('⚠️ Error getting cache info for $cacheKey: $e');
      return {'cached': false, 'exists': true, 'error': e.toString()};
    }
  }

  /// Get all cached symbols
  static List<Map<String, dynamic>> getAllCachedSymbols() {
    final keys = _storage.getKeys();
    final List<Map<String, dynamic>> cachedSymbols = [];

    for (var key in keys) {
      if (key.startsWith('ohlc_')) {
        final parts = key.replaceFirst('ohlc_', '').split('_');
        if (parts.length >= 2) {
          final symbol = parts.sublist(0, parts.length - 1).join('_');
          final resolution = parts.last;
          final info = getCacheInfo(symbol, resolution);

          cachedSymbols.add({
            'symbol': symbol,
            'resolution': resolution,
            'cache_key': key,
            ...info,
          });
        }
      }
    }

    return cachedSymbols;
  }

  /// Verify cache integrity
  static Future<Map<String, dynamic>> verifyCacheIntegrity() async {
    final allCached = getAllCachedSymbols();
    int valid = 0;
    int corrupted = 0;
    int empty = 0;

    for (var cached in allCached) {
      if (cached['exists'] == true && cached['cached'] == true) {
        if (cached['candle_count'] > 0) {
          valid++;
        } else {
          empty++;
        }
      } else {
        corrupted++;
      }
    }

    return {
      'total_cached': allCached.length,
      'valid': valid,
      'empty': empty,
      'corrupted': corrupted,
      'storage_keys': _storage.getKeys().length,
    };
  }

  static int _calculateDefaultFrom(int toTimestamp, String resolution) {
    const candlesToFetch = 300;

    int secondsPerCandle;
    switch (resolution) {
      case '1m':
        secondsPerCandle = 60;
        break;
      case '5m':
        secondsPerCandle = 300;
        break;
      case '15m':
        secondsPerCandle = 900;
        break;
      case '30m':
        secondsPerCandle = 1800;
        break;
      case '1h':
        secondsPerCandle = 3600;
        break;
      case '4h':
        secondsPerCandle = 14400;
        break;
      case '1D':
        secondsPerCandle = 86400;
        break;
      case '1W':
        secondsPerCandle = 604800;
        break;
      case '1M':
        secondsPerCandle = 2592000;
        break;
      case '3M':
        secondsPerCandle = 7776000;
        break;
      case '6M':
        secondsPerCandle = 15552000;
        break;
      case '1Y':
        secondsPerCandle = 31536000;
        break;
      case '5Y':
        secondsPerCandle = 157680000;
        break;
      default:
        secondsPerCandle = 60;
    }

    return toTimestamp - (secondsPerCandle * candlesToFetch);
  }

  static int _parseTime(dynamic value) {
    if (value == null) throw Exception('Time is null');
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.parse(value);
    throw Exception('Invalid time format: $value');
  }

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

  static List<Map<String, String>> getTimeframes() {
    return [
      {'label': '1m', 'value': '1m', 'seconds': '60'},
      {'label': '5m', 'value': '5m', 'seconds': '300'},
      {'label': '15m', 'value': '15m', 'seconds': '900'},
      {'label': '30m', 'value': '30m', 'seconds': '1800'},
      {'label': '1H', 'value': '1h', 'seconds': '3600'},
      {'label': '4H', 'value': '4h', 'seconds': '14400'},
      {'label': '1D', 'value': '1D', 'seconds': '86400'},
      {'label': '1W', 'value': '1W', 'seconds': '604800'},
      {'label': '1M', 'value': '1M', 'seconds': '2592000'},
      {'label': '3M', 'value': '3M', 'seconds': '7776000'},
      {'label': '6M', 'value': '6M', 'seconds': '15552000'},
      {'label': '1Y', 'value': '1Y', 'seconds': '31536000'},
      {'label': '5Y', 'value': '5Y', 'seconds': '157680000'},
    ];
  }

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
