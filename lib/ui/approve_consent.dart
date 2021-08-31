import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/consent_details_bloc.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/ui/consent_request_success.dart';
import 'package:onemoney_sdk/utils/app_sizes.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'link_account_screen.dart';

class ApproveConsentBottomSheet extends StatefulWidget {
  final String consentHandle;
  final List<Account>? account;
  final bool isApprove;
  final Function onResend;

  const ApproveConsentBottomSheet({Key? key, required this.consentHandle, required this.account, required this.isApprove, required this.onResend}) : super(key: key);

  @override
  _ApproveConsentBottomSheetState createState() => _ApproveConsentBottomSheetState();
}

class _ApproveConsentBottomSheetState extends State<ApproveConsentBottomSheet> {
  final _otpController = TextEditingController();
  ConsetDetailsBloc? _bloc;

  bool hasError = false;
  String errorText = "";
  StreamController<ErrorAnimationType>? errorController;
  Color boxColor = ColorResources.COLOR_PRIMARY;

  @override
  void initState() {
    super.initState();

    errorController = StreamController<ErrorAnimationType>();
    _bloc = ConsetDetailsBloc();
  }

  @override
  void dispose() {
    // _otpController.dispose();

    errorController?.close();
    _bloc!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      height: 340.h + MediaQuery.of(context).viewInsets.bottom,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isApprove ? 'Approve Consent' : 'Reject Consent',
            style: popinsMedium.copyWith(color: Colors.black, fontSize: 19.sp),
          ),
          SizedBox(
            height: 50.h,
          ),
          Text('OTP', style: popinsRegular.copyWith(color: Colors.grey, fontSize: SizeConfig.TEXT_SIZE_MEDIUM)),
          SizedBox(
            height: 10.h,
          ),
          StreamBuilder<Response<dynamic>>(
              stream: widget.isApprove ? _bloc!.approveConsetStream : _bloc!.rejectConsetStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      isLoading = true;
                      print(snapshot.data!.message);

                      break;

                    case Status.COMPLETED:
                      isLoading = false;
                      print(snapshot.data!.data);

                      //go to final screen
                      // _gotoNextScreen(context);

                      break;

                    case Status.ERROR:
                      isLoading = false;
                      print(snapshot.data!.data.toString());
                      Future.delayed(Duration.zero, () {
                        _showErrorMessage(snapshot.data!.message.toString());
                      });

                      // WidgetsBinding.instance!.addPostFrameCallback(
                      //     (_) => _showErrorMessage(snapshot.data!.message.toString()));
                      break;
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderWidth: 0.9,
                        activeColor: boxColor, //hasError ? Colors.redAccent : ColorResources.COLOR_PRIMARY,
                        inactiveFillColor: ColorResources.TEXT_FIELD_BACKGROUND,
                        inactiveColor: ColorResources.TEXT_FIELD_BACKGROUND,
                        borderRadius: BorderRadius.circular(5),
                        fieldWidth: 50.w,
                        fieldHeight: 55.h,
                        activeFillColor: ColorResources.TEXT_FIELD_BACKGROUND,
                        selectedFillColor: ColorResources.TEXT_FIELD_BACKGROUND,
                        selectedColor: boxColor, //hasError ? Colors.redAccent : ColorResources.COLOR_PRIMARY
                      ),
                      cursorColor: Colors.grey,
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      //  errorAnimationController: errorController,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      onCompleted: (v) {
                        if (widget.isApprove) {
                          _bloc!.approveConsent(
                            context: context,
                            consentHandles: widget.consentHandle,
                            otp: _otpController.text.toString(),
                            accounts: widget.account,
                            onSuccess: () {
                              boxColor = Colors.green;
                              errorText = "";
                              setState(() {});
                            },
                            onFailure: (errorMessage) {
                              if (errorMessage == "invalid otp provided" || errorMessage == "Make sure your OTP is correct") {
                                errorController?.add(ErrorAnimationType.shake);
                                hasError = true;
                                boxColor = Colors.redAccent;
                                errorText = errorMessage;
                                setState(() {});
                              }
                            },
                          );
                        } else {
                          _bloc!.rejectConsent(
                            context: context,
                            consentHandles: widget.consentHandle,
                            otp: _otpController.text.toString(),
                            onSuccess: () {
                              boxColor = Colors.green;
                              errorText = "";
                              setState(() {});
                            },
                            onFailure: (errorMessage) {
                              if (errorMessage == "invalid otp provided" || errorMessage == "Make sure your OTP is correct") {
                                errorController?.add(ErrorAnimationType.shake);
                                hasError = true;
                                boxColor = Colors.redAccent;
                                errorText = errorMessage;
                                setState(() {});
                              }
                            },
                          );
                        }
                      },
                      onChanged: (value) {
                        print(value);
                        // setState(() {
                        //   //  currentText = value;
                        // });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text(
                        hasError ? errorText : "",
                        style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                );
              }),
          SizedBox(
            height: 40.h,
          ),
          Align(
            alignment: Alignment.center,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Didn't receive any code?\n",
                style: popinsRegular.copyWith(color: Colors.grey, fontSize: 14.sp),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Re-Send Code',
                      style: TextStyle(fontWeight: FontWeight.bold, color: ColorResources.COLOR_PRIMARY),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          widget.onResend();
                          debugPrint("on resend tap");
                        }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(message),
    //   backgroundColor: Colors.redAccent,
    // ));
  }

  _gotoNextScreen(BuildContext context1) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.pushReplacement(context1, MaterialPageRoute(builder: (_) => LinkAccountScreen()));
    });
  }
}

