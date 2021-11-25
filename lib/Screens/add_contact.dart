import 'package:firebase_storage/firebase_storage.dart';

import '../model/contact.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';
  String _address = '';
  String _photoUrl = "empty";

  saveContact(BuildContext context) async {
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _phone.isNotEmpty &&
        _email.isNotEmpty &&
        _address.isNotEmpty) {
      Contact contact =
          Contact(_firstName, _lastName, _phone, _email, _address, _photoUrl);

      await _databaseReference.push().set(contact.toJson());

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

    print("$storageReference");

    storageReference.putFile(file).whenComplete(() {
      var downloadUrl = storageReference.getDownloadURL();

      print("downloadUrl $downloadUrl");

      setState(() {
        _photoUrl = downloadUrl.toString();
      });
    });
  }

  navigateToLastScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
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
                            ? const AssetImage('images/logo.png')
                                as ImageProvider
                            : NetworkImage(_photoUrl),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // First Name
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _firstName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            // Last Name
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _lastName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            // Phone
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _phone = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            // Email
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            // Address
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _address = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            // Save
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: const EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                ),
                onPressed: () {
                  saveContact(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
