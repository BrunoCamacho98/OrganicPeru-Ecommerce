import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/models/detail_sale.dart';
import 'package:organic/models/product.dart';
import 'package:organic/models/user.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:organic/constants/globals.dart' as global;
import 'package:organic/util/queries/sales/sales_query.dart';

class ModalSales extends StatefulWidget {
  const ModalSales({Key? key, required this.user, required this.producto})
      : super(key: key);

  final Product producto;
  final UserLogin user;

  @override
  _ModalSalesState createState() =>
      // ignore: no_logic_in_create_state
      _ModalSalesState(user: user, producto: producto);
}

class _ModalSalesState extends State<ModalSales> {
  _ModalSalesState({required this.user, required this.producto});

  final Product producto;
  final UserLogin user;

  // ignore: non_constant_identifier_names
  final SaleQuery sales_query = SaleQuery();

  // * Controlador de la caja de texto de nombre
  final TextEditingController _cantidadController = TextEditingController();
  // * Controlador de la caja de texto de descripción
  double _totalPrice = 0;
  double stockRestante = 0;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _cantidadController.text = "0";
      stockRestante = double.parse(producto.getWeight());
    });
  }

  setCantidadCompra(double cantidad) {
    var price = double.parse(producto.price!);
    var stock = double.parse(producto.getWeight());

    setState(() {
      _totalPrice = cantidad * price;

      if (cantidad > stock) {
        stockRestante = stock;
        _cantidadController.text = stock.toString();
      } else {
        stockRestante = stock - cantidad;
      }

      _cantidadController.text = cantidad.toString();
    });
  }

  getDetailSale() {
    DetailSale detail = DetailSale(
        idProduct: producto.getId(),
        product: producto,
        amount: double.parse(_cantidadController.text),
        total: _totalPrice);

    return detail;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Comprar ' + producto.getName()),
      insetPadding: const EdgeInsets.all(5),
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: kPrimaryWhite,
      titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w400,
          wordSpacing: 0.8,
          letterSpacing: 0.2),
      actions: [
        MaterialButton(
          onPressed: loading
              ? null
              : () async {
                  DetailSale detail = getDetailSale();
                  global.detailSales = sales_query.addDetailSaleToList(
                      global.detailSales, detail);
                },
          height: 55,
          minWidth: double.infinity,
          color: kPrimaryColor,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          child: const Text(
            "Guardar",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
      elevation: 5.0,
      scrollable: true,
      content: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                producto.image != null
                    ? Image.network(
                        producto.image!,
                        height: 100,
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                          color: kPrimaryColor,
                        ),
                      ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "STOCK",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              producto.getWeight() + ' kg',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black87),
                              textAlign: TextAlign.start,
                              softWrap: true,
                              maxLines: 1,
                              textWidthBasis: TextWidthBasis.parent,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "PRECIO",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              producto.getPrice(),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black87),
                              textAlign: TextAlign.start,
                              softWrap: true,
                              maxLines: 1,
                              textWidthBasis: TextWidthBasis.parent,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: [
                      SpinBox(
                        min: 0,
                        max: double.parse(producto.getWeight()),
                        value: double.parse(_cantidadController.text),
                        decimals: 1,
                        step: 0.5,
                        onChanged: (value) => {setCantidadCompra(value)},
                      )
                      // TextField(
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: <TextInputFormatter>[
                      //     FilteringTextInputFormatter.digitsOnly,
                      //   ],
                      //   controller: _cantidadController,
                      //   onChanged: (value) => {setCantidadCompra(value)},
                      //   decoration: InputDecoration(
                      //       hintText: "Cantidad",
                      //       prefixIcon: const Icon(Icons.price_change),
                      //       border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(5))),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "STOCK RESTANTE",
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        stockRestante.toString(),
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black87),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "TOTAL",
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        _totalPrice.toString(),
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black87),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
