import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:netdania/app/getX/trade_getX.dart';
import 'package:flutter/foundation.dart';
import 'package:netdania/app/config/theme/app_theme.dart';
import 'package:netdania/app/getX/theme_getx.dart';
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
  await GetStorage.init('price_cache');
  await GetStorage.init('ohlc_cache');
  await GetStorage.init('ohlc_cache');
  await GetStorage.init();

  Get.put(UserController());
  Get.put(ThemeController());

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() => GetMaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme, // 👈 add dark theme
          themeMode: themeController.themeMode.value,
          debugShowCheckedModeBanner: false,
          title: 'Ax1 Trading',
          // initialBinding: InitialBinding(),
            unknownRoute: GetPage(name: '/notfound', page: () => LoginSignupPage()),
      getPages: [
        GetPage(name: '/login', page: () => LoginSignupPage()),
        GetPage(name: '/home', page: () => HomePage()),
      ],
          home: const AuthCheck(),
        ));
  }
}