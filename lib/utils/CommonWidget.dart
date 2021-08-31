import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onemoney_sdk/utils/styles.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';

import 'color_resources.dart';

 GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

getRegularText(String text,
    {double? fontsize,
    FontWeight? fontWeight,
    Color? fontcolor,
    TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign ?? TextAlign.left,
    style: popinsRegular.copyWith(
      fontSize: fontsize ?? 15.h,
      color: fontcolor ?? Colors.black,
      fontWeight: fontWeight ?? FontWeight.normal,
    ),
  );
}

getMediumText(String text,
    {double? fontsize,
    FontWeight? fontWeight,
    Color? fontcolor,
    TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign ?? TextAlign.left,
    style: popinsMedium.copyWith(
      fontSize: fontsize ?? 15.h,
      color: fontcolor ?? Colors.black,
      fontWeight: fontWeight ?? FontWeight.normal,
    ),
  );
}

getBoldText(String text,
    {double? fontsize,
    FontWeight? fontWeight,
    Color? fontcolor,
    TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign ?? TextAlign.left,
    style: popinsBold.copyWith(
      fontSize: fontsize ?? 15.h,
      color: fontcolor ?? Colors.black,
      fontWeight: fontWeight ?? FontWeight.normal,
    ),
  );
}

getBackButton(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
    onPressed: () => Navigator.of(context).pop(),
  );
}

AppBar getAppBar(BuildContext context, String title,
    {Widget? leadingButton,
    Brightness? brightness,
    Widget? titleWidget,
    List<Widget>? actionItems,
    bool isWhite = false,
    bool isTitleShow = true,
    TextAlign? textalign,
    bool? centerTitle,
    double? leadingWidth}) {
  return AppBar(
    brightness: Brightness.light,
    iconTheme: IconThemeData(
      color: Colors.black, //change your color here
    ),
    centerTitle: centerTitle ?? false,
    elevation: 0,
    title: isTitleShow
        ? titleWidget ??
            getRegularText(title, fontcolor: Colors.black, fontsize: 18.h)
        : Container(),
    leadingWidth: leadingWidth ?? null,
    leading: leadingButton ??= null,
    automaticallyImplyLeading: leadingButton != null,
    backgroundColor: Colors.white,
    actions: actionItems == null ? null : actionItems,
    titleSpacing: 0,
  );
}

getFirstCharOfText(String text,
    {double? fontsize,
      FontWeight? fontWeight,
      Color? fontcolor,
      TextAlign? textAlign}) {
  return Text(
    text.characters.first,
    textAlign: textAlign ?? TextAlign.center,
    style: popinsBold.copyWith(
      fontSize: fontsize ??  22.sp,
      color: fontcolor ?? Colors.white,
      fontWeight: fontWeight ?? FontWeight.bold,
    ),
  );
}

getMenuButton(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.menu, color: Colors.black),
    onPressed: () => Navigator.of(context).pop(),
  );
}

class DrawCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = ColorResources.COLOR_PRIMARY;
    canvas.drawCircle(Offset(0.0, 0.0), 20, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    //false : paint call might be optimized away.
    return false;
  }
}
