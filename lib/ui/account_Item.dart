import 'package:flutter/material.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/ui/account_linking_bottom_sheet.dart';
import 'package:onemoney_sdk/ui/consent_details_screen.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';

class AccountItem extends StatelessWidget {
  final Account accountModel;
  final Function onTapAccount;
  final bool isSelected;
  final bool isAllowSelection;

  const AccountItem({Key? key, required this.accountModel, required this.onTapAccount, required this.isSelected, required this.isAllowSelection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapAccount();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 18.h),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.w), color: Colors.white),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.saving_account,
                        width: 23.w,
                        height: 23.h,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      getMediumText('${accountModel.data?.accType?.substring(0, 1).toUpperCase()}${accountModel.data?.accType?.substring(1).toLowerCase()} Account',
                          fontcolor: Colors.black87, fontsize: 15.sp),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  getRegularText('Account Number', fontcolor: Colors.grey, fontsize: 12.sp),
                  SizedBox(
                    height: 2,
                  ),
                  getMediumText('${accountModel.data?.maskedAccNumber}', fontcolor: Colors.black87, fontsize: 14.sp),
                ],
              ),
            ),
            if (isAllowSelection)
              Container(
                width: 22.w,
                height: 22.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Color(0xFF5EE27B) : Colors.white,
                    border: Border.all(
                      color: Colors.black26,
                    )), //isSelected ? Color(0xFF5EE27B) :
                // padding: EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 3),
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
        ),
      ),
    );
  }
}
