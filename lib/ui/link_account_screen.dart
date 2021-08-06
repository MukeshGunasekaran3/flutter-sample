import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/bloc/discover_accounts.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/ui/custom_button.dart';
import 'package:onemoney_sdk/ui/finatial_institution_screen.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/Loader.dart';
import 'package:onemoney_sdk/utils/app_sizes.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';

import 'account_linking_screen.dart';

class LinkAccountScreen extends StatefulWidget {
  const LinkAccountScreen({Key? key}) : super(key: key);

  @override
  _LinkAccountScreenState createState() => _LinkAccountScreenState();
}

class _LinkAccountScreenState extends State<LinkAccountScreen> {
  DiscoverAccounts? _bloc;
  bool isLinkedAccounts = false;
  @override
  void initState() {
    super.initState();
    _bloc = DiscoverAccounts();
    initStatePage();
  }

  initStatePage() async {
    _bloc!.disAccountSink.add(Response.loading("in Progress"));

    await _bloc!.getFipListOtherMethod(context);

    _bloc!.getLinkedAccounts(context, (status) {
      if (status.isNotEmpty == true) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AccountLinkingScreen(accountList: (status))));
      } else {
        setState(() {
          isLinkedAccounts = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _bloc!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: getAppBar(context, "", leadingButton: getMenuButton(context), actionItems: [
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
      ]),
      body: StreamBuilder<Response<dynamic>>(
        stream: _bloc!.disAccountStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // ignore: missing_enum_constant_in_switch
            switch (snapshot.data!.status) {
              case Status.LOADING:
                print(snapshot.data!.message);
                // return Center(
                //   child: Container(
                //     width: 40.w,
                //     height: 40.h,
                //     child: CircularProgressIndicator(
                //       valueColor: AlwaysStoppedAnimation<Color>(ColorResources.COLOR_PRIMARY),
                //       strokeWidth: 4,
                //       backgroundColor: Colors.transparent,
                //     ),
                //   ),
                // );
                break;

              case Status.COMPLETED:
                break;

              case Status.ERROR:
                print(snapshot.data!.message);

                // if(snapshot.data!.message.toString()=="user not found"){
                //   AppDialogs.showSimpleDialog(context, snapshot.data!.message.toString(), "content");
                // }
                WidgetsBinding.instance!.addPostFrameCallback((_) => _showErrorMessage(snapshot.data!.message.toString()));

                break;
            }
          }
          return isLinkedAccounts == false
              ? Container()
              : SafeArea(
                  child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        getRegularText(
                          'Hi ${userInfo.value.firstName ?? 'one'},',
                          fontsize: SizeConfig.TEXT_SIZE_HEADING,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: getRegularText(
                            "Let's take you through quick simple\nsteps to link your financial account.",
                            fontsize: SizeConfig.TEXT_SIZE_SUB_HEADING_,
                            fontcolor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                          child: Image.asset(
                            Images.link_account,
                            width: 400.w,
                            height: 120.h,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        getRegularText("Link Accounts", fontsize: SizeConfig.TEXT_SIZE_SUB_HEADING_LARGE, fontcolor: Colors.black, fontWeight: FontWeight.w600),
                        SizedBox(
                          height: 5.h,
                        ),
                        getRegularText("You can quickly link your bank accounts, investments, insurance policies, pension funds etc. with Onemoney for consent based data sharing.",
                            fontsize: 15.sp, fontcolor: Colors.black87),
                        SizedBox(
                          height: 30.h,
                        ),
                        getRegularText("We will need one or more of the following information for quickly linking accounts.", fontsize: 15.sp, fontcolor: Colors.black87),
                        SizedBox(
                          height: 10.h,
                        ),
                        getRowSection('Mobile Number'),
                        getRowSection('Customer Relationship Number'),
                        getRowSection('Account Number'),
                        getRowSection('Folio Number'),
                        getRowSection('Policy Number'),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.h),
                          child: Align(
                            child: CustomButton(
                              buttonText: "Add Account",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FinancialInstitutionScreen()));
                              },
                              buttonWidth: 190.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
        },
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

  getRowSection(String text) {
    return Row(
      children: [getRegularText('• ', fontsize: 24.sp, fontcolor: Colors.black87), getRegularText(text, fontsize: 15.sp, fontcolor: Colors.black87)],
    );
  }
}
