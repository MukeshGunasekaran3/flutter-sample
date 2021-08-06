import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/bloc/discover_accounts.dart';
import 'package:onemoney_sdk/model/color_model.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/ui/custom_button.dart';
import 'package:onemoney_sdk/ui/fianatial_instituation_item.dart';
import 'package:onemoney_sdk/ui/identifire_details_screen.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/Loader.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account_discover_screen.dart';

class FinancialInstitutionScreen extends StatefulWidget {
  const FinancialInstitutionScreen({Key? key}) : super(key: key);

  @override
  _FinancialInstitutionScreenState createState() => _FinancialInstitutionScreenState();
}

class _FinancialInstitutionScreenState extends State<FinancialInstitutionScreen> {
  int colorCount = -1;

  DiscoverAccounts? _bloc;

  List<Fip> selectedFip = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => setState(() {
        _bloc = DiscoverAccounts();
        _bloc?.getFipList(context);
      }),
    );
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
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
                StreamBuilder<Response<dynamic>>(
                    stream: _bloc?.disAccountStream,
                    builder: (context, snapshot) {
                      List<Fip> fipList = [];
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            print(snapshot.data!.message);
                            return Container();
                          case Status.COMPLETED:
                            //print(snapshot.data!.data.toString());

                            break;

                          case Status.ERROR:
                            print(snapshot.data!.message);

                            // if(snapshot.data!.message.toString()=="user not found"){
                            //   AppDialogs.showSimpleDialog(context, snapshot.data!.message.toString(), "content");
                            // }
                            WidgetsBinding.instance!.addPostFrameCallback((_) => _showErrorMessage(snapshot.data!.message.toString()));

                            break;
                        }
                        fipList = (snapshot.data!.data as FipList).fipList ?? [];
                        if (searchText != '' && fipList.isNotEmpty) {
                          fipList = fipList.where((element) => element.fipName?.toLowerCase().contains(searchText.toLowerCase()) ?? false).toList();
                        }
                      }
                      return SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 19.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15.h,
                              ),
                              Text(
                                'Financial Institution',
                                style: popinsMedium.copyWith(color: Colors.black, fontSize: 20.sp),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Text(
                                'Select financial institution that you have accounts',
                                style: popinsRegular.copyWith(color: Colors.black, fontSize: 16.sp),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              TextField(
                                autocorrect: true,
                                decoration: InputDecoration(
                                  hintText: 'Search Institution',
                                  filled: true,
                                  prefixIcon: Icon(Icons.search),
                                  fillColor: ColorResources.TEXT_FIELD_BACKGROUND,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(color: Colors.transparent, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: ColorResources.COLOR_PRIMARY),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              if (snapshot.hasData)
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: fipList.length,
                                  itemBuilder: (context, index) {
                                    if (index > getColors().length - 1) {
                                      colorCount++;
                                      if (colorCount > getColors().length - 1) {
                                        colorCount = -1;
                                        colorCount++;
                                      }
                                    }

                                    return FinancialInstitutionItem(
                                      colorModel: getColors()[index > getColors().length - 1 ? colorCount : index],
                                      fipModel: fipList[index],
                                      isSelected: selectedFip.any((element) => element.fipID == fipList[index].fipID),
                                      onTap: (Fip fipModel) {
                                        // selectedFip.clear();
                                        // selectedFip.add(fipModel);

                                        // this commit code for select multiple FIP
                                        if (selectedFip.any((element) => element.fipID == fipModel.fipID)) {
                                          selectedFip.removeWhere((element) => element.fipID == fipModel.fipID);
                                        } else {
                                          selectedFip.add(fipModel);
                                        }
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                Positioned(
                  bottom: 1,
                  left: 130.w,
                  right: 130.w,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: CustomButton(
                      buttonText: "Continue",
                      onTap: () {
                        if (selectedFip.isEmpty) {
                          _showErrorMessage("select at least one");
                          return;
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => AccountDiscoverScreen(
                                  selectedFip: selectedFip,
                                )));
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
