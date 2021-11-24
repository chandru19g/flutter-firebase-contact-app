import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late User user;
  bool isSignedIn = false;

  checkAuthentication() async {
    _auth.authStateChanges().listen((userData) {
      if (userData == null) {
        Navigator.pushReplacementNamed(context, '/SigninPage');
      }
    });
  }

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        user = firebaseUser!;
        isSignedIn = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(
        child: Center(
          child: !isSignedIn
              ? const CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(50.0),
                      child: const Image(
                        image: AssetImage('images/logo.png'),
                        width: 100.0,
                        height: 100.0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(50.0),
                      child: Text(
                        'Hello, ${user.displayName}, you are logged in as ${user.email}',
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: signOut,
                        child: const Text(
                          'Sign Out',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(
                              100.0, 20.0, 100.0, 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          primary: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
