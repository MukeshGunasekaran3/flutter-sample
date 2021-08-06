import 'package:flutter/material.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/discover_accounts.dart';
import 'package:onemoney_sdk/model/color_model.dart';
import 'package:onemoney_sdk/ui/account_Item.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';

import 'account_linking_bottom_sheet.dart';

class LinkAccountMainItem extends StatelessWidget {
  final ColorModel? colorModel;
  final Account accountModel;
  final Fip? fipModel;

  LinkAccountMainItem({
    this.colorModel,
    required this.accountModel,
    this.fipModel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("hello from item");
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 18.h),
        width: MediaQuery.of(context).size.width,
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
                  margin: EdgeInsets.only(right: 15),
                  height: 55.w,
                  width: 55.w,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: ClipOval(
                      child: FadeInImage.assetNetwork(
                    placeholder: Images.one_money_logo,
                    image: fipModel?.logoUrl ?? 'https://www.nfcw.com/wp-content/uploads/2020/06/axis-bank-logo.jpg',
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
                  child: Text(
                    '${accountModel.data?.fipId}',
                    style: popinsBold.copyWith(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            AccountItem(
              isAllowSelection: false,
              isSelected: false,
              accountModel: accountModel,
              onTapAccount: () {},
            ),
            // ListView.builder(
            //     physics: NeverScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     itemCount: 2,
            //     itemBuilder: (context, index) {
            //       return AccountItem();
            //     })
          ],
        ),
      ),
    );
  }
}
