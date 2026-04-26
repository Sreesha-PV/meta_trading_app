import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:netdania/app/services/authservices.dart';
import 'package:netdania/app/core/constants/urls.dart';

class PriceService {
  static final AuthService _authService = AuthService();

  /// Fetches price data for given symbols from the API
  /// Splits large requests into batches to avoid URL length limits
  static Future<Map<String, Map<String, dynamic>>?> fetchPrices(
    List<String> symbols, {
    int batchSize = 20, // Limit symbols per request
  }) async {
    try {
      if (symbols.isEmpty) {
        if (kDebugMode) print('PriceService: No symbols provided');
        return null;
      }

      // If too many symbols, split into batches
      if (symbols.length > batchSize) {
        Map<String, Map<String, dynamic>> allPrices = {};
        
        for (int i = 0; i < symbols.length; i += batchSize) {
          final batch = symbols.sublist(
            i,
            (i + batchSize > symbols.length) ? symbols.length : i + batchSize,
          );
          
          final batchPrices = await _fetchPricesBatch(batch);
          if (batchPrices != null) {
            allPrices.addAll(batchPrices);
          }
          
          // Small delay between batches to avoid rate limiting
          if (i + batchSize < symbols.length) {
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }
        
        return allPrices.isEmpty ? null : allPrices;
      } else {
        return await _fetchPricesBatch(symbols);
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('PriceService: Error fetching prices: $e\n$st');
      }
      return null;
    }
  }

  static Future<Map<String, Map<String, dynamic>>?> _fetchPricesBatch(
    List<String> symbols,
  ) async {
    try {
      final token = await _authService.getValidToken();

      if (token == null) {
        throw Exception('No token found');
      }

      final url = Uri.parse(ApiUrl.priceUrl(symbols));
      
      if (kDebugMode) {
        print('PriceService: Fetching ${symbols.length} symbols');
        print('PriceService: URL: $url');
      }

      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (kDebugMode) {
        print('PriceService: Response status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is! Map<String, dynamic>) {
          if (kDebugMode) print('PriceService: Invalid response format');
          return null;
        }

        // Check if response has the expected structure
        if (jsonResponse['status'] != 'success') {
          if (kDebugMode) {
            print('PriceService: API returned non-success status: ${jsonResponse['status']}');
          }
          return null;
        }

        final data = jsonResponse['data'];
        if (data is! List) {
          if (kDebugMode) print('PriceService: Data field is not a list');
          return null;
        }

        // Parse the data array into a map keyed by symbol
        Map<String, Map<String, dynamic>> priceMap = {};

        for (var item in data) {
          if (item is Map<String, dynamic>) {
            final symbol = item['item_code']?.toString().toUpperCase();
            if (symbol != null) {
              // Store the complete item data
              priceMap[symbol] = {
                'item_id': item['item_id'],
                'item_code': item['item_code'],
                'symbol': symbol, // Add normalized symbol field
                's': symbol, // Add 's' for compatibility
                'time': item['time'],
                'dot_position': item['dot_position'],
                'last': item['last'],
                'bid': item['bid'],
                'ask': item['ask'],
                'high': item['high'],
                'low': item['low'],
                'open': item['open'],
                'previous_close': item['previous_close'],
                'volume': item['volume'],
              };
            }
          }
        }

        if (kDebugMode) {
          print('PriceService: Successfully parsed ${priceMap.length} prices');
        }

        return priceMap;
      } else if (response.statusCode == 401) {
        if (kDebugMode) {
          print('PriceService: Unauthorized - token may be expired');
        }
        return null;
      } else {
        if (kDebugMode) {
          print('PriceService: Failed with status ${response.statusCode}');
          print('PriceService: Response body: ${response.body}');
        }
        return null;
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('PriceService: Error in batch request: $e');
        print('Stack trace: $st');
      }
      return null;
    }
  }

  /// Fetches price for a single symbol
  static Future<Map<String, dynamic>?> fetchPrice(String symbol) async {
    final prices = await fetchPrices([symbol]);
    return prices?[symbol.toUpperCase()];
  }
}