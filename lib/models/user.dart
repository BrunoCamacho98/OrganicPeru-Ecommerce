import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class UserLogin {
  String? id;
  String? name;
  String? dni;
  String? address;
  String? email;
  String? uid;
  String? type;

  DocumentReference? reference;

  UserLogin(
      {this.id,
      this.name,
      this.dni,
      this.address,
      this.email,
      this.uid,
      this.type,
      this.reference});

  factory UserLogin.fromSnapshot(QueryDocumentSnapshot snapshot) {
    UserLogin newUser =
        UserLogin.fromJson(snapshot.data() as Map<String, dynamic>);
    newUser.reference = snapshot.reference;
    return newUser;
  }

  factory UserLogin.fromJson(Map<String, dynamic> json) => _userFromJson(json);

  toMapString() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'dni': dni,
      'uid': uid,
      'type': type
    };

    return map;
  }

  getName() {
    return name;
  }

  getDNI() {
    return dni ?? "";
  }

  getEmail() {
    return email;
  }

  getAddress() {
    return address ?? "";
  }

  getType() {
    return type;
  }

  getUID() {
    return uid;
  }

  UserLogin.fromSnapShot(DataSnapshot snapshot) {
    id = snapshot.key;
    name = snapshot.value['name'];
    email = snapshot.value['email'];
    dni = snapshot.value['dni'];
    address = snapshot.value['address'];
    uid = snapshot.value['uid'];
    type = snapshot.value['type'];
  }
}

UserLogin _userFromJson(Map<String, dynamic> json) {
  return UserLogin(
      id: json['id'],
      name: json['name'],
      uid: json['uid'],
      email: json['email'],
      address: json['address'],
      dni: json['dni'],
      type: json['type']);
}
