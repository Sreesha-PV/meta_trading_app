import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:netdania/app/services/authservices.dart';
import 'package:netdania/app/services/socket_connection.dart';
import 'package:netdania/app/services/price_services.dart';
import 'package:intl/intl.dart';

class TradePageController extends GetxController {
  late LocalWebSocketService _webSocketService;
  late GetStorage _priceCache;

  // Cache keys
  static const String _cacheKeyPrefix = 'price_cache_';
  static const String _cacheTimestampKey = 'cache_timestamp';

  // Keeps track of previous prices for spread and direction
  final oldPrices = <String, Map<String, String>>{}.obs;

  // Live data observable
  final RxList<Map<String, dynamic>> liveData = RxList<Map<String, dynamic>>();

  // Symbols to subscribe
  final RxList<String> symbols = <String>[].obs;

  final RxBool isLoadingPrices = false.obs;
  bool _socketStarted = false;

  // Constructor with optional initial symbols
  TradePageController({List<String>? initialSymbols}) {
    _priceCache = GetStorage('price_cache');
    
    if (initialSymbols != null && initialSymbols.isNotEmpty) {
      symbols.addAll(initialSymbols);
      debugPrint(
        '📌 TradePageController initialized with symbols: $initialSymbols',
      );
    }
  }

  @override
  void onInit() async {
    super.onInit();

    // Load cached prices immediately on init
    _loadCachedPrices();

    debugPrint('📊 TradePageController onInit - symbols: ${symbols.length}');
  }

  /// Load cached prices from storage
  void _loadCachedPrices() {
    try {
      if (symbols.isEmpty) return;

      int loadedCount = 0;
      for (final symbol in symbols) {
        final cachedData = _priceCache.read('$_cacheKeyPrefix$symbol');
        if (cachedData != null && cachedData is Map) {
          final data = Map<String, dynamic>.from(cachedData);
          
          // Check if cache is not too old (optional: e.g., 24 hours)
          final cacheTime = data['cache_time'] as int?;
          if (cacheTime != null) {
            final age = DateTime.now().millisecondsSinceEpoch - cacheTime;
            // Only use cache if less than 24 hours old
            if (age < 24 * 60 * 60 * 1000) {
              final exists = liveData.any((item) => item['symbol'] == symbol);
              if (!exists) {
                liveData.add(data);
                loadedCount++;
              }
            }
          }
        }
      }

      if (loadedCount > 0) {
        debugPrint('💾 Loaded $loadedCount cached prices from storage');
        isLoadingPrices.value = false;
      }
    } catch (e) {
      debugPrint('⚠️ Error loading cached prices: $e');
    }
  }

