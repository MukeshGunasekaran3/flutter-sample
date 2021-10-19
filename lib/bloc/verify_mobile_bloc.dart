import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:onemoney_sdk/ui/consent_details_screen.dart';
import 'package:onemoney_sdk/ui/finatial_institution_screen.dart';
import 'package:onemoney_sdk/ui/login_screen.dart';
import 'package:onemoney_sdk/ui/one_money_id_screen.dart';
import 'package:onemoney_sdk/ui/signup_screen.dart';
import 'package:onemoney_sdk/utils/app_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/ui/link_account_screen.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/Loader.dart';

class MobileVerificationBloc extends Bloc {
  late StreamController<Response<String>> _verifyMobileController;
  late bool _isStreaming;

  StreamSink<Response<String>> get verifyMobileSink => _verifyMobileController.sink;

  Stream<Response<String>> get verifyMobileStream => _verifyMobileController.stream;

  MobileVerificationBloc() : super() {
    _verifyMobileController = StreamController<Response<String>>();
    _isStreaming = true;
  }

  dispose() {
    _isStreaming = false;
    _verifyMobileController.close();
  }

  verifyOtp({
    required String mobileNumber,
    required String otp,
    required String otpReference,
    required BuildContext context,
    required Function onFailure,
    required Function onSuccess,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    verifyMobileSink.add(Response.loading("in Progress"));
    try {
      dynamic status;
      Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);

      print("in verify otp inside ${status}");

      await onemoney.verifyOtpTologinUser(
          mobileNo: mobileNumber,
          otpReference: otpReference,
          otp: otp,
          onSuccess: (value) async {
            status = value;
            Loader.hideProgressDialog();
          },
          onFailure: (value) async {
            status = value;
            Loader.hideProgressDialog();
          });

      if (_isStreaming) {
        if (status is bool) {
          if (status) {
            onSuccess();
            // verifyMobileSink.add(Response.completed(status.toString()));
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString("registereNumber", mobileNumber);

            Navigator.pop(context);
            Navigator.pop(context);
            onemoney.sendSessionIdToParents();
            // Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);

            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LinkAccountScreen()));
            // getProfile(context: context);
          } else {
            verifyMobileSink.add(Response.error("something wrong"));
            // onFailure("something wrong");
            // AppDialogs.showErrorWithRetry(context, "something wrong", (BuildContext context) {});
          }
        } else {
          if (status is OnemoneyError) {
            verifyMobileSink.add(Response.error(status.errorMessage));
            onFailure(status.errorMessage);
            // AppDialogs.showErrorWithRetry(context, status.errorMessage, (BuildContext context) {});
          } else {
            verifyMobileSink.add(Response.error("something wrong"));
            // onFailure("something wrong");
            // AppDialogs.showErrorWithRetry(context, "something wrong", (BuildContext context) {});
          }
        }
      }
    } catch (e) {
      if (_isStreaming) verifyMobileSink.add(Response.error(e.toString()));
      // onFailure(e.toString());
      // if (_isStreaming) AppDialogs.showErrorWithRetry(context, "something wrong", (BuildContext context) {});
    }
  }

  verifyOtpForSignUp({
    required String mobileNumber,
    required String otp,
    required String otpReference,
    required BuildContext context,
    required Function onFailure,
    required Function onSuccess,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    verifyMobileSink.add(Response.loading("in Progress"));
    try {
      dynamic status;

      print("in verify otp inside ${status}");

      Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
      await onemoney.verifyOtpToSignUpUser(
          mobileNo: mobileNumber,
          otpReference: otpReference,
          otp: otp,
          onSuccess: (value) async {
            status = value;
            Loader.hideProgressDialog();
          },
          onFailure: (value) async {
            status = value;
            Loader.hideProgressDialog();
          });

      if (_isStreaming) {
        if (status is bool) {
          if (status) {
            onSuccess();
            // verifyMobileSink.add(Response.completed(status.toString()));
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString("registereNumber", mobileNumber);

            // Navigator.pop(context);
            // Navigator.pop(context);
            // onemoney.sendSessionIdToParents();

            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LinkAccountScreen()));
            getProfile(context: context);
          } else {
            verifyMobileSink.add(Response.error("something wrong"));
            // AppDialogs.showErrorWithRetry(context, "something wrong", (BuildContext context) {});
          }
        } else {
          if (status is OnemoneyError) {
            verifyMobileSink.add(Response.error(status.errorMessage));
            onFailure(status.errorMessage);
            // AppDialogs.showErrorWithRetry(context, status.errorMessage, (BuildContext context) {});
          } else {
            verifyMobileSink.add(Response.error("something wrong"));
            // AppDialogs.showErrorWithRetry(context, "something wrong", (BuildContext context) {});
          }
        }
      }
    } catch (e) {
      if (_isStreaming) verifyMobileSink.add(Response.error(e.toString()));
    }
  }

  getProfile({required BuildContext context}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    verifyMobileSink.add(Response.loading("in Progress"));
    try {
      dynamic status;
      Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);

      print("in getProfile inside ${status}");

      await onemoney.getUserProfile(
        onSuccess: (value) async {
          status = value;
          Loader.hideProgressDialog();
        },
        onFailure: (value) async {
          status = value;
          Loader.hideProgressDialog();
        },
      );

      if (_isStreaming) {
        if (status is ProfileData) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("userInfo", jsonEncode((status as ProfileData).userData?.toJson()));
          userInfo.value = (status as ProfileData).userData ?? UserData();

          // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OneMoneyIDScreen()));
          if (onemoney.isafterSignUp ?? false) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => FinancialInstitutionScreen()));
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ConsentDetailsScreen()));
          }
        } else {
          if (status is OnemoneyError) {
            verifyMobileSink.add(Response.error(status.errorMessage));
          } else {
            verifyMobileSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) verifyMobileSink.add(Response.error(e.toString()));
    }
  }

  verifyVua({
    required String vua,
    required BuildContext context,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    verifyMobileSink.add(Response.loading("in Progress"));
    try {
      dynamic status;

      Loader.showFullScreenLoader(context);
      await onemoney.verifyVUA(
          mobileNo: vua,
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
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
            // getConsentId(context: context, vua: mobileNumber);
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => SignUpScreen(
                      vua: vua,
                    )));
          }
        } else {
          if (status is OnemoneyError) {
            verifyMobileSink.add(Response.error(status.errorMessage));
          } else {
            verifyMobileSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) verifyMobileSink.add(Response.error(e.toString()));
    }
  }

  getConsentId({required BuildContext context, required String vua, required String mobileNumber}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    verifyMobileSink.add(Response.loading("in Progress"));
    try {
      dynamic status;
      Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);

      print("in getConsentId inside ${status}");

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // var mobileNumber = prefs.getString("registereNumber");

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
          Loader.hideProgressDialog();
        },
        onFailure: (value) async {
          status = value;
          Loader.hideProgressDialog();
        },
      );

      if (_isStreaming) {
        if (status is ConsentHandleData) {
          onemoney.consentId = (status as ConsentHandleData).consentHandle;
          print("##C-id" + onemoney.consentId.toString());
          log((status as ConsentHandleData).consentHandle);
          verifyVua(vua: "$vua", context: context);
          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
          // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ConsentDetailsScreen()));
          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ConsentDetailsScreen()));
        } else {
          if (status is OnemoneyError) {
            verifyMobileSink.add(Response.error(status.errorMessage));
          } else {
            verifyMobileSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) verifyMobileSink.add(Response.error(e.toString()));
    }
  }
}
