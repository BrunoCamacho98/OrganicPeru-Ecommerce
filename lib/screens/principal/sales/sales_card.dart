import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/models/sale.dart';
import 'package:organic/screens/principal/sales/modal_sale.dart';

class SalesCard extends StatefulWidget {
  final Sale sale;

  const SalesCard({Key? key, required this.sale}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _SalesCardState createState() => _SalesCardState(sale: sale);
}

class _SalesCardState extends State<SalesCard> {
  _SalesCardState({required this.sale});

  final Sale sale;

  void showProductModal() {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return ModalSale(sale: sale);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // * Bordes de la tarjeta
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.zero),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: kPrimaryColor, borderRadius: BorderRadius.circular(8)),
              child: const Icon(
                Icons.shop,
                size: 20,
                color: Colors.white,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      '# Productos: ',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(right: 16),
                      child: Text(
                        sale.detailSaleList!.length.toString(),
                        style: const TextStyle(fontSize: 15),
                        textAlign: TextAlign.start,
                        softWrap: true,
                        maxLines: 3,
                        textWidthBasis: TextWidthBasis.parent,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Text(
                      'Costo: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ' ' + sale.getTotalWithTax(),
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.start,
                        softWrap: true,
                        maxLines: 3,
                        textWidthBasis: TextWidthBasis.parent,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // * Precio del producto
                  ],
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Realizado el ' + sale.getDateFormatted(),
                        style: const TextStyle(fontSize: 13),
                        textAlign: TextAlign.start,
                        softWrap: true,
                        maxLines: 1,
                        textWidthBasis: TextWidthBasis.parent,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                showProductModal();
              },
              child: Container(
                height: 35,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.keyboard_arrow_right_sharp,
                  color: Colors.grey,
                  size: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
