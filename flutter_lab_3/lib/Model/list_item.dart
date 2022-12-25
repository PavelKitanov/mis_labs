import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ListItem {
  final String id;
  final String predmet;
  final DateTime datum;
  final TimeOfDay vreme;

  ListItem(
      {required this.id,
      required this.predmet,
      required this.datum,
      required this.vreme});
}
