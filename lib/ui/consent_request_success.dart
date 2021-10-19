import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/ui/consent_details_screen.dart';
import 'package:onemoney_sdk/ui/link_account_screen.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ConsentRequestScreen extends StatefulWidget {
  final String description;
  final bool approveConsentStatus;

  ConsentRequestScreen({Key? key, required this.description, required this.approveConsentStatus}) : super(key: key);

  @override
  _ConsentRequestScreenState createState() => _ConsentRequestScreenState();
}

class _ConsentRequestScreenState extends State<ConsentRequestScreen> {
  late Timer _timer;
  int _start = 0;
  Bloc _bloc = Bloc();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => setState(() {
        startTimer();
      }),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 60) {
          setState(() {
            timer.cancel();
            // Navigator.of(context).popUntil((route) => false);
            _gotoNextScreen(context);
          });
        } else {
          setState(() {
            _start++;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Images.consent_request,
            width: 300.w,
            height: 200.h,
          ),
          SizedBox(
            height: 20.h,
          ),
          getBoldText(widget.description, fontcolor: ColorResources.SUCCESS_COLOR, fontsize: 25.sp, textAlign: TextAlign.center),
          SizedBox(height: 45.h),
          getBoldText('$_start sec', fontcolor: Colors.black, fontsize: 20.sp, textAlign: TextAlign.center),
          SizedBox(height: 8.h),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 40,
            lineHeight: 6.0,
            percent: _start / 60,
            backgroundColor: Colors.grey.withAlpha(70),
            progressColor: ColorResources.SUCCESS_COLOR,
          ),
          SizedBox(height: 18.h),
          getRegularText(
            'Please wait while we redirect you to ${_bloc.onemoney.appName}’s app. Do not press back.',
            fontcolor: Colors.black,
            fontsize: 12.sp,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _gotoNextScreen(BuildContext context1) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      _bloc.onemoney.sendApproveRejectDataToParent({"isApprove": widget.approveConsentStatus});
      // Navigator.of(context).pop();
      // Navigator.pushReplacement(context1, MaterialPageRoute(builder: (_) => ConsentDetailsScreen()));
    });
  }
}
