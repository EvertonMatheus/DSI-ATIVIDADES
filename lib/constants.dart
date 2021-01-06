import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static const appName = 'DSI App';
  static const title = 'CRUD App - DSI/BSI/UFRPE';
  static const spaceSmall = 8.0;
  static const spaceMedium = 16.0;
  static const insetsSmall = EdgeInsets.all(spaceSmall);
  static const insetsMedium = EdgeInsets.all(spaceMedium);
  static const boxSmallHeight = SizedBox(height: spaceSmall);
  static const boxSmallWidth = SizedBox(width: spaceSmall);
  static const boxMediumHeight = SizedBox(height: spaceMedium);
  static const boxMediumWidth = SizedBox(width: spaceMedium);
  static const Color colorGreenBSI1 = Color(0xff89992e);
  static const Color colorGreenBSI2 = Color(0xffc2ca94);
  static const Color colorGreenBSI3 = Color(0xfff7ffe8);
  static final BorderRadius defaultBorderRadius = BorderRadius.circular(5.0);
}

class Images {
  static final AssetImage bsiLogo = AssetImage('images/logo/bsi.png');
  static final AssetImage bsiLogoWhite =
      AssetImage('images/logo/bsi-white.png');
  static final AssetImage bsiLogoBlack =
      AssetImage('images/logo/bsi-black.png');
}
