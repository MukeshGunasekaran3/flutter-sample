import 'dart:convert';

class Identifier {
  String? identifier;
  String? identifierType;
  Identifier({
    this.identifier,
    this.identifierType,
  });

  Identifier copyWith({
    String? identifier,
    String? identifierType,
  }) {
    return Identifier(
      identifier: identifier ?? this.identifier,
      identifierType: identifierType ?? this.identifierType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'identifier': identifier,
      'identifierType': identifierType,
    };
  }

  factory Identifier.fromMap(Map<String, dynamic> map) {
    //if (map == null) return null;

    return Identifier(
      identifier: map['identifier'],
      identifierType: map['identifierType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Identifier.fromJson(String source) => Identifier.fromMap(json.decode(source));

  @override
  String toString() => 'Identifier(identifier: $identifier, identifierType: $identifierType)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Identifier &&
        o.identifier == identifier &&
        o.identifierType == identifierType;
  }

  @override
  int get hashCode => identifier.hashCode ^ identifierType.hashCode;
}
