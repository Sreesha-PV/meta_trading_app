import 'dart:math';

class ProfitCalculator {
  static double calculateProfit({
    required double entryPrice,
    required double currentPrice,
    required double positionQty,
    required double contractSize,
    required int side,
    required int plCalcModeId,
    required int decimalPlaces,
    required double pointValue,
    required double currencyRate,
  }) {
    if (positionQty <= 0) {
      return 0.0;
    }

    double floating = 0.0;
    int calcId = plCalcModeId <= 0 ? 1 : plCalcModeId;

    switch (calcId) {
      case 1:
        floating = (entryPrice - currentPrice) * positionQty * contractSize;
        break;

      case 2:
        if (entryPrice > 0 && currentPrice > 0) {
          floating = ((1 / entryPrice) - (1 / currentPrice)) *
              positionQty *
              contractSize;
        }
        break;

      case 3:
        if (entryPrice > 0 && currentPrice > 0) {
          floating =
              ((entryPrice - currentPrice) * pow(10, decimalPlaces)).round() *
                  pointValue *
                  positionQty;
        }
        break;

      case 4:
        if (entryPrice > 0 && currentPrice > 0) {
          floating =
              ((entryPrice - currentPrice) * contractSize * positionQty) /
                  currentPrice;
        }
        break;

      case 5:
        floating = (entryPrice - currentPrice) * positionQty * contractSize;
        double rate = currencyRate;
        if (rate == 0) rate = 1.0;
        floating *= rate;
        break;

      case 6:
        floating = (entryPrice - currentPrice) * positionQty * contractSize;
        double rate = currencyRate;
        if (rate == 0) rate = 1.0;
        floating /= rate;
        break;

      default:
        floating = 0.0;
        break;
    }

    if (side == 1) {
      floating = -floating;
    }

    return floating;
  }
}
