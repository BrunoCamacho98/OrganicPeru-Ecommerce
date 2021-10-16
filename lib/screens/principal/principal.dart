import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Constant
import 'package:organic/constants/theme.dart';
// Screeen
import 'package:organic/screens/principal/components/body.dart';
import 'package:organic/screens/principal/product/create_product.dart';
import 'package:organic/screens/principal/product/list_product.dart';
import 'package:organic/screens/public/Authentication/authentifcation.dart';
import 'package:organic/screens/public/login.dart';

class Principal extends StatefulWidget {
  PrincipalState createState() => PrincipalState();
}

class PrincipalState extends State<Principal> {
  int _selectDrawerItem = -1;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case -1:
        return Body();
      case 0:
        return CreateProduct();
      case 1:
        return CreateProduct();
      case 4:
        return const ListProduct();
      case 5:
        return Authentication();
    }
  }

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

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
    );
  }

  Drawer buildDrawerApp(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text('Elver Galarga'),
            accountEmail: Text('elver.galarga@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: kBackgroundColor,
              child: Text(
                'E',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
              title: const Text('Home'),
              leading: const Icon(Icons.home),
              selected: (-1 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(-1);
              }),
          ListTile(
              title: const Text('Mis productos'),
              leading: const Icon(Icons.production_quantity_limits_rounded),
              selected: (4 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(4);
              }),
          ListTile(
              title: const Text('Crear producto'),
              leading: const Icon(Icons.add),
              selected: (1 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(1);
              }),
          const Divider(),
          ListTile(
              title: const Text('Perfil'),
              leading: const Icon(Icons.account_circle),
              selected: (4 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(4);
              }),
          ListTile(
              title: const Text('Cerrar sesión'),
              leading: const Icon(Icons.exit_to_app),
              selected: (5 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(5);
              })
        ],
      ),
    );
  }
}
