import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/getX/order_getX.dart';
// ignore: library_prefixes
import 'package:shared_preferences/shared_preferences.dart';
import 'package:netdania/app/getX/trading_getX.dart' as tradingControllerLib;
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/modules/history/view/history_view.dart';
import 'package:netdania/app/modules/home/view/home_page.dart';
import 'package:netdania/app/modules/message/view/message_view.dart';
import 'package:netdania/app/modules/trade/view/trading_page_view.dart';
import 'package:netdania/app/modules/main_tab/components/bottom_navigation.dart';
import 'package:netdania/utils/responsive_layout_helper.dart';
import 'package:netdania/utils/tradingview_webchart.dart';
import 'package:netdania/screens/services/socket_connection.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  static final ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  static final ValueNotifier<bool> isMoreExpandedNotifier = ValueNotifier(
    false,
  );
  static final ValueNotifier<bool> isChartPageNotifier = ValueNotifier(false);

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  late tradingControllerLib.TradingChartController tradingController;
  LocalWebSocketService? _webSocketService;
  bool _hasSubscribed = false;
  // @override
  // void initState() {
  //   super.initState();
  //   tradingController = Get.put(tradingControllerLib.TradingChartController());
  // }

  @override
  void initState() {
    super.initState();

    // Get or create the controller
    if (Get.isRegistered<tradingControllerLib.TradingChartController>()) {
      tradingController =
          Get.find<tradingControllerLib.TradingChartController>();
      debugPrint('✅ Found existing TradingChartController');
      if (tradingController.instruments.isNotEmpty && !_hasSubscribed) {
        _subscribeToInstruments();
      }
    } else {
      tradingController = Get.put(
        tradingControllerLib.TradingChartController(),
      );
      debugPrint('✅ Created new TradingChartController');
    }

    // Subscribe AFTER instruments are loaded (for future updates)
    ever(tradingController.instruments, (_) {
      if (tradingController.instruments.isNotEmpty && !_hasSubscribed) {
        _subscribeToInstruments();
      }
    });
  }

  Future<void> _subscribeToInstruments() async {
    if (_hasSubscribed) {
      debugPrint('ℹ️ Already subscribed to instruments');
      return;
    }

    _hasSubscribed = true;

    final symbols =
        tradingController.instruments.values.map((e) => e.code).toList();

    debugPrint('📋 Subscribing to symbols: $symbols');

    await _initializeWebSocket(symbols);
    await tradingController.subscribeToSymbols(symbols);

    debugPrint('✅ Subscription complete');
  }

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _initializeWebSocket(List<String> symbols) async {
    if (_webSocketService != null) {
      debugPrint('✅ Socket already initialized');
      return;
    }

    try {
      final token = await _getAuthToken();

      if (token == null || token.isEmpty) {
        debugPrint('⚠️ No auth token available for WebSocket');
        return;
      }

      debugPrint('🔌 Initializing WebSocket with ${symbols.length} symbols');

      _webSocketService = LocalWebSocketService(
        symbols: symbols,
        token: token,
        onData: (data) {
          // debugPrint('📊 WebSocket data: ${data['item_code']}');
        },
      );
      Get.put<LocalWebSocketService>(_webSocketService!, permanent: true);
      debugPrint('✅ WebSocket service initialized');
    } catch (e) {
      debugPrint('❌ Error initializing WebSocket: $e');
    }
  }

  @override
  void dispose() {
    if (_webSocketService != null) {
      debugPrint('🔴 Disposing WebSocket service');
      _webSocketService!.dispose();
      try {
        Get.delete<LocalWebSocketService>();
        debugPrint('✅ WebSocket service removed from GetX');
      } catch (e) {
        debugPrint('⚠️ Could not remove WebSocket from GetX: $e');
      }

      _webSocketService = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final symbol = tradingController.symbol.value;

      // debugPrint('📊 liveData updated: ${symbol.toString()}');

      //  final instrument =
      //         tradingController.getInstrument(order.instrumentId) ??
      //         InstrumentModel(
      //           instrumentId: order.instrumentId,
      //           name: instrumentName,
      //           code: instrumentName,
      //         );

      final instrument =
          tradingController.getInstrumentByCode(symbol) ??
          InstrumentModel(instrumentId: 0, code: symbol, name: symbol, decimalPlaces: 2);
      //  final InstrumentModel? instrument = tradingController.getInstrument(
      //               position.instrumentId,
      //             );

      // final OrderController orderController = Get.put(OrderController());

      //  final isExpanded =
      //           orderController.expandedOrderIndex.value == index;
      final List<Widget> pages = [
        HomePage(),
        // LiveCandlestickChart(
        //   symbol: symbol
        //   ),
        // CandlestickChartWidget(),
        TradingViewWeb(symbol: symbol, webSocketService: _webSocketService),
        // TradingViewWeb(symbol: 'XAUUSD'),
        // TradingViewMobile(symbol: symbol,),
        // TradingViewChart(symbol: symbol),
        TradingPage(symbol: symbol, instrument: instrument),
        // TradingPage(accountId: 4),
        HistoryPage(
          instrument: instrument,
          // position: position,

          //  isExpanded: isExpanded,
          //     onToggleExpand: () {
          //       orderController.expandedOrderIndex.value =
          //           isExpanded ? null : index;
          //     },
        ),

        // HistoryPage(
        //   instrument: InstrumentModel(
        //     instrumentId: 0,
        //     code: symbol,
        //     name: symbol,
        //   ),
        // ),
        MessagePage(),
      ];
      return ValueListenableBuilder<int>(
        valueListenable: MainTabView.selectedIndexNotifier,
        builder: (context, index, _) {
          return ResponsiveLayout(
            //Mobile layout
            mobile: Scaffold(
              body: SafeArea(child: pages[index]),
              bottomNavigationBar: BottomNavBar(),
            ),

            //Tablet layout
            tablet: Scaffold(
              body: Row(
                children: [
                  // Keep bottom navigation as side navigation
                  NavigationRail(
                    selectedIndex: index,
                    onDestinationSelected: (i) {
                      MainTabView.selectedIndexNotifier.value = i;
                    },
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.show_chart),
                        label: Text('Chart'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.swap_horiz),
                        label: Text('Trade'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.history),
                        label: Text('History'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.message),
                        label: Text('Messages'),
                      ),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(child: pages[index]),
                ],
              ),
            ),

            //  Desktop / Web layout
            desktop: Scaffold(
              body: Row(
                children: [
                  // Persistent side menu
                  Container(
                    width: 250,
                    color: Colors.grey.shade100,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          'NetDania Pro',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        ...[
                          {'icon': Icons.home, 'label': 'Home'},
                          {'icon': Icons.show_chart, 'label': 'Chart'},
                          {'icon': Icons.swap_horiz, 'label': 'Trade'},
                          {'icon': Icons.history, 'label': 'History'},
                          {'icon': Icons.message, 'label': 'Messages'},
                        ].asMap().entries.map((entry) {
                          final i = entry.key;
                          final data = entry.value;
                          return ListTile(
                            leading: Icon(data['icon'] as IconData),
                            title: Text(data['label'] as String),
                            selected: index == i,
                            onTap:
                                () =>
                                    MainTabView.selectedIndexNotifier.value = i,
                          );
                        }),
                      ],
                    ),
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  // Main content area
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: pages[index],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
