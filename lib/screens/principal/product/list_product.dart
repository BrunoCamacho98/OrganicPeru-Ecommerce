import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organic/screens/principal/product/product_card.dart';

class ListProduct extends StatefulWidget {
  final User? user;

  ListProduct({this.user});

  @override
  _ListProductState createState() => _ListProductState(user: user);
}

class _ListProductState extends State<ListProduct> {
  _ListProductState({this.user});

  final User? user;

  List products = [];

  CollectionReference productReference =
      FirebaseFirestore.instance.collection('Product');

  @override
  void initState() {
    super.initState();
    getProducts().then((value) {
      setState(() {
        products = value;
      });
    });
  }

  Future<List> getProducts() async {
    QuerySnapshot products =
        await productReference.where('userId', isEqualTo: user?.uid).get();

    List productList = [];

    if (products.docs.length != 0) {
      for (var doc in products.docs) {
        productList.add(doc.get('name'));
      }
    }

    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Text(
                'Mis Productos',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: (products as List).isNotEmpty
                  ? (products as List).map((respo) {
                      return ProductCard(title: respo);
                    }).toList()
                  : const <Widget>[
                      ProductCard(title: "prueba"),
                      ProductCard(title: "prueba"),
                    ],
            ),
          ],
        ),
      ),
    );
  }
}
