import 'dart:convert';

class TripExpense {
  final String id;
  final String nodeId;
  final String userId;
  final double value;
  final String name;
  final String time;
  TripExpense({
    required this.id,
    required this.nodeId,
    required this.userId,
    required this.value,
    required this.name,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'nodeId': nodeId});
    result.addAll({'userId': userId});
    result.addAll({'value': value});
    result.addAll({'name': name});
    result.addAll({'time': time});

    return result;
  }

  factory TripExpense.fromMap(Map<String, dynamic> map) {
    return TripExpense(
      id: map['id'] ?? '',
      nodeId: map['nodeId'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      value: map['value']?.toDouble() ?? 0,
      time: map['time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TripExpense.fromJson(String source) => TripExpense.fromMap(json.decode(source));
}
