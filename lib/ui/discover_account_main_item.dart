import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/discover_accounts.dart';
import 'package:onemoney_sdk/model/color_model.dart';
import 'package:onemoney_sdk/ui/account_Item.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';

import 'account_linking_bottom_sheet.dart';

class DiscoverAccountMainItem extends StatefulWidget {
  final ColorModel? colorModel;
  // final Account accountModel;
  final DiscoverAccounts bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isLinked;
  final Fip? fipModel;
  List<Account> bankAccountList;

  DiscoverAccountMainItem({
    this.colorModel,
    // required this.accountModel,
    required this.bloc,
    required this.scaffoldKey,
    required this.isLinked,
    this.fipModel,
    required this.bankAccountList,
  });

  @override
  _DiscoverAccountMainItemState createState() => _DiscoverAccountMainItemState();
}

class _DiscoverAccountMainItemState extends State<DiscoverAccountMainItem> {
  List<Account> selectedBankAccountList = [];
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
                  widget.colorModel != null ? widget.colorModel!.color1! : Color(0xFFC5A7F6),
                  widget.colorModel != null ? widget.colorModel!.color2! : Color(0xCCBB207D),
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
                    image: "${widget.fipModel?.logoUrl ?? 'https://www.nfcw.com/wp-content/uploads/2020/06/axis-bank-logo.jpg'}",
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
                    '${widget.fipModel?.fipName}',
                    style: popinsBold.copyWith(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
                // Container(
                //   width: 22.w,
                //   height: 22.h,
                //   decoration: BoxDecoration(shape: BoxShape.circle, color: widget.isLinked ? Color(0xFF5EE27B) : Colors.white), //isSelected ? Color(0xFF5EE27B) :
                //   // padding: EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 3),
                //   margin: EdgeInsets.only(right: 15.w),
                //   child: Center(
                //     child: Icon(
                //       Icons.check,
                //       size: 18.w,
                //       color: Colors.white,
                //     ),
                //   ),
                // )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // AccountItem(
            //   accountModel: accountModel,
            //   onTapAccount: () async {
            //     bloc.sendOTPToLinkAccount(
            //         account: accountModel,
            //         context: context,
            //         scaffoldKey: scaffoldKey,
            //         afterSuccessFullLined: afterSuccessFullLined,
            //         completion: (status) {
            //           showModalBottomSheet(
            //               context: context,
            //               isScrollControlled: true,
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.vertical(
            //                   top: Radius.circular(20),
            //                 ),
            //               ),
            //               clipBehavior: Clip.antiAliasWithSaveLayer,
            //               builder: (context) {
            //                 return AccountLinkingBottomSheet(
            //                   bankName: this.accountModel.data?.fipId ?? "Bank",
            //                   authSessionpara: status,
            //                   bloc: bloc,
            //                   scaffoldKey: scaffoldKey,
            //                   afterSuccessFullLined: afterSuccessFullLined,
            //                   accountModel: this.accountModel,
            //                 );
            //               });
            //         });
            //   },
            // ),
            if (widget.bankAccountList != null)
              ...widget.bankAccountList
                  .map((e) => AccountItem(
                        isAllowSelection: true,
                        accountModel: e,
                        isSelected: selectedBankAccountList.any((element) => element.data!.accRefNumber == e.data!.accRefNumber),
                        onTapAccount: () async {
                          if (selectedBankAccountList.any((element) => element.data!.accRefNumber == e.data!.accRefNumber)) {
                            selectedBankAccountList.removeWhere((element) => element.data!.accRefNumber == e.data!.accRefNumber);
                          } else {
                            selectedBankAccountList.add(e);
                          }
                          print(selectedBankAccountList.length);
                          setState(() {});
                        },
                      ))
                  .toList(),
            if (!widget.isLinked)
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (selectedBankAccountList.isEmpty) {
                        _showErrorMessage("select at least one account from ${this.widget.bankAccountList[0].data?.fipId}");
                        return;
                      }
                      widget.bloc.sendOTPToBilkLinkAccount(
                          accounts: selectedBankAccountList,
                          context: context,
                          completion: (status) {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                builder: (context) {
                                  return AccountLinkingBottomSheet(
                                    bankName: this.widget.bankAccountList[0].data?.fipId ?? "Bank",
                                    authSessionpara: status,
                                    bloc: widget.bloc,
                                    scaffoldKey: widget.scaffoldKey,
                                    accountList: selectedBankAccountList,
                                  );
                                });
                          });
                    },
                    child: Container(
                      // width: 80.w,
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
                          Text(
                            'Link',
                            style: popinsMedium.copyWith(color: Color(0xFF5EE27B), fontSize: 12.sp),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
