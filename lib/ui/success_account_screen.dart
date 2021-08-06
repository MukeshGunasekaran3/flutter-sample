import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onemoney_sdk/ui/custom_button.dart';
import 'package:onemoney_sdk/ui/login_screen.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';

class AccountCreatedScreen extends StatefulWidget {
  const AccountCreatedScreen({Key? key}) : super(key: key);

  @override
  _AccountCreatedScreenState createState() => _AccountCreatedScreenState();
}

class _AccountCreatedScreenState extends State<AccountCreatedScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(scaffoldKey.currentContext!).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50.h,
        ),
        Image.asset(
          Images.one_money_logo,
          width: 180.w,
          height: 90.h,
        ),
        // SizedBox(
        //   height: 50.h,
        // ),

        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Images.account_created,
                  width: 300.w,
                  height: 250.h,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Account Created\nSuccessfully',
                  textAlign: TextAlign.center,
                  style: popinsBold.copyWith(
                      fontSize: 25.sp, color: ColorResources.SUCCESS_COLOR),
                )
              ],
            ),
          ),
        ),

        SizedBox(
          height: 30.h,
        ),
        //login button
        Padding(
          padding: EdgeInsets.only(bottom: 50.h),
          child: Align(
            child: CustomButton(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false);
              },
              buttonText: "Ready to Link Accounts",
              buttonWidth: 250.w,
            ),
          ),
        ),
      ],
    ));
  }
}
