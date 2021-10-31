import 'package:flutter/widgets.dart';
// * SERVICES
import 'package:organic/services/authentification/auth_services.dart';
// * FIREBASE
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// * MODEL
import 'package:organic/models/user.dart';

class UserQuery with ChangeNotifier {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final CollectionReference userReference =
      FirebaseFirestore.instance.collection("Users");

  Future<UserLogin?> loginUser(BuildContext context, AuthServices loginProvider,
      String email, String password) async {
    UserLogin? userLogin;

    User? user = await loginProvider.login(email, password);

    if (user != null) {
      QuerySnapshot users =
          await userReference.where("uid", isEqualTo: user.uid).get();

      if (users.docs.isNotEmpty) {
        for (var doc in users.docs) {
          if (user.uid == doc.get("uid")) {
            userLogin = UserLogin.fromSnapshot(doc);
          }
        }
      }
    }

    notifyListeners();

    return userLogin;
  }

  Future<UserLogin?> registerUser(BuildContext context,
      AuthServices loginProvider, String email, String password) async {
    UserLogin? userLogin;

    User? user = await loginProvider.register(email, password);

    if (user != null) {
      userLogin = UserLogin(
          email: email,
          name: email,
          uid: user.uid,
          id: null,
          dni: null,
          address: null);

      userReference.add(userLogin.toMapString()).then((value) {
        userLogin?.id = value.id;
        userReference.doc(value.id).set(userLogin?.toMapString());
      });
    }

    notifyListeners();
    return userLogin;
  }

  Future<UserLogin> updateUser(UserLogin user) async {
    print(user.id);
    final CollectionReference userReference =
        FirebaseFirestore.instance.collection("Users");

    userReference.doc(user.id).update(user.toMapString());

    return user;
  }
}
