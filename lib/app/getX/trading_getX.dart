// import 'dart:async';
// import 'dart:convert';
// import 'package:candlesticks/candlesticks.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:netdania/app/models/instrument_model.dart';
// import 'package:netdania/app/models/trade_model.dart';
// import 'package:netdania/screens/services/instrument_fetch_services.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// // import 'package:netdania/app/models/order_model.dart';

// class TradingChartController extends GetxController {
//   // --- Storage ---
//   final GetStorage _storage = GetStorage();

//   // --- Orders ---
//   final _orders = <TradeOrder>[].obs;
//   List<TradeOrder> get orders => _orders;

//   // --- Symbols & Prices ---
//   final RxString symbol = ''.obs;
//   final RxDouble sell = 0.0.obs;
//   final RxDouble buy = 0.0.obs;
//   final RxDouble spread = 0.0.obs;
//   // --- WebSocket ---
//   WebSocketChannel? _channel;
//   StreamSubscription? _socketSubscription;
//   bool _isDisposed = false;

//   // --- Tickers ---
//   final _tickers = <String, Map<String, dynamic>>{}.obs;
//   Map<String, Map<String, dynamic>> get tickers => _tickers;

//   final _tickerData = Rxn<Map<String, dynamic>>();
//   Map<String, dynamic>? get tickerData => _tickerData.value;

//   final RxMap<int, dynamic> _instrumentDetailsCache = <int, dynamic>{}.obs;

//   // Check if instrument details are already cached
// bool hasInstrumentDetails(int instrumentId) {
//   return _instrumentDetailsCache.containsKey(instrumentId);
// }

//   void cacheInstrumentDetails(int instrumentId, dynamic details) {
//     _instrumentDetailsCache[instrumentId] = details;
//   }

//   dynamic getCachedInstrumentDetails(int instrumentId) {
//     return _instrumentDetailsCache[instrumentId];
//   }

//   final _lastPrices = <String, double>{};
//   final _lastBuyPrices = <String, double>{};

//   final _lastPrice = RxnDouble();
//   final _lastBuyPrice = RxnDouble();

//   // TradingChartController({String? initialSymbol}) {
//   //   if (initialSymbol != null) {
//   //     symbol.value = initialSymbol;
//   //   }

//   //   // Load orders from storage
//   //   _loadOrdersFromStorage();

//   //   // Initialize WebSocket
//   //   _initSocket();
//   // }

//   TradingChartController({String? initialSymbol}) {
//     loadInstruments().then((_) {
//       _loadOrdersFromStorage();
//     });

//     _initSocket();
//   }

//   var instruments = <int, InstrumentModel>{}.obs;
//   // RxList<InstrumentModel> instruments = <InstrumentModel>[].obs;
//   // Map<int, InstrumentModel> instrumentMap = {};

//   final InstrumentService service = InstrumentService();

//   @override
//   // void onInit() {
//   //   super.onInit();
//   //   loadInstruments();
//   // }
//   void onInit() {
//     super.onInit();
//     loadInstruments().then((_) {
//       _loadOrdersFromStorage();
//     });
//   }

//   InstrumentModel? getInstrument(int instrumentId) {
//     return instruments[instrumentId];
//   }

//   // InstrumentModel? getInstrumentFromOrder(OrderModel order) {
//   //   print(' getInstrument called with order: $order');
//   //   print(' instrumentId: ${order.instrumentId}');
//   //   return instruments[order.instrumentId];
//   // }

//   // For loading instrument
//   Future<void> loadInstruments() async {
//     final list = await service.fetchInstruments();
//     for (var item in list) {
//       instruments[item.instrumentId] = item;
//     }
//     print("Loaded instruments: ${instruments.length}");
//   }

//   Future<dynamic> detailsInstruments(int instrumentId) async {
//     if (hasInstrumentDetails(instrumentId)) {
//       return _instrumentDetailsCache[instrumentId];
//     }
//     try {
//       final details = await service.fetchInstrumentById(instrumentId);
//       cacheInstrumentDetails(instrumentId, details);
//       return details;
//     } catch (error) {
//       rethrow;
//     }
//   }

//   // --------------------------
//   // Order persistence
//   // --------------------------

//   void _loadOrdersFromStorage() {
//     final storedOrders = _storage.read<List>('orders') ?? [];
//     _orders.assignAll(storedOrders.map((o) => TradeOrder.fromJson(o)).toList());
//   }

