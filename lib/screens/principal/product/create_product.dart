import 'dart:io';
// * FIREBASE
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// * SERVICES
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:organic/services/firebaseApi/firebase_api.dart';
// * IMAGES
import 'package:file_picker/file_picker.dart';
// * CONSTANT
import 'package:organic/constants/theme.dart';

class CreateProduct extends StatefulWidget {
  final User? user;
  CreateProduct({this.user});

  @override
  _CreateProductState createState() => _CreateProductState(user: user);
}

class _CreateProductState extends State<CreateProduct> {
  _CreateProductState({this.user});

  var storage = FirebaseStorage.instance;

  final User? user;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? file;
  UploadTask? task;

  bool loading = false;

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

  void addProduct() async {
    if (_nameController.text.isNotEmpty &&
        _weightController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      setState(() {
        loading = true;
      });
      await uploadFile();
      productReference.add({
        'id': productReference.doc().id,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'weight': _weightController.text.trim(),
        'price': _priceController.text.trim(),
        'userId': user?.uid,
        'image': file?.path
      }).then((value) {
        _nameController.clear();
        _descriptionController.clear();
        _weightController.clear();
        _priceController.clear();
        setState(() {
          file = null;
          loading = false;
        });
      });
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
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
                      ? Image.file(file as File, height: 100.0, width: 100.0)
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
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    hintText: "Nombre del producto",
                    prefixIcon: const Icon(Icons.production_quantity_limits),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: 3,
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
                          child: TextField(
                            controller: _weightController,
                            decoration: InputDecoration(
                                hintText: "Peso",
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
                        TextField(
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
