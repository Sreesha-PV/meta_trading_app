import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netdania/app/core/constants/urls.dart';
import 'package:netdania/app/models/close_order_model.dart';

class ClosePositionService {
  // static const String baseUrl = "http://192.168.4.30:8082";

 
  Future<Map<String, dynamic>> closePosition(
  ClosePositionModel request,
  String token,
) async {
  // final url = Uri.parse("$baseUrl/jwt/client/positions/close");
     final url=   Uri.parse(ApiUrl.closePositionUrl);


  try {
    final response = await http.post(
      url,
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(request.toJson()),
    );

    // Print raw response for debugging
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    // Try parsing JSON even if status is not 200
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return json;
    } else {
      throw Exception(
        "Failed to close position: ${response.statusCode} → $json",
      );
    }
  } catch (e, stack) {
    print("Error closing position: $e");
    print(stack);
    rethrow;
  }
}

}

