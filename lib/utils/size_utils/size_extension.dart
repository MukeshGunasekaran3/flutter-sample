import 'package:onemoney_sdk/utils/size_utils/screen_util.dart';

extension SizeExtension on num {
  ///[ScreenUtil.setWidth]
  double get w => SizeUtil().setWidth(this);

  ///[ScreenUtil.setHeight]
  double get h => SizeUtil().setHeight(this);

  ///[ScreenUtil.radius]
  double get r => SizeUtil().radius(this);

  ///[ScreenUtil.setSp]
  double get sp => SizeUtil().setSp(this);

  ///[ScreenUtil.setSp]
  @Deprecated('please use [sp]')
  double get ssp => SizeUtil().setSp(this);

  ///[ScreenUtil.setSp]
  @Deprecated(
      'please use [sp] , and set textScaleFactor: 1.0 , for example: Text("text", textScaleFactor: 1.0)')
  double get nsp => SizeUtil().setSp(this);

  ///屏幕宽度的倍数
  ///Multiple of screen width
  double get sw => SizeUtil().screenWidth * this;

  ///屏幕高度的倍数
  ///Multiple of screen height
  double get sh => SizeUtil().screenHeight * this;
}
