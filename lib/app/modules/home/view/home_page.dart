import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
// import 'package:netdania/app/features/widgets/add/add_symbol.dart';
import 'package:netdania/app/features/widgets/edit/edit_symbol.dart';
import 'package:netdania/app/getX/trade_getX.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/modules/home/widgets/app_drawer.dart';
import 'package:netdania/app/modules/home/widgets/bottom_features.dart';
import 'package:netdania/helper/pricewidget.dart';
import 'package:netdania/utils/common_menu.dart';
// import 'package:netdania/screens/services/symbol_storage_service.dart';
import 'package:netdania/app/getX/symbol_filter_controller.dart';
import 'dart:ui';

// final ValueNotifier<bool> isSimpleViewMode = ValueNotifier(false);
final Rx<bool> isSimpleViewMode = false.obs;

class HomePage extends StatelessWidget {
  static final ValueNotifier<int> selectedIndexNotifier = ValueNotifier(2);
  static final ValueNotifier<bool> isMoreExpandedNotifier = ValueNotifier(
    false,
  );
  static final ValueNotifier<bool> isChartPageNotifier = ValueNotifier(false);
  static final ValueNotifier<String?> selectedChartSymbolNotifier =
      ValueNotifier(null);
  static final ValueNotifier<bool> isSearchingNotifier = ValueNotifier(false);
  static final TextEditingController searchController = TextEditingController();
  static final ValueNotifier<String> searchQueryNotifier = ValueNotifier('');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final TradePageController tradeController = Get.find<TradePageController>();
    final TradingChartController chartController =
        Get.find<TradingChartController>();
    final SymbolFilterController symbolFilterController =
        Get.isRegistered<SymbolFilterController>()
            ? Get.find<SymbolFilterController>()
            : Get.put(SymbolFilterController(), permanent: true);

