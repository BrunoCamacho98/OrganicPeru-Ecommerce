// * SERVICES
import 'package:flutter/material.dart';
import 'package:organic/main.dart';
import 'package:organic/models/user.dart';
// * SCREEN
import 'package:organic/screens/principal/principal.dart';

// * Go to view Principal.dart
void toPrincipal(BuildContext context, UserLogin? user) async {
  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => Principal(user: user)));
}

// * Go to view Main.dart
void toMain(BuildContext context) async {
  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => const MyApp()));
}
