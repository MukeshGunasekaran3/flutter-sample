import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onemoney_sdk/bloc/login_bloc.dart';
import 'package:onemoney_sdk/model/Repsonse.dart';
import 'package:onemoney_sdk/ui/custom_button.dart';
import 'package:onemoney_sdk/ui/signup_screen.dart';
import 'package:onemoney_sdk/ui/verify_mobile.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/Loader.dart';
import 'package:onemoney_sdk/utils/app_dialogs.dart';
import 'package:onemoney_sdk/utils/app_sizes.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/screenutil_init.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/size_utils/string_utils.dart';
import 'package:onemoney_sdk/utils/styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileNumberController =
      TextEditingController(text: "9175403267"); //9561784130 //6354402202 // ajay 9404016890 //9930106886 //Aspril 9561855723 //8801281717
  final _pinController = TextEditingController();

  LoginBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LoginBloc();
    // _bloc!.loginDataStream.listen((snapshotData) {
    //   // Redirect to another view, given your condition
    //   if (snapshotData.status == Status.COMPLETED) {
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (BuildContext context) => VerifyMobileScreen(
    //           otpReference: snapshotData.data.toString(),
    //           mobileNumber: _mobileNumberController.text,
    //           isFromSignUp: false,
    //         ),
    //       ),
    //     );
    //     // Navigator.of(context).pushNamed("my-new-route");
    //   }
    // });
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _pinController.dispose();
    _bloc!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("In Build method");
    return SizeUtilInit(
        designSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
        builder: () => GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: SafeArea(
                    child: ListView(
                      // mainAxisSize: MainAxisSize.max,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        Align(
                          child: Image.asset(
                            Images.one_money_logo,
                            width: 180.w,
                            height: 90.h,
                          ),
                          alignment: Alignment.topLeft,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h, left: 18.w),
                          child: Text(
                            'Welcome Back!',
                            style: popinsBold.copyWith(
                              fontSize: SizeConfig.TEXT_SIZE_HEADING,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h, left: 18.w),
                          child: getRegularText('Onemoney is at your service! Please login to manage your consents and financial data.',
                              fontsize: SizeConfig.TEXT_SIZE_SUB_HEADING_, fontcolor: Colors.grey),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 5.h, left: 18.w),
                        //   child: RichText(
                        //     text: TextSpan(
                        //       text: 'Are you a new user? ',
                        //       style: popinsRegular.copyWith(color: Colors.grey, fontSize: SizeConfig.TEXT_SIZE_SMALL),
                        //       children: <TextSpan>[
                        //         TextSpan(
                        //             text: 'Sign Up',
                        //             style: TextStyle(fontWeight: FontWeight.bold, color: ColorResources.COLOR_PRIMARY),
                        //             recognizer: TapGestureRecognizer()
                        //               ..onTap = () {
                        //                 Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()));
                        //               }),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.only(top: 50.h, left: 18.w),
                          child: Text('Mobile Number', style: popinsRegular.copyWith(color: Colors.grey, fontSize: SizeConfig.TEXT_SIZE_MEDIUM)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                          child: TextField(
                            autocorrect: true,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            controller: _mobileNumberController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: ColorResources.TEXT_FIELD_BACKGROUND,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(color: Colors.transparent, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: ColorResources.COLOR_PRIMARY),
                              ),
                            ),
                          ),
                        ),

                        Visibility(
                          visible: false,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.h, left: 18.w),
                            child: Text('PIN', style: popinsRegular.copyWith(color: Colors.grey, fontSize: SizeConfig.TEXT_SIZE_MEDIUM)),
                          ),
                        ),

                        Visibility(
                          visible: false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                            child: PinCodeTextField(
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
                                _pinController.text = v.toString();
                              },
                              onChanged: (value) {
                                print(value);
                                _pinController.text = value.toString();
                              },
                            ),
                          ),
                        ),

                        Visibility(
                          visible: false,
                          child: Center(
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot PIN?',
                                textAlign: TextAlign.center,
                                style: popinsMedium.copyWith(fontSize: SizeConfig.TEXT_SIZE_SMALL, color: ColorResources.COLOR_PRIMARY),
                              ),
                            ),
                          ),
                        ),
                        //login button
                        Padding(
                          padding: EdgeInsets.only(bottom: 50.h),
                          child: Align(
                            child: StreamBuilder<Response<String>>(
                                stream: _bloc!.loginDataStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    // ignore: missing_enum_constant_in_switch
                                    switch (snapshot.data!.status) {
                                      case Status.LOADING:
                                        print(snapshot.data!.message);
                                        return Loader.showSimpleLoader(context);

                                      case Status.COMPLETED:
                                        //print(snapshot.data!.data.toString());
                                        // Future.delayed(Duration.zero, () {
                                        //   Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //       builder: (BuildContext context) => VerifyMobileScreen(
                                        //         otpReference: snapshot.data!.data.toString(),
                                        //         mobileNumber: _mobileNumberController.text,
                                        //         isFromSignUp: false,
                                        //       ),
                                        //     ),
                                        //   );
                                        // });

                                        break;

                                      case Status.ERROR:
                                        print(snapshot.data!.message);

                                        // if(snapshot.data!.message.toString()=="user not found"){
                                        //   AppDialogs.showSimpleDialog(context, snapshot.data!.message.toString(), "content");
                                        // }
                                        WidgetsBinding.instance!.addPostFrameCallback((_) => _showErrorMessage(snapshot.data!.message.toString()));

                                        break;
                                    }
                                  }

                                  return CustomButton(
                                    buttonText: "Get OTP",
                                    onTap: () {
                                      // if (_mobileNumberController.text.isEmpty) {
                                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //     content: Text('Please enter mobile number'),
                                      //     backgroundColor: Colors.redAccent,
                                      //   ));
                                      //   return;
                                      // } else if (_mobileNumberController.text.length < 10) {
                                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //     content: Text('Please enter valid mobile number'),
                                      //     backgroundColor: Colors.redAccent,
                                      //   ));
                                      //   return;
                                      // } else if (_pinController.text.isEmpty) {
                                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //     content: Text('Please enter PIN number'),
                                      //     backgroundColor: Colors.redAccent,
                                      //   ));
                                      //   return;
                                      // } else if (_pinController.text.length < 6) {
                                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //     content: Text('Please enter valid PIN number'),
                                      //     backgroundColor: Colors.redAccent,
                                      //   ));
                                      //   return;
                                      // }
                                      if (isStringEmpty(_mobileNumberController.text.trim())) {
                                        _showErrorMessage("Please enter mobile number.");
                                      } else if (validateMobile(_mobileNumberController.text.trim()) == false) {
                                        _showErrorMessage("Please enter valid mobile number.");
                                      } else {
                                        _bloc!.loginUser(
                                            mobileNumber: "${_mobileNumberController.text}",
                                            context: context,
                                            completion: (status) {
                                              pushToOtpScreens(status);
                                            });
                                      }

                                      // debugPrint("mobile number ${_mobileNumberController.text}");
                                      // debugPrint("mobile number ${_pinController.text}");
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(builder: (BuildContext context) => LinkAccountScreen()));
                                    },
                                    buttonWidth: 150.w,
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom,
                        )
                      ],
                    ),
                  )),
            ));
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

  pushToOtpScreens(String status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyMobileScreen(
          otpReference: status,
          mobileNumber: "${_mobileNumberController.text}",
          isFromSignUp: false,
        ),
      ),
    );
  }
}

class Error extends StatelessWidget {
  final String? errorMessage;

  final Function? onRetryPressed;

  const Error({Key? key, this.errorMessage, this.onRetryPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
