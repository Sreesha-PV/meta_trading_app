import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netdania/app/models/wallet_model.dart';

class WalletService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  /// Fetches wallet details from the API
  ///
  /// [token] - Bearer authentication token
  /// [clientId] - The client/wallet ID
  /// [currencyId] - The currency ID to filter by
  ///
  /// Returns [WalletResponse] containing wallet data or null on failure
  Future<WalletResponse?> getWalletDetails({
    required String token,
    required int clientId,
    required int currencyId,
  }) async {
    try {
      // Construct the API URL
      final url = Uri.parse(
        '$baseUrl/jwt/client/wallet/details/$clientId?currency_id=$currencyId',
      );

      print('🔄 Fetching wallet details from: $url');

      // Make the GET request
      final response = await http
          .get(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Request timeout - Please check your internet connection',
              );
            },
          );

      print('📡 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      // Handle successful response
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final walletResponse = WalletResponse.fromJson(jsonData);

        if (walletResponse.success && walletResponse.data != null) {
          print('✅ Wallet details fetched successfully');
          print('💰 Balance: \$${walletResponse.data!.balance}');
          print('📊 Used Margin: \$${walletResponse.data!.usedAmount}');
          return walletResponse;
        } else {
          print('⚠️ API returned success=false: ${walletResponse.message}');
          return walletResponse;
        }
      }
      // Handle authentication errors
      else if (response.statusCode == 401) {
        print('🔒 Authentication failed - Invalid or expired token');
        return WalletResponse(
          success: false,
          code: 401,
          message: 'Authentication failed. Please login again.',
          data: null,
        );
      }
      // Handle not found errors
      else if (response.statusCode == 404) {
        print('❌ Wallet not found for client ID: $clientId');
        return WalletResponse(
          success: false,
          code: 404,
          message: 'Wallet not found',
          data: null,
        );
      }
      // Handle server errors
      else if (response.statusCode >= 500) {
        print('🔥 Server error: ${response.statusCode}');
        return WalletResponse(
          success: false,
          code: response.statusCode,
          message: 'Server error. Please try again later.',
          data: null,
        );
      }
      // Handle other errors
      else {
        print('❌ Error fetching wallet details: ${response.statusCode}');
        print('Response body: ${response.body}');
        return WalletResponse(
          success: false,
          code: response.statusCode,
          message: 'Failed to fetch wallet details',
          data: null,
        );
      }
    } on http.ClientException catch (e) {
      print('🌐 Network error: $e');
      return WalletResponse(
        success: false,
        code: 0,
        message: 'Network error. Please check your internet connection.',
        data: null,
      );
    } on FormatException catch (e) {
      print('📝 JSON parsing error: $e');
      return WalletResponse(
        success: false,
        code: 0,
        message: 'Invalid response format from server',
        data: null,
      );
    } catch (e) {
      print('💥 Exception in getWalletDetails: $e');
      return WalletResponse(
        success: false,
        code: 0,
        message: 'Unexpected error: ${e.toString()}',
        data: null,
      );
    }
  }

  Future<WalletResponse?> updateWalletBalance({
    required String token,
    required int clientId,
    required double newBalance,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/jwt/client/wallet/update/$clientId');

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'balance': newBalance}),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return WalletResponse.fromJson(jsonData);
      }

      return null;
    } catch (e) {
      print('Error updating wallet balance: $e');
      return null;
    }
  }

  /// Gets multiple wallets (if your API supports it)
  /// This is a placeholder - implement based on your API
  Future<List<WalletModel>> getAllWallets({
    required String token,
    required int clientId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/jwt/client/wallets/$clientId');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Adjust based on your actual API response structure
        final List<dynamic> walletsData = jsonData['data'] ?? [];
        return walletsData
            .map((wallet) => WalletModel.fromJson({'data': wallet}))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error fetching all wallets: $e');
      return [];
    }
  }
}
