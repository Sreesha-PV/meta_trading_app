// import 'package:flutter/material.dart';

// class AppColors {
//   // BRAND COLORS
//   static const primary = Color(0xFF0066FF);
//   static const primaryLight = Color(0xFF66A3FF);
//   static const primaryDark = Color(0xFF0047B3);

//   static const accent = Color(0xFFFFC107);
//   static const accentLight = Color(0xFFFFD54F);
//   static const accentDark = Color(0xFFFFA000);

//   static const iconText = Color(0xFFFFAB40);
//   // NEUTRALS
//   static const background = Color(0xFFFFFFFF);
//   static const surface = Color(0xFFF5F6FA);
//   // static const divider = Color(0xFFE0E0E0);
//   static const divider = Color(0x00000000);

//   // TEXT COLORS
//   static const textPrimary = Color(0xFF212121);
//   static const textSecondary = Color(0xFF757575);
//   static const textMuted = Color(0xFF9E9E9E);

//   // STATUS COLORS
//   static const success = Color(0xFF4CAF50);
//   static const error = Color(0xFFF44336);
//   static const warning = Color(0xFFFFC107);
//   static const info = Color(0xFF2196F3);

//   // TRADING / MARKET COLORS
//   static const up = Colors.blue; // price increasing
//   static const down = Colors.red; // price decreasing
//   static const neutral = Colors.grey;
//   static const lightNeutral = Color.fromARGB(255, 239, 239, 239);
  
// }

// import 'package:flutter/material.dart';

// class AppColors {

//   // ================= BRAND =================
//   static const primary = Color(0xFF0066FF);
//   static const primaryLight = Color(0xFF66A3FF);
//   static const primaryDark = Color(0xFF0047B3);

//   static const accent = Color(0xFFFFC107);
//   static const accentLight = Color(0xFFFFD54F);
//   static const accentDark = Color(0xFFFFA000);

//   static const iconText = Color(0xFFFFAB40);

//     // LIGHT THEME
//   static const background = Color(0xFFFFFFFF);
//   static const surface = Color(0xFFF5F6FA);

//   static const textPrimary = Color(0xFF212121);
//   static const textSecondary = Color(0xFF757575);

//   // DARK THEME
//   static const darkBackground = Color(0xFF121212);
//   static const darkSurface = Color(0xFF1E1E1E);

//   static const darkTextPrimary = Color(0xFFFFFFFF);
//   static const darkTextSecondary = Color(0xFFB0B0B0);

//   // ================= BACKGROUND =================
//   // static const background = Color(0xFFFFFFFF);
//   // static const surface = Color(0xFFF5F6FA);
//   static const card = Colors.white;

//   // ================= BORDER =================
//   static const border = Color(0xFFE0E0E0);
//   static const divider = Colors.transparent;

//   // ================= TEXT =================
//   // static const textPrimary = Color(0xFF212121);
//   // static const textSecondary = Color(0xFF757575);
//   static const textMuted = Color(0xFF9E9E9E);

//   // ================= STATUS =================
//   static const success = Color(0xFF4CAF50);
//   static const error = Color(0xFFF44336);
//   static const warning = Color(0xFFFFC107);
//   static const info = Color(0xFF2196F3);

//   // ================= TRADING =================
//   static const bullish = Color(0xFF2196F3); // price up
//   static const bearish = Color(0xFFF44336); // price down
//   static const neutral = Colors.grey;

//   static const lightNeutral = Color(0xFFEFEFEF);
// }


import 'package:flutter/material.dart';

class AppColors {
  // ================= BRAND =================
  static const primary = Color(0xFF0066FF);
  static const accent = Color(0xFFFFC107);

  static const bullish = Color(0xFF2196F3);
  static const bearish = Color(0xFFF44336);

  static const error = Color(0xFFF44336);

  static const info = Color(0xFF2196F3);
  static const success = Color(0xFF4CAF50);

  static const lightNeutral = Color.fromARGB(255, 239, 239, 239);
  static const neutral = Colors.grey;

  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFFB0B0B0);
  static const iconText = Color(0xFFFFAB40);

  static const divider = Colors.transparent;


  // ================= DYNAMIC COLORS =================

  static Color background(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static Color surface(BuildContext context) =>
      Theme.of(context).cardColor;

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onBackground;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

  static Color border(BuildContext context) =>
      Theme.of(context).dividerColor;

  static Color card(BuildContext context) =>
      Theme.of(context).cardColor;
}