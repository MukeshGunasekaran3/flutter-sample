import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onemoney_sdk/ui/splash_screen.dart';

class OnemoneySdk {
  static const MethodChannel _channel = const MethodChannel('onemoney_sdk');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static openOneMoneySDK({required BuildContext buildContext}) {
    Navigator.push(
      buildContext,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }
}
