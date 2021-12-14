// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/models/sale.dart';
import 'package:organic/screens/principal/sales/detail_sale_card.dart';

class ModalSale extends StatefulWidget {
  const ModalSale({Key? key, required this.sale}) : super(key: key);

  final Sale sale;

  @override
  _ModalSaleState createState() => _ModalSaleState(sale: sale);
}

class _ModalSaleState extends State<ModalSale> {
  _ModalSaleState({required this.sale});

  final Sale sale;

  getTotal() {
    double total = 0;

    for (var element in sale.detailSaleList!) {
      total += element.total;
    }

    return 'S/ ' + total.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        padding: const EdgeInsets.only(bottom: 20, left: 0),
        margin: const EdgeInsets.all(0),
        child: const Text(
          'Mi compra',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      scrollable: true,
      insetPadding: const EdgeInsets.all(5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 2),
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: kPrimaryWhite,
      titleTextStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          wordSpacing: 0.5,
          letterSpacing: 0.1),
      content: Column(
        children: sale.detailSaleList!.isNotEmpty
            ? sale.detailSaleList!.map((e) {
                return DetailSaleCard(
                    product: e.product!,
                    detailSale: e,
                    remove: () {},
                    useRemove: false);
              }).toList()
            : [const Text('No tiene compras')],
      ),
    );
  }
}
