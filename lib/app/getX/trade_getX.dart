import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:netdania/screens/services/authservices.dart';
import 'package:netdania/screens/services/socket_connection.dart';
import 'package:netdania/screens/services/price_services.dart';
import 'package:intl/intl.dart';

class TradePageController extends GetxController {
  late LocalWebSocketService _webSocketService;

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

    // DON'T start WebSocket here automatically
    // Wait for symbols to be set via setSymbols() or startWebSocket()
    debugPrint('📊 TradePageController onInit - symbols: ${symbols.length}');
  }

  /// Call this method to set symbols and start WebSocket
  Future<void> setSymbols(List<String> newSymbols) async {
    if (newSymbols.isEmpty) {
      debugPrint('⚠️ Cannot set empty symbols list');
      return;
    }

    symbols.assignAll(newSymbols);
    debugPrint('✅ Symbols set: $newSymbols');

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
  }

  Map<String, dynamic>? getInstrumentBySymbol(String symbol) {
    final index = liveData.indexWhere(
      (e) => e['symbol'] == symbol.toUpperCase(),
    );
    if (index >= 0) return liveData[index];
    return null;
  }

  Map<String, dynamic>? getTicker(String symbol) {
    final instrument = getInstrumentBySymbol(symbol);
    if (instrument != null) {
      return {'bid': instrument['sell'], 'ask': instrument['buy']};
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
