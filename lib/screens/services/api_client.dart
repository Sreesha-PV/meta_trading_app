// import 'dart:convert';
// import 'package:http/http.dart' as http; 
// import 'package:netdania/screens/services/authservices.dart';

// class ApiClient {
//   Future<http.Response> get(String url) async {
//     var token = await AuthService().getAccessToken();
//     var response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 401) {
//       // Token expired → refresh
//       token = await AuthService().getRefreshToken();
//       if (token != null) {
//         response = await http.get(
//           Uri.parse(url),
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         );
//       }
//     }

//     return response;
//   }

//   Future<http.Response> post(String url, {Map<String, dynamic>? body}) async {
//     var token = await AuthService().getToken();
//     var response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(body),
//     );

//     if (response.statusCode == 401) {
//       token = await AuthService().refreshToken();
//       if (token != null) {
//         response = await http.post(
//           Uri.parse(url),
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//           body: jsonEncode(body),
//         );
//       }
//     }

//     return response;
//   }
// }





// // class ApiClient {
// //   Future<http.Response> get(String url) async {
// //     String? token = await AuthService().getAccessToken();

// //     http.Response response = await http.get(
// //       Uri.parse(url),
// //       headers: _headers(token),
// //     );

// //     if (response.statusCode == 401) {
// //       token = await AuthService().refreshAccessToken();
// //       if (token != null) {
// //         response = await http.get(
// //           Uri.parse(url),
// //           headers: _headers(token),
// //         );
// //       }
// //     }

// //     return response;
// //   }

// //   Future<http.Response> post(String url, {Map<String, dynamic>? body}) async {
// //     String? token = await AuthService().getAccessToken();

// //     http.Response response = await http.post(
// //       Uri.parse(url),
// //       headers: _headers(token),
// //       body: jsonEncode(body),
// //     );

// //     if (response.statusCode == 401) {
// //       token = await AuthService().refreshAccessToken();
// //       if (token != null) {
// //         response = await http.post(
// //           Uri.parse(url),
// //           headers: _headers(token),
// //           body: jsonEncode(body),
// //         );
// //       }
// //     }

// //     return response;
// //   }

// //   Map<String, String> _headers(String? token) => {
// //         'Content-Type': 'application/json',
// //         'Authorization': 'Bearer $token',
// //       };
// // }
