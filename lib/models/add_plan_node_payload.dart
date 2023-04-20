import 'dart:convert';

class AddPlanNodePayload {
  final String name;
  final String? note;
  final int time;
  final String nodeId;
  AddPlanNodePayload({
    required this.name,
    required this.note,
    required this.time,
    required this.nodeId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'note': note});
    result.addAll({'time': time});
    result.addAll({'nodeId': nodeId});

    return result;
  }

  factory AddPlanNodePayload.fromMap(Map<String, dynamic> map) {
    return AddPlanNodePayload(
      name: map['name'] ?? '',
      note: map['note'] ?? '',
      time: map['time'] ?? '',
      nodeId: map['nodeId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AddPlanNodePayload.fromJson(String source) => AddPlanNodePayload.fromMap(json.decode(source));
}
