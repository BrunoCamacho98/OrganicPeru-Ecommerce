import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:organic/models/product.dart';
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

  List<Product> products = [];

  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('Product')
      .snapshots(includeMetadataChanges: true);

  UploadTask? task;

  @override
  void initState() {
    super.initState();
    getProducts().then((value) {
      setState(() {
        products = value;
      });
    });
  }

  Future<List<Product>> getProducts() async {
    QuerySnapshot products = await FirebaseFirestore.instance
        .collection('Product')
        .where('userId', isEqualTo: user?.uid)
        .get();

    List<Product> productList = [];

    if (products.docs.isNotEmpty) {
      for (var doc in products.docs) {
        productList.add(Product.fromSnapshot(doc));
      }
    }

    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    child: Text(
                      'Mis Productos',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: products.isNotEmpty
                          ? products.map((product) {
                              return ProductCard(product: product);
                            }).toList()
                          : [
                              Container(
                                child: const Text("No tiene productos"),
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                              )
                            ]),
                ],
              ),
            ),
          );
        });
  }
}
