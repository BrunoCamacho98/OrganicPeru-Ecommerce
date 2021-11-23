import 'package:cloud_firestore/cloud_firestore.dart';

class CreditCard {
  String? type;
  String? number;
  String? cvv;
  String? name;
  String? dueDate;

  DocumentReference? reference;

  CreditCard(
      {this.type,
      this.number,
      this.cvv,
      this.name,
      this.dueDate,
      this.reference});
}
