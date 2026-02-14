import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/modules/home/view/home_page.dart' as HomePage;
import 'package:netdania/app/modules/order/view/place_order.dart';
import 'package:netdania/app/modules/trade/widgets/market/view/market_screen_view.dart';
import 'package:netdania/utils/tradingview_webchart.dart';
import 'package:netdania/screens/services/socket_connection.dart';

class BottomFeaturePage extends StatelessWidget {
  final String symbol;

  const BottomFeaturePage({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    final TradingChartController tradingController =
        Get.find<TradingChartController>();
    
    LocalWebSocketService? webSocketService;
    try {
      webSocketService = Get.find<LocalWebSocketService>();
    } catch (e) {
      print('⚠️ LocalWebSocketService not found: $e');
      webSocketService = null;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              symbol,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ListTile(
              title: const Text(
                'New Order',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Get.back();
                final ticker = tradingController.getTicker(symbol);
                final currentBuyPrice =
                    double.tryParse(ticker?['a'] ?? '0.0') ?? 0.0;
                final currentSellPrice =
                    double.tryParse(ticker?['b'] ?? '0.0') ?? 0.0;

                Get.to(
                  () => PlaceOrder(
                    symbol: symbol,
                    currentBuyPrice: currentBuyPrice,
                    currentSellPrice: currentSellPrice,
                  ),
                );
              },
            ),
          ),

          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ListTile(
              title: const Text(
                'Chart',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                print("Symbol on click $symbol");
                Get.back();
                Get.to(
                  () => TradingViewWeb(
                    symbol: symbol,
                    webSocketService: webSocketService,
                  ),
                );
              },
            ),
          ),

          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ListTile(
              title: const Text(
                'Depth of Market',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Get.back();
                Get.to(() => MarketScreen(symbol: symbol));
              },
            ),
          ),

          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ListTile(
              title: const Text(
                'Properties',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Get.back();
                Get.dialog(
                  AlertDialog(
                    title: const Text('Properties'),
                    content: const Text('Feature coming soon.'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Cancel Button
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ListTile(
              title: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}