    _subscribeToSymbols(
      tradeController,
      chartController,
      symbolFilterController,
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, symbolFilterController),
      drawer: CommonDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            if (symbolFilterController.isLoading.value) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading symbols...'),
                  ],
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                if (width >= 1100) {
                  return const Text('data');
                } else if (width >= 600) {
                  return _buildTabletLayout(
                    tradeController,
                    symbolFilterController,
                  );
                } else {
                  return Obx(() {
                    final selectedSymbols =
                        symbolFilterController.selectedSymbols;

                    if (selectedSymbols.isEmpty) {
                      return _buildEmptyState(context, symbolFilterController);
                    }

                    final liveData = tradeController.liveData;
                    // final symbols = tradeController.symbols;

                    final displayData =
                        liveData.isNotEmpty
                            ? liveData
                                .where(
                                  (item) =>
                                      selectedSymbols.contains(item['symbol']),
                                )
                                .toList()
                            : selectedSymbols.map((symbol) {
                              final ticker = tradeController.getTicker(symbol);
                              return {
                                'symbol': symbol,
                                'sell': ticker?['bid'] ?? 0,
                                'buy': ticker?['ask'] ?? 0,
                                'high': ticker?['high'] ?? 0,
                                'low': ticker?['low'] ?? 0,
                                'priceChange': ticker?['priceChange'] ?? 0,
                                'percentChange': ticker?['percentChange'] ?? 0,
                                'time': ticker?['time'] ?? '',
                                'volume': ticker?['volume'] ?? '',
                              };
                            }).toList();
                    return ValueListenableBuilder<String>(
                      valueListenable: searchQueryNotifier,
                      builder: (context, searchQuery, _) {
                        final filteredData = _filterDataBySearch(
                          displayData,
                          searchQuery,
                        );

                        if (filteredData.isEmpty && searchQuery.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No symbols found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try a different search term',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return isSimpleViewMode.value
                            ? _buildSimpleView(filteredData)
                            : _buildTradingList(filteredData);
                      },
                    );
                  });
                }
              },
            );
          }),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _filterDataBySearch(
    List<Map<String, dynamic>> data,
    String query,
  ) {
    if (query.isEmpty) return data;

    return data.where((item) {
      final symbol = item['symbol'].toString().toLowerCase();
      return symbol.contains(query);
    }).toList();
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    SymbolFilterController symbolFilterController,
  ) {
    return AppBar(
      backgroundColor: AppColors.background,
      automaticallyImplyLeading: false,
      title: ValueListenableBuilder<bool>(
        valueListenable: isSearchingNotifier,
        builder: (context, isSearching, _) {
          if (isSearching) {
            return TextField(
              controller: searchController,
              autofocus: true,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Search symbols...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                searchQueryNotifier.value = value.toLowerCase();
              },
            );
          }

          return Row(
            children: [
              Transform.translate(
                offset: const Offset(-8, 0),
                child: CommonMenuIcon(scaffoldKey: _scaffoldKey),
              ),
              Expanded(
                child: Obx(() {
                  final count = symbolFilterController.selectedSymbols.length;
                  return Text(
                    count > 0 ? 'Quotes ($count)' : 'Quotes',
                    style: const TextStyle(color: AppColors.textPrimary),
                  );
                }),
              ),
            ],
          );
        },
      ),
      actions: [
        Obx(
          () => IconButton(
            onPressed: () {
              isSimpleViewMode.value = !isSimpleViewMode.value;
            },
            icon: Icon(
              isSimpleViewMode.value ? Icons.view_list : Icons.view_module,
            ),
            tooltip: isSimpleViewMode.value ? 'List View' : 'Simple View',
          ),
        ),
        // IconButton(
        //   onPressed: () async {
        //     await Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (_) => AddSymbolPage()),
        //     );
        //     // Refresh symbols after returning
        //     await symbolFilterController.loadSelectedSymbols();
        //   },
        //   icon: const Icon(Icons.add),
        //   tooltip: 'Add Symbol',
        // ),
        ValueListenableBuilder<bool>(
          valueListenable: isSearchingNotifier,
          builder: (context, isSearching, _) {
            if (isSearching) return const SizedBox.shrink();
            return IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditSymbolPage()),
                );
                await symbolFilterController.loadSelectedSymbols();
              },
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Symbols',
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isSearchingNotifier,
          builder: (context, isSearching, _) {
            return IconButton(
              onPressed: () {
                if (isSearching) {
                  isSearchingNotifier.value = false;
                  searchController.clear();
                  searchQueryNotifier.value = '';
                } else {
                  isSearchingNotifier.value = true;
                }
              },
              icon: Icon(isSearching ? Icons.close : Icons.search),
              tooltip: isSearching ? 'Close Search' : 'Search Symbols',
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    SymbolFilterController symbolFilterController,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.show_chart, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No Symbols Selected',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add symbols to start tracking',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditSymbolPage()),
              );
              await symbolFilterController.loadSelectedSymbols();
            },
            icon: const Icon(Icons.add),
            label: const Text('Select Symbols'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingList(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        final isFirst = index == 0;
        return Padding(
          padding: EdgeInsets.only(top: isFirst ? 10.0 : 0),
          child: _buildTradingItem(item),
        );
      },
    );
  }

  Widget _buildSimpleView(List<Map<String, dynamic>> data) {
    return Column(
      children: [
        _buildSimpleHeader(),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return _buildSimpleItem(item, isFirst: index == 0);
            },
          ),
        ),
      ],
    );
  }

  void _subscribeToSymbols(
    TradePageController tradeController,
    TradingChartController chartController,
    SymbolFilterController symbolFilterController,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ever<List<String>>(symbolFilterController.selectedSymbolsRx, (
        selectedSymbols,
      ) {
        debugPrint('📡 Selected symbols changed: $selectedSymbols');
        if (selectedSymbols.isNotEmpty) {
          chartController.subscribeToSymbols(selectedSymbols);
        } else {
          debugPrint('⚠️ No symbols selected');
        }
      });
    });
  }

  Widget _buildTradingItem(dynamic item) {
    final dotPosition = item['dot_position'] ?? 5;
    final highStr = _formatLimit(item['high']);
    final lowStr = _formatLimit(item['low']);

    return GestureDetector(
      // ← Move here
      behavior: HitTestBehavior.opaque,
      onTap: () => _showBottomSheet(item['symbol']),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildSymbolWidget(item),
                const Spacer(),
                _buildPriceWidget(
                  item['sell'],
                  item['sellUp'],
                  lowStr,
                  isSell: true,
                  dotPosition: dotPosition,
                ),
                SizedBox(width: 10),
                _buildPriceWidget(
                  item['buy'],
                  item['buyUp'],
                  highStr,
                  dotPosition: dotPosition,
                ),
                SizedBox(width: 5),
              ],
            ),
            // const SizedBox(height: 6),
            const Divider(color: AppColors.divider, thickness: 0.5),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleItem(dynamic item, {bool isFirst = false}) {
    final dotPosition = item['dot_position'] ?? 5;
    final lowStr = _formatLimit(item['low']);
    final highStr = _formatLimit(item['high']);
    final percentChange =
        (item['percentChange'] is num)
            ? (item['percentChange'] as num).toDouble()
            : double.tryParse(item['percentChange']?.toString() ?? '0') ?? 0.0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showBottomSheet(item['symbol']),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, isFirst ? 20 : 0, 16, 0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    item['symbol'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: PriceWidget(
                    price: item['sell'],
                    isUp: item['sellUp'] == true,
                    limitStr: lowStr,
                    isSell: true,
                    dotPosition: dotPosition,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: PriceWidget(
                    price: item['buy'],
                    isUp: item['buyUp'] == true,
                    limitStr: highStr,
                    dotPosition: dotPosition,
                  ),
                ),
                Expanded(flex: 1, child: _buildPercentChange(percentChange)),
              ],
            ),
            const SizedBox(height: 6),
            const Divider(color: AppColors.divider, thickness: 0.5),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentChange(double percentChange) {
    final sign = percentChange >= 0 ? '+' : '';
    final isPositive = percentChange >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$sign${percentChange.toStringAsFixed(2)}%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isPositive ? Colors.blue : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Symbol',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Bid',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Ask',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Day %',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymbolWidget(dynamic item) {
    final symbol = item['symbol'] ?? '';
    // final priceChange = double.tryParse(item['priceChange'] ?? '0') ?? 0;
    // final percentChange = double.tryParse(item['percentChange'] ?? '0') ?? 0;

    final priceChange =
        (item['priceChange'] is num)
            ? (item['priceChange'] as num).toDouble()
            : double.tryParse(item['priceChange']?.toString() ?? '0') ?? 0.0;

    final percentChange =
        (item['percentChange'] is num)
            ? (item['percentChange'] as num).toDouble()
            : double.tryParse(item['percentChange']?.toString() ?? '0') ?? 0.0;

    final percentColor = percentChange > 0 ? AppColors.up : AppColors.down;

    return Flexible(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12),
              children: [
                TextSpan(
                  text:
                      '${priceChange > 0 ? "+" : ""}${priceChange.toStringAsFixed(2)} ',
                  style: const TextStyle(
                    // color: Colors.grey
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: '${percentChange.toStringAsFixed(2)}%',
                  style: TextStyle(color: percentColor, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          // Text(
          //   symbol,
          //   style: const TextStyle(
          //     fontSize: 15,
          //     fontWeight: FontWeight.w600,
          //     letterSpacing: -0.8,
          //     height: 1.5,
          //   ),
          //   textHeightBehavior: const TextHeightBehavior(
          //     applyHeightToFirstAscent: true,
          //     applyHeightToLastDescent: true,
          //   ),
          // ),
          Transform.scale(
            scaleY: 1.2,
            child: Text(
              symbol,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                item['time'] ?? '',
                style: const TextStyle(
                  fontSize: 13,
                  //  color: Colors.grey
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              if (item['volume'] != null)
                Text(
                  '⇄ ${item['volume']}',
                  style: const TextStyle(
                    fontSize: 13,
                    //  color: Colors.grey
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  //   Widget _buildPriceWidget(dynamic price, bool? isUp, String? limitStr, {bool isSell = false}) {
  //   final parsed = price is num
  //       ? price.toStringAsFixed(5)
  //       : double.tryParse(price?.toString() ?? '')?.toStringAsFixed(5) ?? '--.-----';

  //   final parts = parsed.split('.');
  //   final beforeDecimal = parts[0];
  //   final afterDecimal = parts.length > 1 ? parts[1] : '';

  //   // Optional: Highlight digits if you want
  //   final firstTwo = afterDecimal.length >= 2 ? afterDecimal.substring(0, 2) : afterDecimal;
  //   final lastThree = afterDecimal.length > 2 ? afterDecimal.substring(2) : '';

  //   return Expanded(
  //     flex: 1,
  //     child: Column(
  //       crossAxisAlignment: isSell ? CrossAxisAlignment.center : CrossAxisAlignment.end,
  //       children: [
  //         RichText(
  //           text: TextSpan(
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               color: (isUp ?? false) ? Colors.blue : Colors.red,
  //             ),
  //             children: [
  //               TextSpan(text: '$beforeDecimal.'),
  //               TextSpan(text: firstTwo, style: const TextStyle(fontSize: 18)),
  //               TextSpan(text: lastThree, style: const TextStyle(fontSize: 24)),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           '${isSell ? "L" : "H"}: ${limitStr ?? "-"}',
  //           style: const TextStyle(
  //             color: Colors.grey,
  //             fontSize: 12,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPriceWidget(
    dynamic price,
    bool? isUp,
    String? limitStr, {
    bool isSell = false,
    int dotPosition = 5,
  }) {
    double? priceValue;
    if (price is num) {
      priceValue = price.toDouble();
    } else {
      priceValue = double.tryParse(price?.toString() ?? '');
    }

    if (priceValue == null) {
      return _buildEmptyPriceWidget(limitStr, isSell);
    }

    final label = isSell ? "L" : "H";
    final limitValue = double.tryParse(limitStr ?? '');
    final formattedLimit =
        limitValue == null ? '-' : limitValue.toStringAsFixed(dotPosition);

    Color color;
    if (isUp == null) {
      color = Colors.black;
    } else {
      color = isUp ? AppColors.up : AppColors.down;
    }

    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment:
            isSell ? CrossAxisAlignment.center : CrossAxisAlignment.end,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(begin: priceValue, end: priceValue),
            builder: (context, animatedValue, child) {
              final formatted = animatedValue.toStringAsFixed(dotPosition);
              final parts = formatted.split('.');
              final beforeDecimal = parts[0];
              final afterDecimal = parts.length > 1 ? parts[1] : '';

              String normalDigits = '';
              String bigDigits = '';
              String smallDigit = '';

              if (dotPosition == 2) {
                bigDigits = afterDecimal;
              } else if (dotPosition > 2) {
                final bigCount = 2;
                final smallCount = 1;

                if (afterDecimal.length >= bigCount + smallCount) {
                  normalDigits = afterDecimal.substring(
                    0,
                    afterDecimal.length - bigCount - smallCount,
                  );
                  bigDigits = afterDecimal.substring(
                    afterDecimal.length - bigCount - smallCount,
                    afterDecimal.length - smallCount,
                  );
                  smallDigit = afterDecimal.substring(
                    afterDecimal.length - smallCount,
                  );
                } else {
                  normalDigits = afterDecimal;
                }
              } else {
                normalDigits = afterDecimal;
              }

              return FittedBox(
                fit: BoxFit.scaleDown,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: color,
                      height: 1.0,
                    ),
                    children: [
                      TextSpan(
                        text: '$beforeDecimal.',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1,
                        ),
                      ),
                      if (normalDigits.isNotEmpty)
                        TextSpan(
                          text: normalDigits,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                        ),
                      if (bigDigits.isNotEmpty)
                        TextSpan(
                          text: bigDigits,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -2.0,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      if (smallDigit.isNotEmpty)
                        WidgetSpan(
                          alignment: PlaceholderAlignment.top,
                          child: Transform.translate(
                            offset: const Offset(1, -6),
                            child: Text(
                              smallDigit,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: color,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            '$label: $formattedLimit',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPriceWidget(String? limitStr, bool isSell) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment:
            isSell ? CrossAxisAlignment.center : CrossAxisAlignment.end,
        children: [
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '--.-----',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${isSell ? "L" : "H"}: ${limitStr ?? "-"}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(String? symbol) {
    if (symbol == null) return;

    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel:
          MaterialLocalizations.of(Get.context!).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              maxWidth: 350,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.70),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: BottomFeaturePage(symbol: symbol),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  String _formatLimit(dynamic value) {
    if (value == null) return '-';
    return (value is num)
        ? value.toStringAsFixed(4)
        : double.tryParse(value.toString())?.toStringAsFixed(4) ?? '-';
  }

  /// ---------------- DESKTOP / WEB LAYOUT ----------------
  // Widget _buildDesktopLayout(TradePageController controller) {
  //   return Row(
  //     children: [
  //       // Left: Trading list
  //       Expanded(
  //         flex: 2,
  //         child: Container(
  //           padding: const EdgeInsets.all(8),
  //           child: _buildTradingList(controller),
  //         ),
  //       ),

  //       const VerticalDivider(thickness: 1, width: 1),

  //       // Center: Chart or details
  //       Expanded(
  //         flex: 3,
  //         child: Container(
  //           color: Colors.grey.shade50,
  //           child: const Center(
  //             child: Text(
  //               "Chart / Symbol Details (placeholder)",
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 //  color: Colors.grey
  //                 color: AppColors.textSecondary,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),

  //       const VerticalDivider(thickness: 1, width: 1),

  //       // Right: Orders or positions
  //       Expanded(
  //         flex: 2,
  //         child: Container(
  //           // color: Colors.white,
  //           color: AppColors.background,
  //           padding: const EdgeInsets.all(8),
  //           child: const Center(
  //             child: Text(
  //               "Open Orders / Trade Summary (placeholder)",
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 // color: Colors.grey
  //                 color: AppColors.textSecondary,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildTabletLayout(
    TradePageController tradeController,
    SymbolFilterController symbolFilterController,
  ) {
    return Obx(() {
      final selectedSymbols = symbolFilterController.selectedSymbols;

      if (selectedSymbols.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No Symbols Selected',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add symbols to start tracking',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        );
      }

      final liveData = tradeController.liveData;

      final displayData =
          liveData.isNotEmpty
              ? liveData
                  .where((item) => selectedSymbols.contains(item['symbol']))
                  .toList()
              : selectedSymbols.map((symbol) {
                final ticker = tradeController.getTicker(symbol);
                return {
                  'symbol': symbol,
                  'sell': ticker?['bid'] ?? 0,
                  'buy': ticker?['ask'] ?? 0,
                  'high': ticker?['high'] ?? 0,
                  'low': ticker?['low'] ?? 0,
                  'priceChange': ticker?['priceChange'] ?? 0,
                  'percentChange': ticker?['percentChange'] ?? 0,
                  'time': ticker?['time'] ?? '',
                  'volume': ticker?['volume'] ?? '',
                };
              }).toList();

      // Apply search filter
      return ValueListenableBuilder<String>(
        valueListenable: searchQueryNotifier,
        builder: (context, searchQuery, _) {
          final filteredData = _filterDataBySearch(displayData, searchQuery);

          if (filteredData.isEmpty) {
            if (searchQuery.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No symbols found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text("No data yet."));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.8,
            ),
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              final item = filteredData[index];
              return Card(
                elevation: 1,
                color: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6,
                  ),
                  child: _buildTradingItem(item),
                ),
              );
            },
          );
        },
      );
    });
  }
}
