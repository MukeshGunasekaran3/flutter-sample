import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/model/Repsonse.dart';
import 'package:onemoney_sdk/ui/verify_mobile.dart';
import 'package:onemoney_sdk/utils/app_dialogs.dart';

class LoginBloc extends Bloc {
  late StreamController<Response<String>> _loginStreamController;
  late bool _isStreaming;

  StreamSink<Response<String>> get loginDataSink => _loginStreamController.sink;

  Stream<Response<String>> get loginDataStream => _loginStreamController.stream;

  LoginBloc() : super() {
    _loginStreamController = StreamController<Response<String>>();
    _isStreaming = true;
  }

  dispose() {
    _isStreaming = false;
    _loginStreamController.close();
  }

  loginUser({required String mobileNumber, required BuildContext context, required Function(String status) completion}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    loginDataSink.add(Response.loading("in Progress"));
    try {
      dynamic status;

      await onemoney.loginUser(
          mobileNo: mobileNumber,
          onSuccess: (value) async {
            //OTP Reference
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        if (status is String) {
          loginDataSink.add(Response.completed(status.toString()));
          completion(status.toString());
        } else {
          if (status is OnemoneyError) {
            loginDataSink.add(Response.error(status.errorMessage));
          } else {
            loginDataSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) loginDataSink.add(Response.error(e.toString()));
    }
  }
}
