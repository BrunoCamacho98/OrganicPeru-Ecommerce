import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:organic/models/creditcard.dart';
import 'package:organic/models/detail_sale.dart';
import 'package:organic/models/user.dart';

class Sale {
  String? id;
  late String idUsuario;
  late String address;
  late String dateSale;
  late String state;
  late String type;
  late String number;
  late String cvv;
  late String name;
  late String dueDate;
  late double total;
  late String email;
  List<DetailSale>? detailSaleList;
  UserLogin? user;

  DocumentReference? reference;

  Sale(
      {this.id,
      required this.idUsuario,
      required this.address,
      required this.dateSale,
      required this.state,
      required this.type,
      required this.number,
      required this.cvv,
      required this.name,
      required this.dueDate,
      required this.total,
      required this.email,
      this.detailSaleList,
      this.user,
      this.reference});

  factory Sale.fromSnapshot(QueryDocumentSnapshot snapshot) {
    Sale newSale = Sale.fromJson(snapshot.data() as Map<String, dynamic>);
    newSale.reference = snapshot.reference;
    return newSale;
  }

  factory Sale.fromJson(Map<String, dynamic> json) => _saleFromJson(json);

  getCreditCard() {
    CreditCard credit = CreditCard(
        type: type, cvv: cvv, name: name, number: number, dueDate: dueDate);
    return credit;
  }

  getTotal() {
    return 'S/ ' + total.toString();
  }

  getTax() {
    var tax = total * 0.15;

    return 'S/ ' + tax.toString();
  }

  getTotalWithTax() {
    var tax = total + (total * 0.15).roundToDouble();

    return 'S/ ' + tax.toString();
  }

  getAdress() {
    return address;
  }

  getDate() {
    return DateTime.parse(dateSale);
  }

  getUserName() {
    return user!.getName();
  }

  getDateFormatted() {
    DateTime date = DateTime.parse(dateSale);

    int day = date.day;
    int month = date.month;
    int year = date.year;

    return (day >= 10 ? '' : '0') +
        day.toString() +
        '/' +
        (month >= 10 ? '' : '0') +
        month.toString() +
        '/' +
        year.toString();
  }

  getState() {
    return state;
  }

  Sale.fromSnapShot(DataSnapshot snapshot) {
    id = snapshot.key!;
    idUsuario = snapshot.value['name'];
    address = snapshot.value['address'];
    dateSale = snapshot.value['dateSale'];
    state = snapshot.value['state'];
    type = snapshot.value['type'];
    number = snapshot.value['number'];
    cvv = snapshot.value['cvv'];
    name = snapshot.value['name'];
    dueDate = snapshot.value['dueDate'];
    total = snapshot.value['total'];
    email = snapshot.value['email'];
  }

  toMapString() {
    Map<String, dynamic> map = {
      'id': id,
      'idUsuario': idUsuario,
      'address': address,
      'dateSale': dateSale,
      'state': state,
      'type': type,
      'number': number,
      'cvv': cvv,
      'name': name,
      'dueDate': dueDate,
      'total': total,
      'email': email
    };

    return map;
  }
}

Sale _saleFromJson(Map<String, dynamic> json) {
  return Sale(
      id: json['id'],
      idUsuario: json['idUsuario'],
      address: json['address'],
      dateSale: json['dateSale'],
      state: json['state'],
      type: json['type'],
      number: json['number'],
      cvv: json['cvv'],
      name: json['name'],
      dueDate: json['dueDate'],
      email: json['email'],
      total: json['total']);
}
