import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/verifyvua_bloc.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/ui/consent_details_screen.dart';
import 'package:onemoney_sdk/ui/login_screen.dart';
import 'package:onemoney_sdk/ui/signup_screen.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/app_sizes.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/screenutil_init.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/size_utils/string_utils.dart';

import 'custom_button.dart';
import 'one_money_id_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _animation;

  VerifyVuaBloc? _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = VerifyVuaBloc();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));

    _animation = Tween<double>(
      begin: 50,
      end: 500,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.ease,
      ),
    );
    _animation!.addStatusListener((status) {
      if (AnimationStatus.completed == status) {
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) => LoginScreen()));
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) => ConsentDetailsScreen()));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => OneMoneyIDScreen()));
      }
    });
    _controller!.forward();

    // WidgetsBinding.instance!.addPostFrameCallback(
    //   (_) => setState(() {
    //     _bloc!.verifyVua(
    //       mobileNumber: _bloc!.onemoney.vua ?? "",
    //       context: context,
    //     );
    //   }),
    // );
  }

  @override
  void dispose() {
    _bloc!.dispose();
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeUtilInit(
      designSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
      builder: () => Scaffold(
          body: Center(
        child: AnimatedBuilder(
          animation: _controller!,
          builder: (context, child) {
            return Image.asset(
              Images.one_money_logo,
              width: _animation!.value,
              height: 100.h,
            );
          },
        ),
      )),
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
