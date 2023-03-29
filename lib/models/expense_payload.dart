import 'dart:convert';

class ExpensePayload {
  final String nodeId;
  final String userId;
  final int value;
  final String name;
  final String note;
  ExpensePayload({
    required this.nodeId,
    required this.userId,
    required this.value,
    required this.name,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'nodeId': nodeId});
    result.addAll({'userId': userId});
    result.addAll({'value': value});
    result.addAll({'name': name});
    result.addAll({'note': note});

    return result;
  }

  factory ExpensePayload.fromMap(Map<String, dynamic> map) {
    return ExpensePayload(
      nodeId: map['nodeId'] ?? '',
      userId: map['userId'] ?? '',
      value: map['value']?.toInt() ?? 0,
      name: map['name'] ?? '',
      note: map['note'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpensePayload.fromJson(String source) => ExpensePayload.fromMap(json.decode(source));
}
