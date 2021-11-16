// Firebase

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/screens/public/Authentication/authentifcation.dart';
import 'package:organic/services/authentification/auth_services.dart';
import 'package:provider/provider.dart';

void main() {
  // Inicializar todas las librerías antes de correr la app
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _init = Firebase.initializeApp();
    return FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // * Vista en caso haya algun error con firebase
            return const ErrorWidget();
          } else if (snapshot.hasData) {
            // * Vista principal
            return MultiProvider(
              providers: [
                // * Detectan cambio en el usuario de Firebase (login) y guardan ese dato
                ChangeNotifierProvider<AuthServices>.value(
                    value: AuthServices()),
                StreamProvider<User?>.value(
                    value: AuthServices().user, initialData: null)
              ],
              child: MaterialApp(
                // * Designar los colores usados en la aplicación
                theme: ThemeData(
                  primarySwatch: kprimarySwatch,
                  primaryColor: kPrimaryWhite,
                  textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: Colors.black87,
                      fontFamily: GoogleFonts.montserrat().fontFamily),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                debugShowCheckedModeBanner: false,
                // * Vista de Authentication (login y registro), en caso el usuario no este logeado
                home: const Authentication(),
              ),
            );
          } else {
            // * Vista de carga: Mientas se espera a que termine de cargar las vistas
            return const Loading();
          }
        });
  }
}

// * Vista de error
class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: const [Icon(Icons.error), Text("Something went wrong !")],
      ),
    ));
  }
}

// * Vista de carga
class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      )),
    );
  }
}
