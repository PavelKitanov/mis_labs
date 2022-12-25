import 'package:flutter/material.dart';
import 'package:flutter_lab_3/Model/list_item.dart';
import 'package:nanoid/nanoid.dart';

class NovElement extends StatefulWidget {
  final Function addItem;

  NovElement(this.addItem);

  @override
  State<StatefulWidget> createState() => _NovElementState();
}

class _NovElementState extends State<NovElement> {
  final _predmetController = TextEditingController();
  final _datumVremeController = TextEditingController();

  late String predmet;
  late String datum;
  late String vreme;

  void _submitData() {
    if (_datumVremeController.text.isEmpty) {
      return;
    }
    final String vnesenPredmet = _predmetController.text;
    final vnesenDatum = _datumVremeController.text;

    if (vnesenPredmet.isEmpty) {
      return;
    }

    final newItem = ListItem(
      id: nanoid(5),
      predmet: vnesenPredmet,
      datum: DateTime.parse(vnesenDatum),
      vreme: TimeOfDay.fromDateTime(DateTime.parse(vnesenDatum)),
    );
    widget.addItem(newItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(children: [
        TextField(
          controller: _predmetController,
          decoration: InputDecoration(labelText: "Predmet"),
          onSubmitted: (_) => _submitData(),
        ),
        TextField(
          controller: _datumVremeController,
          decoration: InputDecoration(labelText: "Datum i vreme"),
          keyboardType: TextInputType.datetime,
          onSubmitted: (_) => _submitData(),
        ),
        OutlinedButton(
          child: Text("Dodaj"),
          onPressed: _submitData,
        )
      ]),
    );
  }
}
