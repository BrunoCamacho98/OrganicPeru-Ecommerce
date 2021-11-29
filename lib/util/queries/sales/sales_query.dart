// * FIREBASE

import 'package:cloud_firestore/cloud_firestore.dart';
// * MODEL
import 'package:flutter/widgets.dart';
import 'package:organic/models/detail_sale.dart';
import 'package:organic/models/sale.dart';

class SaleQuery with ChangeNotifier {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final CollectionReference detailSalesReference =
      FirebaseFirestore.instance.collection("DetailSale");

  final CollectionReference salesReference =
      FirebaseFirestore.instance.collection("Sales");

  Future<DetailSale> addDetailSaleToDB(
      BuildContext context, DetailSale detailSale, String saleId) async {
    detailSale.idSale = saleId;

    detailSalesReference.add(detailSale.toMapString()).then((value) {
      detailSale.id = value.id;
      detailSalesReference.doc(value.id).set(detailSale.toMapString());
    });

    notifyListeners();
    return detailSale;
  }

  Sale addSale(
      BuildContext context, List<DetailSale> detailSaleList, Sale sale) {
    String saleId = '';
    sale.detailSaleList = [];

    salesReference.add(sale.toMapString()).then((value) async {
      saleId = value.id;
      sale.id = value.id;
      salesReference.doc(value.id).set(sale.toMapString());

      for (var detailSale in detailSaleList) {
        DetailSale detail =
            await addDetailSaleToDB(context, detailSale, saleId);

        sale.detailSaleList!.add(detail);
      }
    });

    return sale;
  }

  List<DetailSale> addDetailSaleToList(
      List<DetailSale> detailSaleList, DetailSale? detailSale) {
    if (detailSale != null) {
      int detailIndex = detailSaleList
          .indexWhere((element) => element.idProduct == detailSale.idProduct);

      if (detailIndex == -1) {
        detailSaleList.add(detailSale);
      } else {
        detailSaleList[detailIndex] = detailSale;
      }
    }

    return detailSaleList;
  }
}
