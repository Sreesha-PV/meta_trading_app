import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/models/order_model.dart';
import 'package:netdania/app/modules/order/controller/place_order_controller.dart';
import 'package:netdania/app/modules/trade/widgets/market/controller/market_controller.dart';

class MarketScreen extends StatelessWidget {
  final String symbol;
  // final InstrumentModel instrument;

  MarketScreen({super.key, required this.symbol,});

  final tradingController = Get.find<TradingChartController>();
  final marketController = Get.put(MarketController());
  // final c = Get.find<PlaceOrderController>();
  // final c = Get.put(PlaceOrderController());
  @override
  Widget build(BuildContext context,) {
    //  Retrieve arguments passed from OrderTile
    final args = Get.arguments ?? {};
    final OrderRequestModel? selectedOrder = args['order'];
    final double? currentPrice = args['currentPrice'];
  
    return Scaffold(
      appBar: _buildSymbolAppbar(context),
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background(context),

      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),

      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [

      // if (selectedOrder != null) _buildSelectedOrderCard(selectedOrder, currentPrice),

      
      // Expanded(
      //   child: ListView(
      //     children: const [
      //       // Market data list or whatever you have
      //     ],
      //   ),
      // ),
      //     ],
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final ticker =
              tradingController.tickers[symbol.toUpperCase()] ??
              {'a': '0', 'b': '0'};

          final buyPrice = double.tryParse(ticker['a'] ?? '0') ?? 0.0;
          final sellPrice = double.tryParse(ticker['b'] ?? '0') ?? 0.0;

          return Column(
            children: [
              Row(
                children: [
                  // ----- SL -----
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap:
                              () => marketController.updateSl(
                                sellPrice,
                                increment: false,
                              ),
                          child: const Text(
                            '-',
                            style: TextStyle(fontSize: 24,
                            //  color: Colors.blue
                            color: AppColors.bullish
                             ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: marketController.slController,
                            textAlign: TextAlign.center,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'SL',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap:
                              () => marketController.updateSl(
                                sellPrice,
                                increment: true,
                              ),
                          child: const Text(
                            '+',
                            style: TextStyle(fontSize: 24, color: AppColors.bullish),
                          ),
                        ),
                      ],
                    ),
                    
                  ),
                  Container(height: 2,color: AppColors.bearish,),

                  const SizedBox(width: 12),

                  // ----- VOLUME -----
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _volumeButton('-0.01', -0.01),
                          const SizedBox(width: 4),
                          Obx(
                            () => Text(
                              marketController.volume.value.toStringAsFixed(2),
                              style:  TextStyle(
                                // color: Colors.black,
                                color: AppColors.textPrimary(context),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          _volumeButton('+0.01', 0.01),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ----- TP -----
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap:
                              () => marketController.updateTp(
                                buyPrice,
                                increment: false,
                              ),
                          child: const Text(
                            '-',
                            style: TextStyle(fontSize: 24, 
                            // color: Colors.blue
                            color: AppColors.bullish
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: marketController.tpController,
                            textAlign: TextAlign.center,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'TP',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap:
                              () => marketController.updateTp(
                                buyPrice,
                                increment: true,
                              ),
                          child: const Text(
                            '+',
                            style: TextStyle(fontSize: 24, 
                            // color: Colors.blue
                            color: AppColors.bullish
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // _buildSLTPRow(c),
                  // SizedBox(height: 10,),
                  // // _buildVolumeSelector(context,c),
                  // SizedBox(height: 10,),
                  Container(height: 2,
                  // color: Colors.green,
                  color: AppColors.success,
                  margin: const EdgeInsets.only(top: 4))
                ],
              ),

              // Row(
              //   children: [
              //     if (selectedOrder != null)
              //       _buildSelectedOrderCard(selectedOrder, currentPrice,context),
              //   ],
              // ),


              Row(
                children: [
                  if(selectedOrder != null)
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context,index){
                        return _buildSelectedOrderCard(selectedOrder, currentPrice, context);
                  
                      })
                      )
                ],
              )
            ],
          );
        }),
      ),

      bottomNavigationBar: _buildBottomBar(),
    );
  }
 
  // ---------- Bottom Bar ----------
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => print('Sell tapped'),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'SELL',
                style: TextStyle(
                  // color: Colors.red,
                  color: AppColors.bearish,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(height: 20, width: 1, 
          // color: Colors.grey
          color:AppColors.textSecondary(Get.context!)
          ),
          GestureDetector(
            onTap: () => print('Close tapped'),
            child: Text(
              'CLOSE',
              style: TextStyle(
                // color: Color(0xFFFFAB40),
                color: AppColors.iconText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(height: 20, width: 1,
          //  color: Colors.grey
          color:AppColors.textSecondary(Get.context!)
           ),
          GestureDetector(
            onTap: () => print('Buy tapped'),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'BUY',
                style: TextStyle(
                  // color: Colors.green,
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Volume Button ----------
  Widget _volumeButton(String label, double change) {
    final marketController = Get.find<MarketController>();
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        minimumSize: const Size(20, 20),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () => marketController.updateVolume(change),
      child: Text(
        label,
        style: const TextStyle(
          // color: Colors.blue,
          color: AppColors.bullish,
          fontSize: 12),
      ),
    );
  }
  
 Widget _buildSLTPRow(PlaceOrderController c) {
    return Row(
      children: [
        Expanded(
          child: _priceAdjuster(
            c,
            "SL",
            //  Colors.red,
            AppColors.bearish,
            c.adjustSl,
            c.slController,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _priceAdjuster(
            c,
            "TP",
            //  Colors.green,
            AppColors.success,
            c.adjustTp,
            c.tpController,
          ),
        ),
      ],
    );
  }
  

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
                '-',
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
                  color: AppColors.bullish,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 2,
          color: color,
          margin: const EdgeInsets.only(top: 4),
        ),
      ],
    );
  }
  

  // Widget _buildVolumeSelector(BuildContext context, PlaceOrderController c) {
  //   final width = MediaQuery.of(context).size.width;

  //   // Responsive adjustments
  //   final bool isMobile = width < 600;
  //   final bool isTablet = width >= 600 && width < 1100;
  //   final bool isDesktop = width >= 1100;

  //   final double fontSize = isMobile ? 14 : (isTablet ? 15 : 16);
  //   final double spacing = isMobile ? 8 : (isTablet ? 10 : 12);
  //   final double volumeFontSize = isMobile ? 16 : (isTablet ? 18 : 20);

  //   return Center(
  //     child: Container(
  //       constraints: const BoxConstraints(maxWidth: 600),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           // Horizontal scrolling if too wide
  //           SingleChildScrollView(
  //             scrollDirection: Axis.horizontal,
  //             child: Obx(
  //               () => Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   _volumeButton(c, '-0.5', -0.5, fontSize),
  //                   SizedBox(width: spacing),
  //                   _volumeButton(c, '-0.1', -0.1, fontSize),
  //                   SizedBox(width: spacing),
  //                   _volumeButton(c, '-0.01', -0.01, fontSize),
  //                   SizedBox(width: spacing),
  //                   Column(
  //                     children: [
  //                       Text(
  //                         c.volume.value.toStringAsFixed(2),
  //                         style: TextStyle(
  //                           // color: Colors.black,
  //                           color: AppColors.textPrimary,
  //                           fontSize: volumeFontSize,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(width: spacing),
  //                   _volumeButton(c, '+0.01', 0.01, fontSize),
  //                   SizedBox(width: spacing),
  //                   _volumeButton(c, '+0.1', 0.1, fontSize),
  //                   SizedBox(width: spacing),
  //                   _volumeButton(c, '+0.5', 0.5, fontSize),
  //                 ],
  //               ),
  //             ),
  //           ),

  //           // Divider
  //           Container(
  //             margin: const EdgeInsets.only(top: 6),
  //             height: 1,
  //             width: double.infinity,
  //             color: Colors.grey[300],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


  // );
}


Widget _buildSelectedOrderCard(OrderRequestModel order, double? currentPrice,BuildContext context) {
  final isBuy = order.side == 2;
  final sideColor = isBuy
  //  ? Colors.blue : Colors.red;
    ? AppColors.bullish : AppColors.bearish;

  return Container(
    width: MediaQuery.of(context).size.width/2, // Ensures bounded width
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded( //Prevent overflow in left column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${order.instrumentId}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '${isBuy ? 'Buy' : 'Sell'} ${order.orderQty}',
                style: TextStyle(
                    color: sideColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              Text(
                'Entry: ${order.orderPrice.toStringAsFixed(4)}',
                style:  TextStyle(fontSize: 13,
                //  color: Colors.grey
                color:AppColors.textSecondary(context)
                 ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded( //  Prevent overflow in right column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currentPrice == null
                    ? '...'
                    : 'Current: ${currentPrice.toStringAsFixed(4)}',
                style:  TextStyle(fontSize: 13,
                //  color: Colors.grey
                color:AppColors.textSecondary(context)
                 ),
              ),
              // Text(
              //   'T/P: ${order.takeProfit?.toStringAsFixed(4) ?? "N/A"}',
              //   style: const TextStyle(fontSize: 13, 
              //   // color: Colors.grey
              //   color:AppColors.textSecondary
              //   ),
              // ),
              // Text(
              //   'S/L: ${order.stopLoss?.toStringAsFixed(4) ?? "N/A"}',
              //   style: const TextStyle(fontSize: 13, 
              //   // color: Colors.grey
              //   color:AppColors.textSecondary
              //   ),
              // ),
            ],
          ),
        ),
      ],
    ),
  );
}

String _getSideLabel(int side) {
  switch (side) {
    case 1:
      return 'Sell';
    case 2:
      return 'Buy';
    default:
      return 'Unknown';
  }
}

// ---------- AppBar ----------
PreferredSizeWidget _buildSymbolAppbar(BuildContext context) {
  return AppBar(
    // backgroundColor: Colors.white,
    backgroundColor: AppColors.background(context),
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_sharp, 
          // color: Colors.black
          color: AppColors.textPrimary(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        // Text(symbol, style: const TextStyle(color: Colors.black, fontSize: 18)),
        const Spacer(),
        PopupMenuButton<String>(
          icon:  Icon(Icons.refresh,
          //  color: Colors.black
          color: AppColors.textPrimary(context),
           ),
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'All symbol', child: Text('Symbol')),
              ],
        ),
      ],
    ),
  );
}
// }
