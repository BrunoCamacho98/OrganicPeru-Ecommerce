import 'package:flutter/material.dart';
// * SERVICES
import 'package:organic/services/authentification/auth_services.dart';
import 'package:provider/provider.dart';
// * QUERIES
import 'package:organic/util/queries/user/user_query.dart';
// * METHODS
import 'package:organic/methods/global_methods.dart';
// * CONSTANT
import 'package:organic/constants/theme.dart';
// * MODEL
import 'package:organic/models/user.dart';

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

  UserLogin? user;

  bool loading = false;

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

  clearAll() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    final UserQuery userQuery = UserQuery();

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height - 100,
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) => val!.isEmpty ||
                            !val.contains("@") ||
                            val.endsWith("@") ||
                            val.endsWith(".")
                        ? "Enter a valid email"
                        : null,
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: "Correo electrónico",
                        prefixIcon: const Icon(Icons.mail),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.black26))),
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

                        setState(() {
                          loading = true;
                        });
                        // * Método de inicio de sesión
                        UserLogin? user = await userQuery.loginUser(context, loginProvider
                            _emailController.text, _passwordController.text);

                        if (user?.id != null) {
                          clearAll();
                          toPrincipal(context, user);
                          setState(() {
                            loading = false;
                          });
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
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Iniciar sesión",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  MaterialButton(
                    onPressed: () {},
                    height: 55,
                    minWidth: double.infinity,
                    color: kBackgroundColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black12)
                    ),
                    elevation: 0,
                    child: loading
                        ? const CircularProgressIndicator()
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/icons/google_icon.png", height: 20),
                              const SizedBox(width: 10,),
                              const Text("Iniciar sesión con Google",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ))
                            ]
                          ),
                  ),
                  const SizedBox(height: 10),
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
      ),
    ));
  }
}
