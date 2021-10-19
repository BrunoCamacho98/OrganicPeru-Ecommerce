import 'package:flutter/material.dart';
import 'package:organic/screens/principal/product/product_card.dart';

class ListProduct extends StatelessWidget {
  ListProduct({this.products});

  final List? products;

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
