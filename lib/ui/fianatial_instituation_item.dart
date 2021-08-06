import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/model/color_model.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';

class FinancialInstitutionItem extends StatelessWidget {
  final ColorModel? colorModel;
  final Fip fipModel;
  final Function onTap;
  final bool isSelected;

  FinancialInstitutionItem({this.colorModel, required this.fipModel, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("${fipModel.fipName}");
        onTap(fipModel);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        width: MediaQuery.of(context).size.width,
        height: 110.h,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 15),
                  height: 55.w,
                  width: 55.w,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getBoldText(fipModel.fipName ?? "Bank name", fontsize: 16.sp, fontcolor: Colors.white),
                      SizedBox(
                        height: 4.h,
                      ),
                      getRegularText("Deposit, Term Deposit, Recurring Deposit", fontsize: 10.sp, fontcolor: Colors.white),
                    ],
                  ),
                ),
                Container(
                  width: 22.w,
                  height: 22.h,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? Color(0xFF5EE27B) : Colors.white),
                  padding: EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 3),
                  margin: EdgeInsets.only(right: 15.w),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      size: 18.w,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
