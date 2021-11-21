import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/models/product.dart';
import 'package:organic/models/user.dart';
import 'package:organic/screens/principal/components/recommend.dart';
import 'package:organic/screens/principal/components/title_with_more_bbtn.dart';
import 'package:organic/util/queries/product/product_query.dart';

class Body extends StatefulWidget {
  final Function viewDetail;
  final UserLogin user;

  const Body({Key? key, required this.viewDetail, required this.user})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _BodyState createState() => _BodyState(viewDetail: viewDetail, user: user);
}

class _BodyState extends State<Body> {
  _BodyState({required this.viewDetail, required this.user});

  final ProductQuery productQuery = ProductQuery();
  final Function viewDetail;
  final UserLogin user;

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
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Hola ',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Montserrat',
                        fontSize: 25),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      user.getName(),
                      softWrap: true,
                      maxLines: 1,
                      textWidthBasis: TextWidthBasis.longestLine,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Montserrat',
                          fontSize: 28),
                    ),
                  ),
                ],
              )),
          // : HeaderWithSearchBox(size: size),
          TitleWithMoreBtn(title: "Recomendado", press: () {}),
          Recomends(user: user, productos: productos, viewDetail: viewDetail),
          TitleWithMoreBtn(title: "Destacados", press: () {}),
          Recomends(user: user, productos: productos, viewDetail: viewDetail),
          // const Featured(),
          const SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}
