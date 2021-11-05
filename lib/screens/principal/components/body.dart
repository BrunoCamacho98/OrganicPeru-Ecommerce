import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/models/product.dart';
import 'package:organic/screens/principal/components/featured.dart';
import 'package:organic/screens/principal/components/recommend.dart';
import 'package:organic/screens/principal/components/title_with_more_bbtn.dart';
import 'package:organic/util/queries/product/product_query.dart';
// Components
import 'header_with_seachbox.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ProductQuery productQuery = ProductQuery();

  List<Product> productos = [];

  bool loadingScreen = true;

  @override
  void initState() {
    super.initState();

    setState(() {
      productQuery.getProducts().then((value) => value.forEach((element) {
            productos.add(element);
          }));
      loadingScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Provee el tamaño total (height y width) de la pantalla
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          loadingScreen
              ? const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.blueAccent,
                )
              : HeaderWithSearchBox(size: size),
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
