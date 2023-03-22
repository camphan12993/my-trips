import 'dart:convert';

class ExpenseType {
  final String id;
  final String name;
  final String icon;
  ExpenseType({
    required this.id,
    required this.name,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'icon': icon});

    return result;
  }

  factory ExpenseType.fromMap(Map<String, dynamic> map) {
    return ExpenseType(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseType.fromJson(String source) => ExpenseType.fromMap(json.decode(source));
}
