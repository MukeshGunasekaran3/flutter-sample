import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/ui/account_linking_bottom_sheet.dart';
import 'package:onemoney_sdk/ui/account_linking_screen.dart';
import 'package:onemoney_sdk/ui/consent_details_screen.dart';
import 'package:onemoney_sdk/ui/link_account_screen.dart';
import 'package:onemoney_sdk/ui/success_link_bottom_sheet.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/Loader.dart';
import 'package:onemoney_sdk/utils/app_dialogs.dart';

class DiscoverAccounts extends Bloc {
  late StreamController<Response<dynamic>> _discoverAccountStreamController;
  late StreamController<bool> _discoverAccountStreamLoadingController;
  late bool _isStreaming;

  StreamSink<Response<dynamic>> get disAccountSink => _discoverAccountStreamController.sink;
  StreamSink<bool> get disAccountLoadingSink => _discoverAccountStreamLoadingController.sink;

  Stream<Response<dynamic>> get disAccountStream => _discoverAccountStreamController.stream;
  Stream<bool> get disAccountLoadingStream => _discoverAccountStreamLoadingController.stream;

  DiscoverAccounts() : super() {
    _discoverAccountStreamController = StreamController<Response<dynamic>>();
    _discoverAccountStreamLoadingController = StreamController<bool>();
    _isStreaming = true;
  }

  dispose() {
    _isStreaming = false;
    _discoverAccountStreamController.close();
    _discoverAccountStreamLoadingController.close();
  }

  Future<dynamic> getFipListOtherMethod(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    try {
      dynamic status;

      await onemoney.getFipList(onSuccess: (value) async {
        status = value;
        masterFipList.value = value;
      }, onFailure: (value) async {
        status = value;
      });

      if (status is FipList) {
        return status;
      } else {
        if (status is OnemoneyError) {
          Fluttertoast.showToast(
            msg: status.errorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text(status.errorMessage),
          //   backgroundColor: Colors.redAccent,
          // ));
        } else {
          Fluttertoast.showToast(
            msg: "something wrong",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text("something wrong"),
          //   backgroundColor: Colors.redAccent,
          // ));
          // disAccountSink.add(Response.error("something wrong"));
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(e.toString()),
      //   backgroundColor: Colors.redAccent,
      // ));
    }
  }

  //get all Fip
  getFipList(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    disAccountSink.add(Response.loading("in Progress"));
    try {
      dynamic status;

      Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
      await onemoney.getFipList(onSuccess: (value) async {
        status = value;
        masterFipList.value = value;
        Loader.hideProgressDialog();
      }, onFailure: (value) async {
        status = value;
        Loader.hideProgressDialog();
      });

      if (_isStreaming) {
        if (status is FipList) {
          disAccountSink.add(Response.completed(status));
        } else {
          if (status is OnemoneyError) {
            disAccountSink.add(Response.error(status.errorMessage));
          } else {
            disAccountSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) disAccountSink.add(Response.error(e.toString()));
    }
  }

  Future<dynamic> getLinkedAccountsOtherMethod(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    Future.delayed(Duration.zero, () {
      Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
    });
    try {
      dynamic status;
      await onemoney.getLinkedAccounts(onSuccess: (value) async {
        status = value;
      }, onFailure: (value) async {
        status = value;
      });
      Loader.hideProgressDialog();
      if (status is List<Account>) {
        return status;
      } else {
        if (status is OnemoneyError) {
          Fluttertoast.showToast(
            msg: status.errorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text(status.errorMessage),
          //   backgroundColor: Colors.redAccent,
          // ));
        } else {
          Fluttertoast.showToast(
            msg: "something wrong",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text("something wrong"),
          //   backgroundColor: Colors.redAccent,
          // ));
          // disAccountSink.add(Response.error("something wrong"));
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(e.toString()),
      //   backgroundColor: Colors.redAccent,
      // ));
    }
  }

  //get all linked accounts
  getLinkedAccounts(context, Function(List<Account> status) completion) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    disAccountSink.add(Response.loading("in Progress"));
    Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
    try {
      dynamic status;

      await onemoney.getLinkedAccounts(onSuccess: (value) async {
        status = value;
      }, onFailure: (value) async {
        status = value;
      });

      if (_isStreaming) {
        Loader.hideProgressDialog();
        if (status is List<Account>) {
          completion((status as List<Account>));

          disAccountSink.add(Response.completed(status.toString()));
        } else {
          if (status is OnemoneyError) {
            disAccountSink.add(Response.error(status.errorMessage));

            AppDialogs.showErrorWithRetry(context, status.errorMessage, (BuildContext context) {
              Future.delayed(Duration.zero, () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LinkAccountScreen(),
                  ),
                );
              });
            });
          } else {
            disAccountSink.add(Response.error("something wrong"));

            AppDialogs.showErrorWithRetry(context, "something wrong", (BuildContext context) {
              Future.delayed(Duration.zero, () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LinkAccountScreen(),
                  ),
                );
              });
            });
          }
        }
      }
    } catch (e) {
      if (_isStreaming) {
        disAccountSink.add(Response.error(e.toString()));

        AppDialogs.showErrorWithRetry(context, e.toString(), (BuildContext context) {
          Future.delayed(Duration.zero, () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LinkAccountScreen(),
            ));
          });
        });
      }
    }
  }

