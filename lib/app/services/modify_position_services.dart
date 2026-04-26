import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netdania/app/core/constants/urls.dart';
import 'package:netdania/app/models/order_modify_model.dart';

class ModifyPositionServices {
  // static const String baseUrl = "http://192.168.4.30:8082";

  Future<Map<String, dynamic>> modifyOrder(
    ModifyOrderModel request,
    String token,
  ) async {
    final url = Uri.parse(ApiUrl.modifyUrl);

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

      print("Modify Status Code: ${response.statusCode}");
      print("Modify Response: ${response.body}");

      final json = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return json;
      } else {
        throw Exception("Failed → ${response.statusCode} → $json");
      }
    } catch (e, stack) {
      print("Modify Error: $e");
      print(stack);
      rethrow;
    }
  }
}







