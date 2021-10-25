// * FIREBASE
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// * SERVICES
import 'package:organic/services/authentification/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
// * CONSTANT
import 'package:organic/constants/theme.dart';

class Register extends StatefulWidget {
  final Function toggleScreen;

// * Parámetros de la vista de registro
// ? toggleScreen: Función para cambio de vista
  const Register({Key? key, required this.toggleScreen}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // * Controlador de la caja de texto de email
  final TextEditingController _emailController = TextEditingController();
  // * Controlador de la caja de texto de contraseña
  final TextEditingController _passwordController = TextEditingController();
  // * Controlador de la caja de texto para repetición de la contraseña
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final _formkey = GlobalKey<FormState>();

// * Referenciando a la coleccion Users
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    super.initState();
  }

// * Permite un reinicio de los controladores cada vez que se abre la vista
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // * Referenciando el servicio de Authentication, creado en Authentication.dart
    final loginProvider = Provider.of<AuthServices>(context);
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formkey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Registrar usuario",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              // * Caja de texto para ingreso de email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.always,
                validator: (val) => val!.isEmpty ||
                        !val.contains("@") ||
                        val.endsWith("@") ||
                        val.endsWith(".")
                    ? "Enter a valid eamil"
                    : null,
                decoration: InputDecoration(
                    hintText: "user@example.com",
                    prefixIcon: const Icon(Icons.mail),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              const SizedBox(height: 25),
              // * Caja de texto para ingreso de contraseña
              TextFormField(
                controller: _passwordController,
                validator: (val) => val!.isEmpty || val.characters.length < 8
                    ? "La contraseña debe tener como mínimo 8 dígitos"
                    : null,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Contraseña",
                    prefixIcon: const Icon(Icons.vpn_key),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              const SizedBox(height: 25),
              // * Caja de texto para repetición de la contraseña
              TextFormField(
                controller: _repeatPasswordController,
                validator: (val) =>
                    val!.isEmpty || val.compareTo(_passwordController.text) != 0
                        ? "Debe coincidir con la contraseña"
                        : null,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Repetir contraseña",
                    prefixIcon: const Icon(Icons.vpn_key),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              const SizedBox(height: 25),
              // * Botón para registro de usuario
              MaterialButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    // * Registro de usuario a Authentication
                    User user = await loginProvider.register(
                        _emailController.text.trim(),
                        _passwordController.text.trim());

                    // * Creación de usuario en Firestore, agregando la uid del usuario de authentication
                    userReference.add({
                      'id': userReference.doc().id,
                      'email': _emailController.text.trim(),
                      'dni': null,
                      'address': null,
                      'name': _emailController.text.trim(),
                      'uid': user.uid
                    }).then((value) {
                      _emailController.clear();
                      _passwordController.clear();
                      _repeatPasswordController.clear();
                      widget.toggleScreen();
                    });
                  }
                },
                height: 55,
                minWidth: loginProvider.isLoading ? null : double.infinity,
                color: kPrimaryColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                child: loginProvider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Registrar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
              const SizedBox(height: 15),
              // * Volver a la vista de Login
              MaterialButton(
                // * Cambio de vista
                onPressed: () => widget.toggleScreen(),
                height: 55,
                minWidth: double.infinity,
                color: Colors.white,
                textColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                child: const Text(
                  "Volver a Iniciar Sesión",
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
    ));
  }
}
