import 'dart:io';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/models/product.dart';
import 'package:organic/services/firebaseApi/firebase_api.dart';

class ProductDetail extends StatefulWidget {
  final Product producto;
  final Function updateData;

  const ProductDetail(
      {Key? key, required this.producto, required this.updateData})
      : super(key: key);

  @override
  _ProductDetailState createState() =>
      _ProductDetailState(producto: producto, updateData: updateData);
}

class _ProductDetailState extends State<ProductDetail> {
  _ProductDetailState({required this.producto, required this.updateData});

  final Function updateData;

  // * Controlador de la caja de texto de nombre
  final TextEditingController _nameController = TextEditingController();
  // * Controlador de la caja de texto de descripción
  final TextEditingController _descriptionController = TextEditingController();
  // * Controlador de la caja de texto de peso
  final TextEditingController _weightController = TextEditingController();
  // * Controlador de la caja de texto de precio
  final TextEditingController _priceController = TextEditingController();

  final Product producto;

  // * Variable para la subida de imagen
  File? file;
  // * Variable para captura de imagen
  UploadTask? task;

  bool loading = false;

  // * Referencia a la colección Producto en Firestore
  CollectionReference productReference =
      FirebaseFirestore.instance.collection('Product');

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = producto.getName();
      _descriptionController.text = producto.getDescription();
      _weightController.text = producto.getWeight();
      _priceController.text = producto.price!;
    });
  }

  Future selectFile() async {
    // * Devuelve el archivo seleccionado
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    // * Devuelve la ruta de la posición del archivo
    final path = result.files.single.path!;

    // * Cambio de valor de la variable file
    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return null;

    // * Obtiene el nombre de la imagen
    final fileName = basename(file!.path);
    // * Destino está almacenada la imagen en Storage
    final destination = 'files/$fileName';

    // * Obtención de la imagen
    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return null;

    final snapshot = await task!.whenComplete(() {});

    // * Obtiene el url de la imagen
    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(producto.getName()),
      actions: [
        MaterialButton(
          onPressed: () async {
            Product productoUpdated = Product(
              id: producto.id,
              name: _nameController.text,
              description: _descriptionController.text,
              weight: _weightController.text,
              price: _priceController.text,
              image: file != null ? await uploadFile() : producto.image,
              userId: producto.userId,
            );

            updateData(productoUpdated);
          },
          height: 55,
          minWidth: double.infinity,
          color: kPrimaryColor,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 1.5,
                )
              : const Text(
                  "Guardar",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ],
      elevation: 5.0,
      scrollable: true,
      content: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                file != null
                    // * Imagen subida del producto
                    ? Image.file(file as File, height: 100.0, width: 100.0)
                    // * Elemento del url, en caso no se seleccionó algun archivo
                    : producto.getImageUrl() != null
                        ? Image.network(
                            producto.getImageUrl(),
                            height: 100.0,
                            width: 100.0,
                          )
                        // * Elemento por defecto en caso no haya ninguna imagen seleccionada
                        : Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.grey,
                            ),
                          ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  // * Botón para abrir galería y selecciona imagne
                  child: IconButton(
                    onPressed: selectFile,
                    icon: const Icon(
                      Icons.camera_alt,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // * Caja de texto para el nombre del producto
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  hintText: "Nombre del producto",
                  prefixIcon: const Icon(Icons.production_quantity_limits),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(height: 20),
            // * Caja de texto para la descripción del producto
            TextFormField(
              maxLines: 3,
              maxLength: 200,
              controller: _descriptionController,
              decoration: InputDecoration(
                  hintText: "Descripción del producto",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        // * Caja de texto para el stock del producto
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _weightController,
                          decoration: InputDecoration(
                              hintText: "Stock",
                              prefixIcon: const Icon(Icons.line_weight),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      // * Caja de texto para el precio del producto
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _priceController,
                        decoration: InputDecoration(
                            hintText: "Costo",
                            prefixIcon: const Icon(Icons.price_change),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
