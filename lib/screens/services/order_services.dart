// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:netdania/app/core/constants/urls.dart';
// import 'package:netdania/app/models/order_get_model.dart';
// import 'package:netdania/app/models/order_model.dart';
// import 'package:netdania/app/models/positions_model.dart';
// import 'package:netdania/app/models/settlement_get_model.dart';
// import 'package:netdania/screens/services/authservices.dart';

// class OrderService {
//   // static const String _baseUrl = 'http://192.168.4.30:8082';

//   static final AuthService _authService = AuthService();

//   static Future<bool> placeOrder(OrderRequestModel order) async {
//     final token = await _authService.getValidToken();
//     if (token == null) {
//       throw Exception('Session expired. Please login again.');
//     }

//     final response = await http
//         .post(
//           Uri.parse(ApiUrl.orderUrl),
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//           body: jsonEncode(order.toJson()),
//         )
//         .timeout(const Duration(seconds: 15));

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       return true;
//     }

//     if (response.statusCode == 401) {
//       throw Exception('Session expired');
//     }

//     throw Exception('Order failed: ${response.body}');
//   }

//   static Future<bool> closePendingOrder(
//     int pendingOrderId,
//     int accountId,
//     double cancelledQty,
//   ) async {
//     final token = await _authService.getValidToken();
//     if (token == null) {
//       throw Exception('Session expired. Please login again.');
//     }
//     final requestBody = {
//       'account_id': accountId,
//       'ref_pending_order_id': pendingOrderId,
//       'cancelled_qty': cancelledQty,
//     };

//     final response = await http
//         .post(
//           Uri.parse(ApiUrl.closeorderUrl), // or your specific endpoint
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//           body: jsonEncode(requestBody),
//         )
//         .timeout(const Duration(seconds: 15));

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       return true;
//     }

//     if (response.statusCode == 401) {
//       throw Exception('Session expired');
//     }

//     throw Exception('Close order failed: ${response.body}');
//   }

//   static Future<bool> modifyOrder(
//     int accountId,
//     int pendingOrderId,
//     double newOrderPrice,
//     double? newStopLoss,
//     double? newTakeProfit,
//     // int timeInForceId
//   ) async {
//     final token = await _authService.getValidToken();
//     if (token == null) {
//       throw Exception('Session expired. Please login again.');
//     }
//     final requestBody = {
//       'account_id': accountId,
//       'limit_price': newTakeProfit,
//       'order_price': newOrderPrice,
//       'pending_order_id': pendingOrderId,
//       'stop_price': newStopLoss,
//       // 'time_in_force_id': timeInForceId,
//     };

//     final response = await http
//         .post(
//           Uri.parse(ApiUrl.modifyorderUrl),
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//           body: jsonEncode(requestBody),
//         )
//         .timeout(const Duration(seconds: 15));

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       return true;
//     }

//     if (response.statusCode == 401) {
//       throw Exception('Session expired');
//     }

//     throw Exception('Close order failed: ${response.body}');
//   }

//   // static Future<List<PendingOrder>> fetchOrders(int accountId,) async {
//   //   // final token = await getToken();
//   //   final token = await _authService.getValidToken();

//   //   if (token == null) {
//   //     throw Exception('No token found');
//   //   }

//   //   // final url = Uri.parse('http://localhost:4500/api/v1/orders?status=1&account_id=$accountId');
//   //   final url = Uri.parse(ApiUrl.pendingOrderUrl(accountId));

//   //   final response = await http.get(
//   //     url,
//   //     headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
//   //   );

//   //   if (response.statusCode == 200) {
//   //     final body = jsonDecode(response.body);
//   //     // final List data = body['data'];
//   //     final List data = body['data']['orders'] ?? [];

//   //     return data
//   //         .where(
//   //           (json) =>
//   //               json['remaining_qty'] != 0.0 &&
//   //               json['related_position_id'] == null,
//   //         )
//   //         .map((json) => PendingOrder.fromJson(json))
//   //         .toList();
//   //   } else {
//   //     throw Exception(' Failed to fetch orders: ${response.statusCode}');
//   //   }
//   // }

// static Future<List<PendingOrder>> fetchOrders(int accountId,  {int? status}) async {

//   print(' fetchOrders called with status = $status');
//   final token = await _authService.getValidToken();
//   if (token == null) throw Exception('No token found');

//   final url = Uri.parse(ApiUrl.pendingOrderUrl(accountId, status: status));
//   print(' ORDERS URL → $url');

//   final response = await http.get(
//     url,
//     headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
//   );
//   print(' STATUS CODE → ${response.statusCode}');
//   print(' RAW BODY → ${response.body}');

