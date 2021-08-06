import 'dart:convert';

class InputIdentifier {
  String? category;
  String? type;
  String? value;
  InputIdentifier({
    this.category,
    this.type,
    this.value,
  });

  InputIdentifier copyWith({
    String? category,
    String? type,
    String? value,
  }) {
    return InputIdentifier(
      category: category ?? this.category,
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'type': type,
      'value': value,
    };
  }

  factory InputIdentifier.fromMap(Map<String, dynamic> map) {
    // if (map == null) return null;

    return InputIdentifier(
      category: map['category'],
      type: map['type'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InputIdentifier.fromJson(String source) =>
      InputIdentifier.fromMap(json.decode(source));

  @override
  String toString() =>
      'InputIdentifier(category: $category, type: $type, value: $value)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is InputIdentifier &&
        o.category == category &&
        o.type == type &&
        o.value == value;
  }

  @override
  int get hashCode => category.hashCode ^ type.hashCode ^ value.hashCode;
}
