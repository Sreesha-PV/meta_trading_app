// class ApiUrl{
//   static const String baseUrl = 'https://uat.ax1systems.com/gateway';
//   static  String wsUrl(String token) => 'wss://uat.ax1systems.com/notifications?token=$token';
//   // static const String wstickerUrl='wss://uat.ax1systems.com/ticker';
//   static String wstickerUrl(String token) =>'wss://uat.ax1systems.com/ticker?token=$token';
//   static const String registerUrl = '$baseUrl/jwt/client/account/create';
//   static const String loginUrl = '$baseUrl/auth/login';
//   static const String userUrl = '$baseUrl/jwt/client/account/client-details';
//   static const String orderUrl = '$baseUrl/jwt/client/order/create';
//   static String pendingOrderUrl(int accountId) =>'$baseUrl/jwt/client/orders?account_id=$accountId';
//   static String positionUrl(int accountId) =>'$baseUrl/jwt/client/positions/open?account_id=$accountId';
//   static String fetchInstrumentUrl='$baseUrl/jwt/client/instruments';
//   static String instrumentUrl(int id) => '$baseUrl/$id';
//   static String modifyUrl = '$baseUrl/jwt/client/order/modify';
//   static String closePositionUrl = '$baseUrl/jwt/client/positions/close';
//   static String cancelOrderUrl = '$baseUrl/jwt/client/order/cancel';
// }

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrl {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  static final String priceBaseUrl = dotenv.env['PRICE_BASE_URL']!;
  static final String wsBaseUrl = dotenv.env['WS_URL']!;
  static final String wsTickerBaseUrl = dotenv.env['WS_TICKER_URL']!;
  // static final String orderFetchBaseUrl = dotenv.env['ORDER_URL']!;

  static String wsUrl(String token) => '$wsBaseUrl?token=$token';

  static String wsTickerUrl(String token) => '$wsTickerBaseUrl?token=$token';
  // static String wsTickerUrl(int accountId) => '$wsBaseUrl?account_id=$accountId';

  static final String registerUrl = '$baseUrl/jwt/client/account/create';
  static final String loginUrl = '$baseUrl/auth/login';
  static final String logoutUrl = '$baseUrl/auth/logout';
  static final String refreshUrl = '$baseUrl/auth/refresh';
  static final String userUrl = '$baseUrl/jwt/client/account/client-details';
  static final String orderUrl = '$baseUrl/jwt/client/order/create';
  static final String closeorderUrl = '$baseUrl/jwt/client/order/cancel';
  static final String modifyorderUrl = '$baseUrl/jwt/client/order/modify';

  static String closedOrderUrl(int accountId) =>
      '$baseUrl/jwt/client/positions/settled?account_id=$accountId';
  static String pendingOrderUrl(int accountId) =>
      '$baseUrl/jwt/client/orders?account_id=$accountId&status=1';




  static String positionUrl(int accountId) =>
      '$baseUrl/jwt/client/positions/open?account_id=$accountId';

  static String fetchInstrumentUrl(int accountId) =>
      '$baseUrl/jwt/client/instruments?account_id=$accountId';

  static String fetchInstrumentByIdUrl(int id, String accountId) =>
      '$baseUrl/jwt/client/instruments/$id?account_id=$accountId';

  static String instrumentUrl(int id) => '$baseUrl/$id';

  static final String modifyUrl = '$baseUrl/jwt/client/order/modify';
  // static final String modifyUrl = '$baseUrl/jwt/client/positions/tpsl';
  static final String closePositionUrl = '$baseUrl/jwt/client/positions/close';
  static final String cancelOrderUrl = '$baseUrl/jwt/client/order/cancel';

  static String priceUrl(List<String> symbols) =>
      '$priceBaseUrl/price?symbols=${symbols.join(',')}';
}