  /// Save price data to cache
  void _cachePriceData(String symbol, Map<String, dynamic> data) {
    try {
      // Add cache timestamp
      final dataWithTimestamp = Map<String, dynamic>.from(data);
      dataWithTimestamp['cache_time'] = DateTime.now().millisecondsSinceEpoch;
      
      _priceCache.write('$_cacheKeyPrefix$symbol', dataWithTimestamp);
      
      // Update global cache timestamp
      _priceCache.write(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('⚠️ Error caching price for $symbol: $e');
    }
  }

  /// Clear all cached prices
  Future<void> clearCache() async {
    try {
      await _priceCache.erase();
      debugPrint('🗑️ Price cache cleared');
    } catch (e) {
      debugPrint('⚠️ Error clearing cache: $e');
    }
  }

  /// Clear cache for specific symbol
  Future<void> clearSymbolCache(String symbol) async {
    try {
      _priceCache.remove('$_cacheKeyPrefix$symbol');
      debugPrint('🗑️ Cache cleared for $symbol');
    } catch (e) {
      debugPrint('⚠️ Error clearing cache for $symbol: $e');
    }
  }

  /// Call this method to set symbols and start WebSocket
  Future<void> setSymbols(List<String> newSymbols) async {
    if (newSymbols.isEmpty) {
      debugPrint('⚠️ Cannot set empty symbols list');
      return;
    }

    symbols.assignAll(newSymbols);
    debugPrint('✅ Symbols set: $newSymbols');

    // Load cached data for new symbols
    _loadCachedPrices();

    // Start WebSocket if not already started
    if (!_socketStarted) {
      await startWebSocket(newSymbols);
    }
  }

  Future<void> startWebSocket(List<String> symbolsList) async {
    if (_socketStarted) {
      debugPrint('ℹ️ WebSocket already started');
      return;
    }

    final token = await AuthService().getToken();
    if (token == null || token.isEmpty) {
      debugPrint('❌ WebSocket blocked: token not ready');
      return;
    }

    if (symbolsList.isEmpty) {
      debugPrint('❌ WebSocket blocked: symbols empty');
      return;
    }

    _socketStarted = true;
    symbols.assignAll(symbolsList);

    debugPrint(
      '🔌 Starting WebSocket with ${symbolsList.length} symbols: $symbolsList',
    );

    _webSocketService = LocalWebSocketService(
      symbols: symbolsList,
      onData: _handleWebSocketData,
      token: token,
    );

    _fetchInitialPricesInBackground();

    // Set timeout for loading state
    Future.delayed(const Duration(seconds: 5), () {
      if (isLoadingPrices.value) {
        isLoadingPrices.value = false;
        if (liveData.isEmpty) {
          debugPrint('⚠️ No price data received after 5 seconds');
        }
      }
    });
  }

  Future<void> _fetchInitialPricesInBackground() async {
    if (symbols.isEmpty) return;

    try {
      final prices = await PriceService.fetchPrices(symbols);

      if (prices != null && prices.isNotEmpty) {
        prices.forEach((symbol, priceData) {
          final exists = liveData.any((item) => item['symbol'] == symbol);
          if (!exists) {
            _processSymbolData({
              's': priceData['item_code']?.toString() ?? symbol,
              'item_code': priceData['item_code']?.toString(),
              'symbol': symbol,
              'ask': priceData['ask']?.toString(),
              'bid': priceData['bid']?.toString(),
              'open': priceData['open']?.toString(),
              'last': priceData['last']?.toString(),
              'high': priceData['high']?.toString(),
              'low': priceData['low']?.toString(),
              'volume': priceData['volume']?.toString(),
              'previous_close': priceData['previous_close']?.toString(),
              'time': priceData['time']?.toString(),
              'dot_position': priceData['dot_position'] ?? 5,
              'time_unix':
                  priceData['time_unix'] ??
                  (DateTime.now().millisecondsSinceEpoch ~/ 1000),
            });
          }
        });

        debugPrint(
          '✅ Loaded initial prices for ${prices.length} symbols from API',
        );
        isLoadingPrices.value = false;
      }
    } catch (e) {
      debugPrint('⚠️ Could not fetch initial prices from API: $e');
      debugPrint('Will rely on WebSocket data instead');
    }
  }

  void _handleWebSocketData(dynamic parsed) {
    try {
      final List<Map<String, dynamic>> normalized = [];

      if (parsed is Map<String, dynamic>) {
        normalized.add(parsed);
      } else if (parsed is List) {
        for (final item in parsed) {
          if (item is Map<String, dynamic>) {
            normalized.add(item);
          } else if (item is List && item.length >= 3) {
            normalized.add({
              's': item[0]?.toString(),
              'bid': item[1]?.toString(),
              'ask': item[2]?.toString(),
            });
          }
        }
      }

      for (final item in normalized) {
        _processSymbolData(item);
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('[TradePage] WebSocket parse error: $e\n$st');
      }
    }
  }

  void _processSymbolData(Map<String, dynamic> parsed) {
    final symbol =
        (parsed['s'] ?? parsed['item_code'] ?? parsed['symbol'])
            ?.toString()
            .toUpperCase();

    if (symbol == null ||
        !symbols.map((e) => e.toUpperCase()).contains(symbol)) {
      return;
    }

    final buy = parsed['ask']?.toString() ?? '';
    final sell = parsed['bid']?.toString() ?? '';
    final open = parsed['open']?.toString() ?? '';
    final close = parsed['last']?.toString() ?? '';
    final high = parsed['high']?.toString() ?? '';
    final low = parsed['low']?.toString() ?? '';
    final volume = parsed['volume']?.toString() ?? '';
    final previousClose = parsed['previous_close']?.toString() ?? '';

    final dotPosition = parsed['dot_position'] ?? 5;
    final timeUnix =
        parsed['time_unix'] ?? (DateTime.now().millisecondsSinceEpoch ~/ 1000);
    final rawTime = parsed['time'];
    final timeInSeconds =
        rawTime != null
            ? int.tryParse(rawTime.toString()) ??
                DateTime.now().millisecondsSinceEpoch ~/ 1000
            : DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      timeInSeconds * 1000,
      isUtc: true,
    );

    final timeString = DateFormat('HH:mm:ss').format(dateTime);

    if (buy.isEmpty && sell.isEmpty) {
      if (kDebugMode) print('⚠️ No bid/ask data for $symbol');
      return;
    }

    final oldSell = double.tryParse(oldPrices[symbol]?['sell'] ?? '0') ?? 0;
    final oldBuy = double.tryParse(oldPrices[symbol]?['buy'] ?? '0') ?? 0;
    final newSell = double.tryParse(sell) ?? 0;
    final newBuy = double.tryParse(buy) ?? 0;

    final spread =
        newBuy > 0 && newSell > 0
            ? (newBuy - newSell).toStringAsFixed(8)
            : '--';

    final sellUp = newSell > oldSell && oldSell > 0;
    final buyUp = newBuy > oldBuy && oldBuy > 0;

    oldPrices[symbol] = {'sell': sell, 'buy': buy};

    final openPrice = double.tryParse(open) ?? 0.0;
    final closePrice = double.tryParse(close) ?? 0.0;
    final prevClosePrice = double.tryParse(previousClose) ?? openPrice;

    final basePrice = prevClosePrice != 0 ? prevClosePrice : openPrice;
    final priceChange = closePrice - basePrice;
    final percentChange = basePrice != 0 ? (priceChange / basePrice) * 100 : 0;

    final entry = {
      'symbol': symbol,
      'sell': sell.isEmpty ? '--' : sell,
      'buy': buy.isEmpty ? '--' : buy,
      'high': high.isEmpty ? '--' : high,
      'low': low.isEmpty ? '--' : low,
      'close': close.isEmpty ? '--' : close,
      'spread': spread,
      'sellUp': sellUp,
      'buyUp': buyUp,
      'dot_position': dotPosition,
      'time_unix': timeUnix,
      'time': timeString,
      'priceChange': priceChange != 0 ? priceChange.toStringAsFixed(4) : '--',
      'percentChange':
          percentChange != 0 ? percentChange.toStringAsFixed(2) : '--',
      'volume': volume.isEmpty ? '--' : volume,
    };

    final index = liveData.indexWhere((e) => e['symbol'] == symbol);
    final safeEntry = Map<String, dynamic>.from(entry);

    if (index >= 0) {
      liveData[index] = safeEntry;
    } else {
      liveData.add(safeEntry);
    }

    // Cache the price data
    _cachePriceData(symbol, safeEntry);
  }

