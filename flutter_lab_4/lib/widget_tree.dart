import 'package:flutter_lab_4/auth.dart';
import 'package:flutter_lab_4/Pages/login_register_page.dart';
import 'package:flutter/material.dart';

import 'Pages/my_home_page.dart';


class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}