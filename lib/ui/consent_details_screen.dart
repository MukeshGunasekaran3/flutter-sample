import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:onemoney/onemoney.dart';
import 'package:onemoney_sdk/bloc/base_bloc.dart';
import 'package:onemoney_sdk/bloc/consent_details_bloc.dart';
import 'package:onemoney_sdk/model/repsonse.dart';
import 'package:onemoney_sdk/ui/approve_consent.dart';
import 'package:onemoney_sdk/ui/custom_button.dart';
import 'package:onemoney_sdk/utils/CommonWidget.dart';
import 'package:onemoney_sdk/utils/app_dialogs.dart';
import 'package:onemoney_sdk/utils/app_sizes.dart';
import 'package:onemoney_sdk/utils/color_resources.dart';
import 'package:onemoney_sdk/utils/images.dart';
import 'package:onemoney_sdk/utils/size_utils/size_extension.dart';
import 'package:onemoney_sdk/utils/styles.dart';

import 'finatial_institution_screen.dart';

class ConsentDetailsScreen extends StatefulWidget {
  const ConsentDetailsScreen({Key? key}) : super(key: key);

  @override
  _ConsentDetailsScreenState createState() => _ConsentDetailsScreenState();
}

class _ConsentDetailsScreenState extends State<ConsentDetailsScreen> {
  ScrollController _scrollController = ScrollController();

  ConsetDetailsBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ConsetDetailsBloc();
    getConsentDetails();
  }

  List<String> consentHandles = [];
  List<Account> linkedAccountList = [];

  List<Account> selectedAccount = [];
  bool isSelectAllBank = false;
  List<Consents>? consentsList = [];
  bool isSelectWithAuth = false;

  void getConsentDetails() async {
    await _bloc!.getFipListOtherMethod(context);
    masterFipListlocal = masterFipList.value.fipList ?? [];
    // DashboardData dashboardData = await _bloc!.getUserDashboardOtherMethod(context);
    // if (dashboardData.consents?.containsKey("pending") ?? false) {
    //   dashboardData.consents!["pending"].forEach((var element) {
    //     print("${element["consentArtefactID"]}");
    //     consentHandles.add("${element["consentArtefactID"]}");
    //   });
    // }
    // _bloc!.getUserDashboard();
    // if (consentHandles.isNotEmpty) {
    //   _bloc!.getConsentDetailsSingle(
    //       context: context,
    //       consentHandle: consentHandles.isNotEmpty ? consentHandles[0] : '',
    //       completion: (Consent consentData) {
    //         if (consentData.consents?.isNotEmpty ?? false) {
    //           setState(() {
    //             consentsList = consentData.consents;
    //             print(consentsList!.length);
    //           });
    //         }
    //       });
    //   _bloc!.getLinkedAccounts(context, (status) {
    //     linkedAccountList.addAll(status);
    //     print(linkedAccountList.length);
    //     setState(() {});
    //   });
    // } else {
    //   _bloc!.consentDetailsSink.add(Response.completed(Consent()));
    // }

    _bloc!.getConsentDetailsSingleWithoutConsentHandle(
        context: context,
        completion: (Consent consentData) {
          if (consentData.consents?.isNotEmpty ?? false) {
            setState(() {
              consentsList = consentData.consents;
              print(consentsList!.length);
            });
          }
        });
    _bloc!.getLinkedAccounts(context, (status) {
      linkedAccountList.addAll(status);
      print(linkedAccountList.length);
      setState(() {});
    });
  }

  List<Fip> masterFipListlocal = masterFipList.value.fipList ?? [];

  @override
  void dispose() {
    _bloc!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBar(context, "", leadingButton: getBackButton(context), actionItems: [
          Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 20.0),
              child: Container(
                  width: 40,
                  height: 40,
                  padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 4.w),
                  decoration: BoxDecoration(color: ColorResources.COLOR_PRIMARY, shape: BoxShape.circle),
                  child: getFirstCharOfText("${userInfo.value.firstName ?? 'one'}")))
        ]),
        /*appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // backwardsCompatibility: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),*/
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<Response<dynamic>>(
                stream: _bloc!.consentDetailsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        print(snapshot.data!.message);

                        break;

                      case Status.COMPLETED:
                        log((snapshot.data!.data as Consent).toJson().toString());
                        var consentData = (snapshot.data!.data as Consent);

                        if (consentData.consents?.isEmpty ?? true) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 100, // remove size of status bar and appbar
                            child: Center(
                              child: Text("No consents found!"),
                            ),
                          );
                        }
                        consentsList = consentData.consents;
                        var cibil = '';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18.w),
                              child: Text(
                                'Hi ${userInfo.value.firstName ?? 'one'},',
                                style: popinsBold.copyWith(fontSize: SizeConfig.TEXT_SIZE_HEADING),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5.h, left: 18.w, right: 18.w, bottom: 30.h),
                              child: Text(
                                // "These consents will be used to fetch your financial data from Onemoney account aggregator a well as from Credit Bureau.",
                                "These consents will be used to fetch your data from banks as well as ${cibil} credit bureaus.",
                                style: popinsRegular.copyWith(fontSize: SizeConfig.TEXT_SIZE_SUB_HEADING_, color: Colors.grey),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: Image.asset(
                                Images.request_img,
                                width: 400.w,
                                height: 200.h,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 14.w),
                              margin: EdgeInsets.only(top: 30.h, right: 18.w, left: 18.w, bottom: 16.h),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.w), color: Color(0xFFF4FFDE)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: 35.w,
                                          height: 35.h,
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                          //padding: EdgeInsets.only(left: 3, right: 10, top: 2, bottom: 10),
                                          margin: EdgeInsets.only(right: 10.w),
                                          child: Center(
                                            child: Icon(
                                              Icons.alternate_email_sharp,
                                              size: 20.0,
                                              color: ColorResources.COLOR_PRIMARY,
                                            ),
                                          )),
                                      Text(
                                        'Purpose',
                                        style: popinsMedium.copyWith(fontSize: 16.sp),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    '${consentsList![0].purposeText ?? ''}',
                                    style: popinsRegular.copyWith(fontSize: 14.sp, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            getAccountTypes(typesListText: '${consentsList![0].consentTypes ?? ''}', bankAccounts: linkedAccountList),
                            getDateRangeComponent(consentsList![0]),
                            getFrequencyRangeComponent(consentsList![0]),
                            getDataDeletionComponent(consentsList![0]),
                            getConsentValidComponent(consentsList![0]),
                          ],
                        );

                      case Status.ERROR:
                        print(snapshot.data!.message);
                        WidgetsBinding.instance!.addPostFrameCallback((_) => _showErrorMessage(snapshot.data!.message.toString()));

                      // break;

                    }
                  }
                  return SizedBox();
                },
              ),
              if (consentsList?.isNotEmpty ?? false)
                StreamBuilder<Response<dynamic>>(
                    stream: _bloc!.sendOtpToUpdateConsentStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            print(snapshot.data!.message);

                            break;
                          case Status.COMPLETED:
                            print(snapshot.data!.data.toString());
                            break;

                          case Status.ERROR:
                            print(snapshot.data!.message);
                            WidgetsBinding.instance!.addPostFrameCallback((_) => _showErrorMessage(snapshot.data!.message.toString()));
                            break;
                        }
                      }
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 15.w,
                          bottom: 40.h,
                        ),
                        child: Column(
                          children: [
                            if (!_bloc!.onemoney.isOTPAuth)
                              Padding(
                                padding: EdgeInsets.only(left: 25.w, bottom: 15.h),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isSelectWithAuth = !isSelectWithAuth;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(isSelectWithAuth ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded, color: Colors.blue),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          'I have read the consent details and I approve this consent request',
                                          style: popinsMedium.copyWith(fontSize: 14.sp, color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                  buttonText: 'Approve',
                                  onTap: () {
                                    if (selectedAccount.isEmpty) {
                                      _showErrorMessage("Make sure at least one account is selected");
                                      return;
                                    }

                                    if (consentsList != null && consentsList!.isNotEmpty) {
                                      if (_bloc!.onemoney.isOTPAuth) {
                                        _bloc!.sendOtpForUpdateConsent(
                                          context: context,
                                          consentHandle: consentsList![0].consentArtefactId!,
                                          account: selectedAccount,
                                          isApprove: true,
                                        );
                                      } else {
                                        if (isSelectWithAuth) {
                                          _bloc!.approveConsentWithoutAuth(context: context, consentHandles: consentsList![0].consentArtefactId!, accounts: selectedAccount);
                                        } else {
                                          _showErrorMessage("Please read consent details and enable checkbox");
                                        }
                                      }
                                    }
                                  },
                                  buttonWidth: 130.w,
                                ),
                                SizedBox(width: 16.h),
                                CustomButton(
                                  buttonText: 'Reject',
                                  onTap: () {
                                    if (consentsList != null && consentsList!.isNotEmpty) {
                                      if (_bloc!.onemoney.isOTPAuth) {
                                        _bloc!.sendOtpForUpdateConsent(
                                          context: context,
                                          consentHandle: consentsList![0].consentArtefactId!,
                                          account: [],
                                          isApprove: false,
                                        );
                                      } else {
                                        if (isSelectWithAuth) {
                                          _bloc!.rejectConsentWithoutAuth(context: context, consentHandles: consentsList![0].consentArtefactId!);
                                        } else {
                                          _showErrorMessage("Please read consent details and enable checkbox");
                                        }
                                      }
                                    }
                                  },
                                  buttonWidth: 130.w,
                                  textColor: ColorResources.COLOR_PRIMARY,
                                  buttonColor: Colors.white,
                                ),
                                // StreamBuilder<Response<dynamic>>(
                                //     stream: _bloc!.sendOtpToUpdateConsentStream,
                                //     builder: (context, snapshot) {
                                //       if (snapshot.hasData) {
                                //         // ignore: missing_enum_constant_in_switch
                                //         switch (snapshot.data!.status) {
                                //           case Status.LOADING:
                                //             print(snapshot.data!.message);
                                //             return Padding(
                                //               padding: EdgeInsets.only(bottom: 40.h),
                                //               child: Center(
                                //                 child: Container(
                                //                   width: 40.w,
                                //                   height: 40.h,
                                //                   child: CircularProgressIndicator(
                                //                     valueColor: AlwaysStoppedAnimation<Color>(ColorResources.COLOR_PRIMARY),
                                //                     strokeWidth: 4,
                                //                     backgroundColor: Colors.transparent,
                                //                   ),
                                //                 ),
                                //               ),
                                //             );
                                //
                                //           case Status.COMPLETED:
                                //             print(snapshot.data!.data.toString());
                                //
                                //             Navigator.pop(context);
                                //             showModalBottomSheet(
                                //                 context: context,
                                //                 isScrollControlled: true,
                                //                 shape: RoundedRectangleBorder(
                                //                   borderRadius: BorderRadius.vertical(
                                //                     top: Radius.circular(20),
                                //                   ),
                                //                 ),
                                //                 clipBehavior: Clip.antiAliasWithSaveLayer,
                                //                 builder: (context) {
                                //                   return Padding(
                                //                     padding: MediaQuery.of(context).viewInsets,
                                //                     child: ApproveConsentBottomSheet(consentHandle: '', account: [], isApprove: true),
                                //                   );
                                //                 });
                                //
                                //             break;
                                //
                                //           case Status.ERROR:
                                //             print(snapshot.data!.message);
                                //
                                //             WidgetsBinding.instance!.addPostFrameCallback((_) => _showErrorMessage(snapshot.data!.message.toString()));
                                //             break;
                                //         }
                                //       }
                                //       return CustomButton(
                                //         buttonText: 'Accept',
                                //         onTap: () {
                                //           _bloc!.sendOtpForUpdateConsent(mobileNumber: widget.mobileNumber, consentHandle: '', account: [], isApprove: true);
                                //         },
                                //         buttonWidth: 130.w,
                                //       );
                                //     })
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
            ],
          ),
        ));
  }

  getAccountTypes({required String typesListText, required List<Account> bankAccounts}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        margin: EdgeInsets.only(left: 18.w),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 14.w),
          margin: EdgeInsets.only(right: 15.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.w), color: Color(0xFFEBFFDC)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 35.w,
                    height: 35.h,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    //padding: EdgeInsets.only(left: 3, right: 10, top: 2, bottom: 10),
                    margin: EdgeInsets.only(right: 10.w),
                    child: Center(
                      child: Icon(
                        Icons.account_balance_outlined,
                        size: 20.0,
                        color: ColorResources.COLOR_PRIMARY,
                      ),
                    ),
                  ),
                  Text(
                    'Account Types',
                    style: popinsMedium.copyWith(fontSize: 16.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                '${typesListText}',
                style: popinsRegular.copyWith(fontSize: 14.sp, color: Colors.black54),
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      var connectivityResult = await (Connectivity().checkConnectivity());
                      if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
                        AppDialogs.showError(context, "No internet connection");
                        return;
                      }
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FinancialInstitutionScreen()));
                    },
                    child: Text(
                      'Add Account',
                      style: popinsMedium.copyWith(fontSize: 14.sp, color: Colors.blue),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (bankAccounts.length != selectedAccount.length) {
                          selectedAccount.clear();
                          selectedAccount.addAll(bankAccounts);
                        } else {
                          selectedAccount.clear();
                        }
                        isSelectAllBank = bankAccounts.length == selectedAccount.length;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(isSelectAllBank ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded, color: Colors.blue),
                        Text(
                          'Select All',
                          style: popinsMedium.copyWith(fontSize: 14.sp, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              if (bankAccounts.isNotEmpty)
                ...bankAccounts.map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        if (selectedAccount.any((element) => element.data!.accRefNumber == e.data!.accRefNumber)) {
                          selectedAccount.removeWhere((element) => element.data!.accRefNumber == e.data!.accRefNumber);
                        } else {
                          selectedAccount.add(e);
                        }
                        setState(() {
                          isSelectAllBank = bankAccounts.length == selectedAccount.length;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 35.w,
                            height: 35.h,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                            //padding: EdgeInsets.only(left: 3, right: 10, top: 2, bottom: 10),
                            margin: EdgeInsets.only(right: 10.w),
                            child: Icon(
                              Icons.money,
                              size: 20.0,
                              color: ColorResources.COLOR_PRIMARY,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (masterFipListlocal.any((element) => element.fipID == e.data!.fipId))
                                Text(
                                  '${masterFipListlocal.firstWhere((element) => element.fipID == e.data!.fipId).fipName}',
                                  style: popinsMedium.copyWith(fontSize: 12.sp),
                                )
                              else
                                Text(
                                  'Bank name',
                                  style: popinsMedium.copyWith(fontSize: 12.sp),
                                ),
                              Text(
                                '${e.data!.accType}',
                                style: popinsMedium.copyWith(fontSize: 10.sp),
                              ),
                              Text(
                                'Ac No : ${e.data!.maskedAccNumber}',
                                style: popinsMedium.copyWith(fontSize: 10.sp),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 25.w,
                                height: 25.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black38, width: 1),
                                  color: selectedAccount.any((element) => element.data!.accRefNumber == e.data!.accRefNumber) ? Color(0xFF5EE27B) : Colors.white,
                                ),
                                padding: EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 3),
                                margin: EdgeInsets.only(right: 15.w),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 18.w,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  getDateRangeComponent(Consents consentsData) {
    return Padding(
      padding: EdgeInsets.only(left: 18.w, bottom: 16.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 14.w),
        margin: EdgeInsets.only(right: 15.w),
        // width: 250.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.w),
          color: Color(0xFFF3F6E6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 35.w,
                    height: 35.h,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    //padding: EdgeInsets.only(left: 3, right: 10, top: 2, bottom: 10),
                    margin: EdgeInsets.only(right: 10.w),
                    child: Center(
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 20.0,
                        color: ColorResources.COLOR_PRIMARY,
                      ),
                    )),
                Text(
                  'Data range',
                  style: popinsMedium.copyWith(fontSize: 16.sp),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            getDates(
              startDate: DateFormat('dd MMM yyyy').format(DateTime.parse(consentsData.fiDatarangeFrom!)),
              endDate: DateFormat('dd MMM yyyy').format(DateTime.parse(consentsData.fiDatarangeTo!)),
            ),
            // getDates(startDate: "${dateRangeData['from']}", endDate: "${dateRangeData['to']}"),
            SizedBox(
              height: 40.h,
            ),
            Text(
              'The historical duration, such as the last 6 months (for example) for which your data is being sought',
              style: popinsRegular.copyWith(
                fontSize: 14.sp,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDates({required String startDate, required String endDate}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon(
            //   Icons.calendar_today_outlined,
            //   size: 20.0,
            //   color: ColorResources.COLOR_PRIMARY,
            // ),
            // SizedBox(
            //   height: 5.h,
            // ),
            Text(
              'Start Date',
              style: popinsRegular.copyWith(fontSize: 11.sp, color: Color(0xFF3E3E3E)),
            ),
            Text(
              '$startDate',
              style: popinsRegular.copyWith(fontSize: 14.sp, color: Color(0xFF3E3E3E)),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon(
            //   Icons.calendar_today_outlined,
            //   size: 20.0,
            //   color: ColorResources.COLOR_PRIMARY,
            // ),
            // SizedBox(
            //   height: 5.h,
            // ),
            Text(
              'End Date',
              style: popinsRegular.copyWith(fontSize: 11.sp, color: Color(0xFF3E3E3E)),
            ),
            Text(
              '$endDate',
              style: popinsRegular.copyWith(fontSize: 14.sp, color: Color(0xFF3E3E3E)),
            ),
          ],
        )
      ],
    );
  }

  getFrequencyRangeComponent(Consents consentsData) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        margin: EdgeInsets.only(left: 18.w),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 14.w),
          margin: EdgeInsets.only(right: 15.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.w), color: Color(0xFFEBFFDC)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      //padding: EdgeInsets.only(left: 3, right: 10, top: 2, bottom: 10),
                      margin: EdgeInsets.only(right: 10.w),
                      child: Center(
                        child: Icon(
                          Icons.hourglass_empty,
                          size: 20.0,
                          color: ColorResources.COLOR_PRIMARY,
                        ),
                      )),
                  Text(
                    'Frequency of Data Pull',
                    style: popinsMedium.copyWith(fontSize: 16.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                '${consentsData.frequencyValue} times (once a ${consentsData.frequencyUnit!.toString().toLowerCase()})',
                style: popinsMedium.copyWith(fontSize: 14.sp, color: Color(0xFF3E3E3E)),
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                'The number of times your data will be acessed, based on your acceptance of the cansent request.',
                style: popinsRegular.copyWith(fontSize: 14.sp, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getDataDeletionComponent(Consents consentsData) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        margin: EdgeInsets.only(left: 18.w),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 14.w),
          margin: EdgeInsets.only(right: 15.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.w), color: Color(0xFFEFF5FF)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      //padding: EdgeInsets.only(left: 3, right: 10, top: 2, bottom: 10),
                      margin: EdgeInsets.only(right: 10.w),
                      child: Center(
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 20.0,
                          color: ColorResources.COLOR_PRIMARY,
                        ),
                      )),
                  Text(
                    'Your data will be deleted after',
                    style: popinsMedium.copyWith(fontSize: 16.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                '${consentsData.dataLifeValue} ${consentsData.dataLifeUnit.toString().toLowerCase()}${(consentsData.dataLifeValue ?? 0) > 1 ? 's' : ''} from date of fetch',
                style: popinsMedium.copyWith(fontSize: 14.sp, color: Color(0xFF3E3E3E)),
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                'After this duration, your data will not be used by ${'<name>'}',
                //'After this duration, you data is expected to be deleted by party',
                style: popinsRegular.copyWith(fontSize: 14.sp, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getConsentValidComponent(Consents consentsData) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        margin: EdgeInsets.only(left: 18.w),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 14.w),
          margin: EdgeInsets.only(right: 15.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.w), color: Color(0xFFFFF1F9)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      //padding: EdgeInsets.only(left: 3, right: 10, top: 2, bottom: 10),
                      margin: EdgeInsets.only(right: 10.w),
                      child: Center(
                        child: Icon(
                          Icons.calendar_today_outlined,
                          size: 20.0,
                          color: ColorResources.COLOR_PRIMARY,
                        ),
                      )),
                  Text(
                    'Your consent will be valid from',
                    style: popinsMedium.copyWith(fontSize: 16.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              getDates(
                  startDate: DateFormat('dd MMM yyyy').format(DateTime.parse(consentsData.startTime ?? '9999-01-01')),
                  endDate: DateFormat('dd MMM yyyy').format(DateTime.parse(consentsData.expireTime ?? '9999-01-01'))),
              SizedBox(
                height: 40.h,
              ),
              Text(
                'The time period during which <name of party> is permitted to get your data. Any data request placed after this period will be rejected.',
                style: popinsRegular.copyWith(fontSize: 14.sp, color: Colors.black54),
              ),
            ],
          ),
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
