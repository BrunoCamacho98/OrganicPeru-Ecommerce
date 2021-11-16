import 'package:flutter/material.dart';
import 'package:organic/screens/public/login.dart';
import 'package:organic/screens/public/register.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  // * Variable que valida que vista mostrar
  bool isToogle = false;

  // * Cambio de valor de la variable isToogle, para el cambio de vista
  void toggleScreen() {
    setState(() {
      isToogle = !isToogle;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isToogle) {
      // * Vista de registro
      return Register(toggleScreen: toggleScreen);
    } else {
      // * Vista de inicio de sesión
      return Login(toggleScreen: toggleScreen);
    }
  }
}
