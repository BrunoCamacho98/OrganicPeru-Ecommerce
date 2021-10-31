// * SERVICES
import 'package:organic/methods/global_methods.dart';
import 'package:organic/models/user.dart';
import 'package:organic/screens/principal/user/profile.dart';
import 'package:organic/services/authentification/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:organic/util/queries/user/user_query.dart';
import 'package:provider/provider.dart';
// * FIREBASE
import 'package:organic/screens/public/Authentication/authentifcation.dart';
// * CONSTANT
import 'package:organic/constants/theme.dart';
// * SCREENS
import 'package:organic/screens/principal/components/body.dart';
import 'package:organic/screens/principal/product/create_product.dart';
import 'package:organic/screens/principal/product/list_product.dart';

class Principal extends StatefulWidget {
  UserLogin? user;

  // * Parametros de la vista
  // ? User: datos del usuario logeado
  Principal({this.user});

  // * Referenciando al estado
  @override
  PrincipalState createState() => PrincipalState(user: user);
}

class PrincipalState extends State<Principal> {
  // * Parametros del Estado de la vista
  // ? User: datos del usuario logeado
  PrincipalState({this.user});

  UserLogin? user;

  final UserQuery userQuery = UserQuery();

  int _selectDrawerItem = -1;

// * Switch para cambio de vista, según lo seleccionado en el menú lateral
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case -1:
        return Body();
      case 0:
        return CreateProduct(user: user);
      case 1:
        return CreateProduct(user: user);
      case 2:
        return ListProduct(user: user);
      case 3:
        return Profile(
          user: user,
          updateUser: updateUser,
        );
      case 5:
        return Authentication();
    }
  }

  // * Cambio de valor en la variable utilizada para validar que Vista mostrar
  _onSelectItem(int pos) {
    Navigator.of(context).pop();
    setState(() {
      _selectDrawerItem = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _getDrawerItemWidget(_selectDrawerItem),
      drawer: buildDrawerApp(context),
    );
  }

// * Menu superior
  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
    );
  }

  Future updateUser(UserLogin? userLogin) async {
    var userUpdated = await userQuery.updateUser(userLogin!);

    setState(() {
      user = userUpdated;
    });
  }

// * Menu lateral izquierdo
  Drawer buildDrawerApp(BuildContext context) {
    final logoutProvider = Provider.of<AuthServices>(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          // * Datos del usuario
          UserAccountsDrawerHeader(
            accountName: Text(user?.name as String),
            accountEmail: Text(user?.email as String),
            currentAccountPicture: CircleAvatar(
              backgroundColor: kBackgroundColor,
              child: Text(
                (user?.email as String).substring(0, 1).toUpperCase(),
                style: const TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          // * Vista principal, listado de todos los productos
          ListTile(
              title: const Text('Home'),
              leading: const Icon(Icons.home),
              selected: (-1 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(-1);
              }),
          // * Lista de todos los productos agregados por el usuario
          ListTile(
              title: const Text('Mis productos'),
              leading: const Icon(Icons.production_quantity_limits_rounded),
              selected: (2 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(2);
              }),
          // * Creación de productos
          ListTile(
              title: const Text('Crear producto'),
              leading: const Icon(Icons.add),
              selected: (1 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(1);
              }),
          const Divider(),

          // * Perfil de usuario
          ListTile(
              title: const Text('Perfil'),
              leading: const Icon(Icons.account_circle),
              selected: (3 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(3);
              }),
          // * Cierre de sesión
          ListTile(
              title: const Text('Cerrar sesión'),
              leading: const Icon(Icons.exit_to_app),
              selected: (5 == _selectDrawerItem),
              onTap: () {
                logoutProvider.logout();
                toMain(context);
              })
        ],
      ),
    );
  }
}
