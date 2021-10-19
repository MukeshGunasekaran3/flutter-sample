import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onemoney_sdk/bloc/signup_bloc.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/ui/login_screen.dart';
import 'package:onemoney_sdk/ui/verify_mobile.dart';
import 'package:onemoney_sdk/ui/custom_button.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/app_sizes.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/screenutil_init.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/size_utils/string_utils.dart';
import 'package:onemoney_sdk/utils/styles.dart';

class SignUpScreen extends StatefulWidget {
  final String? vua;

  SignUpScreen({
    this.vua,
  });
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _mobileNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _vuaController = TextEditingController();

  var isTermsSelected = false;

  SignUpBloc? _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => setState(() {
        _bloc = SignUpBloc();
        if (widget.vua != null) {
          _vuaController.text = widget.vua!;
          _mobileNumberController.text = widget.vua!;
        }
      }),
    );
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _nameController.dispose();
    _vuaController.dispose();
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeUtilInit(
        designSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
        builder: () => GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                  // resizeToAvoidBottomInset: false,
                  body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: getBoldText('Welcome!', fontsize: SizeConfig.TEXT_SIZE_HEADING),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.h, left: 18.w),
                        child: getRegularText(
                          'Onemoney is at your service! Please register with your Name and Phone Number below.',
                          fontsize: SizeConfig.TEXT_SIZE_SUB_HEADING_,
                          fontcolor: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 5.h, left: 18.w),
                      //   child: RichText(
                      //     text: TextSpan(
                      //       text: 'Already have an account ? ',
                      //       style: popinsRegular.copyWith(color: Colors.grey, fontSize: SizeConfig.TEXT_SIZE_SMALL),
                      //       children: <TextSpan>[
                      //         TextSpan(
                      //             text: 'Sign In',
                      //             style: TextStyle(fontWeight: FontWeight.bold, color: ColorResources.COLOR_PRIMARY),
                      //             recognizer: TapGestureRecognizer()
                      //               ..onTap = () {
                      //                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
                      //               }),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      Padding(
                        padding: EdgeInsets.only(top: 50.h, left: 18.w),
                        child: Text('Name', style: popinsRegular.copyWith(color: Colors.grey, fontSize: SizeConfig.TEXT_SIZE_MEDIUM)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                        child: TextField(
                          autocorrect: true,
                          controller: _nameController,
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
                      Padding(
                        padding: EdgeInsets.only(top: 20.h, left: 18.w),
                        child: getRegularText(
                          'Mobile Number',
                          fontcolor: Colors.grey,
                          fontsize: SizeConfig.TEXT_SIZE_MEDIUM,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                        child: TextField(
                          autocorrect: true,
                          keyboardType: TextInputType.phone,
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
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onChanged: (String text) {
                            _vuaController.text = text;
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 20.h, left: 18.w),
                        child: getRegularText(
                          'Recommended VUA',
                          fontcolor: Colors.grey,
                          fontsize: SizeConfig.TEXT_SIZE_MEDIUM,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextField(
                              autocorrect: true,
                              controller: _vuaController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorResources.TEXT_FIELD_BACKGROUND,
                                //hintText: "8830437601",
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
                            Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: getRegularText(
                                '@onemoney',
                                fontcolor: ColorResources.TEXT_FIELD_HINT,
                                fontsize: 14.sp,
                              ),
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 30.h, left: 18.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isTermsSelected = !isTermsSelected;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.h),
                                child: Icon(
                                  isTermsSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'I agree to Onemoney ',
                                style: popinsRegular.copyWith(color: Colors.grey, fontSize: SizeConfig.TEXT_SIZE_SMALL),
                                children: <TextSpan>[
                                  TextSpan(text: 'Terms and Conditions', style: popinsMedium.copyWith(fontSize: SizeConfig.TEXT_SIZE_SMALL, color: ColorResources.COLOR_PRIMARY)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      //login button
                      StreamBuilder<Response<String>>(
                          stream: _bloc?.signUpStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // ignore: missing_enum_constant_in_switch
                              switch (snapshot.data!.status) {
                                case Status.LOADING:
                                  print(snapshot.data!.message);
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 50.h),
                                    child: Center(
                                      child: Container(
                                        width: 40.w,
                                        height: 40.h,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(ColorResources.COLOR_PRIMARY),
                                          strokeWidth: 4,
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  );

                                case Status.COMPLETED:
                                  print(snapshot.data!.data.toString());
                                  // Future.delayed(Duration.zero, () async {
                                  //   Navigator.of(context).push(MaterialPageRoute(
                                  //       builder: (BuildContext context) =>
                                  //           VerifyMobileScreen(
                                  //             otpReference:
                                  //                 snapshot.data!.data.toString(),
                                  //             mobileNumber: _mobileNumberController.text,
                                  //             isFromSignUp: true,
                                  //           )));
                                  // });
                                  break;

                                case Status.ERROR:
                                  print(snapshot.data!.message);
                                  WidgetsBinding.instance!.addPostFrameCallback((_) => _showErrorMessage(snapshot.data!.message.toString()));

                                  break;
                              }
                            }
                            return Padding(
                              padding: EdgeInsets.only(bottom: 50.h),
                              child: Align(
                                child: CustomButton(
                                  buttonText: "Let’s Go!",
                                  onTap: () {
                                    if (isStringEmpty(_nameController.text.trim())) {
                                      _showErrorMessage("Please enter name.");
                                    } else if (isStringEmpty(_mobileNumberController.text.trim())) {
                                      _showErrorMessage("Please enter mobile number.");
                                    } else if (validateMobile(_mobileNumberController.text.trim()) == false) {
                                      _showErrorMessage("Please enter valid mobile number.");
                                    } else if (isStringEmpty(_vuaController.text.trim())) {
                                      _showErrorMessage("Please enter recommended VUA.");
                                    } else if (isTermsSelected == false) {
                                      _showErrorMessage("Please select agree terms and conditions.");
                                    } else {
                                      _bloc!.signupUser(
                                          name: _nameController.text.toString(),
                                          mobileNumber: _mobileNumberController.text.toString(),
                                          vua: _vuaController.text.toString(),
                                          context: context,
                                          completion: (status) {
                                            pushToOtpScreens(status);
                                          });
                                    }
                                  },
                                  buttonWidth: 200.w,
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
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
          otpReference: status.toString(),
          mobileNumber: _mobileNumberController.text.toString(),
          isFromSignUp: true,
          nameString: _nameController.text.toString(),
          vuaString: _vuaController.text.toString(),
        ),
      ),
    );
  }
}
