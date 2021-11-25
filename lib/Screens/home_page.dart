import 'package:flutter/material.dart';
import 'add_contact.dart';
import 'view_contact.dart';
import 'edit_contact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  navigateToAddScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const AddContact();
    }));
  }

  navigateToViewScreen(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewContact(id);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact App"),
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: _databaseReference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return GestureDetector(
              onTap: () {
                navigateToViewScreen(snapshot.key);
              },
              child: Card(
                color: Colors.white,
                elevation: 2.0,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: snapshot.value['photoUrl'] == "empty"
                                  ? const AssetImage('images/logo.png')
                                      as ImageProvider
                                  : NetworkImage(snapshot.value['photoUrl']),
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${snapshot.value['firstName']} ${snapshot.value['lastName']}",
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("${snapshot.value['phone']}")
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
