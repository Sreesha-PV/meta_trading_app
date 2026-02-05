// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:netdania/app/core/constants/urls.dart';
// import 'package:netdania/app/models/client_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   // final String baseUrl = 'https://uat.ax1systems.com/gateway';

//   String? userId;
//   String? token;

//   Future<void> storeUserId(String userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('user_id', userId);
//     print("User ID saved: $userId");
//   }

//   Future<String?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString('user_id');
//     print("Retrieved User ID: $userId");
//     return userId;
//   }

//   Future<void> storeAccountId(int accountId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('account_id', accountId);
//   }

//   Future<int?> getAccountId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('account_id');
//   }

//   // Future<void> _saveToken(String token) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   await prefs.setString('auth_token', token);
//   // }

//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', token);

//     debugPrint(' Token persisted: ${token.substring(0, 10)}...');
//   }

//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     debugPrint('🔎 Token read: $token');
//     return token;
//   }

//   // Future<String?> getToken() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   return prefs.getString('auth_token');
//   // }

//   Future<bool> signUp({
//     required String email,
//     required String password,
//     required String firstName,
//     required String lastName,
//     required String accountType,
//     // required int userId,
//   }) async {
//     try {
//       final response = await http.post(
//         // Uri.parse('$baseUrl/jwt/client/account/create'),
//         Uri.parse(ApiUrl.registerUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "accountType": accountType,
//           "email": email,
//           "firstName": firstName,
//           "lastName": lastName,
//           "password": password,
//           "userId": userId,
//         }),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final token = data['token'];

//         await saveToken(token);

//         // Decode token to extract user info
//         final decodedToken = JwtDecoder.decode(token);
//         // final userId = decodedToken['user_uuid'];
//         final userId = decodedToken['user_d'];

//         if (userId != null) {
//           await storeUserId(userId.toString());
//         }

//         return true;
//       } else {
//         print('Signup failed: ${response.statusCode}, ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       print('Signup exception: $e');
//       return false;
//     }
//   }

//   // Future<bool> login(String email, String password) async {
//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse('$baseUrl/auth/login'),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: json.encode({'email': email, 'password': password}),
//   //     );

//   //     print('Login response status: ${response.statusCode}');
//   //     print('Login response body: ${response.body}');

//   //     if (response.statusCode == 200) {
//   //       final body = jsonDecode(response.body);
//   //       final data = body['data'];

//   //       final token = data['token'];
//   //       if (token == null) {
//   //         print('Login failed: token is null');
//   //         return false;
//   //       }
//   //       await _saveToken(token);
//   //       // await _saveCookie(token);
//   //       // final notificationService = NotificationService();

//   //       // await notificationService.connect(token);

//   //       // notificationService.disconnect();
//   //       NotificationService().connect(token);
//   //       // Decode token to get user info
//   //       final decodedToken = JwtDecoder.decode(token);
//   //       final userId = decodedToken['user_id'];

//   //       if (userId != null) {
//   //         await storeUserId(userId.toString());
//   //       } else {
//   //         print('Warning: userId not found in token');
//   //       }
//   //       //  NotificationService().connect(token);
//   //       return true;
//   //     } else {
//   //       final errorMessage =
//   //           json.decode(response.body)['message'] ?? 'An error occurred';
//   //       print('Login failed: $errorMessage');
//   //       return false;
//   //     }
//   //   } catch (e) {
//   //     print('Login exception: $e');
//   //     return false;
//   //   }
//   // }

// Future<String?> login(String email, String password) async {
//   try {
//     final response = await http.post(
//       Uri.parse(ApiUrl.loginUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'email': email, 'password': password}),
//     );

//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       final token = body['data']['token'];

//       await saveToken(token);

//       final decodedToken = JwtDecoder.decode(token);
//       final userId = decodedToken['user_id'];

//       if (userId != null) {
//         await storeUserId(userId.toString());
//       }

//       return token;
//     }
//     return null;
//   } catch (e) {
//     debugPrint('Login exception: $e');
//     return null;
//   }
// }

