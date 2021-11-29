import 'package:flutter/material.dart';
// Constant
import 'package:organic/constants/theme.dart';
import 'package:organic/constants/globals.dart' as global;
import 'package:organic/models/detail_sale.dart';
import 'package:organic/screens/principal/sales/detail_sale_card.dart';

class ModalDetailSales extends StatefulWidget {
  const ModalDetailSales({Key? key, required this.confirmSale})
      : super(key: key);

  final Function confirmSale;

  @override
  // ignore: no_logic_in_create_state
  _ModalDetailSalesState createState() =>
      // ignore: no_logic_in_create_state
      _ModalDetailSalesState(confirmSale: confirmSale);
}

class _ModalDetailSalesState extends State<ModalDetailSales> {
  _ModalDetailSalesState({required this.confirmSale});

  final Function confirmSale;

  getTotal() {
    double total = 0;

    for (var element in global.detailSales) {
      total += element.total;
    }

    return 'S/ ' + total.toString();
  }

  deleteFromDetailList(DetailSale detailSale) {
    setState(() {
      global.detailSales.remove(detailSale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: const Text(
          'Mis compras',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
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
      actions: [
        MaterialButton(
          onPressed: () => confirmSale(7, null),
          height: 55,
          minWidth: double.infinity,
          color: kPrimaryColor,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Comprar ',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '(Total: ' + getTotal() + ')',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
      content: Column(
        children: global.detailSales.isNotEmpty
            ? global.detailSales.map((e) {
                return DetailSaleCard(
                  product: e.product!,
                  detailSale: e,
                  remove: deleteFromDetailList,
                );
              }).toList()
            : [const Text('No tiene compras')],
      ),
    );
  }
}