// //   if (!response.headers['content-type']!.contains('application/json') ?? true) {
// //   throw Exception(
// //     'Backend returned non-JSON (${response.statusCode}):\n${response.body}',
// //   );
// // }

//   if (response.statusCode == 200) {
//     final body = jsonDecode(response.body);
//     // final List data = body['data']['orders'];
//     final List data = body['data']['orders'] ?? [];

//     return data
//         .where((json) =>
//             json['remaining_qty'] != 0.0 && json['related_position_id'] == null)
//         .map((json) => PendingOrder.fromJson(json))
//         .toList();
//   }
//   else {
//     // throw Exception('Failed to fetch orders: ${response.statusCode}');
//     throw Exception('Failed to fetch orders: ${response.statusCode}\n${response.body}');

//   }
// }

//   static Future<List<ClosedOrder>> fetchClosedOrders(int accountId) async {
//     final token = await _authService.getValidToken();

//     if (token == null) {
//       throw Exception('No token found');
//     }

//     final url = Uri.parse(ApiUrl.closedOrderUrl(accountId));

//     final response = await http.get(
//       url,
//       headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       final List data = body['data'];
//       return data.map((json) => ClosedOrder.fromJson(json)).toList();
//       // return data
//       //     .where(
//       //       (json) =>
//       //           json['remaining_qty'] == 0.0 ||
//       //           json['order_status'] == 'Filled' ||
//       //           json['order_status'] == 'Cancelled' ||
//       //           json['order_status'] == 'Rejected',
//       //     )
//       //     .map((json) => ClosedOrder.fromJson(json))
//       //     .toList();
//     } else {
//       throw Exception('Failed to fetch closed orders: ${response.statusCode}');
//     }
//   }

//   static Future<List<PendingOrder>> fetchOrdersByRelatedPositionId(
//     int accountId,
//     // int status,
//     // String token,
//     int relatedPositionId,
//   ) async {

//     final url = Uri.parse(ApiUrl.pendingOrderUrl(accountId,));
//     // final token = await getToken();
//     final token = await _authService.getValidToken();

//     // print(url);

//     final response = await http.get(
//       url,
//       headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       // final List data = body['data'];
//       final List data = body['data']['orders'] ?? [];

//       print("List of Orders $data");

//       final filteredData =
//           data.where((order) {
//             return order['related_position_id'] == relatedPositionId &&
//                 order['remaining_qty'] != 0.0;
//           }).toList();

//       print(
//         ' Orders filtered by related_position_id $relatedPositionId: ${JsonEncoder.withIndent("  ").convert(filteredData)}',
//       );

//       return filteredData.map((json) => PendingOrder.fromJson(json)).toList();
//     } else {
//       throw Exception(' Failed to fetch orders: ${response.statusCode}');
//     }
//   }

//   static Future<List<Position>> positionOrders(
//     int accountId, {
//     String? accountUuid,
//   }) async {
//     // final token = await getToken();
//     final token = await _authService.getValidToken();

//     if (token == null) {
//       throw Exception('No token found');
//     }

//     String urlString = ApiUrl.positionUrl(accountId);
//     // '$_baseUrl/jwt/client/positions/open?account_id=$accountId';
//     // if (accountUuid != null) urlString += '&account_uuid=$accountUuid';

//     final url = Uri.parse(urlString);
//     print('🌐 Fetching Positions from: $url');
//     print('Token: "$token"');
//     final response = await http.get(
//       url,
//       headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       // final List data = body['data'] ?? [];
//       final List data = body['data']['positions'] ?? [];
//       final positions = data.map((json) => Position.fromJson(json)).toList();
//       print(response.body);
//       print('📥 Position fetched successfully: $positions');
//       return positions;
//     } else {
//       throw Exception(
//         'Failed to fetch positions: ${response.statusCode} \nResponse: ${response.body}',
//       );
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netdania/app/core/constants/urls.dart';
import 'package:netdania/app/models/order_get_model.dart';
import 'package:netdania/app/models/order_model.dart';
import 'package:netdania/app/models/positions_model.dart';
import 'package:netdania/app/models/settlement_get_model.dart';
import 'package:netdania/screens/services/authservices.dart';

class OrderService {
  // static const String _baseUrl = 'http://192.168.4.30:8082';

  static final AuthService _authService = AuthService();