//   // Future<String?> login(String email, String password) async {
//   //   try {
//   //     final response = await http.post(
//   //       // Uri.parse('$baseUrl/auth/login'),
//   //       Uri.parse(ApiUrl.loginUrl),

//   //       headers: {'Content-Type': 'application/json'},
//   //       body: json.encode({'email': email, 'password': password}),
//   //     );

//   //     if (response.statusCode == 200) {
//   //       final body = jsonDecode(response.body);
//   //       final data = body['data'];

//   //       final token = data['token'];
//   //       // await _saveToken(token);
//   //       await AuthService().saveToken(token);

//   //       final decodedToken = JwtDecoder.decode(token);
//   //       final userId = decodedToken['user_id'];

//   //       if (userId != null) {
//   //         await storeUserId(userId.toString());
//   //       }

//   //       return token; // <--- return token instead of boolean
//   //     }
//   //     return null;
//   //   } catch (e) {
//   //     print('Login exception: $e');
//   //     return null;
//   //   }
//   // }

//   Future<UserProfileData?> getUserDetails() async {
//     try {
//       final token = await getToken();
//       if (token == null) return null;

//       final response = await http.get(
//         // Uri.parse('$baseUrl/jwt/client/account/client-details'),
//         Uri.parse(ApiUrl.userUrl),

//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonBody = jsonDecode(response.body);

//         // Convert JSON → Model
//         final userResponse = UserProfileResponse.fromJson(jsonBody);
//         return userResponse.data;
//       } else {
//         print('Failed to get user details: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Exception fetching user details: $e');
//       return null;
//     }
//   }

//   Future<bool> isTokenExpired() async {
//   // final token = await getToken();
//   final token = await getValidToken();

//   if (token == null) return true;

//   return JwtDecoder.isExpired(token);
// }

//   Future<String?> refreshToken() async {
//   try {
//     final token = await getToken();
//     if (token == null) return null;

//     final response = await http.post(
//       Uri.parse(ApiUrl.tokenRefreshUrl),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       final newToken = body['data']?['token'];

//       if (newToken != null) {
//         await saveToken(newToken);
//         return newToken;
//       }
//     }
//     return null;
//   } catch (e) {
//     debugPrint('Refresh token error: $e');
//     return null;
//   }
// }

// Future<String?> getValidToken() async {
//   final token = await getToken();

//   if (token == null) return null;

//   if (JwtDecoder.isExpired(token)) {
//     debugPrint(' Token expired, refreshing...');
//     return await refreshToken();
//   }

//   return token;
// }

// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:netdania/app/core/constants/urls.dart';
import 'package:netdania/app/models/client_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:netdania/utils/websocket_web.dart';

class AuthService {
  // final String baseUrl = 'https://uat.ax1systems.com/gateway';

  String? userId;
  String? token;

  bool _isRefreshing = false;
  Future<String?>? _refreshFuture;

  Timer? _tokenCheckTimer;

