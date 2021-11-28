// * SERVICES
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// * CONSTANT
import 'package:organic/constants/theme.dart';
// * MODEL
import 'package:organic/models/product.dart';

// ignore: must_be_immutable
class ProductCard extends StatelessWidget {
  // * Parametros de la vista
  // ? key: Clave de la vista, no es necesario colocarle un valor
  // ? Product: Producto que se esta instanciando
  // ? removeProduct: Función para eliminar producto;
  ProductCard(
      {Key? key,
      required this.product,
      required this.removeProduct,
      required this.detailProduct})
      : super(key: key);

  // * Función de eliminación de producto
  final Function removeProduct;
  final Function detailProduct;

  // * Variable del producto
  final Product product;

  Widget? dropdownValue;

  // * Referencia a la colección Product de Firestore
  CollectionReference productReference =
      FirebaseFirestore.instance.collection('Product');

  @override
  Widget build(BuildContext context) {
    return Container(
      // * Bordes de la tarjeta
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.zero),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: kBackgroundColor,
                child: ClipOval(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: product.image != null
                        // * Imagen del producto, mediante el enlace guardado al crearlo
                        ? Image.network(
                            product.image!,
                            width: 10,
                            height: 10,
                          )
                        // * En caso no tenga una imagen guardada aparecerá este elemento
                        : Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            // * Nombre del producto
            Container(
              width: MediaQuery.of(context).size.width / 2.5,
              alignment: Alignment.centerLeft,
              child: Text(
                product.getName(),
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.start,
                softWrap: true,
                maxLines: 3,
                textWidthBasis: TextWidthBasis.parent,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            // * Precio del producto
            Container(
              width: MediaQuery.of(context).size.width / 3.8,
              alignment: Alignment.center,
              child: Text(
                product.getPrice(),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.start,
                softWrap: true,
                maxLines: 3,
                textWidthBasis: TextWidthBasis.parent,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            getDropdownMenu()
          ],
        ),
      ),
    );
  }

  Widget getDropdownMenu() {
    return DropdownButton<Widget>(
      value: dropdownValue,
      icon: const Icon(Icons.more_vert),
      iconSize: 20,
      elevation: 8,
      alignment: Alignment.center,
      borderRadius: BorderRadius.circular(4),
      style: const TextStyle(color: Colors.black54),
      underline: Container(
        height: 1,
        color: Colors.white,
      ),
      onChanged: (value) {
        if (value!.key == const Key("detailOption")) {
          detailProduct(product);
        }

        if (value.key == const Key("removeOption")) {
          removeProduct(product.id);
        }
      },
      items: <Widget>[
        IconButton(
            key: const Key("detailOption"),
            onPressed: () => detailProduct(product),
            alignment: Alignment.center,
            color: Colors.blueAccent,
            icon: const Icon(Icons.edit_outlined)),
        IconButton(
            key: const Key("removeOption"),
            onPressed: () async => removeProduct(product.id),
            alignment: Alignment.center,
            color: Colors.redAccent,
            icon: const Icon(Icons.delete_outline)),
      ].map<DropdownMenuItem<Widget>>((Widget value) {
        return DropdownMenuItem<Widget>(
          value: value,
          child:
              Container(width: 10, alignment: Alignment.center, child: value),
        );
      }).toList(),
    );
  }
}
