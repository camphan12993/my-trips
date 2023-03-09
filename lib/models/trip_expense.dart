import 'dart:convert';

class TripExpense {
  final String id;
  final String nodeId;
  final String userId;
  final double value;
  TripExpense({
    required this.id,
    required this.nodeId,
    required this.userId,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'nodeId': nodeId});
    result.addAll({'userId': userId});
    result.addAll({'value': value});

    return result;
  }

  factory TripExpense.fromMap(Map<String, dynamic> map) {
    return TripExpense(
      id: map['id'] ?? '',
      nodeId: map['nodeId'] ?? '',
      userId: map['userId'] ?? '',
      value: map['value']?.toDouble() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TripExpense.fromJson(String source) => TripExpense.fromMap(json.decode(source));
}
