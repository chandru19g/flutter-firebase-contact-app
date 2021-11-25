import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../model/contact.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditContact extends StatefulWidget {
  final String id;
  const EditContact(this.id, {Key? key}) : super(key: key);

  @override
  _EditContactState createState() => _EditContactState(id);
}

class _EditContactState extends State<EditContact> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  String id;
  _EditContactState(this.id);

  String _firstName = "";
  String _lastName = "";
  String _phone = "";
  String _email = "";
  String _address = "";
  String? _photoUrl;

  final TextEditingController _fnController = TextEditingController();
  final TextEditingController _lnController = TextEditingController();
  final TextEditingController _poController = TextEditingController();
  final TextEditingController _emController = TextEditingController();
  final TextEditingController _adController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getContact(id);
  }

  getContact(id) async {
    Contact contact;

    _databaseReference.child(id).onValue.listen((event) {
      contact = Contact.fromSnapshot(event.snapshot);

      _fnController.text = contact.firstName;
      _lnController.text = contact.lastName;
      _poController.text = contact.phone;
      _emController.text = contact.email;
      _adController.text = contact.address;

      setState(() {
        _firstName = contact.firstName;
        _lastName = contact.lastName;
        _email = contact.email;
        _address = contact.address;
        _phone = contact.phone;
        _photoUrl = contact.photoUrl;

        isLoading = false;
      });
    });
  }

  updateContact(BuildContext context) async {
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _email.isNotEmpty &&
        _phone.isNotEmpty &&
        _address.isNotEmpty) {
      Contact contact = Contact.withId(
          id, _firstName, _lastName, _phone, _email, _address, _photoUrl!);
      await _databaseReference.child(id).set(contact.toJson());
      navigateToLastScreen(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Field Required'),
            content: const Text('All fields are required'),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future pickImage() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200.0,
      maxWidth: 200.0,
    );

    File file = File(pickedFile!.path);

    String fileName = basename(file.path);
    uploadImage(file, fileName);
  }

  void uploadImage(File file, String fileName) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);

    final result = await storageReference.putFile(file);
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      _photoUrl = fileUrl;
    });
  }

  navigateToLastScreen(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Contact"),
      ),
      body: Container(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    //image view
                    Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            pickImage();
                          },
                          child: Center(
                            child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _photoUrl == "empty"
                                          ? const AssetImage("images/logo.png")
                                              as ImageProvider
                                          : NetworkImage(_photoUrl!),
                                    ))),
                          ),
                        )),
                    //
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _firstName = value;
                          });
                        },
                        controller: _fnController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _lastName = value;
                          });
                        },
                        controller: _lnController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        controller: _poController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        controller: _emController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _address = value;
                          });
                        },
                        controller: _adController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    // update button
                    Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(
                              100.0, 20.0, 100.0, 20.0),
                          primary: Colors.red,
                        ),
                        onPressed: () {
                          updateContact(context);
                        },
                        child: const Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
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
