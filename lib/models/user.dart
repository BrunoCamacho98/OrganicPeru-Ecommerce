import 'package:firebase_database/firebase_database.dart';

class User {
  String? id;
  String? name;
  String? dni;
  String? address;
  String? email;
  String? uid;

  User({this.id, this.name, this.dni, this.address, this.email, this.uid});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    dni = json['dni'];
    address = json['address'];
    uid = json['uid'];
  }

  getName() {
    return name;
  }

  getDNI() {
    return dni;
  }

  getEmail() {
    return email;
  }

  getAddress() {
    return address;
  }

  getUID() {
    return uid;
  }

  User.fromSnapShot(DataSnapshot snapshot) {
    id = snapshot.key;
    name = snapshot.value['name'];
    email = snapshot.value['email'];
    dni = snapshot.value['dni'];
    address = snapshot.value['address'];
    uid = snapshot.value['uid'];
  }
}
