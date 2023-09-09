import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_lab_4/notification.dart';

import '../Model/exam.dart';
import '../Widgets/nov_element.dart';
import '../auth.dart';
import 'calendar_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<Exam> _userItems = [];

  final User? user = Auth().currentUser;

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Exams');
    fetchData();
    addNotifications();
  }

  void fetchData() {
    dbRef.onChildAdded.listen((data) {
      ExamData examData = ExamData.fromJson(data.snapshot.value as Map);
      Exam exam = Exam(key: data.snapshot.key, examData: examData);
      if (exam.examData!.userId == user!.uid) {
        _userItems.add(exam);
        addNotifications();
      }
      setState(() {});
    });
  }

  void addNotifications() {
    for (Exam exam in _userItems) {
      NotificationService().scheduleNotification(
          title: "Reminder for " + exam.examData!.predmet! + " exam.",
          body: "Exam starting in 30 minutes! Don't be late!",
          date: exam.examData!.startDatum!.subtract(Duration(minutes: 30)));
    }
  }

  void filterDataByUser() {}

  Future<void> signOut() async {
    await Auth().signOut();
  }

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NovElement(_addNewItemToList),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _addNewItemToList(ExamData item) {
    Map<String, dynamic> exams = {
      'predmet': item.predmet,
      'startDatum': item.startDatum.toString(),
      'endDatum': item.endDatum.toString(),
      'userId': item.userId
    };
    dbRef.push().set(exams).then((value) => {Navigator.of(context).pop()});
  }

  void _deleteItem(Exam item) {
    dbRef.child(item.key!).remove().then(
      (value) {
        int index =
            _userItems.indexWhere((element) => element.key == item.key!);
        _userItems.removeAt(index);
      },
    );
    setState(() {
      _userItems.removeWhere((element) => element.key == item.key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Midterms and exams"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CalendarPage(),
                ));
              },
              icon: Icon(Icons.calendar_month)),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _addItemFunction(context)),
          IconButton(
              // Add this IconButton for Sign Out
              icon: Icon(Icons.logout), // You can change the icon as needed
              onPressed: () {
                // Implement your sign-out logic here
                signOut();
              })
        ],
      ),
      body: Center(
        child: _userItems.isEmpty
            ? Text("No midterms or exams")
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    child: ListTile(
                      title: Text(
                          "Subject: ${_userItems[index].examData?.predmet}"),
                      subtitle: Text(
                          "Date: ${_userItems[index].examData?.startDatum.toString().split(" ")[0]} \n"
                          "Start: ${_userItems[index].examData?.start!.format(context)} \n"
                          "End: ${_userItems[index].examData?.end!.format(context)}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteItem(_userItems[index]),
                      ),
                    ),
                  );
                },
                itemCount: _userItems.length,
              ),
      ),
    );
  }
}
