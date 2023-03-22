import 'dart:convert';

import 'package:my_trips_app/models/trip_expense.dart';

class Trip {
  final String id;
  final String name;
  final String adminId;
  final String startDate;
  final List<String> memberIds;
  List<TripExpense> otherExpense;
  Trip({
    required this.id,
    required this.name,
    required this.adminId,
    required this.startDate,
    required this.memberIds,
    required this.otherExpense,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'adminId': adminId});
    result.addAll({'startDate': startDate});
    result.addAll({'memberIds': memberIds});
    result.addAll({'otherExpense': otherExpense.map((x) => x.toMap()).toList()});

    return result;
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      adminId: map['adminId'] ?? '',
      startDate: map['startDate'] ?? '',
      memberIds: List<String>.from(map['memberIds']),
      otherExpense: map['otherExpense'] != null ? List<TripExpense>.from(map['otherExpense']?.map((x) => TripExpense.fromMap(x))) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Trip.fromJson(String source) => Trip.fromMap(json.decode(source));
}
