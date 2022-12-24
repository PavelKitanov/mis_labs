import 'package:flutter/material.dart';
import './cloth_question.dart';
import './cloth_answer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  void _iWasTapped() {
    setState(() {
      _questionIndex += 1;
    });
    print('I was tapped');
  }

  var questions = [
    {'question':"Select T-shirt brand",
    'answer':['Burberry',  'Calvin Klein', 'Paul&Shark']},

    {'question':"Select jeans brand",
    'answer':['Levi\'s',  'DIESEL', 'Bershka']},

    {'question':"Select sneakers brand",
    'answer':['Nike', 'Adidas', 'Puma']},
  ];
  var _questionIndex = 0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: "Clothes",
     home: Scaffold(
      appBar: AppBar(
        title: Text("Clothes"), 
      ),
      body: Column(
        children: [
          ClothQuestion(questions[_questionIndex]['question'] as String),
          ...(questions[_questionIndex]['answer'] as List<String>).map((answer) {
            return ClothAnswer(_iWasTapped, answer);
          }),
        ],
      )
     )
    );
  }
}

