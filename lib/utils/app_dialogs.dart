import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onemoney_sdk/ui/custom_button.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';

class AppDialogs {
  static showError(
    BuildContext context,
    String error, {
    bool barrierDismissible: true,
  }) {
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding:
                  EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.h))),
              child: Container(
                width: MediaQuery.of(context).size.width,
                // padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 4.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      Images.one_money_logo,
                      width: 120.h,
                      height: 80.h,
                    ),
                    getMediumText(error,
                        textAlign: TextAlign.center, fontsize: 16.sp),
                    Container(
                      margin: EdgeInsets.only(
                          top: 30.h, left: 8.h, right: 8.h, bottom: 16.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CustomButton(
                            buttonHeight: 44.h,
                            buttonWidth: 120.h,
                            buttonText: "Okay",
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            title: Text('Attention'),
            content: Text('$error'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('CLOSE'))
            ],
          );
        });
  }

  static showErrorWithRetry(
      BuildContext context, String error, Function callback) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            title: Text('Error'),
            content: Text('$error'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('CLOSE')),
              FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    callback(context);
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('RETRY'))
            ],
          );
        });
  }

  static showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: Row(
              children: [
                CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: ColorResources.COLOR_PRIMARY,
                ),
                SizedBox(width: 30),
                Text('Please Wait...')
              ],
            )));
  }

  static showSimpleDialog(BuildContext context, String title, String content) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 16.0,
                ),
                SingleChildScrollView(
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  static showSuccessDialog(
      BuildContext context, String title, String content, Function onClose) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  content,
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OKAY'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }).then((a) {
      onClose();
    });
  }
}
