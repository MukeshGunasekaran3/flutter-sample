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

class AccountLinkingBottomSheet extends StatelessWidget {
  final List<Account> accountList;
  AuthSessionParameters authSessionpara;
  final DiscoverAccounts bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String bankName;

  AccountLinkingBottomSheet({Key? key, required this.authSessionpara, required this.bloc, required this.scaffoldKey, required this.bankName, required this.accountList}) : super(key: key);

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
            getRegularText('For $bankName Account', fontcolor: Colors.black54, fontsize: 19.sp),
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
                Navigator.pop(context);
                bloc.verifyOTPToLinkAccount(referenceNumber: authSessionpara.refNumber, authToken: v, context: scaffoldKey.currentContext!);
              },
              onChanged: (value) {
                print(value);
                // setState(() {
                //   //  currentText = value;
                // });
              },
            ),
            SizedBox(
              height: 40.h,
            ),
            InkWell(
              onTap: () {
                bloc.sendOTPToBilkLinkAccount(
                    accounts: accountList,
                    context: context,
                    completion: (status) {
                      this.authSessionpara = status;
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
