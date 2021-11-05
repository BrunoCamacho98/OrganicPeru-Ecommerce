import 'package:flutter/material.dart';
// * MODEL
import 'package:organic/models/product.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  // ignore: no_logic_in_create_state
  _DetailProductState createState() => _DetailProductState(product: product);
}

class _DetailProductState extends State<DetailProduct> {
  _DetailProductState({required this.product});

  final Product product;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