  static Future<bool> placeOrder(OrderRequestModel order) async {
    final token = await _authService.getValidToken();
    if (token == null) {
      throw Exception('Session expired. Please login again.');
    }

    final response = await http
        .post(
          Uri.parse(ApiUrl.orderUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(order.toJson()),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    }

    if (response.statusCode == 401) {
      throw Exception('Session expired');
    }

    throw Exception('Order failed: ${response.body}');
  }

  static Future<bool> closePendingOrder(
    int pendingOrderId,
    int accountId,
    double cancelledQty,
  ) async {
    final token = await _authService.getValidToken();
    if (token == null) {
      throw Exception('Session expired. Please login again.');
    }
    final requestBody = {
      'account_id': accountId,
      'ref_pending_order_id': pendingOrderId,
      'cancelled_qty': cancelledQty,
    };

    final response = await http
        .post(
          Uri.parse(ApiUrl.closeorderUrl), // or your specific endpoint
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(requestBody),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    }

    if (response.statusCode == 401) {
      throw Exception('Session expired');
    }

    throw Exception('Close order failed: ${response.body}');
  }

  static Future<bool> modifyOrder(
    int accountId,
    int pendingOrderId,
    double newOrderPrice,
    double? newStopLoss,
    double? newTakeProfit,
  ) async {
    final token = await _authService.getValidToken();
    if (token == null) {
      throw Exception('Session expired. Please login again.');
    }
    final requestBody = {
      'account_id': accountId,
      'limit_price': newTakeProfit,
      'order_price': newOrderPrice,
      'pending_order_id': pendingOrderId,
      'stop_price': newStopLoss,
      'time_in_force_id': 0,
    };

    final response = await http
        .post(
          Uri.parse(ApiUrl.modifyorderUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(requestBody),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    }

    if (response.statusCode == 401) {
      throw Exception('Session expired');
    }

    throw Exception('Close order failed: ${response.body}');
  }

  static Future<List<PendingOrder>> fetchOrders(int accountId) async {
    final token = await _authService.getValidToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse(ApiUrl.pendingOrderUrl(accountId));

    final response = await http.get(
      url,
      headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];

      return data
          .where(
            (json) =>
                json['related_position_id'] ==
                null,
          )
          .map((json) => PendingOrder.fromJson(json))
          .toList();
    } else {
      throw Exception(' Failed to fetch orders: ${response.statusCode}');
    }
  }

  static Future<List<ClosedOrder>> fetchClosedOrders(int accountId) async {
    final token = await _authService.getValidToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse(ApiUrl.closedOrderUrl(accountId));

    final response = await http.get(
      url,
      headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      return data.map((json) => ClosedOrder.fromJson(json)).toList();

      // return data
      //     .where(
      //       (json) =>
      //           json['remaining_qty'] == 0.0 ||
      //           json['order_status'] == 'Filled' ||
      //           json['order_status'] == 'Cancelled' ||
      //           json['order_status'] == 'Rejected',
      //     )
      //     .map((json) => ClosedOrder.fromJson(json))
      //     .toList();
    } else {
      throw Exception('Failed to fetch closed orders: ${response.statusCode}');
    }
  }

  static Future<List<PendingOrder>> fetchOrdersByRelatedPositionId(
    int accountId,
    // String token,
    int relatedPositionId,
  ) async {
    // final url = Uri.parse('$_baseUrl/jwt/client/orders?account_id=$accountId');
    final url = Uri.parse(ApiUrl.pendingOrderUrl(accountId));
    // final token = await getToken();
    final token = await _authService.getValidToken();

    // print(url);

    final response = await http.get(
      url,
      headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];

      print("List of Orders $data");

      final filteredData =
          data.where((order) {
            return order['related_position_id'] == relatedPositionId &&
                order['remaining_qty'] != 0.0;
          }).toList();

      print(
        ' Orders filtered by related_position_id $relatedPositionId: ${JsonEncoder.withIndent("  ").convert(filteredData)}',
      );

      return filteredData.map((json) => PendingOrder.fromJson(json)).toList();
    } else {
      throw Exception(' Failed to fetch orders: ${response.statusCode}');
    }
  }

  static Future<List<Position>> positionOrders(
    int accountId, {
    String? accountUuid,
  }) async {
    // final token = await getToken();
    final token = await _authService.getValidToken();

    if (token == null) {
      throw Exception('No token found');
    }

    String urlString = ApiUrl.positionUrl(accountId);
    // '$_baseUrl/jwt/client/positions/open?account_id=$accountId';
    // if (accountUuid != null) urlString += '&account_uuid=$accountUuid';

    final url = Uri.parse(urlString);
    print('🌐 Fetching Positions from: $url');
    print('Token: "$token"');
    final response = await http.get(
      url,
      headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'] ?? [];
      final positions = data.map((json) => Position.fromJson(json)).toList();
      print(response.body);
      print('📥 Position fetched successfully: $positions');
      return positions;
    } else {
      throw Exception(
        'Failed to fetch positions: ${response.statusCode} \nResponse: ${response.body}',
      );
    }
  }
}