/*class ApproveConsentBottomSheet extends StatelessWidget {
  const ApproveConsentBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Approve Consent',
            style: popinsMedium.copyWith(color: Colors.black, fontSize: 19.sp),
          ),
          SizedBox(
            height: 50.h,
          ),
          Text('OTP',
              style: popinsRegular.copyWith(
                  color: Colors.grey, fontSize: SizeConfig.TEXT_SIZE_MEDIUM)),
          SizedBox(
            height: 10.h,
          ),
          PinCodeTextField(
            appContext: context,
            length: 6,
            obscureText: true,
            obscuringCharacter: '*',
            blinkWhenObscuring: true,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderWidth: 0.9,
                activeColor: ColorResources.COLOR_PRIMARY,
                inactiveFillColor: ColorResources.TEXT_FIELD_BACKGROUND,
                inactiveColor: ColorResources.TEXT_FIELD_BACKGROUND,
                borderRadius: BorderRadius.circular(5),
                fieldWidth: 50.w,
                fieldHeight: 55.h,
                activeFillColor: ColorResources.TEXT_FIELD_BACKGROUND,
                selectedFillColor: ColorResources.TEXT_FIELD_BACKGROUND,
                selectedColor: ColorResources.COLOR_PRIMARY),
            cursorColor: Colors.grey,
            animationDuration: Duration(milliseconds: 300),
            enableActiveFill: true,
            //  errorAnimationController: errorController,
            // controller: textEditingController,
            keyboardType: TextInputType.number,
            onCompleted: (v) {
              Navigator.of(context);
              showModalBottomSheet(
                context: context,
                enableDrag: false,
                isScrollControlled: true,
                isDismissible: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: ConsentRequestScreen(),
                  );
                },
              );
              //go to final screen
            },
            onChanged: (value) {
              print(value);
            },
          ),
          SizedBox(
            height: 40.h,
          ),
          Align(
            alignment: Alignment.center,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Didn't receive any code?\n",
                style:
                    popinsRegular.copyWith(color: Colors.grey, fontSize: 14.sp),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Re-Send Code',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorResources.COLOR_PRIMARY),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          debugPrint("on resend tap");
                        }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}*/
