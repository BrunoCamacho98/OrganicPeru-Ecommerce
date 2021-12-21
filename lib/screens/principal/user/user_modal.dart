import 'package:organic/models/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';

class UserModal extends StatefulWidget {
  final UserLogin user;
  final Function updateData;

  const UserModal({Key? key, required this.user, required this.updateData})
      : super(key: key);

  @override
  _UserModalState createState() =>
      // ignore: no_logic_in_create_state
      _UserModalState(user: user, updateData: updateData);
}

class _UserModalState extends State<UserModal> {
  _UserModalState({required this.user, required this.updateData});

  final Function updateData;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  final UserLogin user;

  String userType = '';

  bool loading = false;

  // * Referencia a la colección Producto en Firestore
  CollectionReference productReference =
      FirebaseFirestore.instance.collection('Product');

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = user.getName();
      _emailController.text = user.getEmail();
      _addressController.text = user.getAddress();
      _dniController.text = user.getDNI();
      userType = user.getType();
    });
  }

  getDropDownType() {
    return DropdownButton<String>(
      value: userType,
      icon: const Icon(Icons.keyboard_arrow_down_sharp),
      elevation: 10,
      isExpanded: true,
      style: const TextStyle(color: Colors.black87, fontSize: 18),
      underline: Container(
        height: 2,
        width: 100,
        color: Colors.transparent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          user.type = newValue!;
          userType = newValue;
        });
      },
      items: <String>['CUSTOMER', 'ADMIN']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(5),
            child: Text(value.substring(0, 1).toUpperCase() +
                value.substring(1).toLowerCase()),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text(
            'Editar ',
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 18),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 270,
            child: Text(user.getName(),
                softWrap: true,
                maxLines: 1,
                textWidthBasis: TextWidthBasis.parent,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 20)),
          ),
        ],
      ),
      insetPadding: const EdgeInsets.all(5),
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: kPrimaryWhite,
      titleTextStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          wordSpacing: 0.5,
          letterSpacing: 0.1),
      actions: [
        MaterialButton(
          onPressed: () async => updateData(user),
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
        key: _formkey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  user.name = value;
                });
              },
              decoration: InputDecoration(
                  hintText: "Nombre",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(height: 20),
            TextFormField(
              maxLines: 1,
              controller: _emailController,
              decoration: InputDecoration(
                  hintText: "Correo del usuario",
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(height: 20),
            // * Caja de texto para la descripción del producto
            TextFormField(
              controller: _dniController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                user.dni = value;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (val) => val!.isEmpty || val.characters.length != 8
                  ? "Ingrese un dni valido"
                  : null,
              decoration: InputDecoration(
                  hintText: "DNI",
                  prefixIcon: const Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _addressController,
              onChanged: (value) {
                user.address = value;
              },
              decoration: InputDecoration(
                  hintText: "Dirección",
                  prefixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(6),
              width: MediaQuery.of(context).size.width - 80,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.circular(8)),
              child: getDropDownType(),
            )
          ],
        ),
      ),
    );
  }
}
