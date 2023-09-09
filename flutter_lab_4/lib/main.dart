import 'package:flutter/material.dart';
import 'package:flutter_lab_4/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  NotificationService().initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Midterms and exams',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WidgetTree(),
    );
  }
}

