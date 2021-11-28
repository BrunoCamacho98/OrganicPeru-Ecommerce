import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:organic/models/product.dart';

class DetailSale {
  String? id;
  late String idProduct;
  late double amount;
  late double total;
  String? idSale;
  Product? product;

  DocumentReference? reference;

  DetailSale(
      {this.id,
      required this.idProduct,
      required this.amount,
      required this.total,
      this.product,
      this.idSale,
      this.reference});

  factory DetailSale.fromSnapshot(QueryDocumentSnapshot snapshot) {
    DetailSale newDetailSale =
        DetailSale.fromJson(snapshot.data() as Map<String, dynamic>);
    newDetailSale.reference = snapshot.reference;
    return newDetailSale;
  }

  factory DetailSale.fromJson(Map<String, dynamic> json) =>
      _detailSaleFromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['idProduct'] = idProduct;
    data['amount'] = amount;
    data['total'] = total;
    data['idSale'] = idSale;
    return data;
  }

  getTotal() {
    return total;
  }

  getTotalFormatted() {
    return 'S/ ' + total.toString();
  }

  getAmount() {
    return amount;
  }

  getAmountFormatted() {
    return amount.toString() + 'kg';
  }

  DetailSale.fromSnapShot(DataSnapshot snapshot) {
    id = snapshot.key;
    idProduct = snapshot.value['idProduct'];
    amount = snapshot.value['amount'];
    total = snapshot.value['total'];
    idSale = snapshot.value['idSale'];
  }

  toMapString() {
    Map<String, dynamic> map = {
      'id': id,
      'idProduct': idProduct,
      'amount': amount,
      'total': total,
      'idSale': idSale
    };

    return map;
  }
}

DetailSale _detailSaleFromJson(Map<String, dynamic> json) {
  return DetailSale(
      id: json['id'],
      idSale: json['idSale'],
      idProduct: json['idProduct'],
      amount: json['amount'],
      total: json['total']);
}

toJsonString(DetailSale detail) {
  Map<String, dynamic> map = {
    'id': detail.id,
    'idProduct': detail.idProduct,
    'amount': detail.amount,
    'total': detail.total,
    'idSale': detail.idSale
  };

  return map;
}
