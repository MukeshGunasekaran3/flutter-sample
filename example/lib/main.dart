import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onemoney_sdk/onemoney_sdk.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney/onemoney.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await OnemoneySdk.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('One-Money example app'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion\n'),
              SizedBox(
                height: 10,
              ),
              Builder(
                builder: (cont) => TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                  onPressed: () {
                    Onemoney().init(
                      appIdentifier: '[]',
                      //  baseUrl: 'https://api-sandbox.onemoney.in/',
                      baseUrl: 'api-sandbox.onemoney.in',
                      clientId:
                          'fp_test_d4c1ccc11767f14695349f360f915adcdbda16c1',
                      clientSecret:
                          'f8d0841160d7781e4ecf33f74070677a0b8870e94a6ecf31533a9409415eef87895d9459',
                      organisationId: 'AWE0258',
                      vua: "9561855723",
                      consentId: "0f80e937-cae7-4ce7-8071-d386bd894f61",
                      isOTPAuth: true,
                    );

                    OnemoneySdk.openOneMoneySDK(buildContext: cont);
                  },
                  child: Text('Open one-money SDK'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
