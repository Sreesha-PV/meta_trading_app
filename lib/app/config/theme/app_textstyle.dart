import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTextStyle {
  static TextStyle _textStyle(
      {
      required double size,
      required FontWeight weight,
      double? lineHeight = 1.5}) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: lineHeight,
      fontFamily: 'HarmonyOS_Sans_SC',
      // color: AppColors.textPrimary,
    );
  }

  static TextStyle h1_400_100 =
      _textStyle(size: 24, weight: FontWeight.w400, lineHeight: 1);
  static TextStyle h1_400 = _textStyle(size: 24, weight: FontWeight.w400,);
  static TextStyle h1_500 = _textStyle(size: 24, weight: FontWeight.w500);
  static TextStyle h1_700 = _textStyle(size: 24, weight: FontWeight.w700);

  static TextStyle h2_400_100 =
      _textStyle(size: 20, weight: FontWeight.w400, lineHeight: 1);
  static TextStyle h2_400 = _textStyle(size: 20, weight: FontWeight.w400);
  static TextStyle h2_500 = _textStyle(size: 20, weight: FontWeight.w500);
  static TextStyle h2_700 = _textStyle(size: 20, weight: FontWeight.w700);

  static TextStyle h3_400_100 =
      _textStyle(size: 18, weight: FontWeight.w400, lineHeight: 1);
  static TextStyle h3_400 = _textStyle(size: 18, weight: FontWeight.w400);
  static TextStyle h3_500 = _textStyle(size: 18, weight: FontWeight.w500);
  static TextStyle h3_700 = _textStyle(size: 18, weight: FontWeight.w700);

  static TextStyle body_400_100 =
      _textStyle(size: 16, weight: FontWeight.w400, lineHeight: 1);
  static TextStyle body_400 = _textStyle(size: 16, weight: FontWeight.w400);
  static TextStyle body_500 = _textStyle(size: 16, weight: FontWeight.w500);
  static TextStyle body_700 = _textStyle(size: 16, weight: FontWeight.w700);

  static TextStyle body2_400_100 =
      _textStyle(size: 15, weight: FontWeight.w400, lineHeight: 1);
  static TextStyle body2_400 = _textStyle(size: 15, weight: FontWeight.w400);
  static TextStyle body2_500 = _textStyle(size: 15, weight: FontWeight.w500);
  static TextStyle body2_700 = _textStyle(size: 15, weight: FontWeight.w700);

  static TextStyle medium_400_100 =
      _textStyle(size: 14, weight: FontWeight.w400, lineHeight: 1);
  static TextStyle medium_400 = _textStyle(size: 14, weight: FontWeight.w400);
  static TextStyle medium_500 = _textStyle(size: 14, weight: FontWeight.w500);
  static TextStyle medium_700 = _textStyle(size: 14, weight: FontWeight.w700);

  static TextStyle medium2_400_100 =
      _textStyle(size: 13, weight: FontWeight.w400, lineHeight: 1);
  static TextStyle medium2_400 = _textStyle(size: 13, weight: FontWeight.w400);
  static TextStyle medium2_500 = _textStyle(size: 13, weight: FontWeight.w500);
  static TextStyle medium2_700 = _textStyle(size: 13, weight: FontWeight.w700);

  static TextStyle small_400_100 =
      _textStyle(size: 12, weight: FontWeight.w400, lineHeight: 1);
  static TextStyle small_400 = _textStyle(size: 12, weight: FontWeight.w400);
  static TextStyle small_500 = _textStyle(size: 12, weight: FontWeight.w500);
  static TextStyle small_700 = _textStyle(size: 12, weight: FontWeight.w700);

  static TextStyle small2_400_100 =
      _textStyle(size: 11, weight: FontWeight.w400, lineHeight: 1);
  static TextStyle small2_400 = _textStyle(size: 11, weight: FontWeight.w400);
  static TextStyle small2_500 = _textStyle(size: 11, weight: FontWeight.w500);
  static TextStyle small2_700 = _textStyle(size: 11, weight: FontWeight.w700);

  static TextStyle small3_400_100 =
      _textStyle(size: 10, weight: FontWeight.w400, lineHeight: 1);
  static TextStyle small3_400 = _textStyle(size: 10, weight: FontWeight.w400);
  static TextStyle small3_500 = _textStyle(size: 10, weight: FontWeight.w500);
  static TextStyle small3_700 = _textStyle(size: 10, weight: FontWeight.w700);

  static TextStyle small4_400_100 =
      _textStyle(size: 9, weight: FontWeight.w400, lineHeight: 1);
  static TextStyle small4_400 = _textStyle(size: 9, weight: FontWeight.w400);
  static TextStyle small4_500 = _textStyle(size: 9, weight: FontWeight.w500);
  static TextStyle small4_700 = _textStyle(size: 9, weight: FontWeight.w700);
}

