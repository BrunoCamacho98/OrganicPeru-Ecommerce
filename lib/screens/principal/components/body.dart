import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/models/product.dart';
import 'package:organic/screens/principal/components/recommend.dart';
import 'package:organic/screens/principal/components/title_with_more_bbtn.dart';
import 'package:organic/util/queries/product/product_query.dart';

class Body extends StatefulWidget {
  final Function viewDetail;

  const Body({Key? key, required this.viewDetail}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _BodyState createState() => _BodyState(viewDetail: viewDetail);
}

class _BodyState extends State<Body> {
  _BodyState({required this.viewDetail});

  final ProductQuery productQuery = ProductQuery();
  final Function viewDetail;

  List<Product> productos = <Product>[];

  bool loadingScreen = true;

  @override
  void initState() {
    setState(() {
      productQuery.getProducts().then((productos) {
        setState(() {
          this.productos.addAll(productos);
        });
      });

      // ignore: unnecessary_this
      this.loadingScreen = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Provee el tamaño total (height y width) de la pantalla
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Text(
              'Hi Organic',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                  fontSize: 28),
            ),
          ),
          // : HeaderWithSearchBox(size: size),
          TitleWithMoreBtn(title: "Recomendado", press: () {}),
          Recomends(productos: productos, viewDetail: viewDetail),
          TitleWithMoreBtn(title: "Destacados", press: () {}),
          Recomends(productos: productos, viewDetail: viewDetail),
          // const Featured(),
          const SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}
