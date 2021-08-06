import 'dart:convert';

import 'identifier_model.dart';
import 'package:collection/collection.dart';

class Fip {
  String? fipID;
  String? code;
  String? fipName;
  String? logoUrl;
  String? smallUrl;
  bool? discoverOTP;
  List<String>? fis;
  List<Identifier>? identifiers;
  Fip({
    this.fipID,
    this.code,
    this.fipName,
    this.logoUrl,
    this.smallUrl,
    this.discoverOTP,
    this.fis,
    this.identifiers,
  });

  Fip copyWith({
    String? fipID,
    String? code,
    String? fipName,
    String? logoUrl,
    String? smallUrl,
    bool? discoverOTP,
    List<String>? fis,
    List<Identifier>? identifiers,
  }) {
    return Fip(
      fipID: fipID ?? this.fipID,
      code: code ?? this.code,
      fipName: fipName ?? this.fipName,
      logoUrl: logoUrl ?? this.logoUrl,
      smallUrl: smallUrl ?? this.smallUrl,
      discoverOTP: discoverOTP ?? this.discoverOTP,
      fis: fis ?? this.fis,
      identifiers: identifiers ?? this.identifiers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fipID': fipID,
      'code': code,
      'fipName': fipName,
      'logoUrl': logoUrl,
      'smallUrl': smallUrl,
      'discoverOTP': discoverOTP,
      'fis': fis,
      'identifiers': identifiers!.map((x) => x.toMap()).toList(),
    };
  }

  factory Fip.fromMap(Map<String, dynamic> map) {
    //if (map == null) return null;

    return Fip(
      fipID: map['fipID'],
      code: map['code'],
      fipName: map['fipName'],
      logoUrl: map['logoUrl'],
      smallUrl: map['smallUrl'],
      discoverOTP: map['discoverOTP'],
      fis: List<String>.from(map['FIs']),
      identifiers: List<Identifier>.from(map['identifiers']?.map((x) => Identifier.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Fip.fromJson(String source) => Fip.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Fip(fipID: $fipID, code: $code, fipName: $fipName, logoUrl: $logoUrl, smallUrl: $smallUrl, discoverOTP: $discoverOTP, fis: $fis, identifiers: $identifiers)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is Fip &&
        o.fipID == fipID &&
        o.code == code &&
        o.fipName == fipName &&
        o.logoUrl == logoUrl &&
        o.smallUrl == smallUrl &&
        o.discoverOTP == discoverOTP &&
        listEquals(o.fis, fis) &&
        listEquals(o.identifiers, identifiers);
  }

  @override
  int get hashCode {
    return fipID.hashCode ^
    code.hashCode ^
    fipName.hashCode ^
    logoUrl.hashCode ^
    smallUrl.hashCode ^
    discoverOTP.hashCode ^
    fis.hashCode ^
    identifiers.hashCode;
  }
}
