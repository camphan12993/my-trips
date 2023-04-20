import 'dart:convert';

class PlanNode {
  final String id;
  final String name;
  final String? note;
  final int time;
  final String nodeId;
  PlanNode({
    required this.id,
    required this.name,
    this.note,
    required this.time,
    required this.nodeId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    if (note != null) {
      result.addAll({'note': note});
    }
    result.addAll({'time': time});
    result.addAll({'nodeId': nodeId});

    return result;
  }

  factory PlanNode.fromMap(Map<String, dynamic> map) {
    return PlanNode(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      note: map['note'],
      time: map['time'] ?? '',
      nodeId: map['nodeId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanNode.fromJson(String source) => PlanNode.fromMap(json.decode(source));
}
