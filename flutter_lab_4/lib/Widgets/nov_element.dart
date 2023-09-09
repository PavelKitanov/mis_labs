import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lab_4/Model/exam.dart';

class NovElement extends StatefulWidget {
  final Function addItem;

  NovElement(this.addItem);

  @override
  State<StatefulWidget> createState() => _NovElementState();
}

class _NovElementState extends State<NovElement> {
  final _predmetController = TextEditingController();
  final _startDatumVremeController = TextEditingController();
  final _endDatumVremeController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  void _submitData() {
    if (_startDatumVremeController.text.isEmpty) {
      return;
    }
    if (_endDatumVremeController.text.isEmpty) {
      return;
    }
    final String vnesenPredmet = _predmetController.text;
    final startDate = _startDatumVremeController.text;
    final endDate = _endDatumVremeController.text;

    if (vnesenPredmet.isEmpty) {
      return;
    }

    final newItem = ExamData(
      predmet: vnesenPredmet,
      startDatum: DateTime.parse(startDate),
      endDatum: DateTime.parse(endDate),
      userId: user!.uid,
      start: TimeOfDay.fromDateTime(DateTime.parse(startDate)),
      end: TimeOfDay.fromDateTime(DateTime.parse(endDate))
    );
    widget.addItem(newItem);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(children: [
        TextField(
          controller: _predmetController,
          decoration: InputDecoration(labelText: "Subject"),
          onSubmitted: (_) => _submitData(),
        ),
        TextField(
          controller: _startDatumVremeController,
          decoration: InputDecoration(labelText: "Start date and time"),
          keyboardType: TextInputType.datetime,
          onSubmitted: (_) => _submitData(),
        ),
        TextField(
          controller: _endDatumVremeController,
          decoration: InputDecoration(labelText: "End date and time"),
          keyboardType: TextInputType.datetime,
          onSubmitted: (_) => _submitData(),
        ),
        OutlinedButton(
          child: Text("Add"),
          onPressed: _submitData,
        )
      ]),
    );
  }
}
