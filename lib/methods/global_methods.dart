import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Pages
// import 'package:organic/screens/public/login.dart';
// import 'package:organic/screens/public/register.dart';
import 'package:organic/screens/principal/principal.dart';

// void toRegister(BuildContext context) async {
//   await Navigator.push(
//       context, MaterialPageRoute(builder: (context) => Register()));
// }

// void toLogin(BuildContext context) async {
//   await Navigator.push(
//       context, MaterialPageRoute(builder: (context) => Login()));
// }

void toPrincipal(BuildContext context, User? user) async {
  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => Principal(user: user)));
}
