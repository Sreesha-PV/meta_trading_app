
class PriceHelper {
  static String normalizeSymbol(String symbol) {
    // Keep symbol normalization simple and consistent
    return symbol.replaceAll('/', '').toUpperCase();
  }

  static double getCurrentPrice(Map<String, dynamic>? ticker, int side) {
    if (ticker == null) return 0.0;

    // Try all possible key variants to be safe
    final ask = double.tryParse(
      ticker['ask']?.toString() ??
      ticker['a']?.toString() ??
      ticker['buy']?.toString() ??
      '0'
    ) ?? 0.0;

    final bid = double.tryParse(
      ticker['bid']?.toString() ??
      ticker['b']?.toString() ??
      ticker['sell']?.toString() ??
      '0'
    ) ?? 0.0;

    return side == 1 ? ask : bid;
  }

  
}