import 'package:firebase_database/firebase_database.dart';

class Contact {
  String? nid;
  String nfirstName;
  String nlastName;
  String nphone;
  String nemail;
  String naddress;
  String nphotoUrl;

  // Constructor for add
  Contact(this.nfirstName, this.nlastName, this.nphone, this.nemail,
      this.naddress, this.nphotoUrl);

  // Constructor for edit
  Contact.withId(this.nid, this.nfirstName, this.nlastName, this.nphone,
      this.nemail, this.naddress, this.nphotoUrl);

  // Getters
  String get id => nid!;
  String get firstName => nfirstName;
  String get lastName => nlastName;
  String get phone => nphone;
  String get email => nemail;
  String get address => naddress;
  String get photoUrl => nphotoUrl;

  // Setters
  set firstName(String firstName) {
    this.firstName = firstName;
  }

  set lastName(String lastName) {
    this.lastName = lastName;
  }

  set phone(String phone) {
    this.phone = phone;
  }

  set email(String email) {
    this.email = email;
  }

  set address(String address) {
    this.address = address;
  }

  set photoUrl(String photoUrl) {
    this.photoUrl = photoUrl;
  }

  static Contact fromSnapshot(DataSnapshot snapshot) => Contact.withId(
      snapshot.key!,
      snapshot.value['firstName'],
      snapshot.value['lastName'],
      snapshot.value['phone'],
      snapshot.value['email'],
      snapshot.value['address'],
      snapshot.value['photoUrl']);

  Map<String, dynamic> toJson() {
    return {
      "firstName": nfirstName,
      "lastName": nlastName,
      "phone": nphone,
      "email": nemail,
      "address": naddress,
      "photoUrl": nphotoUrl
    };
  }
}
