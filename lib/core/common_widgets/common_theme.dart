import 'package:flutter/widgets.dart';

class CommonTheme {
  CommonTheme._();
  // fonts
  static const String fontVerela = 'Varela';
  // colors

  static const Color primaryLightest = Color(0xFFF2F5F9);
  static const Color primaryLighter = Color(0xFF9CC4F4);
  static const Color primaryLight = Color(0xFF649FF8);
  static const Color primary = Color(0xFF2D68BF);
  static const Color primaryDark = Color(0xFF224C8C);
  static const Color primaryDarker = Color(0xFF081C5B);
  static const Color primaryDarkest = Color(0xFFFFFFFF);

  static final Color secondaryLightest = Color(0xFFFFFFFF).withOpacity(0.3);
  static final Color secondaryLighter = Color(0xFFFFFFFF).withOpacity(0.3);
  static final Color secondaryLight = Color(0xFFFFFFFF).withOpacity(0.3);
  static final Color secondary = Color(0xFFFFFFFF).withOpacity(0.3);
  static final Color secondaryDark = Color(0xFFFFFFFF).withOpacity(0.3);
  static final Color secondaryDarker = Color(0xFFFFFFFF).withOpacity(0.3);
  static final Color secondaryDarkest = Color(0xFFFFFFFF).withOpacity(0.3);

  static const Color white = Color(0xFFFFFFFF);

  static const Color greyLightest = Color(0xFFF7F7F7);
  static const Color greyLighter = Color(0xFFEAEAEA);
  static const Color greyLight = Color(0xFFD4D4D4);
  static const Color grey = Color(0xFFA9A9A9);
  static const Color greyDark = Color(0xFF696969);
  static const Color greyDarker = Color(0xFF505050);
  static const Color greyDarkest = Color(0xFFFFFFFF);

  static const Color black = Color(0xFF0F2340);

  static const Color infoLightest = primaryLightest;
  static const Color infoLighter = primaryLighter;
  static const Color infoLight = primaryLight;
  static const Color info = primary;
  static const Color infoDark = primaryDark;
  static const Color infoDarker = primaryDarker;
  static const Color infoDarkest = primaryDarkest;

  static const Color successLightest = Color(0xFFF0FDE8);
  static const Color successLighter = Color(0xFFB4EEA0);
  static const Color successLight = Color(0xFF7DE15B);
  static const Color success = Color(0xFF33AF28);
  static const Color successDark = Color(0xFF147D1C);
  static const Color successDarker = Color(0xFF07531A);
  static const Color successDarkest = Color(0xFFFFFFFF);

  static const Color warningLightest = Color(0xFFFEFAE6);
  static const Color warningLighter = Color(0xFFFEEFB3);
  static const Color warningLight = Color(0xFFFCD44F);
  static const Color warning = Color(0xFFF9B402);
  static const Color warningDark = Color(0xFFB37701);
  static const Color warningDarker = Color(0xFF774800);
  static const Color warningDarkest = Color(0xFFFFFFFF);

  static const Color dangerLightest = Color(0xFFFDEFE7);
  static const Color dangerLighter = Color(0xFFFBD4C6);
  static const Color dangerLight = Color(0xFFF19E8E);
  static const Color danger = Color(0xFFCB2828);
  static const Color dangerDark = Color(0xFF921429);
  static const Color dangerDarker = Color(0xFF610726);
  static const Color dangerDarkest = Color(0xFFFFFFFF);

  static const double elevationLeve1 = 2.00;
  static const double elelvationLevel2 = 8.00;
  static const double elevationLevel3 = 16.00;

// Text Styles

  static TextStyle tsHeaderDesktop = TextStyle(
      fontFamily: fontVerela,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 32,
      height: 1.3,
      color: CommonTheme.greyDark);

  static TextStyle tsHeaderMobile = TextStyle(
      fontFamily: fontVerela,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 24,
      height: 1.3,
      color: CommonTheme.greyDark);

  static TextStyle tsBodyDefault = TextStyle(
      fontFamily: fontVerela,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 16,
      height: 1.3);

  static TextStyle tsBodySmall = TextStyle(
      fontFamily: fontVerela,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      height: 1.3);

  static TextStyle tsBodyExtraSmall = TextStyle(
      fontFamily: fontVerela,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      height: 1.3);
}
