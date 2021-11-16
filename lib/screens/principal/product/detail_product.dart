import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
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
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          alignment: Alignment.topLeft,
          height: size.height,
          width: size.width,
          color: kPrimaryColor,
        ),
        Positioned(
          top: 50,
          left: 15,
          width: size.width * 0.43,
          height: size.height * 0.38,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "DESDE",
                    style: TextStyle(fontSize: 14, color: Colors.white54),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.getPrice(),
                    style: const TextStyle(fontSize: 19, color: kPrimaryWhite),
                    textAlign: TextAlign.start,
                    softWrap: true,
                    maxLines: 1,
                    textWidthBasis: TextWidthBasis.parent,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "STOCK",
                    style: TextStyle(fontSize: 14, color: Colors.white54),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.getWeight() + ' Kg',
                    style: const TextStyle(fontSize: 19, color: kPrimaryWhite),
                    textAlign: TextAlign.start,
                    softWrap: true,
                    maxLines: 1,
                    textWidthBasis: TextWidthBasis.parent,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.center,
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.black87,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.production_quantity_limits_rounded,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          width: size.width,
          top: 40,
          left: 30,
          child: Text(
            product.getName(),
            style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        Positioned(
          top: size.height * 0.45,
          width: size.width,
          height: size.height * 0.5,
          child: Container(
            height: size.height * 0.5,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Descripción",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    product.getDescription(),
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                    textAlign: TextAlign.start,
                    softWrap: true,
                    maxLines: 1,
                    textWidthBasis: TextWidthBasis.parent,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.12,
          right: 20,
          width: size.width * 0.5,
          height: size.height * 0.4,
          child: product.image != null
              // * Imagen del producto, mediante el enlace guardado al crearlo
              ? Image.network(
                  product.image!,
                  width: 100,
                  height: 100,
                )
              // * En caso no tenga una imagen guardada aparecerá este elemento
              : Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.grey,
                  ),
                ),
        ),
      ],
    );
  }
}
