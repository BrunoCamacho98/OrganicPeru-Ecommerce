import 'package:flutter/material.dart';
// Constant
import 'package:organic/constants/globals.dart' as global;
import 'package:organic/models/sale.dart';
import 'package:organic/screens/principal/sales/sales_card.dart';
import 'package:organic/util/queries/sales/sales_query.dart';

class SalesUserList extends StatefulWidget {
  const SalesUserList({Key? key}) : super(key: key);

  @override
  _SalesUserListState createState() => _SalesUserListState();
}

class _SalesUserListState extends State<SalesUserList> {
  final SaleQuery saleQuery = SaleQuery();

  List<Sale> saleList = [];

  @override
  void initState() {
    saleQuery.getSalesByUser(global.userLogged!).then((value) {
      setState(() {
        saleList = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2),
      child: Column(
        children: saleList.isNotEmpty
            ? saleList.map((sale) {
                return SalesCard(sale: sale);
              }).toList()
            : [const Text('No tiene compras')],
      ),
    );
  }
}
