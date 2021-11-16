import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/models/product.dart';

// ignore: must_be_immutable
class Recomends extends StatelessWidget {
  Recomends({Key? key, required this.productos, required this.viewDetail})
      : super(key: key);

  final Function viewDetail;
  List<Product> productos = <Product>[];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: productos.map((producto) {
          return RecomendPlantCard(
            country: "Perú",
            product: producto,
            press: viewDetail,
          );
        }).toList(),
      ),
    );
  }
}

class RecomendPlantCard extends StatelessWidget {
  const RecomendPlantCard(
      {Key? key, this.country, required this.press, required this.product})
      : super(key: key);

  final String? country;
  final Function press;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding * 2.5,
      ),
      decoration: BoxDecoration(
          color: kPrimaryColor, borderRadius: BorderRadius.circular(10)),
      width: 180,
      height: 300,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            alignment: Alignment.centerRight,
            child: Column(
              children: [
                const Text(
                  "FROM",
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                  textAlign: TextAlign.start,
                ),
                Text(
                  product.getPrice(),
                  style: const TextStyle(fontSize: 15, color: kPrimaryWhite),
                  textAlign: TextAlign.start,
                  softWrap: true,
                  maxLines: 1,
                  textWidthBasis: TextWidthBasis.parent,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          product.image != null
              ? Image.network(
                  product.image!,
                  height: 150,
                )
              : Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.0),
                    color: kPrimaryColor,
                  ),
                ),
          GestureDetector(
            onTap: () => press(6, product),
            child: Container(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              height: 50,
              decoration: BoxDecoration(
                color: kPrimaryColor,
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
              child: Container(
                margin: const EdgeInsets.only(right: 1.5),
                alignment: Alignment.centerLeft,
                child: Text(
                  product.getName().toUpperCase(),
                  style: const TextStyle(fontSize: 13.5, color: kPrimaryWhite),
                  textAlign: TextAlign.start,
                  softWrap: true,
                  maxLines: 2,
                  textWidthBasis: TextWidthBasis.parent,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => press(6, product),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4),
                    child:
                        const Icon(Icons.info_outline, color: Colors.white60),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.white60, width: 0.8)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