//   InstrumentModel? getInstrumentByCode(String code) {
//     try {
//       return instruments.values.firstWhere(
//         (inst) => inst.code.toUpperCase() == code.toUpperCase(),
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   void subscribeToSymbols(List<String> symbols) {
//     // final message = {
//     //   "action": "subscribe",
//     //   "symbols": symbols.map((s) => s.toUpperCase()).toList(),
//     // };
//     final message = {
//       "action": "subscribe",
//       "symbols": ["EURUSD", "GBPJPY"],
//     };
//     _channel?.sink.add(jsonEncode(message));
//   }

//   void _saveOrdersToStorage() {
//     _storage.write('orders', _orders.map((o) => o.toJson()).toList());
//   }

//   void addOrder(TradeOrder order) {
//     _orders.add(order);
//     _saveOrdersToStorage();
//   }

//   void removeOrder(TradeOrder order) {
//     _orders.remove(order);
//     _saveOrdersToStorage();
//   }

//   void clearOrders() {
//     _orders.clear();
//     _saveOrdersToStorage();
//   }

//   // --------------------------
//   // WebSocket handling
//   // --------------------------
//   void _initSocket() {
//     _channel = WebSocketChannel.connect(
//       Uri.parse('ws://192.168.4.30:8000/ticker'),
//     );

//     _socketSubscription = _channel!.stream.listen((event) {
//       if (_isDisposed) return;

//       final message = event is String ? event : utf8.decode(event);

//       if (!message.trim().startsWith('{') && !message.trim().startsWith('[')) {
//         print("Ignoring non-JSON message: $message");
//         return;
//       }

//       try {
//         final decoded = jsonDecode(message);

//         if (decoded is Map<String, dynamic>) {
//           final sym =
//               decoded['symbol']?.toString().toUpperCase() ??
//               decoded['item_code']?.toString().toUpperCase();
//           if (sym != null) {
//             _tickers[sym] = decoded;
//             _tickerData.value = decoded;

//             final newSell =
//                 double.tryParse(decoded['bid']?.toString() ?? '0') ?? 0;
//             final newBuy =
//                 double.tryParse(decoded['ask']?.toString() ?? '0') ?? 0;

//             _lastPrices[sym] = newSell;
//             _lastBuyPrices[sym] = newBuy;

//             _lastPrice.value = newSell;
//             _lastBuyPrice.value = newBuy;
//           }
//         }
//       } catch (e) {
//         print("WebSocket decode error: $e");
//       }
//     });
//   }

//   // --------------------------
//   // Helper methods
//   // --------------------------
//   Map<String, dynamic>? getTicker(String symbol) {
//     return _tickers[symbol.toUpperCase()];
//   }

//   Map<String, dynamic>? getTickerSafe(String symbol) {
//     final sym = symbol.toUpperCase();
//     return _tickers.containsKey(sym) ? _tickers[sym] : _tickerData.value;
//   }

//   //   RxMap<String, Map<String, double>> tickers = <String, Map<String,double>>{}.obs;

//   // Map<String, double>? getTickerSafe(String symbol) {
//   //   return tickers[symbol];
//   // }

//   bool isPriceUpForSymbol(String symbol) {
//     final last = _lastPrices[symbol] ?? 0;
//     final current = _tickers[symbol]?['bid'] ?? 0;
//     return current > last;
//   }

//   bool get isPriceUp =>
//       _lastPrice.value != null &&
//       (_tickerData.value?['bid'] ?? 0) > _lastPrice.value!;
//   bool get isBuyPriceUp =>
//       _lastBuyPrice.value != null &&
//       (_tickerData.value?['ask'] ?? 0) > _lastBuyPrice.value!;

//   // --------------------------
//   // Candles & price history
//   // --------------------------
//   final _candles = <Candle>[].obs;
//   List<Candle> get candles => _candles;
//   void updateCandles(List<Candle> newCandles) => _candles.value = newCandles;

//   final _priceHistory = <String, List<double>>{}.obs;
//   List<double> getPriceHistory(String symbol) =>
//       _priceHistory[symbol.toUpperCase()] ?? [];

//   // --------------------------
//   // Cleanup
//   // --------------------------
//   void disposeSocket() {
//     _channel?.sink.close();
//     _socketSubscription?.cancel();
//   }

//   @override
//   void onClose() {
//     _isDisposed = true;
//     disposeSocket();
//     super.onClose();
//   }
// }

// import 'dart:async';
// import 'dart:convert';
// import 'package:candlesticks/candlesticks.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:netdania/app/core/constants/urls.dart';
// import 'package:netdania/app/getX/trade_getX.dart';
// import 'package:netdania/app/models/instrument_model.dart';
// import 'package:netdania/app/models/trade_model.dart';
// import 'package:netdania/screens/services/instrument_fetch_services.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class TradingChartController extends GetxController {
//   // --- Storage ---
//   final GetStorage _storage = GetStorage();

//   // --- Orders ---
//   final _orders = <TradeOrder>[].obs;
//   List<TradeOrder> get orders => _orders;

//   // --- Symbols & Prices ---
//   final RxString symbol = ''.obs;
//   final RxDouble sell = 0.0.obs;
//   final RxDouble buy = 0.0.obs;
//   final RxDouble spread = 0.0.obs;

//   // --- WebSocket ---
//   WebSocketChannel? _channel;
//   StreamSubscription? _socketSubscription;
//   bool _isDisposed = false;

//   // --- Tickers ---
//   final _tickers = <String, Map<String, dynamic>>{}.obs;
//   Map<String, Map<String, dynamic>> get tickers => _tickers;

//   final _tickerData = Rxn<Map<String, dynamic>>();
//   Map<String, dynamic>? get tickerData => _tickerData.value;

//     final RxMap<int, dynamic> _instrumentDetailsCache = <int, dynamic>{}.obs;

//   // Check if instrument details are already cached
//   bool hasInstrumentDetails(int instrumentId) {
//     return _instrumentDetailsCache.containsKey(instrumentId);
//   }

//   void cacheInstrumentDetails(int instrumentId, dynamic details) {
//     _instrumentDetailsCache[instrumentId] = details;
//   }

//   dynamic getCachedInstrumentDetails(int instrumentId) {
//     return _instrumentDetailsCache[instrumentId];
//   }

//   final _lastPrices = <String, double>{};
//   final _lastBuyPrices = <String, double>{};

//   final _lastPrice = RxnDouble();
//   final _lastBuyPrice = RxnDouble();

//   // Track which symbols we have subscribed to
//   final Set<String> _subscribedSymbols = <String>{};

//   // Instruments
//   var instruments = <int, InstrumentModel>{}.obs;
//   final InstrumentService service = InstrumentService();

//   // TradingChartController();

//   TradingChartController({String? initialSymbol}) {
//     loadInstruments().then((_) {
//       _loadOrdersFromStorage();
//     });

//     // _initSocket();
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     // initialize once
//     loadInstruments().then((_) {
//       _loadOrdersFromStorage();
//     });

//     _initSocket();
//   }

//   // -------------------------
//   // Instruments & persistence
//   // -------------------------
//   // Future<void> loadInstruments() async {
//   //   try {
//   //     final list = await service.fetchInstruments();

//   //     for (var item in list) {
//   //       instruments[item.instrumentId] = item;
//   //     }
//   //     debugPrint("Loaded instruments: ${instruments.length}");
//   //   } catch (e) {
//   //     debugPrint("Failed to load instruments: $e");
//   //   }

//   // }

// Future<void> loadInstruments() async {
//   try {
//     final list = await service.fetchInstruments();

//     for (var item in list) {
//       instruments[item.instrumentId] = item;
//     }

//     debugPrint("Loaded instruments: ${instruments.length}");

//     //  START TRADE PAGE WEBSOCKET HERE
//     if (Get.isRegistered<TradePageController>()) {
//       final tradeController = Get.find<TradePageController>();

//       final symbols = instruments.values
//           .map((e) => e.code.toString())
//           .toList();

//       if (symbols.isNotEmpty) {
//         debugPrint('Starting Trade WebSocket with symbols: $symbols');
//         tradeController.startWebSocket(symbols);
//       }
//     }
//   } catch (e) {
//     debugPrint("Failed to load instruments: $e");
//   }
// }

//   void _loadOrdersFromStorage() {
//     final storedOrders = _storage.read<List>('orders') ?? [];
//     _orders.assignAll(storedOrders.map((o) => TradeOrder.fromJson(o)).toList());
//   }

//   InstrumentModel? getInstrument(int instrumentId) {
//     return instruments[instrumentId];
//   }

//   InstrumentModel? getInstrumentByCode(String code) {
//     try {
//       return instruments.values.firstWhere(
//           (inst) => inst.code.toUpperCase() == code.toUpperCase());
//     } catch (e) {
//       return null;
//     }
//   }

//     Future<dynamic> detailsInstruments(int instrumentId) async {
//     if (hasInstrumentDetails(instrumentId)) {
//       return _instrumentDetailsCache[instrumentId];
//     }
//     try {
//       final details = await service.fetchInstrumentById(instrumentId);
//       cacheInstrumentDetails(instrumentId, details);
//       return details;
//     } catch (error) {
//       rethrow;
//     }
//   }

//   // -------------------------
//   // WebSocket lifecycle
//   // -------------------------
//   void _initSocket() {
//     // if already connected skip
//     if (_channel != null) return;
// final token = _storage.read<String>('token');

//   if (token == null || token.isEmpty) {
//     debugPrint("WebSocket token missing");
//     return;
//   }

//     try {
//       // _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.4.30:8000/ticker'));
//       _channel =
//       //  WebSocketChannel.connect(Uri.parse(ApiUrl.wstickerUrl(token)));
//        WebSocketChannel.connect(Uri.parse('${ApiUrl.wsUrl}?token=$token'));

//       _socketSubscription = _channel!.stream.listen((event) {
//         if (_isDisposed) return;

//         final message = event is String ? event : utf8.decode(event);
//         if (!message.trim().startsWith('{') && !message.trim().startsWith('[')) {
//           debugPrint("Ignoring non-JSON message: $message");
//           return;
//         }

//         try {
//           final decoded = jsonDecode(message);
//           if (decoded is Map<String, dynamic>) {
//             final rawSym = decoded['symbol']?.toString() ?? decoded['item_code']?.toString();
//             if (rawSym != null) {
//               final sym = rawSym.toUpperCase();
//               // normalize common fields (a/b or ask/bid)
//               final normalized = <String, dynamic>{};
//               normalized.addAll(decoded);
//               // Keep both forms for compatibility
//               normalized['ask'] = decoded['ask']?.toString() ?? decoded['a']?.toString() ?? normalized['ask'];
//               normalized['bid'] = decoded['bid']?.toString() ?? decoded['b']?.toString() ?? normalized['bid'];

//               _tickers[sym] = normalized;
//               _tickerData.value = normalized;

//               final newSell = double.tryParse(normalized['bid']?.toString() ?? '0') ?? 0;
//               final newBuy = double.tryParse(normalized['ask']?.toString() ?? '0') ?? 0;

//               _lastPrices[sym] = newSell;
//               _lastBuyPrices[sym] = newBuy;

//               _lastPrice.value = newSell;
//               _lastBuyPrice.value = newBuy;
//               // reactive update is automatic from obs changes
//             }
//           }
//         } catch (e) {
//           debugPrint("WebSocket decode error: $e");
//         }
//       }, onError: (err) {
//         debugPrint("WS error: $err");
//         // optionally attempt reconnect logic here
//         // but keep simple: dispose and recreate if needed by subscribe call
//       }, onDone: () {
//         debugPrint("WebSocket closed by server");
//         // null so future subscribe can reconnect
//         _channel = null;
//       });
//     } catch (e) {
//       debugPrint("Failed to init socket: $e");
//       _channel = null;
//     }
//   }

//   // Ensure socket is available (re-init if needed)
//   Future<void> _ensureSocket() async {
//     if (_channel == null) {
//       _initSocket();
//       // small delay may be needed in some networks; keep minimal
//       await Future.delayed(const Duration(milliseconds: 100));
//     }
//   }

//   // -------------------------
//   // Subscribe / unsubscribe
//   // -------------------------

//   /// - normalizes & dedupes
//   /// - sends unsubscribe for removed symbols
//   /// - sends subscribe for new symbols
//   Future<void> subscribeToSymbols(List<String> symbols) async {
//     final normalized = symbols
//         .where((s) => s.trim().isNotEmpty)
//         .map((s) => s.toUpperCase())
//         .toSet();

//     // compute diffs
//     final toSubscribe = normalized.difference(_subscribedSymbols);
//     final toUnsubscribe = _subscribedSymbols.difference(normalized);

//     // ensure socket exist
//     await _ensureSocket();

//     if (_channel == null) {
//       debugPrint("Cannot subscribe: socket not available");
//       return;
//     }

//     try {
//       if (toUnsubscribe.isNotEmpty) {
//         final unsubMsg = {
//           // "action": "unsubscribe",
//           // "symbols": toUnsubscribe.toList(),
//           {
//     "action": "subscribe",
//     "symbols": [
//         "EURUSD"
//     ]
// }
//         };
//         _channel?.sink.add(jsonEncode(unsubMsg));
//         _subscribedSymbols.removeAll(toUnsubscribe);
//         debugPrint("Unsubscribed: $toUnsubscribe");
//       }

//       if (toSubscribe.isNotEmpty) {
//         final subMsg = {
//           // "action": "subscribe",
//           // "symbols": toSubscribe.toList(),
//           {
//     "action": "subscribe",
//     "symbols": [
//         "EURUSD"
//     ]
// }
//         };
//         _channel?.sink.add(jsonEncode(subMsg));
//         _subscribedSymbols.addAll(toSubscribe);
//         debugPrint("Subscribed: $toSubscribe");
//       }

//       debugPrint("Current subscribedSymbols: $_subscribedSymbols");
//     } catch (e) {
//       debugPrint("Subscribe error: $e");
//     }
//   }

//   // helper to get ticker
//   Map<String, dynamic>? getTicker(String symbol) {
//     return _tickers[symbol.toUpperCase()];
//   }

//   Map<String, dynamic>? getTickerSafe(String symbol) {
//     final sym = symbol.toUpperCase();
//     return _tickers.containsKey(sym) ? _tickers[sym] : _tickerData.value;
//   }
// // RxMap<String, dynamic> getTickerReactive(String symbol) {
// //   final sym = symbol.toUpperCase();
// //   if (!_tickers.containsKey(sym)) {
// //     _tickers[sym] = <String, dynamic>{}.obs;
// //   } else if (_tickers[sym] is! RxMap) {
// //     // convert normal map to RxMap
// //     final old = _tickers[sym]!;
// //     _tickers[sym] = RxMap<String, dynamic>.from(old);
// //   }
// //   return _tickers[sym]! as RxMap<String, dynamic>;
// // }

// // Map<String, dynamic>? getTickerSafe(String symbol) {
// //   final sym = symbol.toUpperCase();
// //   if (_tickers.containsKey(sym)) return _tickers[sym];
// //   return null;
// // }

//   bool isPriceUpForSymbol(String symbol) {
//     final last = _lastPrices[symbol] ?? 0;
//     final current = double.tryParse(_tickers[symbol]?['bid']?.toString() ?? '0') ?? 0;
//     return current > last;
//   }

//   // bool get isPriceUp =>
//   //     _lastPrice.value != null &&
//   //     (_tickerData.value?['bid'] ?? 0) > _lastPrice.value!;
//   // bool get isBuyPriceUp =>
//   //     _lastBuyPrice.value != null &&
//   //     (_tickerData.value?['ask'] ?? 0) > _lastBuyPrice.value!;

// bool get isPriceUp {
//   final last = _lastPrice.value ?? 0.0;
//   final current = double.tryParse(_tickerData.value?['bid']?.toString() ?? '0') ?? 0.0;
//   _lastPrice.value = current; // update after comparison
//   return current > last;
// }

// bool get isBuyPriceUp {
//   final last = _lastBuyPrice.value ?? 0.0;
//   final current = double.tryParse(_tickerData.value?['ask']?.toString() ?? '0') ?? 0.0;
//   _lastBuyPrice.value = current; // update
//   return current > last;
// }

//   // -------------------------
//   // Orders & persistence
//   // -------------------------
//   void _saveOrdersToStorage() {
//     _storage.write('orders', _orders.map((o) => o.toJson()).toList());
//   }

//   void addOrder(TradeOrder order) {
//     _orders.add(order);
//     _saveOrdersToStorage();
//   }

//   void removeOrder(TradeOrder order) {
//     _orders.remove(order);
//     _saveOrdersToStorage();
//   }

//   void clearOrders() {
//     _orders.clear();
//     _saveOrdersToStorage();
//   }

//   // candles & price history
//   final _candles = <Candle>[].obs;
//   List<Candle> get candles => _candles;
//   void updateCandles(List<Candle> newCandles) => _candles.value = newCandles;

//   final _priceHistory = <String, List<double>>{}.obs;
//   List<double> getPriceHistory(String symbol) => _priceHistory[symbol.toUpperCase()] ?? [];

//   // -------------------------
//   // Cleanup
//   // -------------------------
//   void disposeSocket() {
//     try {
//       _socketSubscription?.cancel();
//     } catch (e) {
//       debugPrint("Error cancelling socket subscription: $e");
//     }
//     try {
//       _channel?.sink.close();
//     } catch (e) {
//       // ignore
//     }
//     _socketSubscription = null;
//     _channel = null;
//     _subscribedSymbols.clear();
//   }

//   @override
//   void onClose() {
//     _isDisposed = true;
//     disposeSocket();
//     super.onClose();
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:netdania/app/core/constants/urls.dart';
import 'package:netdania/app/getX/account_getx.dart';
import 'package:netdania/app/getX/trade_getX.dart';
import 'package:netdania/app/models/instrument_detail_model.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/models/trade_model.dart';
import 'package:netdania/screens/services/instrument_fetch_services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TradingChartController extends GetxController {
  final GetStorage _storage = GetStorage();

  final _orders = <TradeOrder>[].obs;
  List<TradeOrder> get orders => _orders;

  final RxString symbol = ''.obs;
  final RxDouble sell = 0.0.obs;
  final RxDouble buy = 0.0.obs;
  final RxDouble spread = 0.0.obs;

  WebSocketChannel? _channel;
  StreamSubscription? _socketSubscription;
  bool _isDisposed = false;

  final _tickers = <String, Map<String, dynamic>>{}.obs;
  Map<String, Map<String, dynamic>> get tickers => _tickers;

  final _tickerData = Rxn<Map<String, dynamic>>();
  Map<String, dynamic>? get tickerData => _tickerData.value;

  final RxMap<int, InstrumentDetailsModel> _instrumentDetailsCache =
      <int, InstrumentDetailsModel>{}.obs;
  bool hasInstrumentDetails(int instrumentId) {
    return _instrumentDetailsCache.containsKey(instrumentId);
  }

  void cacheInstrumentDetails(int instrumentId, dynamic details) {
    _instrumentDetailsCache[instrumentId] = details;
  }

  dynamic getCachedInstrumentDetails(int instrumentId) {
    return _instrumentDetailsCache[instrumentId];
  }

  final _lastPrices = <String, double>{};
  final _lastBuyPrices = <String, double>{};

  final _lastPrice = RxnDouble();
  final _lastBuyPrice = RxnDouble();

  final Set<String> _subscribedSymbols = <String>{};

  var instruments = <int, InstrumentModel>{}.obs;
  final InstrumentService service = InstrumentService();

  @override
  void onInit() {
    super.onInit();
    final accountController = Get.find<AccountController>();

    final accountId = accountController.selectedAccountId.value;
    debugPrint("Account id a Trade Controller  $accountId");

    loadInstruments(accountId).then((_) {
      _loadOrdersFromStorage();
      fetchPricesFromApi();
    });
    _tryInitSocket();
  }

  final _instrumentsReady = false.obs;
  bool get instrumentsReady => _instrumentsReady.value;

  Future<void> loadInstruments(int accountId) async {
    try {
      debugPrint('📥 Starting to load instruments...');

      final list = await service.fetchInstruments(accountId);

      for (var item in list) {
        instruments[item.instrumentId] = item;
      }

      debugPrint(" Loaded instruments: ${instruments.length}");
      debugPrint(" Codes: ${instruments.values.map((e) => e.code).toList()}");

      _instrumentsReady.value = true;

      debugPrint(' Instruments ready!');

      if (Get.isRegistered<TradePageController>()) {
        final tradeController = Get.find<TradePageController>();
        final symbols =
            instruments.values.map((e) => e.code.toString()).toList();
        if (symbols.isNotEmpty) {
          debugPrint('Starting Trade WebSocket with symbols: $symbols');
          tradeController.startWebSocket(symbols);
        }
      }
    } catch (e) {
      debugPrint(" Failed to load instruments: $e");
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  void _loadOrdersFromStorage() {
    final storedOrders = _storage.read<List>('orders') ?? [];
    _orders.assignAll(storedOrders.map((o) => TradeOrder.fromJson(o)).toList());
  }

  InstrumentModel? getInstrument(int instrumentId) {
    return instruments[instrumentId];
  }

  InstrumentModel? getInstrumentByCode(String code) {
    try {
      final searchCode = code.toUpperCase();

      final result = instruments.values.firstWhere((inst) {
        final instCode = inst.code.toUpperCase();
        debugPrint(
          '  Comparing "$searchCode" with "$instCode" - Match: ${instCode == searchCode}',
        );
        return instCode == searchCode;
      });

      debugPrint(
        ' Found instrument: ${result.code} (ID: ${result.instrumentId})',
      );
      return result;
    } catch (e) {
      debugPrint(' Instrument NOT FOUND for code: "$code"');
      debugPrint(' Error: $e');
      debugPrint(
        ' Did you mean one of these? ${instruments.values.map((e) => e.code).take(5).toList()}',
      );
      return null;
    }
  }

  Future<dynamic> detailsInstruments(int instrumentId) async {
    print("Intrument Details from Order $instrumentId");

    if (hasInstrumentDetails(instrumentId)) {
      return _instrumentDetailsCache[instrumentId];
    }
    try {
      final details = await service.fetchInstrumentById(instrumentId);
      print("Details :$details");
      cacheInstrumentDetails(instrumentId, details);
      print("Cache:$_instrumentDetailsCache");
      return details;
    } catch (error) {
      rethrow;
    }
  }

  void onLoginSuccess() {
    debugPrint(' Login success → initializing socket');
    _tryInitSocket();
  }

  Future<void> fetchPricesFromApi() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        debugPrint('❌ No auth token for price fetch');
        return;
      }

      final symbols = instruments.values.map((e) => e.code).toList();
      if (symbols.isEmpty) return;

      final url = ApiUrl.priceUrl(symbols);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success' && data['data'] is List) {
          for (var priceData in data['data']) {
            final code = priceData['item_code'];

            _tickers[code] = {
              'symbol': code,
              'bid': priceData['bid'],
              'ask': priceData['ask'],
              'last': priceData['last'],
            };

            // debugPrint(
            //   '💰 Loaded price for $code: bid=${priceData['bid']}, ask=${priceData['ask']}',
            // );
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Failed to fetch prices: $e');
    }
  }

  Future<void> _tryInitSocket() async {
    if (_channel != null) {
      debugPrint('✅ Socket already initialized');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        debugPrint('❌ No auth token found');
        return;
      }

      final url = ApiUrl.wsTickerUrl(token);
      debugPrint('🔌 Connecting WebSocket to $url');

      _channel = WebSocketChannel.connect(Uri.parse(url));

      _socketSubscription = _channel!.stream.listen(
        (data) {
          if (_isDisposed) return;
          if (data is! String) return;

          final msg = data.trim();
          if (!msg.startsWith('{') && !msg.startsWith('[')) return;

          try {
            final parsed = jsonDecode(msg);

            if (parsed is List) {
              for (var item in parsed) {
                if (item is Map<String, dynamic>) {
                  _handleWebSocketMessage(item);
                }
              }
            } else if (parsed is Map<String, dynamic>) {
              _handleWebSocketMessage(parsed);
            }
          } catch (e) {
            debugPrint('⚡ WS parse error: $e');
          }
        },
        onDone: () {
          debugPrint('🔌 WebSocket closed');
          _channel = null;
          _socketSubscription = null;
          Future.delayed(Duration(seconds: 5), _tryInitSocket);
        },
        onError: (error) {
          debugPrint('❌ WebSocket error: $error');
          _channel = null;
          _socketSubscription = null;
          Future.delayed(Duration(seconds: 5), _tryInitSocket);
        },
      );

      debugPrint('✅ WebSocket connected');
    } catch (e) {
      debugPrint('❌ Failed to connect socket: $e');
      _channel = null;
    }
  }

  void _handleWebSocketMessage(Map<String, dynamic> data) {
    if (data.containsKey('item_code') && data.containsKey('last')) {
      final itemCode = data['item_code'] as String?;
      if (itemCode == null || itemCode.isEmpty) {
        debugPrint('⚠️ Invalid item_code in ticker data');
        return;
      }
      _tickers[itemCode] = data;
      if (symbol.value == itemCode) {
        _updatePricesForSymbol(itemCode, data);
      }
    }
  }

  void _updatePricesForSymbol(String symbolCode, Map<String, dynamic> data) {
    final last = (data['last'] as num?)?.toDouble() ?? 0.0;
    final bid = (data['bid'] as num?)?.toDouble() ?? 0.0;
    final ask = (data['ask'] as num?)?.toDouble() ?? 0.0;

    // debugPrint(
    //   '🔄 Updating prices for $symbolCode - Last: $last, Bid: $bid, Ask: $ask',
    // );

    sell.value = bid;
    buy.value = ask;
    spread.value = (ask - bid).abs();

    _lastPrice.value = last;
    _lastBuyPrice.value = ask;

    _lastPrices[symbolCode] = last;
    _lastBuyPrices[symbolCode] = ask;

    _tickerData.value = data;

    debugPrint('✅ Updated: Sell=$bid, Buy=$ask, Spread=${spread.value}');
  }

  Future<void> subscribeToSymbols(List<String> symbols) async {
    final normalized =
        symbols.map((s) => s.toUpperCase()).where((s) => s.isNotEmpty).toSet();

    final toSubscribe = normalized.difference(_subscribedSymbols);

    if (toSubscribe.isEmpty) {
      debugPrint('⏭️  All symbols already subscribed, skipping');
      return;
    }

    debugPrint('➕ New symbols to subscribe: $toSubscribe');

    await _tryInitSocket();

    if (_channel == null) {
      debugPrint('❌ Socket not ready - channel is null');
      return;
    }

    // debugPrint('✅ Socket ready, sending subscription message');

    final msg = {"action": "subscribe", "symbols": toSubscribe.toList()};

    // debugPrint('📤 Sending message: ${jsonEncode(msg)}');

    _channel!.sink.add(jsonEncode(msg));
    _subscribedSymbols.addAll(toSubscribe);

    debugPrint('✅ Subscribed to: $toSubscribe');
    // debugPrint('📊 Total subscribed symbols: $_subscribedSymbols');
  }

  Map<String, dynamic>? getTicker(String symbol) {
    return _tickers[symbol.toUpperCase()];
  }

  Map<String, dynamic>? getTickerSafe(String symbol) {
    final sym = symbol.toUpperCase();
    return _tickers.containsKey(sym) ? _tickers[sym] : _tickerData.value;
  }

  bool isPriceUpForSymbol(String symbol) {
    final last = _lastPrices[symbol] ?? 0;
    final current =
        double.tryParse(_tickers[symbol]?['bid']?.toString() ?? '0') ?? 0;
    return current > last;
  }

  bool get isPriceUp {
    final last = _lastPrice.value ?? 0.0;
    final current =
        double.tryParse(_tickerData.value?['bid']?.toString() ?? '0') ?? 0.0;
    _lastPrice.value = current;
    return current > last;
  }

  bool get isBuyPriceUp {
    final last = _lastBuyPrice.value ?? 0.0;
    final current =
        double.tryParse(_tickerData.value?['ask']?.toString() ?? '0') ?? 0.0;
    _lastBuyPrice.value = current;
    return current > last;
  }

  void _saveOrdersToStorage() {
    _storage.write('orders', _orders.map((o) => o.toJson()).toList());
  }

  void addOrder(TradeOrder order) {
    _orders.add(order);
    _saveOrdersToStorage();
  }

  void removeOrder(TradeOrder order) {
    _orders.remove(order);
    _saveOrdersToStorage();
  }

  void clearOrders() {
    _orders.clear();
    _saveOrdersToStorage();
  }

  final _candles = <Candle>[].obs;
  List<Candle> get candles => _candles;
  void updateCandles(List<Candle> newCandles) => _candles.value = newCandles;

  final _priceHistory = <String, List<double>>{}.obs;
  List<double> getPriceHistory(String symbol) =>
      _priceHistory[symbol.toUpperCase()] ?? [];

  void disposeSocket() {
    try {
      _socketSubscription?.cancel();
    } catch (e) {
      debugPrint("Error cancelling socket subscription: $e");
    }
    try {
      _channel?.sink.close();
    } catch (e) {}
    _socketSubscription = null;
    _channel = null;
    _subscribedSymbols.clear();
  }

  @override
  void onClose() {
    _isDisposed = true;
    disposeSocket();
    super.onClose();
  }
}
