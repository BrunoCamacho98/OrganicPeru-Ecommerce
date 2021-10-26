import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/methods/global_methods.dart';
import 'package:organic/services/authentification/auth_services.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final Function toggleScreen;

  const Login({Key? key, required this.toggleScreen}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // * Controlador de la caja de texto de email
  final TextEditingController _emailController = TextEditingController();
  // * Controlador de la caja de texto de password
  final TextEditingController _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  // * Permite un reinicio de los controladores cada vez que se abre la vista
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Iniciar sesión",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                // * Caja de texto para ingreso de email
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (val) => val!.isEmpty ||
                          !val.contains("@") ||
                          val.endsWith("@") ||
                          val.endsWith(".")
                      ? "Enter a valid eamil"
                      : null,
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "Correo electrónico",
                      prefixIcon: const Icon(Icons.mail),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                const SizedBox(height: 30),
                // * Caja de texto para ingreso de contraseña
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Contraseña",
                      prefixIcon: const Icon(Icons.vpn_key),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                const SizedBox(height: 30),
                // * Botón para validar el inicio de sesión
                MaterialButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      // * Método de inicio de sesión
                      User? user = await loginProvider.login(
                          _emailController.text.trim(),
                          _passwordController.text.trim());

                      if (user?.uid != null) {
                        toPrincipal(context, user);
                      }
                    }
                  },
                  height: 55,
                  minWidth: double.infinity,
                  color: kPrimaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  child: loginProvider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
                // * Botón de envio a la vista de registro
                MaterialButton(
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
                    "Crear cuenta",
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
      ),
    ));
  }
}
