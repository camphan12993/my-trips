import 'dart:convert';

class TripPayedExpense {
  final String userId;
  final int value;
  final String name;
  TripPayedExpense({
    required this.userId,
    required this.value,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'userId': userId});
    result.addAll({'value': value});
    result.addAll({'name': name});

    return result;
  }

  factory TripPayedExpense.fromMap(Map<String, dynamic> map) {
    return TripPayedExpense(
      userId: map['userId'] ?? '',
      value: map['value']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TripPayedExpense.fromJson(String source) => TripPayedExpense.fromMap(json.decode(source));
}
