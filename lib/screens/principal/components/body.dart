import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/models/product.dart';
import 'package:organic/screens/principal/components/featured.dart';
import 'package:organic/screens/principal/components/recommend.dart';
import 'package:organic/screens/principal/components/title_with_more_bbtn.dart';
// Components
import 'header_with_seachbox.dart';

class Body extends StatelessWidget {
  Body({Key? key, required this.productos}) : super(key: key);

  List<Product> productos = [];

  @override
  Widget build(BuildContext context) {
    //Provee el tamaño total (height y width) de la pantalla
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWithSearchBox(size: size),
          TitleWithMoreBtn(title: "Recomendado", press: () {}),
          Recomends(productos: productos),
          TitleWithMoreBtn(title: "Destacados", press: () {}),
          const Featured(),
          const SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}
