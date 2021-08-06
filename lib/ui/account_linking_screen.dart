import 'package:flutter/material.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/model/color_model.dart';
import 'package:onemoney_sdk/ui/consent_details_screen.dart';
import 'package:onemoney_sdk/ui/custom_button.dart';
import 'package:onemoney_sdk/ui/link_account_main_item.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'finatial_institution_screen.dart';

class AccountLinkingScreen extends StatefulWidget {
  final List<Account> accountList;
  const AccountLinkingScreen({Key? key, required this.accountList}) : super(key: key);

  @override
  _AccountLinkingScreenState createState() => _AccountLinkingScreenState();
}

class _AccountLinkingScreenState extends State<AccountLinkingScreen> {
  int colorCount = -1;
  List<Fip> masterFipListlocal = masterFipList.value.fipList!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBar(
          context,
          "",
          leadingButton: getBackButton(context),
          actionItems: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 20.0),
              child: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 4.w),
                decoration: BoxDecoration(color: ColorResources.COLOR_PRIMARY, shape: BoxShape.circle),
                child: getFirstCharOfText("${userInfo.value.firstName ?? 'one'}"),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 19.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  getMediumText('Account Linking', fontsize: 20.sp),
                  SizedBox(
                    height: 15.h,
                  ),
                  getRegularText('You are almost done, please choose the accounts you would like to link', fontsize: 16.sp),
                  SizedBox(
                    height: 25.h,
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.accountList.length,
                      itemBuilder: (context, index) {
                        if (index > getColors().length - 1) {
                          colorCount++;
                          if (colorCount > getColors().length - 1) {
                            colorCount = -1;
                            colorCount++;
                          }
                        }

                        return LinkAccountMainItem(
                            colorModel: getColors()[index > getColors().length - 1 ? colorCount : index],
                            accountModel: widget.accountList[index],
                            fipModel: masterFipListlocal.firstWhere((element) => element.fipID == widget.accountList[index].data!.fipId));
                      }),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Align(
                      child: CustomButton(
                        buttonText: "Continue",
                        onTap: () async {
                          // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FinancialInstitutionScreen()));

                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if (prefs.containsKey("registereNumber")) {
                            var mobileNumber = prefs.getString("registereNumber")!;
                            // List<String> consentHandles = widget.accountList.map((e) => e.data?.accRefNumber ?? "").toList();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => ConsentDetailsScreen(),
                              ),
                            );
                          }
                        },
                        buttonWidth: 190.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  List<ColorModel> getColors() {
    List<ColorModel> list = [];

    list.add(ColorModel(color1: Color(0xFFA7BEF6), color2: Color(0xCC405EC9)));
    list.add(ColorModel(color1: Color(0xFFC5A7F6), color2: Color(0xCCBB207D)));
    list.add(ColorModel(color1: Color(0xFFE59482), color2: Color(0xCCF09968)));
    list.add(ColorModel(color1: Color(0xFF23FF95), color2: Color(0xCC68F0F0)));

    return list;
  }
}
