import 'package:flutter/material.dart';

class Exam {
  String? key;
  ExamData? examData;

  Exam({this.key, this.examData});
}

class ExamData {
  String? predmet;
  DateTime? startDatum;
  DateTime? endDatum;
  String? userId;
  TimeOfDay? start;
  TimeOfDay? end;
  String? address;

  ExamData(
      {required this.predmet,
      required this.startDatum,
      required this.endDatum,
      required this.userId,
      required this.start,
      required this.end,
      required this.address});

  ExamData.fromJson(Map<dynamic, dynamic> json) {
    predmet = json['predmet'];
    startDatum = json['startDatum'] != null
        ? DateTime.parse(json['startDatum'])
        : DateTime.now();
    endDatum = json['endDatum'] != null
        ? DateTime.parse(json['endDatum'])
        : DateTime.now();
    userId = json['userId'];
    start = TimeOfDay.fromDateTime(startDatum!);
    end = TimeOfDay.fromDateTime(endDatum!);
    address = json['address'];
  }
}
