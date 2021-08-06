import 'dart:convert';

import 'package:collection/collection.dart';

class AccountData {
  String? accType;
  String? accRefNumber;
  String? maskedAccNumber;
  String? fipId;
  Map? userInfo;
  AccountData({
    this.accType,
    this.accRefNumber,
    this.maskedAccNumber,
    this.fipId,
    this.userInfo,
  });

  AccountData copyWith({
    String? accType,
    String? accRefNumber,
    String? maskedAccNumber,
    String? fipId,
    Map? userInfo,
  }) {
    return AccountData(
      accType: accType ?? this.accType,
      accRefNumber: accRefNumber ?? this.accRefNumber,
      maskedAccNumber: maskedAccNumber ?? this.maskedAccNumber,
      fipId: fipId ?? this.fipId,
      userInfo: userInfo ?? this.userInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accType': accType,
      'accRefNumber': accRefNumber,
      'maskedAccNumber': maskedAccNumber,
      'fipId': fipId,
      'userInfo': userInfo,
    };
  }

  factory AccountData.fromMap(Map<String, dynamic> map) {
    //if (map == null) return null;

    return AccountData(
      accType: map['accType'],
      accRefNumber: map['accRefNumber'],
      maskedAccNumber: map['maskedAccNumber'],
      fipId: map['fipId'],
      userInfo: Map.from(map['userInfo']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountData.fromJson(String source) => AccountData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AccountData(accType: $accType, accRefNumber: $accRefNumber, maskedAccNumber: $maskedAccNumber, fipId: $fipId, userInfo: $userInfo)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return o is AccountData &&
        o.accType == accType &&
        o.accRefNumber == accRefNumber &&
        o.maskedAccNumber == maskedAccNumber &&
        o.fipId == fipId &&
        mapEquals(o.userInfo, userInfo);
  }

  @override
  int get hashCode {
    return accType.hashCode ^
    accRefNumber.hashCode ^
    maskedAccNumber.hashCode ^
    fipId.hashCode ^
    userInfo.hashCode;
  }
}
