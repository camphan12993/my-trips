import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/models/app_currency.dart';

class AppUtils {
  static TimeOfDay getTimeOfDate(int time) {
    int hours = time ~/ 60;
    int minutes = time % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }

  static NumberFormat formatCurrency(AppCurrency currency) {
    return NumberFormat.simpleCurrency(locale: currency.local, name: currency.name, decimalDigits: 0);
  }
}