  Map<String, dynamic>? getInstrumentBySymbol(String symbol) {
    final index = liveData.indexWhere(
      (e) => e['symbol'] == symbol.toUpperCase(),
    );
    if (index >= 0) return liveData[index];
    
    // Fallback to cache if not in live data
    final cached = _priceCache.read('$_cacheKeyPrefix${symbol.toUpperCase()}');
    if (cached != null && cached is Map) {
      return Map<String, dynamic>.from(cached);
    }
    
    return null;
  }

  Map<String, dynamic>? getTicker(String symbol) {
    final instrument = getInstrumentBySymbol(symbol);
    if (instrument != null) {
      return {'bid': instrument['sell'], 'ask': instrument['buy']};
    }
    return null;
  }

  /// Get cache age for a symbol
  Duration? getCacheAge(String symbol) {
    try {
      final cachedData = _priceCache.read('$_cacheKeyPrefix$symbol');
      if (cachedData != null && cachedData is Map) {
        final cacheTime = cachedData['cache_time'] as int?;
        if (cacheTime != null) {
          return Duration(
            milliseconds: DateTime.now().millisecondsSinceEpoch - cacheTime,
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error getting cache age for $symbol: $e');
    }
    return null;
  }

  @override
  void onClose() {
    if (_socketStarted) {
      _webSocketService.dispose();
    }
    super.onClose();
  }
}