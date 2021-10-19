import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/ui/approve_consent.dart';
import 'package:onemoney_sdk/ui/consent_request_success.dart';
import 'package:onemoney_sdk/ui/link_account_screen.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/Loader.dart';
import 'package:onemoney_sdk/utils/app_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsetDetailsBloc extends Bloc {
  late StreamController<Response<dynamic>> _consentDetailsController;
  late StreamController<Response<dynamic>> _approveConsetController;
  late StreamController<Response<dynamic>> _rejectConsetController;
  late StreamController<Response<dynamic>> _sendOtpToUpdateController;
  late bool _isStreaming;

  StreamSink<Response<dynamic>> get consentDetailsSink => _consentDetailsController.sink;

  Stream<Response<dynamic>> get consentDetailsStream => _consentDetailsController.stream;

  StreamSink<Response<dynamic>> get approveConsetSink => _approveConsetController.sink;

  Stream<Response<dynamic>> get approveConsetStream => _approveConsetController.stream;

  StreamSink<Response<dynamic>> get rejectConsetSink => _rejectConsetController.sink;

  Stream<Response<dynamic>> get rejectConsetStream => _rejectConsetController.stream;

  StreamSink<Response<dynamic>> get sendOtpToUpdateConsentSink => _sendOtpToUpdateController.sink;

  Stream<Response<dynamic>> get sendOtpToUpdateConsentStream => _sendOtpToUpdateController.stream;

  ConsetDetailsBloc() : super() {
    _consentDetailsController = StreamController<Response<dynamic>>();
    _approveConsetController = StreamController<Response<dynamic>>();
    _rejectConsetController = StreamController<Response<dynamic>>();
    _sendOtpToUpdateController = StreamController<Response<dynamic>>();
    _isStreaming = true;
  }

  dispose() {
    _isStreaming = false;
    _consentDetailsController.close();
    _approveConsetController.close();
    _rejectConsetController.close();
    _sendOtpToUpdateController.close();
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
      print("in getFipListOtherMethod inside");
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
          //         content: Text(status.errorMessage),
          //         backgroundColor: Colors.redAccent,
          //       ));
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

  Future<dynamic> getUserDashboardOtherMethod(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    consentDetailsSink.add(Response.loading("in Progress"));
    try {
      dynamic status;

      await onemoney.getUserDashboard(onSuccess: (value) async {
        status = value;
      }, onFailure: (value) async {
        status = value;
      });

      if (status is DashboardData) {
        return status;
      } else {
        if (status is OnemoneyError) {
          // AppDialogs.showErrorWithRetry(context, status.errorMessage, () {
          //   this.getUserDashboardOtherMethod(context);
          // });
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

  getUserDashboard(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    consentDetailsSink.add(Response.loading("in Progress"));
    try {
      dynamic status;

      await onemoney.getUserDashboard(onSuccess: (value) async {
        status = value;
      }, onFailure: (value) async {
        status = value;
      });

      if (_isStreaming) {
        if (status is DashboardData) {
          consentDetailsSink.add(Response.completed(status));
        } else {
          if (status is OnemoneyError) {
            consentDetailsSink.add(Response.error(status.errorMessage));
          } else {
            consentDetailsSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) consentDetailsSink.add(Response.error(e.toString()));
    }
  }

  getConsentDetails({required List<String>? consentHandles, required BuildContext context}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    consentDetailsSink.add(Response.loading("in Progress"));
    try {
      dynamic status;

      await onemoney.getConsentDetails(
          consentHandles: consentHandles,
          onSuccess: (value) async {
            //OTP Reference
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        if (status is List<ConsentDetails>) {
          consentDetailsSink.add(Response.completed(status));
        } else {
          if (status is OnemoneyError) {
            consentDetailsSink.add(Response.error(status.errorMessage));
          } else {
            consentDetailsSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) consentDetailsSink.add(Response.error(e.toString()));
    }
  }

  getConsentDetailsSingleWithoutConsentHandle({required Function completion, required BuildContext context}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    consentDetailsSink.add(Response.loading("in Progress"));
    try {
      dynamic status;
      Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
      await onemoney.getConsentDetailsSingleWithoutConsentHandle(
        onSuccess: (value) async {
          //OTP Reference
          Loader.hideProgressDialog();
          status = value;
        },
        onFailure: (value) async {
          Loader.hideProgressDialog();
          status = value;
        },
      );

      if (_isStreaming) {
        if (status is Consent) {
          consentDetailsSink.add(Response.completed(status));
          completion(status);
        } else {
          if (status is OnemoneyError) {
            consentDetailsSink.add(Response.error(status.errorMessage));
            consentDetailsSink.add(Response.completed(Consent()));
          } else {
            consentDetailsSink.add(Response.completed(Consent()));
            consentDetailsSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      consentDetailsSink.add(Response.completed(Consent()));
      if (_isStreaming) consentDetailsSink.add(Response.error(e.toString()));
    }
  }

  getConsentDetailsSingle({required String consentHandle, required Function completion, required BuildContext context}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    consentDetailsSink.add(Response.loading("in Progress"));
    try {
      dynamic status;
      Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
      await onemoney.getConsentDetailsBySingle(
          consentHandle: consentHandle,
          onSuccess: (value) async {
            //OTP Reference
            Loader.hideProgressDialog();
            status = value;
          },
          onFailure: (value) async {
            Loader.hideProgressDialog();
            status = value;
          });

      if (_isStreaming) {
        if (status is Consent) {
          consentDetailsSink.add(Response.completed(status));
          completion(status);
        } else {
          if (status is OnemoneyError) {
            consentDetailsSink.add(Response.error(status.errorMessage));
          } else {
            consentDetailsSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) consentDetailsSink.add(Response.error(e.toString()));
    }
  }

  //get all linked accounts
  getLinkedAccounts(context, Function(List<Account> status) completion) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
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

          // disAccountSink.add(Response.completed(status.toString()));
        } else {
          if (status is OnemoneyError) {
            // disAccountSink.add(Response.error(status.errorMessage));

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
            // disAccountSink.add(Response.error("something wrong"));

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
        // disAccountSink.add(Response.error(e.toString()));

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

  approveConsent({
    required BuildContext context,
    required String consentHandles,
    required String otp,
    required List<Account>? accounts,
    required Function onFailure,
    required Function onSuccess,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    print("-=-=-==-=-=-=-=-=-=-=-=-=->");
    print(consentHandles);
    print(otp);
    print(accounts);
    if (accounts?.isEmpty ?? false) {
      approveConsetSink.add(Response.error("Make sure at least one account is selected"));
      return;
    }
    approveConsetSink.add(Response.loading("in Progress"));
    Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
    try {
      dynamic status;

      await onemoney.approveConsent(
          consentHandle: consentHandles,
          otp: otp,
          accounts: accounts,
          onSuccess: (value) async {
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        Loader.hideProgressDialog();
        if (status is bool) {
          if (status) {
            approveConsetSink.add(Response.completed(status.toString()));
            onSuccess();
            Future.delayed(Duration(milliseconds: 500), () async {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ConsentRequestScreen(
                    description: 'Consent Request Approved Successfully',
                    approveConsentStatus: true,
                  ),
                ),
              );
            });
          } else {
            // Navigator.pop(context);
            approveConsetSink.add(Response.error("make sure your OTP is correct"));
            onFailure("Make sure your OTP is correct");
          }
        } else {
          if (status is OnemoneyError) {
            approveConsetSink.add(Response.error(status.errorMessage));
            onFailure(status.errorMessage);
          } else {
            approveConsetSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) approveConsetSink.add(Response.error(e.toString()));
    }
  }

  approveConsentWithoutAuth({required BuildContext context, required String consentHandles, required List<Account>? accounts}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    print("-=-=-==-=-=-=-=-=-=-=-=-=->");
    print(consentHandles);
    print(accounts);

    sendOtpToUpdateConsentSink.add(Response.loading("in Progress"));
    Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
    try {
      dynamic status;

      await onemoney.approveConsentWithOutAuth(
          consentHandle: consentHandles,
          accounts: accounts,
          onSuccess: (value) async {
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        Loader.hideProgressDialog();
        if (status is bool) {
          if (status) {
            sendOtpToUpdateConsentSink.add(Response.completed(status.toString()));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ConsentRequestScreen(
                  description: 'Consent Request Approved Successfully',
                  approveConsentStatus: true,
                ),
              ),
            );
          } else {
            sendOtpToUpdateConsentSink.add(Response.error("something wrong from back"));
          }
        } else {
          if (status is OnemoneyError) {
            sendOtpToUpdateConsentSink.add(Response.error(status.errorMessage));
          } else {
            sendOtpToUpdateConsentSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) sendOtpToUpdateConsentSink.add(Response.error(e.toString()));
    }
  }

  rejectConsent({
    required BuildContext context,
    required String consentHandles,
    required String otp,
    required Function onFailure,
    required Function onSuccess,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    print("-=-=-==-=-=-=-=-=-=-=-=-=->");
    print(consentHandles);
    print(otp);
    Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
    rejectConsetSink.add(Response.loading("in Progress"));
    try {
      dynamic status;

      await onemoney.rejectConsent(
          consentHandle: consentHandles,
          otp: otp,
          onSuccess: (value) async {
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        Loader.hideProgressDialog();
        if (status is bool) {
          if (status) {
            rejectConsetSink.add(Response.completed(status.toString()));
            onSuccess();
            Future.delayed(Duration(milliseconds: 500), () async {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ConsentRequestScreen(
                    description: 'Consent Request Rejected Successfully',
                    approveConsentStatus: false,
                  ),
                ),
              );
            });
          } else {
            rejectConsetSink.add(Response.error("Make sure your OTP is correct"));
            onFailure("Make sure your OTP is correct");
          }
        } else {
          if (status is OnemoneyError) {
            rejectConsetSink.add(Response.error(status.errorMessage));
            onFailure(status.errorMessage);
          } else {
            rejectConsetSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) rejectConsetSink.add(Response.error(e.toString()));
    }
  }

  rejectConsentWithoutAuth({required BuildContext context, required String consentHandles}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }
    print("-=-=-==-=-=-=-=-=-=-=-=-=->");
    print(consentHandles);
    Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
    sendOtpToUpdateConsentSink.add(Response.loading("in Progress"));
    try {
      dynamic status;

      await onemoney.rejectConsentWithOutAuth(
          consentHandle: consentHandles,
          onSuccess: (value) async {
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        Loader.hideProgressDialog();
        if (status is bool) {
          if (status) {
            sendOtpToUpdateConsentSink.add(Response.completed(status.toString()));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ConsentRequestScreen(
                  description: 'Consent Request Rejected Successfully',
                  approveConsentStatus: false,
                ),
              ),
            );
          } else {
            sendOtpToUpdateConsentSink.add(Response.error("something wrong from back"));
          }
        } else {
          if (status is OnemoneyError) {
            sendOtpToUpdateConsentSink.add(Response.error(status.errorMessage));
          } else {
            sendOtpToUpdateConsentSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) sendOtpToUpdateConsentSink.add(Response.error(e.toString()));
    }
  }

  sendOtpForUpdateConsent({required BuildContext context, required String consentHandle, required List<Account>? account, required bool isApprove}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }

    sendOtpToUpdateConsentSink.add(Response.loading("in Progress"));
    Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mobileNumber = prefs.getString("registereNumber");
    try {
      dynamic status;

      await onemoney.sendOtpToUpdateConsent(
          actionType: "CONSENT_CONFIRMED",
          identifierValue: mobileNumber,
          identifierType: "MOBILE",
          onSuccess: (value) async {
            //OTP Reference
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        Loader.hideProgressDialog();
        if (status is bool) {
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
                  return ApproveConsentBottomSheet(
                    consentHandle: consentHandle,
                    account: account,
                    isApprove: isApprove,
                    onResend: () {
                      reSendOtpForUpdateConsent(
                        context: context,
                        consentHandle: consentHandle,
                        account: account,
                        isApprove: isApprove,
                      );
                    },
                  );
                });
            // afterSuccessFullLined();
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
          sendOtpToUpdateConsentSink.add(Response.completed(status.toString()));
        } else {
          if (status is OnemoneyError) {
            sendOtpToUpdateConsentSink.add(Response.error(status.errorMessage));
          } else {
            sendOtpToUpdateConsentSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) sendOtpToUpdateConsentSink.add(Response.error(e.toString()));
    }
  }

  reSendOtpForUpdateConsent({required BuildContext context, required String consentHandle, required List<Account>? account, required bool isApprove}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      AppDialogs.showError(context, "No internet connection");
      return;
    }

    sendOtpToUpdateConsentSink.add(Response.loading("in Progress"));
    Loader.showFullScreenLoader(globalKey.currentState!.overlay!.context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mobileNumber = prefs.getString("registereNumber");
    try {
      dynamic status;

      await onemoney.sendOtpToUpdateConsent(
          actionType: "CONSENT_CONFIRMED",
          identifierValue: mobileNumber,
          identifierType: "MOBILE",
          onSuccess: (value) async {
            //OTP Reference
            status = value;
          },
          onFailure: (value) async {
            status = value;
          });

      if (_isStreaming) {
        Loader.hideProgressDialog();
        if (status is bool) {
          if (status) {
            // afterSuccessFullLined();
            Fluttertoast.showToast(
              msg: "Otp sent on ${mobileNumber}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 14.0,
            );
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
          sendOtpToUpdateConsentSink.add(Response.completed(status.toString()));
        } else {
          if (status is OnemoneyError) {
            sendOtpToUpdateConsentSink.add(Response.error(status.errorMessage));
          } else {
            sendOtpToUpdateConsentSink.add(Response.error("something wrong"));
          }
        }
      }
    } catch (e) {
      if (_isStreaming) sendOtpToUpdateConsentSink.add(Response.error(e.toString()));
    }
  }
}
