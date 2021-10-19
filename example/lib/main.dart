import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onemoney_sdk/onemoney_sdk.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/utils/Loader.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalKey,
      home: FirstPageTest(),
    );
  }
}

class FirstPageTest extends StatefulWidget {
  FirstPageTest({Key? key}) : super(key: key);

  @override
  _FirstPageTestState createState() => _FirstPageTestState();
}

class _FirstPageTestState extends State<FirstPageTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.blue),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SecondpageTest(),
            ));
          },
          child: Text('navigate in parent app'),
        ),
      ),
    );
  }
}

class SecondpageTest extends StatefulWidget {
  SecondpageTest({Key? key}) : super(key: key);

  @override
  _SecondpageTestState createState() => _SecondpageTestState();
}

class _SecondpageTestState extends State<SecondpageTest> {
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
      platformVersion = await OnemoneySdk.platformVersion ?? 'Unknown platform version';
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

  var sessionid;
  var objectData;
  var consentIdInit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.blue),
                onPressed: () {
                  var onemoney = Onemoney();
                  onemoney.init(
                    appIdentifier: '[]',
                    //  baseUrl: 'https://api-sandbox.onemoney.in/',
                    // baseUrl: 'api-sandbox.onemoney.in',
                    // clientId: 'fp_test_d4c1ccc11767f14695349f360f915adcdbda16c1',
                    // clientSecret: 'f8d0841160d7781e4ecf33f74070677a0b8870e94a6ecf31533a9409415eef87895d9459',
                    // organisationId: 'AWE0258',

                    baseUrl: 'api-sandbox.onemoney.in',
                    clientId: 'fp_test_9bc80583a87191ba4e1d538c90e54eaaf432e0b2',
                    clientSecret: 'd66ff9a2f5abb24849fdd624f95e5419dd3f735e0ed784c499b0f83079bf5219d5e8f3f2',
                    organisationId: 'ONE0194',
                    // vua: "9404016890",
                    // vua: "9561855723",
                    vua: "9175403267",
                    appName: "Universal fintech",
                    // consentId: "0e57466b-ee71-4bfd-b51f-1b19e8d675ab",
                    isOTPAuth: true,
                    onLoginSuccessCallback: (String sessionid) async {
                      print("sessionid");
                      print(sessionid);
                      setState(() {
                        this.sessionid = sessionid;
                      });
                      consentIdInit = await getConsentId(onemoney: onemoney, vua: "9175403267", mobileNumber: "9175403267");
                      OnemoneySdk.openOneMoneySDK(buildContext: cont, consentIdInit: consentIdInit);
                    },
                    onApproveRejectCallback: (objectData) {
                      print("onApproveRejectCallback");
                      print(objectData);
                      setState(() {
                        this.objectData = objectData;
                      });
                    },
                  );

                  OnemoneySdk.openOneMoneySDK(buildContext: cont);
                },
                child: Text('Open one-money SDK'),
              ),
            ),
            // if (sessionid != null)

            // Text("sessionId : ${sessionid}"),
            // SizedBox(height: 10),
            // Text("onApproveRejectCallback : ${objectData}"),
          ],
        ),
      ),
    );
  }

  Future<String?> getConsentId({required Onemoney onemoney, required String vua, required String mobileNumber}) async {
    //
    try {
      dynamic status;
      Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);

      await onemoney.requestConsent(
        requestConsent: Requestconsent(
          accountID: "chenna",
          partyIdentifierType: "MOBILE",
          partyIdentifierValue: "$mobileNumber",
          vua: "$vua@onemoney",
          productID: "CHENNA",
        ),
        onSuccess: (value) async {
          status = value;
        },
        onFailure: (value) async {
          status = value;
        },
      );
      Loader.hideProgressDialog();
      if (status is ConsentHandleData) {
        print("##C-id " + onemoney.consentId.toString());
        onemoney.consentId = (status as ConsentHandleData).consentHandle;
        print("##C-id " + onemoney.consentId.toString());

        return onemoney.consentId;
      } else {
        if (status is OnemoneyError) {
          print("#Error :" + status.errorMessage.toString());
          // verifyMobileSink.add(Response.error(status.errorMessage));
        } else {
          print("#Error :" + "something wrong");
          // verifyMobileSink.add(Response.error("something wrong"));
        }
      }
    } catch (e) {
      print("#Error :" + e.toString());
      // if (_isStreaming) verifyMobileSink.add(Response.error(e.toString()));
    }
  }
}
