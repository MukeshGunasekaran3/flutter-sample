import 'dart:convert';

import 'package:collection/collection.dart';

import 'fip_model.dart';

class FipList {
  List<Fip>? fipList;

  FipList({
    this.fipList,
  });

  FipList copyWith({
    List<Fip>? fipList,
  }) {
    return FipList(
      fipList: fipList ?? this.fipList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fipList': fipList!.map((x) => x.toMap()).toList(),
    };
  }

  factory FipList.fromMap(Map<String, dynamic> map) {
    //if (map == null) return null;

    return FipList(
      fipList: List<Fip>.from(map['fipList']?.map((x) => Fip.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory FipList.fromJson(String source) =>
      FipList.fromMap(json.decode(source));

  @override
  String toString() => 'FipList(fipList: $fipList)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is FipList && listEquals(o.fipList, fipList);
  }

  @override
  int get hashCode => fipList.hashCode;
}