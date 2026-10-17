import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primaryDark = Color(0xFF173D32); // #173D32 Dark Forest Green
  static const Color primary = Color(0xFF2D8065);     // #2D8065 Jade Green
  static const Color primaryLight = Color(0xFFE9F3ED); // #E9F3ED Soft Mint Tint
  static const Color accentPale = Color(0xFFB9D3C5);  // #B9D3C5 Muted Green

  // Neutral Palette
  static const Color background = Color(0xFFF4F7F5);  // #F4F7F5 Off-white / light slate
  static const Color surface = Color(0xFFFFFFFF);     // #FFFFFF Card background
  static const Color surfaceMuted = Color(0xFFE9EEEB); // #E9EEEB Light grey container
  static const Color border = Color(0xFFDAE4DE);      // #DAE4DE Subtle border
  static const Color textDark = Color(0xFF20372F);    // #20372F Heading / Primary Text
  static const Color textMuted = Color(0xFF687A72);   // #687A72 Secondary / Caption Text
  static const Color textLight = Color(0xFFFFFFFF);   // #FFFFFF White Text

  // State & Feedback
  static const Color warning = Color(0xFF9A650E);     // #9A650E Gold/Brown Warning
  static const Color warningBg = Color(0xFFFFF4DC);   // #FFF4DC Warning Banner/Badge
  static const Color error = Color(0xFFB3433F);       // #B3433F Coral Red Error
  static const Color errorBg = Color(0xFFFDEDED);     // Error Background
  static const Color success = Color(0xFF2D8065);     // #2D8065 Success
}

class AppStyles {
  static const String fontFamily = 'Inter';

  // Headings
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.35,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.4,
  );

  // Subtitle / Label
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.primary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.45,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.45,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
}
