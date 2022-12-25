import 'package:flutter/material.dart';
import 'Model/list_item.dart';
import 'Widgets/nov_element.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Midterms and exams',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListItem> _userItems = [];

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

  void _addNewItemToList(ListItem item) {
    setState(() {
      _userItems.add(item);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _userItems.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Midterms and exams"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add), onPressed: () => _addItemFunction(context))
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
                      title: Text("Predmet: ${_userItems[index].predmet}"),
                      subtitle: Text(
                          "Datum: ${_userItems[index].datum.toString().split(" ")[0]} Vreme: ${_userItems[index].vreme.format(context)}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteItem(_userItems[index].id),
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
