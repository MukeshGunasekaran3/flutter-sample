import 'dart:convert';

import 'account_data.dart';


class Account {
  AccountData? data;
  String? type;
  Account({
    this.data,
    this.type,
  });

  Account copyWith({
    AccountData? data,
    String? type,
  }) {
    return Account(
      data: data ?? this.data,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.toMap(),
      'type': type,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    // if (map == null) return null;

    return Account(
      data: AccountData.fromMap(map['data']),
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) => Account.fromMap(json.decode(source));

  @override
  String toString() => 'Account(data: $data, type: $type)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Account &&
        o.data == data &&
        o.type == type;
  }

  @override
  int get hashCode => data.hashCode ^ type.hashCode;
}
