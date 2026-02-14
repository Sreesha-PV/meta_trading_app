import 'package:http/http.dart' as http;
import 'package:netdania/app/core/constants/urls.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/models/instrument_detail_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class InstrumentService {
  // final String baseUrl = "http://192.168.4.30:8082/jwt/client/instruments";

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<String?> getAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<List<InstrumentModel>> fetchInstruments(int accountId) async {
    final token = await getToken();
    try {
      final url = Uri.parse(ApiUrl.fetchInstrumentUrl(accountId));
      // print('🌐 Fetching instruments from: $url');
      // print('Token: "$token"');

      final response = await http.get(
        url,
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        print("Instrument API failed: ${response.statusCode}");
        return [];
      }

      final jsonBody = jsonDecode(response.body);
      final data = jsonBody["data"] as List;
      print("Instument Data${response.body}");
      return data.map((e) => InstrumentModel.fromJson(e)).toList();
    } catch (e) {
      print("Instrument fetch error: $e");
      return [];
    }
  }

  Future<Object> fetchInstrumentById(int id) async {
    final token = await getToken();
    final accountId = await getAccountId();
    // final accountId = 9;
    if (accountId == null) {
      print("Account ID is null");
      return [];
    }

    // Remove unnecessary string interpolation
    final url = ApiUrl.fetchInstrumentByIdUrl(id, accountId);
    print("Fetching instrument from URL: $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        print("Instrument API failed: ${response.statusCode}");
        return [];
      }

      final jsonBody = jsonDecode(response.body);
      final data = jsonBody["data"];
      print("Instrument Details: $data");
      return InstrumentDetailsModel.fromJson(data);
    } catch (e) {
      print("Instrument fetch error: $e");
      return [];
    }
  }
}
