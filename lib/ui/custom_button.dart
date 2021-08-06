import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function() onTap;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? fontSize;
  final Color? textColor;
  final Color? buttonColor;

  const CustomButton(
      {required this.buttonText,
      required this.onTap,
      this.buttonWidth,
      this.buttonHeight,
      this.fontSize,
      this.textColor,
      this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: buttonWidth ?? 200.w,
        padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 7.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200.w),
            border: Border.all(color: ColorResources.COLOR_PRIMARY, width: 1.7),
            color: buttonColor ?? ColorResources.COLOR_PRIMARY),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: popinsMedium.copyWith(
              fontSize: fontSize ?? 15.sp,
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
