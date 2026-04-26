import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netdania/app/models/chart_model.dart';
import 'package:netdania/app/services/authservices.dart';

class OhlcService {
  // static const String baseUrl =
  //     'https://uat.ax1systems.com/ohcl/api/v1/ohcl-limit-less';
      
// https://uat.ax1systems.com/ohcl/api/v1/ohcl-limit-less?symbol=EURUSD
static final AuthService _authService = AuthService();


  Future<List<OhlcCandle>> fetchOhlc({
  required String symbol,
  required String resolution,
  required int from,
  required int to,
}) async {
    final token = await _authService.getValidToken();

  final uri = Uri.parse(
    // '$baseUrl?symbol=$symbol&resolution=$resolution&from=$from&to=$to',
    'https://uat.ax1systems.com/ohcl/api/v1/ohcl-limit-less?symbol=EURUSD'
  
  );
  
  final response = await http.get(
    uri,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode != 200) {
    throw Exception(
      'Failed to load OHLC data: ${response.statusCode}: ${response.body}',
    );
  }

  final decoded = json.decode(response.body);

  if (decoded['data'] == null || decoded['data'] is! List) {
    throw Exception('Unexpected response format: $decoded');
  }

  return (decoded['data'] as List)
      .map((e) => OhlcCandle.fromJson(e))
      .toList();
}
}

