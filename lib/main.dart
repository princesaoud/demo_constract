import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Constract',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Demo Constract'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Contracts")
              .orderBy('updated', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print(snapshot.data.toString());
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> data = snapshot.data.docs;
              return GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 4,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(snapshot.data.docs.length, (index) {
                  return Center(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            Card(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: ListTile(
                                      title: Text(
                                        "Titre: ${data[index].data()['title']}",
                                        textAlign: TextAlign.center,
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Text(
                                              "Description: ${data[index].data()['description']}"),
                                          Text(
                                            "Prix : ${data[index].data()['prix']} F CFA",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (data[index].data()['etat'] == 0)
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Card(
                                          color: Colors.green,
                                          child: TextButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection("Contracts")
                                                    .doc(data[index]
                                                        .data()['key'])
                                                    .set({
                                                  'etat': 1
                                                }, SetOptions(merge: true));
                                              },
                                              child: Text(
                                                'Valider',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        )),
                                        Expanded(
                                            child: Card(
                                          color: Colors.red,
                                          child: TextButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection("Contracts")
                                                    .doc(data[index]
                                                        .data()['key'])
                                                    .set({
                                                  'etat': 2
                                                }, SetOptions(merge: true));
                                              },
                                              child: Text('Refuser',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ))
                                      ],
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Text("Snapshot has no data"),
              );
            }
          }),
    );
  }
}