  discoverAccounts({required List<InputIdentifier>? inputIdentifier, required String? fipID, required BuildContext context}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    disAccountSink.add(Response.loading("in Progress"));
    Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
    try {
      dynamic status;

      await onemoney.discoverAccounts(
          identifiers: inputIdentifier,
          fipId: fipID,
          onSuccess: (value) async {
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        Loader.hideProgressDialog();
        if (status is List<Account>) {
          disAccountSink.add(Response.completed(status));
        } else {
          if (status is OnemoneyError) {
            disAccountSink.add(Response.error(status.errorMessage));
          } else {
            disAccountSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) disAccountSink.add(Response.error(e.toString()));
    }
  }

  sendOTPToLinkAccount(
      {required Account? account,
      required BuildContext context,
      required GlobalKey<ScaffoldState> scaffoldKey,
      required Function afterSuccessFullLined,
      required Function(AuthSessionParameters status) completion}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    // disAccountSink.add(Response.loading("in Progress"));
    disAccountLoadingSink.add(true);
    try {
      dynamic status;

      await onemoney.sendOtpToLinkAccount(
          account: account,
          onSuccess: (value) async {
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        if (status is AuthSessionParameters) {
          disAccountLoadingSink.add(false);
          // disAccountSink.add(Response.completed(status));
          completion(status);
        } else {
          if (status is OnemoneyError) {
            disAccountLoadingSink.add(false);
            disAccountSink.add(Response.error(status.errorMessage));
          } else {
            disAccountLoadingSink.add(false);
            disAccountSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      disAccountLoadingSink.add(false);
      if (_isStreaming) disAccountSink.add(Response.error(e.toString()));
    }
  }

  sendOTPToBilkLinkAccount({required List<Account>? accounts, required BuildContext context, required Function(AuthSessionParameters status) completion}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    // disAccountSink.add(Response.loading("in Progress"));
    Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
    disAccountLoadingSink.add(true);
    try {
      dynamic status;

      await onemoney.sendOtpToBulkLinkAccount(
          accounts: accounts,
          onSuccess: (value) async {
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        Loader.hideProgressDialog();
        if (status is AuthSessionParameters) {
          disAccountLoadingSink.add(false);
          // disAccountSink.add(Response.completed(status));
          completion(status);
        } else {
          if (status is OnemoneyError) {
            disAccountLoadingSink.add(false);
            disAccountSink.add(Response.error(status.errorMessage));
          } else {
            disAccountLoadingSink.add(false);
            disAccountSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      Loader.hideProgressDialog();
      disAccountLoadingSink.add(false);
      if (_isStreaming) disAccountSink.add(Response.error(e.toString()));
    }
  }

  verifyOTPToLinkAccount({required String? referenceNumber, required String? authToken, required BuildContext context}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    disAccountLoadingSink.add(true);
    Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
    try {
      dynamic status;

      await onemoney.verifyOtpToLinkAccount(
          referenceNumber: referenceNumber,
          authToken: authToken,
          onSuccess: (value) async {
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        Loader.hideProgressDialog();
        if (status is bool) {
          // disAccountSink.add(Response.completed(status.toString()));
          disAccountLoadingSink.add(false);
          if (status) {
            await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                builder: (context) {
                  return AccountLinkSccBottomSheet();
                });
            // afterSuccessFullLined();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ConsentDetailsScreen()));
          } else {
            Fluttertoast.showToast(
              msg: "Oops!! Otp verification failed ",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 14.0,
            );
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text("Oops!! Otp verification failed "),
            //   backgroundColor: Colors.redAccent,
            // ));
          }
          // Navigator.push(context, MaterialPageRoute(builder: (_) => LinkAccountScreen()));
        } else {
          if (status is OnemoneyError) {
            disAccountSink.add(Response.error(status.errorMessage));
          } else {
            disAccountSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      Loader.hideProgressDialog();
      if (_isStreaming) disAccountSink.add(Response.error(e.toString()));
    }
  }
}
