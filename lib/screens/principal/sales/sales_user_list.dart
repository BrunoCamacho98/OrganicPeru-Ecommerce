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
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mis compras",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: saleList.isNotEmpty
                ? saleList.map((sale) {
                    return SalesCard(
                      sale: sale,
                      showUser: false,
                      useTax: true,
                    );
                  }).toList()
                : [
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 2,
                        child: const Text(
                          'No ha realizado compras',
                          style: TextStyle(fontSize: 16),
                        ))
                  ],
          ),
        ],
      ),
    );
  }
}
