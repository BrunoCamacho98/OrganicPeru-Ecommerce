import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organic/screens/principal/product/product_card.dart';

class ListProduct extends StatelessWidget {
  ListProduct({this.user, Key? key}) : super(key: key);

  final User? user;

  List products = [];

  CollectionReference productReference =
      FirebaseFirestore.instance.collection('Product');

  // Future<List> getProducts() async {
  //   QuerySnapshot products =
  //       await productReference.where('userId', isEqualTo: user?.uid).get();

  //   List productList = [];

  //   if (products.docs.length != 0) {
  //     for (var doc in products.docs) {
  //       productList.add(doc.data());
  //     }
  //   }
  // }

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
              children: const <Widget>[
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
