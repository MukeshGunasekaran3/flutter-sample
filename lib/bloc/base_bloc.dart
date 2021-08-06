import 'package:flutter/material.dart';
import 'package:onemoney/onemoney.dart';

ValueNotifier<FipList> masterFipList = ValueNotifier(FipList());
ValueNotifier<UserData> userInfo = ValueNotifier(UserData());

class Bloc {
  final onemoney = Onemoney();

  Bloc() {
    // onemoney.init(
    //   appIdentifier: '[]',
    //   //  baseUrl: 'https://api-sandbox.onemoney.in/',
    //   baseUrl: 'api-sandbox.onemoney.in',
    //   clientId: 'fp_test_d4c1ccc11767f14695349f360f915adcdbda16c1',
    //   clientSecret: 'f8d0841160d7781e4ecf33f74070677a0b8870e94a6ecf31533a9409415eef87895d9459',
    //   organisationId: 'AWE0258',
    //   vua: "123",
    //   consentId: "123",
    // );
  }
}
