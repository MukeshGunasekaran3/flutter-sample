import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/ui/verify_mobile.dart';
import 'package:onemoney_sdk/utils/app_dialogs.dart';

class SignUpBloc extends Bloc {
  late StreamController<Response<String>> _signupStreamController;
  late bool _isStreaming;

  StreamSink<Response<String>> get signUpSink => _signupStreamController.sink;

  Stream<Response<String>> get signUpStream => _signupStreamController.stream;

  SignUpBloc() : super() {
    _signupStreamController = StreamController<Response<String>>();
    _isStreaming = true;
  }

  dispose() {
    _isStreaming = false;
    _signupStreamController.close();
  }

  signupUser({required String name, required String mobileNumber, required String vua, required BuildContext context, required Function(String status) completion}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    signUpSink.add(Response.loading("in Progress"));
    try {
      dynamic status;

      await onemoney.signUpUser(
          name: name,
          mobileNo: mobileNumber,
          vua: vua + "@onemoney",
          termsAndConditions: true,
          onSuccess: (value) async {
            //OTP Reference
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        if (status is String) {
          signUpSink.add(Response.completed(status.toString()));
          completion(status.toString());
        } else {
          if (status is OnemoneyError) {
            signUpSink.add(Response.error(status.errorMessage));
          } else {
            signUpSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) signUpSink.add(Response.error(e.toString()));
    }
  }
}
