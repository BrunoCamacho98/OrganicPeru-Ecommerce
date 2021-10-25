import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:organic/models/product.dart';
import 'package:organic/screens/principal/product/product_card.dart';

class ListProduct extends StatefulWidget {
  final User? user;

  ListProduct({this.user});

  @override
  _ListProductState createState() => _ListProductState(user: user);
}

class _ListProductState extends State<ListProduct> {
  _ListProductState({this.user});

  // * Usuario logeado
  final User? user;

  // * Lista de productos
  List<Product> products = [];

  // * Referencia a la colección de Product, detectando cada cambio realizado en Firestore
  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('Product')
      .snapshots(includeMetadataChanges: true);

  // * Variable usado para la obtención de los datos de los archivos en el servicio de Storage
  UploadTask? task;

  // * Referencia a la colección Product de Firestore
  CollectionReference productReference =
      FirebaseFirestore.instance.collection('Product');

// * Función que se corre de forma automática al cargar la vista
  @override
  void initState() {
    super.initState();
    // * Correr la función para obtener el listado de productos
    getProducts().then((value) {
      setState(() {
        products = value;
      });
    });
  }

// ? Retorno de la lista de productos
  Future<List<Product>> getProducts() async {
    // * Filtrado y retorno de la lista de productos que el usuario ha agregado
    QuerySnapshot products = await FirebaseFirestore.instance
        .collection('Product')
        // * Filtrado mediante id del usuario
        .where('userId', isEqualTo: user?.uid)
        .get();

    List<Product> productList = [];

    // * Guardado de los datos en Firestore en una lista de Productos
    if (products.docs.isNotEmpty) {
      for (var doc in products.docs) {
        productList.add(Product.fromSnapshot(doc));
      }
    }

    return productList;
  }

// ? Función para eliminar productos
  Future removeProduct(String productId) async {
    await productReference
        .doc(productId)
        .delete(); // * Eliminar producto mediante uso id
  }

  @override
  Widget build(BuildContext context) {
    // * Permite actualización de elementos al detectar un cambio en la colección
    return StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    child: Text(
                      'Mis Productos',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: products.isNotEmpty
                          ?
                          // * Lista de todos los productos del usuario
                          products.map((product) {
                              // * Retorno de la carta de detalle del producto
                              return ProductCard(
                                product: product,
                                removeProduct: () async =>
                                    removeProduct(product.id!),
                              );
                            }).toList()
                          : [
                              // * Vista en caso no tenga productos
                              Container(
                                child: const Text("No tiene productos"),
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                // * Dar valor al height del elemento obteniendo el tamaño actual de la pantalla
                                height: MediaQuery.of(context).size.height / 2,
                              )
                            ]),
                ],
              ),
            ),
          );
        });
  }
}
