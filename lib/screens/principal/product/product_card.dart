// * SERVICES
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
// * CONSTANT
import 'package:organic/constants/theme.dart';
// * MODEL
import 'package:organic/models/product.dart';

class ProductCard extends StatelessWidget {
  // * Parametros de la vista
  // ? key: Clave de la vista, no es necesario colocarle un valor
  // ? Product: Producto que se esta instanciando
  ProductCard({Key? key, required this.product}) : super(key: key);

  final Product product;

  CollectionReference productReference = FirebaseFirestore.instance
      .collection('Product'); // * Referencia al documento Product de Firestore

  Future removeProduct() async {
    await productReference
        .doc(product.id)
        .delete(); // * Eliminar producto mediante uso id
  }

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
                    child: url != null
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
            Text(
              product.getName(),
              style: const TextStyle(fontSize: 16),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            // * Precio del producto
            Text(
              product.getPrice(),
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            // ? Opciones: Editar y Eliminar
            // * Editar
            IconButton(
                onPressed: () {},
                alignment: Alignment.center,
                color: Colors.blueAccent,
                icon: const Icon(Icons.edit_outlined)),
            // * Eliminar
            IconButton(
                onPressed: () async => removeProduct(),
                alignment: Alignment.center,
                color: Colors.redAccent,
                icon: const Icon(Icons.delete_outline))
          ],
        ),
      ),
    );
  }
}
