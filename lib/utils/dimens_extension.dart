import 'package:base_app/utils/screen_dimens.dart';

extension SizeExtension on num {
  ///[ScreenDimens.setWidth]
  num get w => ScreenDimens.I.setWidth(this);

  ///[ScreenDimens.setHeight]
  num get h => ScreenDimens.I.setHeight(this);

  ///[ScreenDimens.setSp]
  num get sp => ScreenDimens.I.setSp(this);

  ///[ScreenDimens.setSp]
  num get ssp => ScreenDimens.I.setSp(this, allowFontScalingSelf: true);

  ///[ScreenDimens.setSp]
  num get nsp => ScreenDimens.I.setSp(this, allowFontScalingSelf: false);

  num get wp => ScreenDimens.I.screenWidth * this;

  num get hp => ScreenDimens.I.screenHeight * this;
}
