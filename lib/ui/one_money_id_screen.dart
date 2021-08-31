import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onemoney_sdk/bloc/verify_mobile_bloc.dart';
import 'package:onemoney_sdk/ui/custom_button.dart';
import 'package:onemoney_sdk/ui/success_account_screen.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/size_utils/string_utils.dart';
import 'package:onemoney_sdk/utils/styles.dart';

class OneMoneyIDScreen extends StatefulWidget {
  const OneMoneyIDScreen({Key? key}) : super(key: key);

  @override
  _OneMoneyIDScreenState createState() => _OneMoneyIDScreenState();
}

class _OneMoneyIDScreenState extends State<OneMoneyIDScreen> with SingleTickerProviderStateMixin {
  MobileVerificationBloc? _bloc;
  final _vuaController = TextEditingController(text: "9561855723");
  final _mobileController = TextEditingController(text: "9561855723");
  @override
  void initState() {
    _bloc = MobileVerificationBloc();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: MediaQuery.of(context).size.height - (MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.h,
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
                  child: Text(
                    'Onemoney ID',
                    style: popinsBold.copyWith(fontSize: 25.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h, left: 18.w),
                  child: Text(
                    'You are almost done.',
                    maxLines: 2,
                    style: popinsRegular.copyWith(fontSize: 15.sp, color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30.h, left: 18.w, right: 18.w),
                      child: Row(
                        children: [
                          Expanded(child: Text('Mobile number', style: popinsRegular.copyWith(color: Colors.grey, fontSize: 14.sp))),
                          // InkWell(
                          //   onTap: () {},
                          //   child: Icon(
                          //     Icons.edit,
                          //     color: ColorResources.COLOR_PRIMARY,
                          //     size: 20.w,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            autocorrect: true,
                            controller: _mobileController,
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
                          // Padding(
                          //   padding: EdgeInsets.only(right: 15.w),
                          //   child: Text('@onemoney', style: popinsRegular.copyWith(color: ColorResources.TEXT_FIELD_HINT, fontSize: 14.sp)),
                          // )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h, left: 18.w, right: 18.w),
                      child: Row(
                        children: [
                          Expanded(child: Text('VUA', style: popinsRegular.copyWith(color: Colors.grey, fontSize: 14.sp))),
                          // InkWell(
                          //   onTap: () {},
                          //   child: Icon(
                          //     Icons.edit,
                          //     color: ColorResources.COLOR_PRIMARY,
                          //     size: 20.w,
                          //   ),
                          // )
                        ],
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
                            child: Text('@onemoney', style: popinsRegular.copyWith(color: ColorResources.TEXT_FIELD_HINT, fontSize: 14.sp)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h, top: 40.h),
                  child: Align(
                    child: CustomButton(
                      onTap: () {
                        if (isStringEmpty(_mobileController.text.trim())) {
                          _showErrorMessage("Please enter mobile number.");
                        } else if (validateMobile(_mobileController.text.trim()) == false) {
                          _showErrorMessage("Please enter valid mobile number.");
                        } else if (isStringEmpty(_vuaController.text.trim())) {
                          _showErrorMessage("Please enter recommended VUA.");
                        } else {
                          _bloc!.getConsentId(context: context, vua: _vuaController.text, mobileNumber: _mobileController.text);
                        }
                      },
                      buttonText: "Submit",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
}
