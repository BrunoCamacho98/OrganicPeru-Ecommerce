import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
// * FIREBASE
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// * SERVICES
import 'package:organic/services/firebaseApi/firebase_api.dart';
// * IMAGES
import 'package:file_picker/file_picker.dart';
// * CONSTANT
import 'package:organic/constants/theme.dart';
// * MODEL
import 'package:organic/models/product.dart';
import 'package:organic/models/user.dart';

class CreateProduct extends StatefulWidget {
  final UserLogin? user;
  // ignore: use_key_in_widget_constructors
  const CreateProduct({this.user});

  @override
  // ignore: no_logic_in_create_state
  _CreateProductState createState() => _CreateProductState(user: user);
}

class _CreateProductState extends State<CreateProduct> {
  _CreateProductState({this.user});

  var storage = FirebaseStorage.instance;

  final UserLogin? user;

  // * Controlador de la caja de texto de nombre
  final TextEditingController _nameController = TextEditingController();
  // * Controlador de la caja de texto de descripción
  final TextEditingController _descriptionController = TextEditingController();
  // * Controlador de la caja de texto de peso
  final TextEditingController _weightController = TextEditingController();
  // * Controlador de la caja de texto de precio
  final TextEditingController _priceController = TextEditingController();

  // * Variable para la subida de imagen
  File? file;
  // * Variable para captura de imagen
  UploadTask? task;

  // * Usado para la carga en la subida de datos
  bool loading = false;

  // * Referencia a la colección Producto en Firestore
  CollectionReference productReference =
      FirebaseFirestore.instance.collection('Product');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // * Método para agregar producto a la BD
  void addProduct() async {
    // * Validación de los controladores requeridos
    if (_nameController.text.isNotEmpty &&
        _weightController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      setState(() {
        loading = true;
      });

      // * Obtención de la url de la imagen
      var url = await uploadFile();

      // * Creación del objeto producto
      var product = Product(
          id: productReference.doc().id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          weight: _weightController.text.trim(),
          price: _priceController.text.trim(),
          userId: user?.uid,
          image: url);

      // * Guardar producto en la colección Products
      productReference.add(product.toMapString()).then((value) {
        // * Vaciar cajas de texto después de guardar el objeto
        _nameController.clear();
        _descriptionController.clear();
        _weightController.clear();
        _priceController.clear();
        setState(() {
          file = null;
          loading = false;
        });

        product.id = value.id;
        // * Obteniendo el ID del objeto subido
        productReference.doc(value.id).set(product.toMapString());
      });
    }
  }

  // * Método para seleccionar un archivo de la galería
  Future selectFile() async {
    // * Devuelve el archivo seleccionado
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    // * Devuelve la ruta de la posición del archivo
    final path = result.files.single.path!;

    // * Cambio de valor de la variable file
    setState(() => file = File(path));
  }

  // * Método para obtener el url de la imagen
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: 50),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Nuevo producto",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  file != null
                      // * Imagen subida del producto
                      ? Image.file(file as File, height: 100.0, width: 100.0)
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
                maxLines: 2,
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
                maxLength: 500,
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
              const SizedBox(height: 20),

              // * Botón para guardar los datos del producto
              MaterialButton(
                onPressed: () {
                  addProduct();
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
          ),
        ),
      ),
    );
  }
}
