// * SERVICES
import 'package:flutter/material.dart';
import 'package:organic/main.dart';
import 'package:organic/models/product.dart';
import 'package:organic/models/user.dart';
import 'package:organic/screens/principal/components/modal_sale.dart';
// * SCREEN
import 'package:organic/screens/principal/principal.dart';
import 'package:organic/screens/principal/product/detail_product.dart';

// * Go to view Principal.dart
void toPrincipal(BuildContext context, UserLogin? user) async {
  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => Principal(user: user)));
}

// * Go to view Main.dart
void toMain(BuildContext context) async {
  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => const MyApp()));
}

void toDetailProduct(BuildContext context, Product product) async {
  await Navigator.push(context,
      MaterialPageRoute(builder: (context) => DetailProduct(product: product)));
}

void showSaleModal(BuildContext context, UserLogin user, Product producto) {
  showDialog(
      context: context,
      builder: (buildcontext) {
        return ModalSales(producto: producto, user: user);
      });
}
