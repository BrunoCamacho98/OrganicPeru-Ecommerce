import 'package:flutter/material.dart';
// Constant
import 'package:organic/constants/globals.dart' as global;

class SalesUserList extends StatefulWidget {
  const SalesUserList({Key? key}) : super(key: key);

  @override
  _SalesUserListState createState() => _SalesUserListState();
}

class _SalesUserListState extends State<SalesUserList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2),
      child: Column(
        children: global.detailSales.isNotEmpty
            ? global.detailSales.map((e) {
                return Text(e.total.toString());
              }).toList()
            : [const Text('No tiene compras')],
      ),
    );
  }
}
