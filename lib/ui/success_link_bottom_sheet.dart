import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';

import 'consent_details_screen.dart';

class AccountLinkSccBottomSheet extends StatefulWidget {
  final String mobileNumber = "9400000000";
  const AccountLinkSccBottomSheet({Key? key}) : super(key: key);

  @override
  _AccountLinkSccBottomSheetState createState() => _AccountLinkSccBottomSheetState();
}

class _AccountLinkSccBottomSheetState extends State<AccountLinkSccBottomSheet> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (BuildContext context) => ConsentDetailsScreen(mobileNumber: widget.mobileNumber,)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Images.link_account,
            width: 300.w,
            height: 200.h,
          ),
          SizedBox(
            height: 20.h,
          ),
          getBoldText('Your Account Linked\nSuccessfully', fontcolor: ColorResources.SUCCESS_COLOR, fontsize: 25.sp, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
