import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';

import 'color_resources.dart';

class Loader {
  static showSimpleLoader(
    BuildContext context,
  ) {
    return Container(
      width: 40.w,
      height: 40.h,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(ColorResources.COLOR_PRIMARY),
        strokeWidth: 4,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static Future<void> showFullScreenLoader(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: new Material(
            type: MaterialType.transparency,
            child: Center(
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        );
      },
    );
  }

  static void hideProgressDialog() {
    Navigator.pop(globalKey.currentState!.overlay!.context);
  }
}
