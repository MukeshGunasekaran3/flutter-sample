import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onemoney_sdk/bloc/login_bloc.dart';
import 'package:onemoney_sdk/bloc/signup_bloc.dart';
import 'package:onemoney_sdk/bloc/verify_mobile_bloc.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/ui/link_account_screen.dart';
import 'package:onemoney_sdk/ui/success_account_screen.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/Loader.dart';
import 'package:onemoney_sdk/utils/app_sizes.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'custom_button.dart';

class VerifyMobileScreen extends StatefulWidget {
  String otpReference;
  final String mobileNumber;
  final String? nameString;
  final String? vuaString;
  final bool isFromSignUp;

  VerifyMobileScreen({required this.otpReference, required this.mobileNumber, required this.isFromSignUp, this.nameString, this.vuaString});

  @override
  _VerifyMobileScreenState createState() => _VerifyMobileScreenState();
}

class _VerifyMobileScreenState extends State<VerifyMobileScreen> {
  final _otpController = TextEditingController();

  MobileVerificationBloc? _bloc;
  LoginBloc? _blocLogin;
  SignUpBloc? _blocSignup;
  @override
  void initState() {
    super.initState();
    _bloc = MobileVerificationBloc();
    _blocLogin = LoginBloc();
    _blocSignup = SignUpBloc();
  }

  @override
  void dispose() {
    _bloc!.dispose();
    _blocLogin!.dispose();
    _blocSignup!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            body: SingleChildScrollView(
          child: StreamBuilder<Response<String>>(
              stream: _bloc!.verifyMobileStream,
              builder: (conte, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      isLoading = true;
                      print(snapshot.data!.message);
                      break;

                    case Status.COMPLETED:
                      isLoading = false;
                      print(snapshot.data!.data);

                      // _gotoAccountLinkingScreen(conte);
                      //  goToNextScreen(conte);

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

                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        Image.asset(
                          Images.one_money_logo,
                          width: 180.w,
                          height: 90.h,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h, left: 18.w),
                          child: getRegularText(
                            'Verify Mobile Number',
                            fontsize: SizeConfig.TEXT_SIZE_HEADING,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h, left: 18.w, right: 18.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: getRegularText('The mobile number you have given us is:\n${widget.mobileNumber} you can edit your number', fontsize: 15.sp, fontcolor: Colors.grey),
                              ),
                              SizedBox(
                                height: 8.w,
                              ),
                              InkWell(
                                onTap: () {
                                  //
                                  Navigator.of(context).pop(context);
                                },
                                child: Image.asset(
                                  Images.edit,
                                  width: 18.w,
                                  height: 18.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60.h,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            Images.verify_number,
                            width: 300.w,
                            height: 240.h,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 40.h, left: 25.w, bottom: 10.h),
                          child: getRegularText('OTP', fontsize: 15.sp, fontcolor: Colors.grey),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                          child: PinCodeTextField(
                            appContext: context,
                            length: 6,
                            obscureText: true,
                            obscuringCharacter: '*',
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            controller: _otpController,
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderWidth: 0.9,
                                activeColor: ColorResources.COLOR_PRIMARY,
                                inactiveFillColor: ColorResources.TEXT_FIELD_BACKGROUND,
                                inactiveColor: ColorResources.TEXT_FIELD_BACKGROUND,
                                borderRadius: BorderRadius.circular(5),
                                fieldWidth: (MediaQuery.of(context).size.width - 36) / 6 > 55 ? 55.h : (MediaQuery.of(context).size.width - 36) / 6,
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
                              if (widget.isFromSignUp) {
                                _bloc!.verifyOtpForSignUp(mobileNumber: "${widget.mobileNumber}", otp: _otpController.text.toString(), otpReference: widget.otpReference, context: conte);
                              } else {
                                _bloc!.verifyOtp(mobileNumber: "${widget.mobileNumber}", otp: _otpController.text.toString(), otpReference: widget.otpReference, context: conte);
                              }
                            },
                            onChanged: (value) {
                              print(value);
                              // setState(() {
                              //   //  currentText = value;
                              // });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
                          child: Column(
                            children: [
                              Align(
                                child: getRegularText("Didn't receive the code?", fontsize: 14.sp, fontcolor: Colors.grey),
                              ),
                              InkWell(
                                onTap: () {
                                  if (widget.isFromSignUp) {
                                    _blocSignup!.signupUser(
                                        name: widget.nameString ?? "",
                                        mobileNumber: "${widget.mobileNumber}",
                                        vua: widget.vuaString ?? "",
                                        context: context,
                                        completion: (status) {
                                          Fluttertoast.showToast(
                                            msg: "Otp sent on ${widget.mobileNumber}",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.black54,
                                            textColor: Colors.white,
                                            fontSize: 14.0,
                                          );
                                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          //   content: Text("Otp sent on ${widget.mobileNumber}"),
                                          //   backgroundColor: Colors.redAccent,
                                          // ));
                                        });
                                  } else {
                                    _blocLogin!.loginUser(
                                        mobileNumber: "${widget.mobileNumber}",
                                        context: context,
                                        completion: (status) {
                                          widget.otpReference = status;
                                          Fluttertoast.showToast(
                                            msg: "Otp sent on ${widget.mobileNumber}",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.black54,
                                            textColor: Colors.white,
                                            fontSize: 14.0,
                                          );
                                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          //   content: Text("Otp sent on ${widget.mobileNumber}"),
                                          //   backgroundColor: Colors.redAccent,
                                          // ));
                                        });
                                  }
                                  // Navigator.of(context).push(
                                  //     MaterialPageRoute(builder: (BuildContext context) => OneMoneyIDScreen()));
                                },
                                child: Align(
                                  child: getRegularText("Resend Code", fontsize: 14.sp, fontcolor: ColorResources.COLOR_PRIMARY),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Visibility(
                    //   visible: false,
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: MediaQuery.of(context).size.height,
                    //     color: Colors.black45,
                    //     child: Center(
                    //       child: Container(
                    //         width: 40.w,
                    //         height: 40.h,
                    //         child: CircularProgressIndicator(
                    //           valueColor: AlwaysStoppedAnimation<Color>(
                    //               ColorResources.COLOR_PRIMARY),
                    //           strokeWidth: 4,
                    //           backgroundColor: Colors.transparent,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              }),
        )));
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

  goToNextScreen(BuildContext context1) {
    Future.delayed(Duration.zero, () async {
      if (widget.isFromSignUp) {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AccountCreatedScreen()));
      } else {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => LinkAccountScreen()), (route) => false);
      }
    });
  }
}
