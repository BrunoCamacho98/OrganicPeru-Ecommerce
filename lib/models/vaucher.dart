import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Vaucher {
  String? id;
  late String code;
  String? idSale;

  DocumentReference? reference;

  Vaucher({this.id, required this.code, this.idSale});

  factory Vaucher.fromSnapshot(QueryDocumentSnapshot snapshot) {
    Vaucher newDetailSale =
        Vaucher.fromJson(snapshot.data() as Map<String, dynamic>);
    newDetailSale.reference = snapshot.reference;
    return newDetailSale;
  }

  factory Vaucher.fromJson(Map<String, dynamic> json) =>
      _detailSaleFromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['idSale'] = idSale;
    data['code'] = code;
    return data;
  }

  Vaucher.fromSnapShot(DataSnapshot snapshot) {
    id = snapshot.key;
    idSale = snapshot.value['idSale'];
    code = snapshot.value['code'];
  }

  toMapString() {
    Map<String, dynamic> map = {
      'id': id,
      'idSale': idSale,
      'code': code,
    };

    return map;
  }
}

Vaucher _detailSaleFromJson(Map<String, dynamic> json) {
  return Vaucher(id: json['id'], idSale: json['idSale'], code: json['code']);
}

toJsonString(Vaucher detail) {
  Map<String, dynamic> map = {
    'id': detail.id,
    'code': detail.hashCode,
    'idSale': detail.idSale
  };

  return map;
}
