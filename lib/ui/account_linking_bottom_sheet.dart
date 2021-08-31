import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/discover_accounts.dart';
import 'package:onemoney_sdk/ui/success_link_bottom_sheet.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/app_sizes.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'consent_details_screen.dart';

class AccountLinkingBottomSheet extends StatefulWidget {
  final List<Account> accountList;
  AuthSessionParameters authSessionpara;
  final DiscoverAccounts bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String bankName;

  AccountLinkingBottomSheet({Key? key, required this.authSessionpara, required this.bloc, required this.scaffoldKey, required this.bankName, required this.accountList}) : super(key: key);

  @override
  _AccountLinkingBottomSheetState createState() => _AccountLinkingBottomSheetState();
}

class _AccountLinkingBottomSheetState extends State<AccountLinkingBottomSheet> {
  bool hasError = false;
  Color boxColor = ColorResources.COLOR_PRIMARY;
  String errorText = "";

  StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        height: 360.h + MediaQuery.of(context).viewInsets.bottom,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getMediumText('Account Linking', fontsize: 19.sp),
            SizedBox(
              height: 10.h,
            ),
            getRegularText('For ${widget.bankName} Account', fontcolor: Colors.black54, fontsize: 19.sp),
            SizedBox(
              height: 50.h,
            ),
            getRegularText('OTP', fontcolor: Colors.grey, fontsize: SizeConfig.TEXT_SIZE_MEDIUM),
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
              // controller: textEditingController,
              keyboardType: TextInputType.number,
              onCompleted: (v) {
                // Navigator.pop(context);
                widget.bloc.verifyOTPToLinkAccount(
                  referenceNumber: widget.authSessionpara.refNumber,
                  authToken: v,
                  context: widget.scaffoldKey.currentContext!,
                  onSuccess: () {
                    boxColor = Colors.green;
                    errorText = "";
                    setState(() {});
                  },
                  onFailure: (errorMessage) {
                    if (errorMessage == "invalid otp provided") {
                      errorController?.add(ErrorAnimationType.shake);
                      hasError = true;
                      boxColor = Colors.redAccent;
                      errorText = errorMessage;
                      setState(() {});
                    }
                  },
                );
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
            SizedBox(
              height: 40.h,
            ),
            InkWell(
              onTap: () {
                widget.bloc.resendOTPToBilkLinkAccount(
                    accounts: widget.accountList,
                    context: context,
                    completion: (status) {
                      widget.authSessionpara = status;
                    });
              },
              child: Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Didn't receive any code?\n",
                    style: popinsRegular.copyWith(color: Colors.grey, fontSize: 14.sp),
                    children: const <TextSpan>[
                      TextSpan(text: 'Re-Send Code', style: TextStyle(fontWeight: FontWeight.bold, color: ColorResources.COLOR_PRIMARY)),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
