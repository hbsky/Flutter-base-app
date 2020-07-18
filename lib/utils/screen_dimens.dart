import 'package:flutter/material.dart';

/// wireframe screen size
class ScreenSolution {
  final int screenWidthPx;
  final int screenHeightPx;

  ScreenSolution(this.screenWidthPx, this.screenHeightPx);
}

final ScreenSolution iphone5sScreen = ScreenSolution(640, 1136);
final ScreenSolution iphone6Screen = ScreenSolution(750, 1334);

class ScreenDimens {
  static final ScreenDimens _instance = ScreenDimens._();
  static ScreenDimens get I => _instance;

  num _uiWidthPx;
  num _uiHeightPx;

  /// Sets whether the font size is scaled according to the system's "font size" assist option
  bool _allowFontScaling;

  double _screenWidth;
  double _screenHeight;
  double _pixelRatio;
  double _statusBarHeight;
  double _bottomBarHeight;
  double _textScaleFactor;

  factory ScreenDimens(BuildContext context,
      {ScreenSolution screenSolution, bool allowFontScaling = false}) {
    _instance._allowFontScaling = allowFontScaling;
    _instance._init(context, screenSolution: screenSolution);
    return _instance;
  }

  ScreenDimens._();

  void _init(BuildContext context, {ScreenSolution screenSolution}) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var dpRatio = mediaQuery.devicePixelRatio;
    _instance._uiWidthPx =
        screenSolution?.screenWidthPx ?? mediaQuery.size.width * dpRatio;
    _instance._uiHeightPx =
        screenSolution?.screenHeightPx ?? mediaQuery.size.height * dpRatio;

    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = mediaQuery.padding.bottom;
    _textScaleFactor = mediaQuery.textScaleFactor;
  }

  double get textScaleFactor => _textScaleFactor;

  double get pixelRatio => _pixelRatio;

  double get screenWidth => _screenWidth;

  double get screenHeight => _screenHeight;

  double get screenWidthPx => _screenWidth * _pixelRatio;

  double get screenHeightPx => _screenHeight * _pixelRatio;

  double get statusBarHeight => _statusBarHeight;

  double get bottomBarHeight => _bottomBarHeight;

  double get scaleWidth => _screenWidth / _uiWidthPx;

  double get scaleHeight => _screenHeight / _uiHeightPx;

  double get scaleText => scaleWidth;

  num setWidth(num width) => width * scaleWidth;

  num setHeight(num height) => height * scaleHeight;

  void setAllowFontScaling(bool allowFontScaling) =>
      this._allowFontScaling = allowFontScaling;

  num setSp(num fontSize, {bool allowFontScalingSelf}) =>
      allowFontScalingSelf == null
          ? (_allowFontScaling
              ? (fontSize * scaleText)
              : ((fontSize * scaleText) / _textScaleFactor))
          : (allowFontScalingSelf
              ? (fontSize * scaleText)
              : ((fontSize * scaleText) / _textScaleFactor));
}
