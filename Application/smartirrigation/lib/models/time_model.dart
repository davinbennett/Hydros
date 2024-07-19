import 'dart:convert';

class TimeModel {
  int hour;
  int minute;
  String timeFormat;

  TimeModel({
    required this.hour,
    required this.minute,
    required this.timeFormat,
  });
}