// extension TextColor on TextStyle {
// //   // Brand 主色
// //   TextStyle get colorBrandMain => copyWith(color: AppColors.colorBrandMain);

// //   // 透明色
// //   TextStyle get colorTransparent => copyWith(color: AppColors.transparent);

// //   // Always
// //   TextStyle get colorAlwaysBlack => copyWith(color: AppColors.colorAlwaysBalck);
// //   TextStyle get colorAlwaysWhite => copyWith(color: AppColors.colorAlwaysWhite);

// //   // 文字颜色
//   TextStyle get textPrimary => copyWith(color: AppColors.textPrimary);
//   TextStyle get textSecondary => copyWith(color: AppColors.textSecondary);
//   TextStyle get darkBackground => copyWith(color: AppColors.darkBackground);
//   TextStyle get surface => copyWith(color: AppColors.surface);
//   TextStyle get info => copyWith(color: AppColors.info);
//   TextStyle get primary => copyWith(color: AppColors.primary);
//   TextStyle get textMuted => copyWith(color: AppColors.textMuted);
//   TextStyle get background => copyWith(color: AppColors.background);
//   TextStyle get bullish => copyWith(color: AppColors.bullish);




extension TextColor on TextStyle {
  TextStyle textPrimary(BuildContext context) =>
      copyWith(color: Theme.of(context).colorScheme.onBackground);

  TextStyle textSecondary(BuildContext context) =>
      copyWith(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      );

  TextStyle primary(BuildContext context) =>
      copyWith(color: Theme.of(context).colorScheme.primary);

  TextStyle muted(BuildContext context) =>
      copyWith(color: Theme.of(context).hintColor);

TextStyle surface(BuildContext context) =>
      copyWith(color: Theme.of(context).colorScheme.onPrimary);

  // These can stay static (good 👍)
  TextStyle bullish() => copyWith(color: AppColors.bullish);
  TextStyle bearish() => copyWith(color: AppColors.bearish);


