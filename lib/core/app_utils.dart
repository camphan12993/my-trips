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

  static String getCountDownTime(String start) {
    DateTime startDay = DateTime.parse(start);
    DateTime now = DateTime.now();
    if (startDay.isAfter(now)) {
      int days = startDay.difference(now).inDays;
      if (days == 0) {
        int hours = startDay.difference(now).inHours;
        if (hours == 0) {
          int minutes = startDay.difference(now).inMinutes;
          return 'Còn $minutes phút';
        }
        return 'Còn $hours giờ';
      }
      return 'Còn $days ngày';
    } else {
      return 'Đang diễn ra';
    }
  }
}
