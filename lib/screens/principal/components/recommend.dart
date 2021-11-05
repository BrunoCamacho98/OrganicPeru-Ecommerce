import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/methods/global_methods.dart';
import 'package:organic/models/product.dart';

class Recomends extends StatelessWidget {
  Recomends({Key? key, required this.productos}) : super(key: key);

  List<Product> productos = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: productos.map((producto) {
          return RecomendPlantCard(
            image: producto.image,
            title: producto.name,
            country: "Perú",
            price: producto.getPrice(),
            product: producto,
            press: () {
              toDetailProduct(context, producto);
            },
          );
        }).toList(),
      ),
    );
  }
}

class RecomendPlantCard extends StatelessWidget {
  const RecomendPlantCard(
      {Key? key,
      this.image,
      this.title,
      this.country,
      this.price,
      this.press,
      required this.product})
      : super(key: key);

  final String? image, title, country;
  final String? price;
  final Function? press;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding * 2.5,
      ),
      width: 180,
      height: 300,
      child: Column(
        children: <Widget>[
          product.image != null
              ? Image.network(
                  product.image!,
                  height: 240,
                )
              : Image.asset(
                  "assets/images/saco-organic.jpeg",
                  height: 240,
                ),
          GestureDetector(
            onTap: () async => toDetailProduct(context, product),
            child: Container(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 1.5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title!.toUpperCase(),
                      style: const TextStyle(fontSize: 13),
                      textAlign: TextAlign.start,
                      softWrap: true,
                      maxLines: 2,
                      textWidthBasis: TextWidthBasis.parent,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: 58,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      price!,
                      style:
                          const TextStyle(fontSize: 13.5, color: kPrimaryColor),
                      textAlign: TextAlign.start,
                      softWrap: true,
                      maxLines: 1,
                      textWidthBasis: TextWidthBasis.parent,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
