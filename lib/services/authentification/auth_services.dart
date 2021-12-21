import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:organic/models/user.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // * Registro de usuarios

  Future register(String email, String password) async {
    setLoading(true);
    try {
      // * Creación de usuario en Authentication
      UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = authResult.user;

      setLoading(false);
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No hay internet, por favor conectarse a Internet");
    } catch (e) {
      setLoading(false);
      setMessage(e.toString());
    }
    notifyListeners();
  }

  // * Login de usuario mediante Authentication

  Future login(String email, String password) async {
    setLoading(true);
    try {
      // * Uso del servicio de Authentication para el inicio de sesión de usuario
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = authResult.user;
      setLoading(false);
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No hay internet, por favor conectarse a Internet");
    } catch (e) {
      setLoading(false);
      setMessage(e.toString());
    }
    notifyListeners();
  }

  // * Cierre de sesión

  Future logout() async {
    await firebaseAuth.signOut();
  }

// * Envío de notificación de cambio en el valor del usuario
  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message) {
    _errorMessage = message;
  }

// * Servicio para detectar el cambio de usuario y actualizarlo
  Stream<User?> get user =>
      firebaseAuth.authStateChanges().map((event) => event);
}
