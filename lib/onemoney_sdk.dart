import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/ui/consent_details_screen.dart';
import 'package:onemoney_sdk/ui/login_screen.dart';
import 'package:onemoney_sdk/ui/signup_screen.dart';
import 'package:onemoney_sdk/ui/splash_screen.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/Loader.dart';
import 'package:onemoney_sdk/utils/app_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnemoneySdk {
  static const MethodChannel _channel = const MethodChannel('onemoney_sdk');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static openOneMoneySDK({required BuildContext buildContext, String? consentIdInit}) {
    Onemoney onemoney = Onemoney();

    getProfile({required BuildContext context}) async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
        AppDialogs.showError(context, "No internet connection");
        return;
      }
      // verifyMobileSink.add(Response.loading("in Progress"));
      try {
        dynamic status;
        Loader.showFullScreenLoader(context);

        print("in getProfile inside ${status}");

        await onemoney.getUserProfile(
          onSuccess: (value) async {
            status = value;
          },
          onFailure: (value) async {
            status = value;
          },
        );
        Loader.hideProgressDialog();
        if (status is ProfileData) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("userInfo", jsonEncode((status as ProfileData).userData?.toJson()));
          userInfo.value = (status as ProfileData).userData ?? UserData();
          print("onemoney.consentId");
          print(onemoney.consentId);
          // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OneMoneyIDScreen()));
          Navigator.push(context, MaterialPageRoute(builder: (_) => ConsentDetailsScreen()));
        } else {
          if (status is OnemoneyError) {
            print("#Error :" + status.errorMessage.toString());
            // verifyMobileSink.add(Response.error(status.errorMessage));
          } else {
            print("#Error :" + "something wrong");
            // verifyMobileSink.add(Response.error("something wrong"));
          }
          // }
        }
      } catch (e) {
        print("#Error :" + e.toString());
        // if (_isStreaming) verifyMobileSink.add(Response.error(e.toString()));
      }
    }

    onemoney.consentId = consentIdInit;

    verifyVua({required String vua, required BuildContext context}) async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
        AppDialogs.showError(context, "No internet connection");
        return;
      }
      // verifyMobileSink.add(Response.loading("in Progress"));
      try {
        dynamic status;

        Loader.showFullScreenLoader(context);
        await onemoney.verifyVUA(
            mobileNo: vua,
            onSuccess: (value) async {
              //OTP Reference
              status = value;
            },
            onFailure: (value) async {
              status = value;
              // Loader.hideProgressDialog();
            });
        Loader.hideProgressDialog();
        if (status is bool) {
          // verifyVuaSink.add(Response.completed(status.toString()));
          if (status == true) {
            onemoney.isafterSignUp = false;
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
          } else {
            onemoney.isafterSignUp = true;
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignUpScreen(vua: vua)));
          }
        } else {
          if (status is OnemoneyError) {
            print("#Error :" + status.errorMessage.toString());
            // verifyMobileSink.add(Response.error(status.errorMessage));
          } else {
            print("#Error :" + "something wrong");
            // verifyMobileSink.add(Response.error("something wrong"));
          }
          // }
        }
      } catch (e) {
        print("#Error :" + e.toString());
        // if (_isStreaming) verifyMobileSink.add(Response.error(e.toString()));
      }
    }

    if (onemoney.sessionid != null && onemoney.sessionid != "" && onemoney.consentId != null && onemoney.consentId != "") {
      onemoney.isafterSignUp = false;
      getProfile(context: globalKey.currentState?.overlay?.context ?? buildContext);
    } else {
      verifyVua(context: globalKey.currentState?.overlay?.context ?? buildContext, vua: onemoney.vua!);
    }
  }
}