  TextStyle  info() => copyWith(color: AppColors.info);
  

//   TextStyle get colorTextTertiary =>
//       copyWith(color: AppColors.colorTextTertiary);

//   TextStyle get colorTextInversePrimary =>
//       copyWith(color: AppColor.colorTextInversePrimary);
//   TextStyle get colorTextSecondary =>
//       copyWith(color: AppColor.colorTextSecondary);

//   TextStyle get colorTexYel =>
//       copyWith(color: AppColor.superColor);

//   TextStyle get colorTextDescription =>
//       copyWith(color: AppColor.colorTextDescription);
//   TextStyle get colorTextTips => copyWith(color: AppColor.colorTextTips);
//   TextStyle get colorTextDisabled =>
//       copyWith(color: AppColor.colorTextDisabled);

//   TextStyle get colorTextInverseSecondary =>
//       copyWith(color: AppColor.colorTextInverseSecondary);
//   TextStyle get colorTextInverseTertiary =>
//       copyWith(color: AppColor.colorTextInverseTertiary);
//   TextStyle get colorTextError => copyWith(color: AppColor.colorTextError);
//   TextStyle get colorTextWarning => copyWith(color: AppColor.colorTextWarning);
//   TextStyle get colorTextSuccess => copyWith(color: AppColor.colorTextSuccess);
//   TextStyle get colorTextBrand => copyWith(color: AppColor.colorTextBrand);

//   // 背景色
//   TextStyle get colorBackgroundPrimary =>
//       copyWith(color: AppColor.colorBackgroundPrimary);
//   TextStyle get colorBackgroundSecondary =>
//       copyWith(color: AppColor.colorBackGroundSecondary);
//   TextStyle get colorBackgroundTertiary =>
//       copyWith(color: AppColor.colorBackgroundTertiary);
//   TextStyle get colorBackGroundDisabled =>
//       copyWith(color: AppColor.colorBackGroundDisabled);
//   TextStyle get colorBackgroundInversePrimary =>
//       copyWith(color: AppColor.colorBackgroundInversePrimary);
//   TextStyle get colorBackgroundWarning =>
//       copyWith(color: AppColor.colorBackgroundWarning);

//   TextStyle get colorBackGroundMask =>
//       copyWith(color: AppColor.colorBackGroundMask);

//   // Border颜色
//   TextStyle get colorBorderGutter =>
//       copyWith(color: AppColor.colorBorderGutter);
//   TextStyle get colorBorderSubtle =>
//       copyWith(color: AppColor.colorBorderSubtle);
//   TextStyle get colorBorderStrong =>
//       copyWith(color: AppColor.colorBorderStrong);
//   TextStyle get colorBorderButtonStrong =>
//       copyWith(color: AppColor.colorBorderButtonStrong);
//   TextStyle get colorBorderButtonLine =>
//       copyWith(color: AppColor.colorBorderButtonLine);

//   // Function颜色
//   TextStyle get colorFunctionBuy => copyWith(color: AppColor.colorFunctionBuy);
//   TextStyle get colorFunctionBuyLightBackground =>
//       copyWith(color: AppColors.colorFunctionBuyLightBackground);
//   TextStyle get colorFunctionBuyVolume =>
//       copyWith(color: AppColor.colorFunctionBuyVolume);
//   TextStyle get colorFunctionSell =>
//       copyWith(color: AppColor.colorFunctionSell);
//   TextStyle get colorFunctionSellLightBackground =>
//       copyWith(color: AppColor.colorFunctionSellLightBackground);
//   TextStyle get colorFunctionSellVolume =>
//       copyWith(color: AppColor.colorFunctionSellVolume);

//   /// 主题配置色 暂时用不上（没有主题切换）
//   TextStyle get colorTextPrimaryLight =>
//       copyWith(color: AppColor.colorTextPrimaryLight);
//   TextStyle get colorTextSecondaryLight =>
//       copyWith(color: AppColor.colorTextSecondaryLight);
//   TextStyle get bgColorLight => copyWith(color: AppColor.bgColorLight);
//   TextStyle get cardBgColorLight => copyWith(color: AppColor.cardBgColorLight);

//   TextStyle get colorTextPrimaryDark =>
//       copyWith(color: AppColor.colorTextPrimaryDark);
//   TextStyle get colorTextSecondaryDark =>
//       copyWith(color: AppColor.colorTextSecondaryDark);
//   TextStyle get bgColorDark => copyWith(color: AppColor.bgColorDark);
//   TextStyle get cardBgColorDark => copyWith(color: AppColor.cardBgColorDark);

//   // 分割线
//   TextStyle get dividerColorLight =>
//       copyWith(color: AppColor.dividerColorLight);
//   TextStyle get dividerColorDark => copyWith(color: AppColor.dividerColorDark);
//   TextStyle get ellipsis => copyWith(overflow: TextOverflow.ellipsis);
}
