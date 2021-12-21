import 'package:flutter/widgets.dart';
// * FIREBASE
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// * MODEL
import 'package:organic/models/product.dart';
import 'package:organic/models/user.dart';

class ProductQuery with ChangeNotifier {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final CollectionReference productReference =
      FirebaseFirestore.instance.collection("Product");

  Future<List<Product>> getProducts() async {
    QuerySnapshot products =
        await FirebaseFirestore.instance.collection('Product').get();

    List<Product> productList = [];

    // * Guardado de los datos en Firestore en una lista de Productos
    if (products.docs.isNotEmpty) {
      for (var doc in products.docs) {
        productList.add(Product.fromSnapshot(doc));
      }
    }

    notifyListeners();

    return productList;
  }

  Future<List<Product>> getProductsByUser(UserLogin user) async {
    QuerySnapshot products = await FirebaseFirestore.instance
        .collection('Product')
        // * Filtrado mediante id del usuario
        .where('userId', isEqualTo: user.uid)
        .get();

    List<Product> productList = [];

    // * Guardado de los datos en Firestore en una lista de Productos
    if (products.docs.isNotEmpty) {
      for (var doc in products.docs) {
        productList.add(Product.fromSnapshot(doc));
      }
    }

    notifyListeners();

    return productList;
  }

  Future<Product?> updateProduct(Product producto) async {
    try {
      QuerySnapshot products = await FirebaseFirestore.instance
          .collection('Product')
          .where('id', isEqualTo: producto.id)
          .get();

      Product product = Product();

      if (products.docs.isNotEmpty) {
        for (var doc in products.docs) {
          product = Product.fromSnapshot(doc);
        }
      }

      notifyListeners();

      return product;
    } catch (e) {
      return null;
    }
  }
}
