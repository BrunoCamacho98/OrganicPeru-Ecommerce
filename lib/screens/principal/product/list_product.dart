import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/methods/global_methods.dart';
import 'package:organic/models/product.dart';
import 'package:organic/models/user.dart';
import 'package:organic/screens/principal/product/modal_product.dart';
import 'package:organic/screens/principal/product/product_card.dart';

class ListProduct extends StatefulWidget {
  final UserLogin? user;

  // ignore: use_key_in_widget_constructors
  const ListProduct({this.user});

  @override
  // ignore: no_logic_in_create_state
  _ListProductState createState() => _ListProductState(user: user);
}

class _ListProductState extends State<ListProduct> {
  _ListProductState({this.user});

  // * Usuario logeado
  final UserLogin? user;

  // * Lista de productos
  List<Product> products = [];

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

    setState(() {
      products.removeWhere((element) => element.id == productId);
    });

    getToast('Producto eliminado', Colors.red);
  }

  Future updateData(Product producto) async {
    productReference.doc(producto.id).update(producto.toMapString());

    var index = products.indexWhere((element) => element.id == producto.id);
    products[index] = producto;
  }

  // ? Función para abrir el modal para editar producto
  void showProductModal(Product producto) {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return ProductModal(producto: producto, updateData: updateData);
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // * Permite actualización de elementos al detectar un cambio en la colección

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: 0 + kDefaultPadding,
              ),
              height: size.height * 0.12 - 20,
              decoration: const BoxDecoration(
                color: kPrimaryWhite,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'Mis Productos',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  // Image.asset("assets/images/logo.png")
                ],
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
                          removeProduct: removeProduct,
                          detailProduct: showProductModal,
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
  }
}
