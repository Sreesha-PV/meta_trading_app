import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:netdania/app/getX/trade_getX.dart';
import 'package:flutter/foundation.dart';
import 'package:netdania/app/getX/user_getX.dart';
import 'package:netdania/app/modules/home/view/home_page.dart';
import 'package:netdania/app/modules/login/view/login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:netdania/screens/services/socket_connection.dart';
import 'package:netdania/app/widgets/auth_check.dart';

void main() async {
  // if (kIsWeb) {
  WidgetsFlutterBinding.ensureInitialized();
  // }
  // print('Main started');
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  // Register GetX controller globally with required parameters
  // Get.put(
  //   TradePageController(
  //     // symbols: [
  //     //  'EURUSD',

  //     // ],
  //     initialSymbols: [],
  //   ),
  // );
  Get.put(UserController());
  // Get.put(LocalWebSocketService(
  //   symbols: ['EURUSD',
  //   'GBPJPY'
  //   ],
  //   onData: (data) {},
  // ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'Arial'),
      debugShowCheckedModeBanner: false,
      title: 'Ax1 Trading',
      home: const AuthCheck(),
      unknownRoute: GetPage(name: '/notfound', page: () => LoginSignupPage()),
      getPages: [
        GetPage(name: '/login', page: () => LoginSignupPage()),
        GetPage(name: '/home', page: () => HomePage()),
      ],
    );
  }
}
