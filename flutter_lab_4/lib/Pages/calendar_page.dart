import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Model/exam.dart';
import '../auth.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final User? user = Auth().currentUser;

  List<Exam> exams = [];
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Exams');
    fetchData();
  }

  void fetchData() {
    dbRef.onChildAdded.listen((data) {
      ExamData examData = ExamData.fromJson(data.snapshot.value as Map);
      Exam exam = Exam(key: data.snapshot.key, examData: examData);
      if (exam.examData!.userId == user!.uid) {
        exams.add(exam);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Midterms and exams"),
      ),
      body: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 1,
        dataSource: ExamsDataSource(getAppointemnts(exams)),
         timeSlotViewSettings: TimeSlotViewSettings(
          startHour: 6, 
          endHour: 22, 
        
      ),
    )
    );
  }
}

List<Appointment> getAppointemnts(List<Exam> exams) {
  List<Appointment> appointments = <Appointment>[];
  for (Exam exam in exams) {
    final DateTime start = exam.examData!.startDatum!;
    final DateTime end = exam.examData!.endDatum!;
    final String subject = exam.examData!.predmet!;

    appointments.add(Appointment(
        startTime: start, endTime: end, subject: subject, color: Colors.blue));
  }
  return appointments;
}

class ExamsDataSource extends CalendarDataSource {
  ExamsDataSource(List<Appointment> source) {
    appointments = source;
  }
}
