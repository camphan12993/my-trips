import 'dart:convert';

import 'package:my_trips_app/models/trip_expense.dart';
import 'package:my_trips_app/models/trip_member.dart';
import 'package:my_trips_app/models/trip_payed_expense.dart';

class Trip {
  final String id;
  final String name;
  final String adminId;
  final String startDate;
  final String locale;
  final String currency;
  final List<TripMember> members;
  final List<TripExpense> otherExpense;
  final List<TripPayedExpense> payedExpenses;
  final bool hasEnd;
  Trip(
      {required this.id,
      required this.name,
      required this.adminId,
      required this.startDate,
      required this.locale,
      required this.currency,
      required this.members,
      required this.otherExpense,
      required this.payedExpenses,
      required this.hasEnd});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'adminId': adminId});
    result.addAll({'startDate': startDate});
    result.addAll({'locale': locale});
    result.addAll({'currency': currency});
    result.addAll({'hasEnd': hasEnd});
    result.addAll({'members': members.map((x) => x.toMap()).toList()});
    result.addAll({'otherExpense': otherExpense.map((x) => x.toMap()).toList()});
    result.addAll({'payedExpenses': payedExpenses.map((x) => x.toMap()).toList()});

    return result;
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      adminId: map['adminId'] ?? '',
      startDate: map['startDate'] ?? '',
      locale: map['locale'] ?? '',
      currency: map['currency'] ?? '',
      hasEnd: map['hasEnd'] ?? false,
      members: List<TripMember>.from((map['members'] ?? []).map((x) => TripMember.fromMap(x))),
      otherExpense: List<TripExpense>.from((map['otherExpense'] ?? []).map((x) => TripExpense.fromMap(x))),
      payedExpenses: List<TripPayedExpense>.from((map['payedExpenses'] ?? []).map((x) => TripPayedExpense.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Trip.fromJson(String source) => Trip.fromMap(json.decode(source));
}