  Future<void> storeUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    print("User ID saved: $userId");
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    print("Retrieved User ID: $userId");
    return userId;
  }

  Future<void> storeAccountId(int accountId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('account_id', accountId);
  }

  Future<int?> getAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('account_id');
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    debugPrint(' Token persisted: ${token.substring(0, 10)}...');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    // debugPrint(' Token read: $token');
    return token;
  }

  Future<void> saveTokenExpiry(int expiryTimestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('token_expiry', expiryTimestamp);
    debugPrint('⏰ Token expiry saved: $expiryTimestamp');
  }

  Future<int?> getTokenExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('token_expiry');
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String accountType,
    // required int userId,
  }) async {
    try {
      final response = await http.post(
        // Uri.parse('$baseUrl/jwt/client/account/create'),
        Uri.parse(ApiUrl.registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "accountType": accountType,
          "email": email,
          "firstName": firstName,
          "lastName": lastName,
          "password": password,
          "userId": userId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        await saveToken(token);

        final decodedToken = JwtDecoder.decode(token);
        final userUuid = decodedToken['user_uuid'] ?? decodedToken['user_id'];

        if (userUuid != null) {
          await storeUserId(userUuid.toString());
        }

        if (decodedToken['exp'] != null) {
          await saveTokenExpiry(decodedToken['exp']);
        }

        return true;
      } else {
        debugPrint('Signup failed: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('Signup exception: $e');
      return false;
    }
  }

  void startPeriodicTokenCheck({int intervalSeconds = 10}) {
    _tokenCheckTimer?.cancel();

    debugPrint(
      '🔄 Starting periodic token check (every $intervalSeconds seconds)',
    );

    _tokenCheckTimer = Timer.periodic(Duration(seconds: intervalSeconds), (
      timer,
    ) async {
      // debugPrint('⏰ Periodic token check at ${DateTime.now()}');

      final token = await getToken();

      if (token == null) {
        debugPrint('❌ No token found, stopping periodic check');
        stopPeriodicTokenCheck();
        return;
      }

      if (JwtDecoder.isExpired(token)) {
        debugPrint('⚠️ Token expired during periodic check → logout');
        stopPeriodicTokenCheck();
        await logout();
        return;
      }

      if (willExpireSoon(token, bufferSeconds: 60)) {
        // debugPrint('🔄 Token expiring soon during periodic check → refreshing');
        final newToken = await getValidToken();

        if (newToken == null) {
          debugPrint('❌ Refresh failed during periodic check → logout');
          stopPeriodicTokenCheck();
          await logout();
        }
      } else {
        final expiry = JwtDecoder.getExpirationDate(token).toUtc();
        final now = DateTime.now().toUtc();
        final secondsRemaining = expiry.difference(now).inSeconds;
        // debugPrint('✅ Token still valid, expires in $secondsRemaining seconds');
      }
    });
  }

  void stopPeriodicTokenCheck() {
    _tokenCheckTimer?.cancel();
    _tokenCheckTimer = null;
    debugPrint('🛑 Periodic token check stopped');
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        // Uri.parse('$baseUrl/auth/login'),
        Uri.parse(ApiUrl.loginUrl),

        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];

        final token = data['token'];
        final exp = data['exp'];
        // await _saveToken(token);
        // await AuthService().saveToken(token);
        await saveToken(token);
        if (exp != null) {
          await saveTokenExpiry(exp);
        }

        final decodedToken = JwtDecoder.decode(token);
        final userId = decodedToken['user_id'] ?? decodedToken['user_uuid'];

        if (userId != null) {
          await storeUserId(userId.toString());
        }

        startPeriodicTokenCheck(intervalSeconds: 10);

        return token;
      }
      return null;
    } catch (e) {
      print('Login exception: $e');
      return null;
    }
  }

  // Future<void> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = await getToken();

  //   if (token != null) {
  //     try {
  //       final response = await http.post(
  //         Uri.parse(ApiUrl.logoutUrl),
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json',
  //         },
  //       );

  //       if (response.statusCode == 200) {
  //         debugPrint(' Server logout successful');
  //       } else {
  //         debugPrint(' Server logout failed: ${response.body}');
  //       }
  //     } catch (e) {
  //       debugPrint(' Exception during logout: $e');
  //     }
  //   }

  //   await prefs.remove('auth_token');
  //   await prefs.remove('user_id');
  //   await prefs.remove('account_id');
  //   // token = null;
  //   userId = null;

  //   debugPrint('Local logout complete');
  // }
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('token_expiry');
    await prefs.remove('user_id');
    await prefs.remove('account_id');
    debugPrint('🗑️ All auth data cleared');
  }

  Future<void> logout() async {
    stopPeriodicTokenCheck();
    if (Get.isRegistered<WebSocketService>()) {
      Get.find<WebSocketService>().disconnect();
    }
    final prefs = await SharedPreferences.getInstance();
    final token = await getToken();

    if (token != null && !JwtDecoder.isExpired(token)) {
      try {
        await http.post(
          Uri.parse(ApiUrl.logoutUrl),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
      } catch (e) {
        debugPrint('⚠️ Logout API call failed: $e');
      }
    }

    await prefs.remove('auth_token');
    await prefs.remove('token_expiry');
    await prefs.remove('user_id');
    userId = null;
    _isRefreshing = false;
    _refreshFuture = null;
    debugPrint('🚪 Local logout complete');
  }

  // Future<String?> getValidToken() async {
  //   String? token = await getToken();

  //   debugPrint(' getValidToken called');
  //   debugPrint(' Token: $token');

  //   if (token == null) return null;

  //   final isExpired = JwtDecoder.isExpired(token);
  //   debugPrint(' isExpired = $isExpired');

  //   if (isExpired) {
  //     debugPrint(' Token expired → refreshing');
  //     token = await refreshToken();
  //   }

  //   return token;
  // }

  // bool willExpireSoon(String token, {int bufferSeconds = 60}) {
  //   final expiry = JwtDecoder.getExpirationDate(token);
  //   return expiry.difference(DateTime.now()).inSeconds < bufferSeconds;
  // }

  bool willExpireSoon(String token, {int bufferSeconds = 60}) {
    try {
      final expiry = JwtDecoder.getExpirationDate(token).toUtc();
      final now = DateTime.now().toUtc();
      final secondsRemaining = expiry.difference(now).inSeconds;

      // debugPrint('⏳ Token expires in $secondsRemaining seconds');
      return secondsRemaining <= bufferSeconds;
    } catch (e) {
      debugPrint('⚠️ Error checking token expiry: $e');
      return true;
    }
  }

  Future<String?> getValidToken() async {
    String? token = await getToken();
    if (token == null) {
      debugPrint('❌ No token found');
      return null;
    }

    if (JwtDecoder.isExpired(token)) {
      debugPrint('⚠️ Token already expired → logout');
      await logout();
      return null;
    }

    if (willExpireSoon(token, bufferSeconds: 60)) {
      // debugPrint('🔄 Token expiring in less than 60 seconds → refreshing');

      if (_isRefreshing) {
        debugPrint('⏳ Already refreshing, waiting...');
        return await _refreshFuture;
      }

      _isRefreshing = true;
      _refreshFuture = refreshToken();

      final newToken = await _refreshFuture;

      _isRefreshing = false;
      _refreshFuture = null;

      if (newToken == null) {
        debugPrint('❌ Refresh failed → logout');
        await logout();
        return null;
      }

      // debugPrint('✅ Token refreshed successfully');
      return newToken;
    }

    return token;
  }

  Future<String?> refreshToken() async {
    try {
      final oldToken = await getToken();
      if (oldToken == null) {
        debugPrint('❌ No token to refresh');
        return null;
      }

      final response = await http.post(
        Uri.parse(ApiUrl.refreshUrl),
        headers: {
          'Authorization': 'Bearer $oldToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];

        final newToken = data['token'];
        final exp = data['exp'];

        await saveToken(newToken);
        if (exp != null) {
          await saveTokenExpiry(exp);
        }

        // debugPrint('✅ Token refreshed successfully');
        return newToken;
      } else {
        debugPrint(
          '❌ Refresh failed: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('❌ Refresh exception: $e');
      return null;
    }
  }

  Future<UserProfileData?> getUserDetails() async {
    try {
      final token = await getValidToken();

      if (token == null) {
        debugPrint('❌ No valid token available');
        return null;
      }

      final response = await http.get(
        Uri.parse(ApiUrl.userUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final userResponse = UserProfileResponse.fromJson(jsonBody);
        debugPrint('✅ User details fetched successfully');
        return userResponse.data;
      } else if (response.statusCode == 401) {
        debugPrint('⚠️ 401 Unauthorized, attempting token refresh');
        final newToken = await refreshToken();
        if (newToken != null) {
          final retryResponse = await http.get(
            Uri.parse(ApiUrl.userUrl),
            headers: {
              'Authorization': 'Bearer $newToken',
              'Content-Type': 'application/json',
            },
          );
          if (retryResponse.statusCode == 200) {
            final jsonBody = jsonDecode(retryResponse.body);
            final userResponse = UserProfileResponse.fromJson(jsonBody);
            return userResponse.data;
          }
        }
        debugPrint('❌ Failed to get user details after refresh');
        return null;
      } else {
        debugPrint('❌ Failed to get user details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Exception fetching user details: $e');
      return null;
    }
  }
}
