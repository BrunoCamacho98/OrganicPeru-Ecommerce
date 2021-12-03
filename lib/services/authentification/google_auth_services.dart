import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    var googleSingIn = GoogleSignIn();
    var googleUser = await googleSingIn.signIn();

    if (googleUser == null) return;
    _user = googleUser;

    var googleAuth = await googleUser.authentication;

    var credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      // * Uso del servicio de Authentication para el inicio de sesión de usuario
      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

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

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message) {
    _errorMessage = message;
  }
}
