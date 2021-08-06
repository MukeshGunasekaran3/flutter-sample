import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/bloc/discover_accounts.dart';
import 'package:onemoney_sdk/model/color_model.dart';
import 'package:onemoney_sdk/ui/account_linking_screen.dart';
import 'package:onemoney_sdk/ui/custom_button.dart';
import 'package:onemoney_sdk/ui/identifier_details_item.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/styles.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdentifireDetailsScreen extends StatefulWidget {
  final List<Fip> selectedFip;

  const IdentifireDetailsScreen({Key? key, required this.selectedFip}) : super(key: key);

  @override
  _IdentifireDetailsScreenState createState() => _IdentifireDetailsScreenState();
}

class _IdentifireDetailsScreenState extends State<IdentifireDetailsScreen> {
  int colorCount = -1;
  late List<Fip> selectedFip;

  DiscoverAccounts? _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = DiscoverAccounts();
    selectedFip = widget.selectedFip;
    // _bloc!.discoverAccounts(fipID: widget.fipID, inputIdentifier: widget.identifiers);
  }

  @override
  void dispose() {
    _bloc!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: getAppBar(context, "", leadingButton: getBackButton(context), actionItems: [
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
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 19.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        getRegularText('Provide Identifier Details', fontsize: 20.sp),
                        SizedBox(
                          height: 15.h,
                        ),
                        getRegularText('Enter identifiers to enable discovery of your financial account', fontsize: 16.sp),
                        SizedBox(
                          height: 25.h,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: selectedFip.length,
                          itemBuilder: (context, index) {
                            if (index > getColors().length - 1) {
                              colorCount++;
                              if (colorCount > getColors().length - 1) {
                                colorCount = -1;
                                colorCount++;
                              }
                            }

                            return IndentifierDetailsItem(
                              colorModel: getColors()[index > getColors().length - 1 ? colorCount : index],
                              fipModel: selectedFip[index],
                            );
                          },
                        ),
                        SizedBox(
                          height: 70.h,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1,
                  left: 130.w,
                  right: 130.w,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: CustomButton(
                      buttonText: "Continue",
                      onTap: () {
                        debugPrint("hello from button");
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (BuildContext context) =>
                        //         AccountLinkingScreen()));
                      },
                      buttonWidth: 180.w,
                    ),
                  ),
                ),
              ],
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

  List<ColorModel> getColors() {
    List<ColorModel> list = [];

    list.add(ColorModel(color1: Color(0xFFA7BEF6), color2: Color(0xCC405EC9)));
    list.add(ColorModel(color1: Color(0xFFC5A7F6), color2: Color(0xCCBB207D)));
    list.add(ColorModel(color1: Color(0xFFE59482), color2: Color(0xCCF09968)));
    list.add(ColorModel(color1: Color(0xFF23FF95), color2: Color(0xCC68F0F0)));

    return list;
  }
}
