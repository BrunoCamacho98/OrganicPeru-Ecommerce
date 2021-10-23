import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';

class CreateProduct extends StatefulWidget {
  final User? user;
  CreateProduct({this.user});

  @override
  _CreateProductState createState() => _CreateProductState(user: user);
}

class _CreateProductState extends State<CreateProduct> {
  _CreateProductState({this.user});

  final User? user;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  File? file;

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

  void addProduct() {
    if (_nameController.text.isNotEmpty &&
        _weightController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      productReference.add({
        'id': productReference.doc().id,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'weight': _weightController.text.trim(),
        'price': _priceController.text.trim(),
        'userId': user?.uid
      }).then((value) {
        _nameController.clear();
        _descriptionController.clear();
        _weightController.clear();
        _priceController.clear();
      });
    }
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
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: kBackgroundColor,
                      child: ClipOval(
                          child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Image.asset(
                                  "assets/images/saco-organic.jpeg"))),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: Icon(
                      Icons.camera_alt,
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
                child: const Text(
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
