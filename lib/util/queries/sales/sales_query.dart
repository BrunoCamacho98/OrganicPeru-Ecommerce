// * FIREBASE
import 'package:cloud_firestore/cloud_firestore.dart';
// * MODEL
import 'package:flutter/widgets.dart';
import 'package:organic/models/detail_sale.dart';
import 'package:organic/models/product.dart';

class UserQuery with ChangeNotifier {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final CollectionReference detailSalesReference =
      FirebaseFirestore.instance.collection("DetailSale");

  Future<DetailSale> addDetailSale(
      BuildContext context, Product producto, double amount) async {
    var total = double.parse(producto.getPrice()) * amount;

    DetailSale detailSale = DetailSale(
        id: '',
        idProduct: producto.getId(),
        amount: amount,
        total: total,
        idSale: null);

    detailSalesReference.add(detailSale.toMapString()).then((value) {
      detailSale.id = value.id;
      detailSalesReference.doc(value.id).set(detailSale.toMapString());
    });

    notifyListeners();
    return detailSale;
  }

  // Future<UserLogin> updateUser(UserLogin user) async {
  //   final CollectionReference userReference =
  //       FirebaseFirestore.instance.collection("Users");

  //   userReference.doc(user.id).update(user.toMapString());

  //   return user;
  // }
}
