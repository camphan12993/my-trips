import 'dart:convert';

class Trip {
  final String id;
  final String name;
  final String adminId;
  final String startDate;
  final List<String> memberIds;
  Trip({
    required this.id,
    required this.name,
    required this.adminId,
    required this.startDate,
    required this.memberIds,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'adminId': adminId});
    result.addAll({'startDate': startDate});
    result.addAll({'memberIds': memberIds});

    return result;
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      adminId: map['adminId'] ?? '',
      startDate: map['startDate'] ?? '',
      memberIds: map['memberIds'] != null ? List<String>.from(map['memberIds']) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Trip.fromJson(String source) => Trip.fromMap(json.decode(source));
}
