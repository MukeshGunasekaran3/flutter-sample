import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/bloc/discover_accounts.dart';
import 'package:onemoney_sdk/model/color_model.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'discover_account_main_item.dart';

class AccountDiscoverScreen extends StatefulWidget {
  final List<Fip> selectedFip;
  const AccountDiscoverScreen({Key? key, required this.selectedFip}) : super(key: key);

  @override
  _AccountDiscoverScreenState createState() => _AccountDiscoverScreenState();
}

class _AccountDiscoverScreenState extends State<AccountDiscoverScreen> {
  int colorCount = -1;
  late List<Fip> selectedFip;
  DiscoverAccounts? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DiscoverAccounts();
    selectedFip = widget.selectedFip;
    afterInitScreen();
  }

  List<Account>? linkedAccountList;

  afterInitScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var regnumber = prefs.getString("registereNumber");
    List<InputIdentifier> identifiers = [];

    selectedFip.forEach((element) {
      identifiers.addAll(element.identifiers!.map(
        (e) {
          return InputIdentifier(type: e.identifier, category: e.identifierType, value: regnumber);
        },
      ).toList());
    });
    _bloc!.disAccountSink.add(Response.loading("in Progress"));
    var responce = await _bloc!.getLinkedAccountsOtherMethod(context);
    if (responce is List<Account>) {
      linkedAccountList = responce;
    }
    _bloc!.discoverAccounts(fipID: selectedFip.first.fipID!, inputIdentifier: identifiers, context: context);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Fip> masterFipListlocal = masterFipList.value.fipList ?? [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
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
        // appBar: AppBar(
        //   iconTheme: IconThemeData(
        //     color: Colors.black, //change your color here
        //   ),
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        //     onPressed: () => Navigator.of(context).pop(),
        //   ),
        //   // backwardsCompatibility: true,
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        // ),
        body: Stack(
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
                    Text(
                      'Account Linking',
                      style: popinsMedium.copyWith(color: Colors.black, fontSize: 20.sp),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      'Almost there! Select the account you wish to link.',
                      style: popinsRegular.copyWith(color: Colors.black, fontSize: 16.sp),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    StreamBuilder<Response<dynamic>>(
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
                              List<Account> allAccount = (snapshot.data!.data as List<Account>);

                              var groupedList = groupBy(allAccount, (Account obj) => obj.data!.fipId);
                              if (groupedList.isEmpty)
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height - 250, // remove size of status bar and appbar
                                  child: Center(
                                    child: Text("No account for linking!"),
                                  ),
                                );

                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: groupedList.length,
                                  itemBuilder: (context, index) {
                                    var fip = groupedList[groupedList.keys.toList()[index]];
                                    if (fip == null) return SizedBox();
                                    if (index > getColors().length - 1) {
                                      colorCount++;
                                      if (colorCount > getColors().length - 1) {
                                        colorCount = -1;
                                        colorCount++;
                                      }
                                    }
                                    // Account accountModel = (snapshot.data!.data as List<Account>)[index];
                                    return DiscoverAccountMainItem(
                                      colorModel: getColors()[index > getColors().length - 1 ? colorCount : index],
                                      // accountModel: accountModel,
                                      bloc: _bloc!,
                                      scaffoldKey: scaffoldKey,
                                      isLinked: linkedAccountList?.any((element) => (element.data!.accRefNumber == fip[0].data!.accRefNumber)) ?? false,
                                      fipModel: masterFipListlocal.any((element) => element.fipID == fip[0].data!.fipId)
                                          ? masterFipListlocal.firstWhere((element) => element.fipID == fip[0].data!.fipId)
                                          : null,
                                      bankAccountList: fip,
                                    );
                                  });

                            case Status.ERROR:
                              print(snapshot.data!.message);

                              // if(snapshot.data!.message.toString()=="user not found"){
                              //   AppDialogs.showSimpleDialog(context, snapshot.data!.message.toString(), "content");
                              // }
                              WidgetsBinding.instance!.addPostFrameCallback((_) => _showErrorMessage(snapshot.data!.message.toString()));

                              break;
                          }
                        }
                        return SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
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
