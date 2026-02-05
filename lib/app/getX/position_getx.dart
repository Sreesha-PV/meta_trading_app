import 'package:get/get.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/models/positions_model.dart';
import 'package:netdania/screens/services/order_services.dart';
import 'package:netdania/app/getX/trading_getX.dart';
// import 'package:netdania/app/getX/order_getX.dart';
import 'package:netdania/app/modules/trade/helper/symbol_utils.dart';
import 'package:netdania/app/getX/account_getx.dart';
import 'package:netdania/utils/profit_calculator.dart';

class PositionsController extends GetxController {
  RxList<Position> positionOrders = <Position>[].obs;
  var isLoaded = false.obs;

  RxList<Position> get orderFetchList => positionOrders;

  @override
  void onInit() {
    super.onInit();
    loadPositions();
  }

  Future<void> loadPositions() async {
    try {
      final accountController = Get.find<AccountController>();
      final accountId = accountController.selectedAccountId.value;

      final list = await OrderService.positionOrders(accountId);
      positionOrders.assignAll(list);
      isLoaded.value = true;
      print("✓ Positions loaded and cached: ${list.length} positions");
    } catch (e) {
      print("✗ Failed to load positions → $e");
    }
  }

  void addOrUpdatePosition(Position position) {
    final index = positionOrders.indexWhere(
      (p) => p.positionId == position.positionId,
    );
    if (position.positionQty == 0) {
      removePositionById(position.positionId);
      return;
    }

    if (index != -1) {
      positionOrders[index] = position;
      print("✓ Position Array $positionOrders");
      print("✓ Position updated: ID ${position.positionId}");
    } else {
      positionOrders.add(position);
      print("✓ Position Array $positionOrders");
      print("✓ Position added: ID ${position.positionId}");
    }
  }

  void removePositionById(int positionId) {
    final initialLength = positionOrders.length;
    positionOrders.removeWhere((p) => p.positionId == positionId);
    if (positionOrders.length < initialLength) {
      print("✓ Position removed: ID $positionId");
    }
  }

  void removePosition(Position position) {
    removePositionById(position.positionId);
  }

  void handleWebSocketUpdate(Map<String, dynamic> data) {
    try {
      final action = data['action'] as String?;

      switch (action) {
        case 'add':
          final positionData = data['position'];
          if (positionData != null) {
            final position = Position.fromJson(positionData);
            addOrUpdatePosition(position);
          }
          break;
        case 'update':
          print("✓ Position Array Update  $positionOrders");
          final positionId = data['positionId'] as int?;
          if (positionId != null) {
            removePositionById(positionId);
          }
          final positionData = data['position'];
          if (positionData != null) {
            final position = Position.fromJson(positionData);
            addOrUpdatePosition(position);
          }
          break;
        default:
          print("⚠ Unknown WebSocket action: $action");
      }
    } catch (e) {
      print("✗ Error handling WebSocket update → $e");
    }
  }

  /// Bulk update positions from WebSocket (if receiving multiple at once)
  void handleBulkWebSocketUpdate(List<Map<String, dynamic>> updates) {
    for (var update in updates) {
      handleWebSocketUpdate(update);
    }
  }

  double calculateTotalUnrealizedPL(
    Map<String, dynamic> tickers,
    TradingChartController tradingController,
  ) {
    double total = 0.0;

    for (var position in positionOrders) {
      final instrument =
          tradingController.getInstrument(position.instrumentId) ??
              InstrumentModel(
                instrumentId: position.instrumentId,
                name: 'UNKNOWN',
                code: 'UNKNOWN',
              );
      final symbolKey = PriceHelper.normalizeSymbol(
        instrument.code.toUpperCase(),
      );
      final ticker = tickers[symbolKey];

      if (ticker != null) {
        final currentPrice = PriceHelper.getCurrentPrice(
          ticker,
          position.side == 1 ? 2 : 1,
        );
        final instrumentDetails = tradingController.getCachedInstrumentDetails(
          position.instrumentId,
        );
        final contractSize = instrumentDetails?.contractSize?.toDouble() ?? 1.0;
        final decimalPlaces = instrumentDetails?.decimalPlaces ?? 0;
        final pointValue = (instrumentDetails?.point ?? 1).toDouble();
        final plCalcModeId = instrumentDetails?.plCalcModeId ?? 1;
        double currencyRate = 1.0;

        if (plCalcModeId == 5 || plCalcModeId == 6) {
          final quoteCurrencyId = instrumentDetails
              ?.quoteCurrencyInstrumentId; // ← Added null safety

          if (quoteCurrencyId != null) {
            if (!tradingController.hasInstrumentDetails(quoteCurrencyId)) {
              tradingController.detailsInstruments(quoteCurrencyId);
            }
            final quoteCurrencyInstrument = tradingController.getInstrument(
              quoteCurrencyId,
            );

            if (quoteCurrencyInstrument != null) {
              final quoteCurrencySymbolKey =
                  quoteCurrencyInstrument.code.toUpperCase();
              final quoteCurrencyTicker =
                  tradingController.tickers[quoteCurrencySymbolKey];

              if (quoteCurrencyTicker != null) {
                final currencyRateBuy = (PriceHelper.getCurrentPrice(
                          quoteCurrencyTicker,
                          1,
                        ) ??
                        0)
                    .toDouble();

                final currencyRateSell = (PriceHelper.getCurrentPrice(
                          quoteCurrencyTicker,
                          2,
                        ) ??
                        0)
                    .toDouble();

                currencyRate = (currencyRateBuy + currencyRateSell) / 2.0;
              }
            }
          }
        }

        final positionPL = ProfitCalculator.calculateProfit(
          entryPrice: (position.orderPrice ?? 0).toDouble(),
          currentPrice: (currentPrice ?? 0).toDouble(),
          positionQty: (position.positionQty ?? 0).toDouble(),
          contractSize: contractSize,
          side: position.side ?? 0,
          plCalcModeId: plCalcModeId,
          decimalPlaces: decimalPlaces,
          pointValue: pointValue,
          currencyRate: currencyRate,
        );
        total += positionPL;
      }
    }

    return total;
  }

  Position? findPosition({
    required int instrumentId,
    required int side,
    required int accountId,
  }) {
    try {
      return positionOrders.firstWhere(
        (p) =>
            p.instrumentId == instrumentId &&
            p.side == side &&
            p.accountId == accountId,
      );
    } catch (_) {
      return null;
    }
  }

  /// Force reload positions from API (useful for manual refresh)
  Future<void> refreshPositions() async {
    await loadPositions();
  }

  /// Clear all cached positions
  void clearPositions() {
    positionOrders.clear();
    isLoaded.value = false;
    print("✓ Positions cache cleared");
  }


}
