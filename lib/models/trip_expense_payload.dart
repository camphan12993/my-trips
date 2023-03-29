import 'dart:convert';

class TripExpensePayload {
  final String userId;
  final int value;
  final String name;
  final String note;
  TripExpensePayload({
    required this.userId,
    required this.value,
    required this.name,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'userId': userId});
    result.addAll({'value': value});
    result.addAll({'name': name});
    result.addAll({'note': note});

    return result;
  }

  factory TripExpensePayload.fromMap(Map<String, dynamic> map) {
    return TripExpensePayload(
      userId: map['userId'] ?? '',
      value: map['value']?.toInt() ?? 0,
      name: map['name'] ?? '',
      note: map['note'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TripExpensePayload.fromJson(String source) => TripExpensePayload.fromMap(json.decode(source));
}
