import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/modules/order/components/date_picker.dart';
import 'package:netdania/app/modules/order/components/datetime_picker_sheet.dart';
import 'package:netdania/app/modules/order/controller/place_order_controller.dart';
import 'package:netdania/utils/responsive_layout_helper.dart';
// import 'package:netdania/utils/tradingview_webchart.dart';
// import 'package:netdania/app/config/theme/app_color.dart';

/// ---------------- VIEW ----------------
class PlaceOrder extends StatelessWidget {
  final String symbol;
  final double currentBuyPrice;
  final double currentSellPrice;

  const PlaceOrder({
    super.key,
    required this.symbol,
    required this.currentBuyPrice,
    required this.currentSellPrice,
  });


  @override
  Widget build(BuildContext context) {
    final c = Get.put(PlaceOrderController(), permanent: true);

    // final c = Get.find<PlaceOrderController>();

    c.symbol.value = symbol;
    c.currentBuyPrice.value = currentBuyPrice;
    c.currentSellPrice.value = currentSellPrice;

    // c.setSymbol(symbol);
    // c.currentBuyPrice.value = currentBuyPrice;
    // c.currentSellPrice.value = currentSellPrice;

    return ResponsiveLayout(
      mobile: _buildScaffold(context, c, const EdgeInsets.all(0)),
      tablet: _buildScaffold(
        context,
        c,
        const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      ),
      desktop: _buildDesktopLayout(context, c),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    PlaceOrderController c,
    EdgeInsets padding,
  ) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, c),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: _buildOrderBody(context, c, padding),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, PlaceOrderController c) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, c),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildOrderBody(context, c, EdgeInsets.zero),
            ),
            const SizedBox(width: 24),
            // Expanded(
            //   flex: 3,
            //   child: Container(
            //     padding: const EdgeInsets.all(16),
            //     decoration: BoxDecoration(
            //       color: Colors.grey[50],
            //       borderRadius: BorderRadius.circular(12),
            //       border: Border.all(color: Colors.grey[300]!),
            //     ),
            //     child: Obx(() {
            //       final data = c.tradingController.getPriceHistory(
            //         c.symbol.value,
            //       );
            //       if (data.isEmpty) {
            //         return const Center(
            //           child: Text("Waiting for live data..."),
            //         );
            //       }
            //       return LineChartWidget(priceHistory: data);
            //     }),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderBody(
    BuildContext context,
    PlaceOrderController c,
    EdgeInsets padding,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderTypeDropdown(c),
            Divider(
              height: 1,
              thickness: 0.5,
              color: CupertinoColors.separator.withOpacity(0.3),
            ),
            _buildVolumeSelector(context, c),
            const SizedBox(height: 16),
            Obx(() {
              return c.selectedOrderType.value == 0
                  ? const SizedBox.shrink()
                  : Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              'Price',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(child: _buildPriceInput(c)),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
            }),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'Stop Loss',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                    ),
                  ),
                ),
                Expanded(
                  child: _priceAdjuster(
                    c,
                    "SL",
                    AppColors.down,
                    c.adjustSl,
                    c.slController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'Take Profit',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: _priceAdjuster(
                    c,
                    "TP",
                    AppColors.success,
                    c.adjustTp,
                    c.tpController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              return c.selectedOrderType.value == 0
                  ? _buildFillPolicyDropdown(c, context)
                  : Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          'Expiration',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(child: _buildExpiryDropDown(c, context)),
                    ],
                  );
            }),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.lightNeutral,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                final symbol = c.symbol.value;
                final ticker = c.tradingController.getTicker(symbol);
                final bidRaw = ticker?['bid'];
                final askRaw = ticker?['ask'];
                final dotPositionRaw = ticker?['dot_position'];
                final sell = double.tryParse(bidRaw?.toString() ?? '0') ?? 0;
                final buy = double.tryParse(askRaw?.toString() ?? '0') ?? 0;
                final dotPosition =
                    int.tryParse(dotPositionRaw?.toString() ?? '5') ?? 5;
                final color =
                    c.tradingController.isPriceUp
                        ? AppColors.up
                        : AppColors.down;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _formattedPrice(sell, color, dotPosition),
                    _formattedPrice(buy, color, dotPosition),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),
            Obx(() {
              return c.selectedOrderType.value == 0
                  ? _buildBottomButtons(c, context)
                  : _buildBottomPlaceButton(c);
            }),
          ],
        ),
      ),
    );
  }

  /// ---------------- UI PARTS ----------------
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PlaceOrderController c,
  ) {
    return AppBar(
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background,
      // automaticallyImplyLeading: false,
      title: Row(
        children: [
          // IconButton(
          //   icon: const Icon(Icons.arrow_back, color: Colors.black),
          //   onPressed: () => Navigator.pop(context),
          // ),
          Obx(() {
            return Text(
              c.symbol.value,
              style: const TextStyle(
                // color: Colors.black,
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            );
          }),
          // Text(
          //   c.symbol.value,
          //   style: const TextStyle(
          //     // color: Colors.black,
          //     color: AppColors.textPrimary,
          //     fontSize: 18,
          //   ),
          // ),
          const Spacer(),

          // const Icon(
          //   Icons.refresh,
          //   // color: Colors.black
          //   color: AppColors.textPrimary,
          // ),
          PopupMenuButton<InstrumentModel>(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onSelected: (instrument) {
              c.changeSymbol(instrument);
              // Get.find<ChartController>().loadCandles(newSymbol: instrument.code);
            },
            itemBuilder: (context) {
              if (c.isLoadingInstruments.value) {
                return [
                  const PopupMenuItem(
                    enabled: false,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ];
              }

              if (c.instruments.isEmpty) {
                return const [
                  PopupMenuItem(enabled: false, child: Text('No instruments')),
                ];
              }

              return c.instruments.map((instrument) {
                return PopupMenuItem<InstrumentModel>(
                  value: instrument,
                  child: Text(instrument.code),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTypeDropdown(PlaceOrderController c) {
    const Map<int, String> orderTypeOptions = {
      0: 'Market Execution',
      1: 'Buy Limit',
      2: 'Sell Limit',
      3: 'Buy Stop',
      4: 'Sell Stop',
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: c.selectedOrderType.value,
            isExpanded: true,
            icon: const Icon(
              CupertinoIcons.chevron_down,
              color: CupertinoColors.secondaryLabel,
              size: 20,
            ),
            style: const TextStyle(
              fontSize: 17,
              color: CupertinoColors.label,
              fontWeight: FontWeight.w400,
            ),
            dropdownColor: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            elevation: 8,
            itemHeight: 48,
            items:
                orderTypeOptions.entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (int? val) {
              if (val == null) return;
              c.selectedOrderType.value = val;
              if (val == 0) {
                c.priceController.clear();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPriceInput(PlaceOrderController c) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                c.adjustPrice(-0.1);
              },
              child: const Text(
                '⎼',
                style: TextStyle(fontSize: 24, color: AppColors.info),
              ),
            ),
            Expanded(
              child: TextField(
                controller: c.priceController,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'Not Set',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (_) => c.syncTextWithPrice(),
              ),
            ),
            GestureDetector(
              onTap: () {
                c.adjustPrice(0.1);
              },
              child: const Text(
                '+',
                style: TextStyle(fontSize: 24, color: AppColors.up),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVolumeSelector(BuildContext context, PlaceOrderController c) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.only(bottom: 8)),

            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _volumeButton(c, '-0.5', -0.5),
                  _volumeButton(c, '-0.1', -0.1),

                  c.isEditingVolume.value
                      ? Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: CupertinoTextField(
                          controller: c.volumeTextController,
                          focusNode: c.volumeFocusNode,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          autofocus: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onSubmitted: (value) {
                            final newVol = double.tryParse(value);
                            if (newVol != null && newVol >= 0.01) {
                              c.volume.value = newVol;
                            }
                            c.isEditingVolume.value = false;
                          },
                        ),
                      )
                      : GestureDetector(
                        onTap: () {
                          c.volumeTextController.text = c.volume.value
                              .toStringAsFixed(2);
                          c.isEditingVolume.value = true;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            c.volume.value.toStringAsFixed(2),
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                  _volumeButton(c, '+0.1', 0.1),
                  _volumeButton(c, '+0.5', 0.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _volumeButton(PlaceOrderController c, String label, double delta) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: () {
        final newVol = c.volume.value + delta;
        if (newVol >= 0.01) {
          c.volume.value = newVol;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Widget _buildSLTPRow(PlaceOrderController c) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: _priceAdjuster(
  //           c,
  //           "SL",
  //           //  Colors.red,
  //           AppColors.down,
  //           c.adjustSl,
  //           c.slController,
  //         ),
  //       ),
  //       const SizedBox(width: 12),
  //       Expanded(
  //         child: _priceAdjuster(
  //           c,
  //           "TP",
  //           //  Colors.green,
  //           AppColors.success,
  //           c.adjustTp,
  //           c.tpController,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _priceAdjuster(
    PlaceOrderController c,
    String label,
    Color color,
    void Function(double) onChange,
    TextEditingController controller,
  ) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => onChange(-0.1),
              child: const Text(
                '⎼',
                style: TextStyle(
                  fontSize: 24,
                  //  color: Colors.blue
                  color: AppColors.info,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: label,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onChange(0.1),
              child: const Text(
                '+',
                style: TextStyle(
                  fontSize: 24,
                  //  color: Colors.blue
                  color: AppColors.up,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFillPolicyDropdown(
    PlaceOrderController c,
    BuildContext context,
  ) {
    const policies = ['Fill or Kill', 'Immediate or Cancel'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Fill Policy',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            // Spacer(),
            Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: c.selectedFillPolicy.value,
                  alignment: Alignment.centerRight,
                  dropdownColor: AppColors.background,
                  onChanged: (v) => c.selectedFillPolicy.value = v!,
                  items:
                      policies
                          .map(
                            (val) => DropdownMenuItem(
                              value: val,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  val,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    // color: Colors.black
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 1.5,
          color: Colors.grey[300],
          margin: const EdgeInsets.only(top: 6),
        ),
      ],
    );
  }

  Widget _buildExpiryDropDown(PlaceOrderController c, BuildContext context) {
    // const expirations = ['GTC', 'Today', 'Specified', 'Specified day'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min, // shrink-wrap row
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: c.selectedExpiration.value,
                    isExpanded: true,
                    alignment: Alignment.centerRight,
                    dropdownColor: AppColors.background,

                    // THIS controls what is shown when selected
                    selectedItemBuilder: (context) {
                      return ['GTC', 'Today', 'Specified', 'Specified day']
                          .map(
                            (_) => Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                c.expirationDisplayValue,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList();
                    },

                    onChanged: (v) async {
                      if (v == null) return;

                      c.selectedExpiration.value = v;

                      if (v == 'Specified') {
                        await showDateTimePicker(context);
                      } else if (v == 'Specified day') {
                        await showDatePicker(context);
                      } else {
                        c.expirationDate.value = null;
                      }
                    },

                    items: const [
                      DropdownMenuItem(value: 'GTC', child: Text('GTC')),
                      DropdownMenuItem(value: 'Today', child: Text('Today')),
                      DropdownMenuItem(
                        value: 'Specified',
                        child: Text('Specified'),
                      ),
                      DropdownMenuItem(
                        value: 'Specified day',
                        child: Text('Specified day'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButtons(PlaceOrderController c, BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      // decoration: BoxDecoration(
      //   color: AppColors.neutral,
      //   border: Border(top: BorderSide(color: Colors.grey[300]!)),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    c.placeOrder(false);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.down,
                      // borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          'Sell by Market',
                          style: TextStyle(
                            color: AppColors.surface,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    c.placeOrder(true);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.up,
                      // borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          'Buy by Market',
                          style: TextStyle(
                            color: AppColors.surface,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Attention! The trade will be executed at market condition. Difference with requested price may be significant!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPlaceButton(PlaceOrderController c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.neutral,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),

      child: Column(
        children: [
          GestureDetector(
            onTap: () => c.placeOrder(false),
            child: Column(
              children: const [
                Text(
                  'Place',
                  style: TextStyle(
                    // color: Colors.red,
                    color: AppColors.surface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _formattedPrice(double priceValue, Color color, int dotPosition) {
    return TweenAnimationBuilder<double>(
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

        return RichText(
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
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
              if (normalDigits.isNotEmpty)
                TextSpan(
                  text: normalDigits,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                ),
              if (bigDigits.isNotEmpty)
                TextSpan(
                  text: bigDigits,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -2.0,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              if (smallDigit.isNotEmpty)
                WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: Transform.translate(
                    offset: const Offset(1, -8),
                    child: Text(
                      smallDigit,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: color,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showDateTimePicker(BuildContext context) async {
    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const DateTimePickerSheet(),
    );

    if (result != null) {
      final c = Get.find<PlaceOrderController>();
      c.expirationDate.value = result;
    }
  }

  // Future<void> showDatePicker(BuildContext context) async {
  //   final result = await showModalBottomSheet<DateTime>(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (_) => const DatePickerSheet(),
  //   );

  //   if (result != null) {
  //     final c = Get.find<PlaceOrderController>();
  //     c.expirationDate.value = result;
  //   }
  // }

  Future<void> showDatePicker(BuildContext context) async {
    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const DatePickerSheet(),
    );

    if (result != null) {
      final c = Get.find<PlaceOrderController>();
      c.expirationDate.value = result;
    }
  }
}

int mapExpirationToTIF(String expiration) {
  switch (expiration) {
    case 'GTC':
      return 1;
    case 'Today':
      return 5; // Day
    case 'Specified day':
      return 3; // GTD  → date only
    case 'Specified':
      return 4; // GTDT → date + time
    default:
      return 1;
  }
}
