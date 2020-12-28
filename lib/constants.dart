import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static final String appName = 'DSI App';
  static final String title = 'CRUD App - DSI/BSI/UFRPE';
  static const paddingSmall = EdgeInsets.all(5.0);
  static const paddingMedium = EdgeInsets.all(12.0);
  static const spaceSmallHeight = SizedBox(height: 8.0);
  static const spaceSmallWidth = SizedBox(width: 8.0);
  static const spaceMediumHeight = SizedBox(height: 16.0);
  static const spaceMediumWidth = SizedBox(width: 16.0);
  static const Color colorGreenBSI1 = Color(0xff89992e);
  static const Color colorGreenBSI2 = Color(0xffc2ca94);
  static const Color colorGreenBSI3 = Color(0xfff7ffe8);
}

class Images {
  static final AssetImage bsiLogo = AssetImage('images/logo/bsi.png');
  static final AssetImage bsiLogoWhite =
      AssetImage('images/logo/bsi-white.png');
  static final AssetImage bsiLogoBlack =
      AssetImage('images/logo/bsi-black.png');
}
