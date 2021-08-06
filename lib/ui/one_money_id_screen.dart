import 'package:flutter/material.dart';
import 'package:onemoney_sdk/ui/custom_button.dart';
import 'package:onemoney_sdk/ui/success_account_screen.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';

class OneMoneyIDScreen extends StatefulWidget {
  const OneMoneyIDScreen({Key? key}) : super(key: key);

  @override
  _OneMoneyIDScreenState createState() => _OneMoneyIDScreenState();
}

class _OneMoneyIDScreenState extends State<OneMoneyIDScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.only(top: 50.h, left: 18.w, right: 18.w),
              child: Row(
                children: [
                  Expanded(
                      child: Text('VUA',
                          style: popinsRegular.copyWith(color: Colors.grey, fontSize: 14.sp))),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.edit,
                      color: ColorResources.COLOR_PRIMARY,
                      size: 20.w,
                    ),
                  )
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
                    child: Text('@onemoney',
                        style: popinsRegular.copyWith(
                            color: ColorResources.TEXT_FIELD_HINT, fontSize: 14.sp)),
                  )
                ],
              ),
            ),
          ],
        ),
        Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.only(bottom: 80.h),
          child: Align(
            child: CustomButton(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => AccountCreatedScreen()));
              },
              buttonText: "Submit",
            ),
          ),
        ),
      ],
    ));
  }
}
