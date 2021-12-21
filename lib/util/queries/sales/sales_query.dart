// * FIREBASE

import 'package:cloud_firestore/cloud_firestore.dart';
// * MODEL
import 'package:flutter/widgets.dart';
import 'package:organic/models/detail_sale.dart';
import 'package:organic/models/product.dart';
import 'package:organic/models/sale.dart';
import 'package:organic/models/user.dart';
import 'package:organic/models/vaucher.dart';
import 'package:organic/util/queries/product/product_query.dart';
import 'package:organic/util/queries/user/user_query.dart';

class SaleQuery with ChangeNotifier {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final CollectionReference detailSalesReference =
      FirebaseFirestore.instance.collection("DetailSale");

  final CollectionReference salesReference =
      FirebaseFirestore.instance.collection("Sales");

  final CollectionReference vaucherReference =
      FirebaseFirestore.instance.collection("Vaucher");

  final CollectionReference productReference =
      FirebaseFirestore.instance.collection("Product");

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

  Future<List<DetailSale>> getDetailSaleListBySaleId(String saleId) async {
    List<DetailSale> detailSaleList = [];

    QuerySnapshot detailSales =
        await detailSalesReference.where('idSale', isEqualTo: saleId).get();

    if (detailSales.docs.isNotEmpty) {
      for (var doc in detailSales.docs) {
        DetailSale detailsale = DetailSale.fromSnapshot(doc);
        Product? product;
        QuerySnapshot products = await productReference
            .where('id', isEqualTo: detailsale.idProduct)
            .get();

        if (products.docs.isNotEmpty) {
          for (var doc in products.docs) {
            product = Product.fromSnapshot(doc);
          }
        }

        detailsale.product = product;

        detailSaleList.add(detailsale);
      }
    }

    return detailSaleList;
  }

  Future<List<DetailSale>> getDetailSaleListBySaleIdAndProductList(
      String saleId, List<Product> productList) async {
    List<DetailSale> detailSaleList = [];

    QuerySnapshot detailSales =
        await detailSalesReference.where('idSale', isEqualTo: saleId).get();

    if (detailSales.docs.isNotEmpty) {
      for (var doc in detailSales.docs) {
        DetailSale detailsale = DetailSale.fromSnapshot(doc);

        Product? product;
        QuerySnapshot products = await productReference
            .where('id', isEqualTo: detailsale.idProduct)
            .get();

        if (products.docs.isNotEmpty) {
          for (var doc in products.docs) {
            product = Product.fromSnapshot(doc);
          }
        }

        List<Product> productListFind = productList
            .where((producto) => producto.id == product!.id)
            .toList();

        if (productListFind.isNotEmpty) {
          detailsale.product = product;
          detailSaleList.add(detailsale);
        }
      }
    }

    return detailSaleList;
  }

  Vaucher addVaucher(BuildContext context, Sale sale, String code) {
    sale.detailSaleList = [];

    Vaucher vaucher = Vaucher(idSale: sale.id, code: code);

    vaucherReference.add(vaucher.toMapString()).then((value) async {
      vaucher.id = value.id;
      vaucherReference.doc(value.id).set(vaucher.toMapString());
    });

    return vaucher;
  }

  Future<List<Sale>> getSalesByUser(UserLogin user) async {
    QuerySnapshot sales = await FirebaseFirestore.instance
        .collection('Sales')
        // * Filtrado mediante id del usuario
        .where('idUsuario', isEqualTo: user.id)
        .get();

    List<Sale> salesList = [];

    // * Guardado de los datos en Firestore en una lista de Productos
    if (sales.docs.isNotEmpty) {
      for (var doc in sales.docs) {
        Sale sale = Sale.fromSnapshot(doc);

        sale.detailSaleList = await getDetailSaleListBySaleId(doc.id);
        salesList.add(sale);
      }
    }

    notifyListeners();

    return salesList;
  }

  Future<List<Sale>> getSalesByUserProductsAndDate(
      UserLogin user, DateTime date) async {
    ProductQuery productQuery = ProductQuery();
    UserQuery userQuery = UserQuery();

    List<Product> productListByUser =
        await productQuery.getProductsByUser(user);

    if (productListByUser.isEmpty) return [];

    QuerySnapshot sales =
        await FirebaseFirestore.instance.collection('Sales').get();

    List<Sale> salesList = [];

    // * Guardado de los datos en Firestore en una lista de Productos
    if (sales.docs.isNotEmpty) {
      for (var doc in sales.docs) {
        Sale sale = Sale.fromSnapshot(doc);

        DateTime dateSale = DateTime.parse(sale.dateSale);

        if (dateSale.day == date.day &&
            dateSale.month == date.month &&
            dateSale.year == date.year) {
          List<DetailSale> detailSaleList =
              await getDetailSaleListBySaleIdAndProductList(
                  doc.id, productListByUser);

          if (detailSaleList.isNotEmpty) {
            sale.user = await userQuery.getUserById(sale.idUsuario);
            sale.detailSaleList = detailSaleList;
            salesList.add(sale);
          }
        }
      }
    }

    notifyListeners();

    return salesList;
  }
}
