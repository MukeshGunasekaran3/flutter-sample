import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/model/color_model.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/app_sizes.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';

class IndentifierDetailsItem extends StatelessWidget {
  final ColorModel? colorModel;
  final Fip fipModel;

  IndentifierDetailsItem({this.colorModel, required this.fipModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("hello from item");
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        width: MediaQuery.of(context).size.width,
        //height: 240.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.w),
            gradient: LinearGradient(
                colors: [
                  colorModel != null ? colorModel!.color1! : Color(0xFFC5A7F6),
                  colorModel != null ? colorModel!.color2! : Color(0xCCBB207D),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15),
                  height: 55.w,
                  width: 55.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: ClipOval(
                      child: FadeInImage.assetNetwork(
                    placeholder: Images.one_money_logo,
                    image: fipModel.logoUrl ?? 'https://www.nfcw.com/wp-content/uploads/2020/06/axis-bank-logo.jpg',
                    imageErrorBuilder: (context, object, stacktrace) {
                      return Image.asset(
                        Images.one_money_logo,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      );
                    },
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  )),
                ),
                Text(
                  fipModel.fipName ?? 'Bank Name',
                  style: popinsBold.copyWith(fontSize: 16.sp, color: Colors.white),
                ),
              ],
            ),
            if (false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text('Enter Mobile Number', textAlign: TextAlign.left, style: popinsRegular.copyWith(color: Colors.white, fontSize: 13.sp)),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    height: 50.h,
                    child: TextField(
                      autocorrect: true,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
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
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            if (false)
              Container(
                width: 100.w,
                height: 30.h,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.w), color: Colors.white),
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      Images.check_mark,
                      width: 15.w,
                      height: 15.h,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                        'Discovered',
                        style: popinsMedium.copyWith(color: Color(0xFF5EE27B), fontSize: 12.sp),
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
