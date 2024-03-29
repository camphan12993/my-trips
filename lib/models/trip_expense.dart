import 'dart:convert';

class TripExpense {
  final String id;
  final String nodeId;
  final String userId;
  final int value;
  final String name;
  final String time;
  final bool hasPaid;
  final String note;
  TripExpense({
    required this.id,
    required this.nodeId,
    required this.userId,
    required this.value,
    required this.name,
    required this.time,
    required this.hasPaid,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'nodeId': nodeId});
    result.addAll({'userId': userId});
    result.addAll({'value': value});
    result.addAll({'name': name});
    result.addAll({'time': time});
    result.addAll({'hasPaid': hasPaid});
    result.addAll({'note': note});

    return result;
  }

  factory TripExpense.fromMap(Map<String, dynamic> map) {
    return TripExpense(
      id: map['id'] ?? '',
      nodeId: map['nodeId'] ?? '',
      userId: map['userId'] ?? '',
      value: map['value']?.toInt() ?? 0,
      name: map['name'] ?? '',
      time: map['time'] ?? '',
      hasPaid: map['hasPaid'] ?? false,
      note: map['note'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TripExpense.fromJson(String source) => TripExpense.fromMap(json.decode(source));
}
