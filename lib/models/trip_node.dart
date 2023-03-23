import 'dart:convert';

import 'package:my_trips_app/models/trip_expense.dart';

class TripNode {
  final String id;
  final String tripId;
  final String name;
  final String createdDate;
  List<TripExpense> expenses;
  TripNode({
    required this.id,
    required this.tripId,
    required this.name,
    required this.createdDate,
    required this.expenses,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'tripId': tripId});
    result.addAll({'name': name});
    result.addAll({'createdDate': createdDate});
    result.addAll({'expenses': expenses.map((x) => x.toMap()).toList()});

    return result;
  }

  factory TripNode.fromMap(Map<String, dynamic> map) {
    return TripNode(
      id: map['id'] ?? '',
      tripId: map['tripId'] ?? '',
      name: map['name'] ?? '',
      createdDate: map['createdDate'] ?? '',
      expenses: map['expenses'] != null ? List<TripExpense>.from(map['expenses'].map((x) => TripExpense.fromMap(x))) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory TripNode.fromJson(String source) => TripNode.fromMap(json.decode(source));
}
