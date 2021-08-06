import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/ui/login_screen.dart';
import 'package:onemoney_sdk/ui/signup_screen.dart';
import 'package:onemoney_sdk/utils/Loader.dart';
import 'package:onemoney_sdk/utils/app_dialogs.dart';

class VerifyVuaBloc extends Bloc {
  late StreamController<Response<String>> _verifyVuaStreamController;
  late bool _isStreaming;

  StreamSink<Response<String>> get verifyVuaSink =>
      _verifyVuaStreamController.sink;

  Stream<Response<String>> get signUpStream =>
      _verifyVuaStreamController.stream;

  VerifyVuaBloc() : super() {
    _verifyVuaStreamController = StreamController<Response<String>>();
    _isStreaming = true;
  }

  dispose() {
    _isStreaming = false;
    _verifyVuaStreamController.close();
  }

  verifyVua({
    required String mobileNumber,
    required BuildContext context,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    verifyVuaSink.add(Response.loading("in Progress"));
    try {
      dynamic status;

      Loader.showFullScreenLoader(context);
      await onemoney.verifyVUA(
          mobileNo: mobileNumber,
          onSuccess: (value) async {
            //OTP Reference
            status = value;
            Loader.hideProgressDialog();
          },
          onFailure: (value) async {
            status = value;
            Loader.hideProgressDialog();
          });

      if (_isStreaming) {
        if (status is bool) {
          // verifyVuaSink.add(Response.completed(status.toString()));
          if (status == true) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => SignUpScreen(
                      vua: mobileNumber,
                    )));
          }
        } else {
          if (status is OnemoneyError) {
            verifyVuaSink.add(Response.error(status.errorMessage));
          } else {
            verifyVuaSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) verifyVuaSink.add(Response.error(e.toString()));
    }
  }
}
