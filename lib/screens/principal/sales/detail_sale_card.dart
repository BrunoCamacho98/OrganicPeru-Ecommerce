import 'package:flutter/material.dart';
// * CONSTANT
import 'package:organic/constants/theme.dart';
import 'package:organic/models/detail_sale.dart';
// * MODEL
import 'package:organic/models/product.dart';

// ignore: must_be_immutable
class DetailSaleCard extends StatelessWidget {
  // * Parametros de la vista
  // ? key: Clave de la vista, no es necesario colocarle un valor
  // ? Product: Producto que se esta instanciando
  // ? removeProduct: Función para eliminar producto;
  DetailSaleCard(
      {Key? key,
      required this.detailSale,
      required this.product,
      required this.remove,
      required this.useRemove})
      : super(key: key);

  final DetailSale detailSale;

  final Function remove;

  bool useRemove = false;

  // * Variable del producto
  final Product product;

  Widget? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      decoration: const BoxDecoration(
          border: Border(
        top: BorderSide(
            color: Colors.black12, style: BorderStyle.solid, width: 1),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: kBackgroundColor,
                    child: ClipOval(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: product.image != null
                            // * Imagen del producto, mediante el enlace guardado al crearlo
                            ? Image.network(
                                product.image!,
                                width: 10,
                                height: 10,
                              )
                            // * En caso no tenga una imagen guardada aparecerá este elemento
                            : Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                // * Nombre del producto
                Container(
                  width: MediaQuery.of(context).size.width / 3.5,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    product.getName(),
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.start,
                    softWrap: true,
                    maxLines: 3,
                    textWidthBasis: TextWidthBasis.parent,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                useRemove ? const Spacer() : const SizedBox(),
                // * Precio del producto
                useRemove
                    ? IconButton(
                        key: const Key("removeOption"),
                        onPressed: () => remove(detailSale),
                        alignment: Alignment.center,
                        color: Colors.redAccent,
                        icon: const Icon(Icons.cancel))
                    : const SizedBox()
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerLeft,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cantidad: ',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          maxLines: 3,
                          textWidthBasis: TextWidthBasis.parent,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          detailSale.getAmountFormatted(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w100,
                              color: Colors.black87),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          maxLines: 3,
                          textWidthBasis: TextWidthBasis.parent,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                ),
                const Spacer(),
                // * Precio del producto
                Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Costo: ',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                        textAlign: TextAlign.start,
                        softWrap: true,
                        maxLines: 3,
                        textWidthBasis: TextWidthBasis.parent,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        detailSale.getTotalFormatted(),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                            color: Colors.black87),
                        textAlign: TextAlign.start,
                        softWrap: true,
                        maxLines: 3,
                        textWidthBasis: TextWidthBasis.parent,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
