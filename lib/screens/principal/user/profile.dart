import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/models/user.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  final UserLogin? user;
  Function updateUser;

  Profile({Key? key, required this.user, required this.updateUser})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _ProfileState createState() =>
      // ignore: no_logic_in_create_state
      _ProfileState(user: user, updateUser: updateUser);
}

class _ProfileState extends State<Profile> {
  _ProfileState({required this.user, required this.updateUser});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final UserLogin? user;
  Function updateUser;

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.getName();
    _addressController.text = user?.getAddress();
    _dniController.text = user?.getDNI();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Form(
          key: _formkey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: 36 + kDefaultPadding,
                  ),
                  height: size.height * 0.12 - 27,
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 95,
                      ),
                      Positioned(
                        top: 25,
                        child: Container(
                          alignment: Alignment.center,
                          height: 28,
                          child: Text(
                            user?.name as String,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 52,
                        child: Container(
                          alignment: Alignment.center,
                          height: 28,
                          child: Text(
                            user?.getEmail(),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -60,
                        child: Container(
                          alignment: Alignment.center,
                          width: 80,
                          height: 80,
                          clipBehavior: Clip.antiAlias,
                          child: Text(
                            (user?.getEmail() as String)
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                                fontSize: 35, color: kPrimaryColor),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(180),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 3,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            user?.name = value;
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
                        controller: _dniController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          user?.dni = value;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) =>
                            val!.isEmpty || val.characters.length != 8
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
                          user?.address = value;
                        },
                        decoration: InputDecoration(
                            hintText: "Dirección",
                            prefixIcon: const Icon(Icons.home),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                      const SizedBox(height: 40),
                      MaterialButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            updateUser(user);
                          }
                        },
                        height: 60,
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
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
