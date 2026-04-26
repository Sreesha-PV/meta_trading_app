// import 'package:flutter/material.dart';

// class AppTheme {

//   static const Color primaryColor = Color(0xFF0A2540);
//   static const Color secondaryColor = Color(0xFF1E88E5);
//   static const Color backgroundColor = Color(0xFFF5F7FA);

//   static ThemeData lightTheme = ThemeData(
//     fontFamily: 'Arial',

//     primaryColor: primaryColor,
//     scaffoldBackgroundColor: backgroundColor,

//     colorScheme: const ColorScheme.light(
//       primary: primaryColor,
//       secondary: secondaryColor,
//     ),

//     appBarTheme: const AppBarTheme(
//       backgroundColor: primaryColor,
//       elevation: 0,
//       centerTitle: true,
//       titleTextStyle: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//         fontFamily: 'Arial',
//       ),
//     ),

//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(fontSize: 16),
//       bodyMedium: TextStyle(fontSize: 14),
//       titleLarge: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     ),

//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: secondaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     ),
//   );
// }





// import 'package:flutter/material.dart';
// import 'package:netdania/app/config/theme/app_color.dart';


// class AppTheme {

//   static ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,

//     fontFamily: 'Arial',

//     scaffoldBackgroundColor: AppColors.background,

//     primaryColor: AppColors.primary,

//     appBarTheme: const AppBarTheme(
//       backgroundColor: AppColors.primary,
//       elevation: 0,
//     ),

//     colorScheme: const ColorScheme.light(
//       primary: AppColors.primary,
//       secondary: AppColors.accent,
//     ),
//   );

//   static ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,

//     fontFamily: 'Arial',

//     scaffoldBackgroundColor: AppColors.darkBackground,

//     primaryColor: AppColors.primary,

//     appBarTheme: const AppBarTheme(
//       backgroundColor: AppColors.darkSurface,
//       elevation: 0,
//     ),

//     colorScheme: const ColorScheme.dark(
//       primary: AppColors.primary,
//       secondary: AppColors.accent,
//     ),
//   );
// }

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      onBackground: Colors.black,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      background: Colors.black,
      onBackground: Colors.white,
    ),
  );
}