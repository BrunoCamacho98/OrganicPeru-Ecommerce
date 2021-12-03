import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organic/constants/globals.dart' as global;
import 'package:organic/constants/theme.dart';
import 'package:organic/methods/global_methods.dart';
// Model
import 'package:organic/models/sale.dart';
import 'package:organic/services/mail/mail_service.dart';
import 'package:organic/util/queries/product/product_query.dart';
import 'package:organic/util/queries/sales/sales_query.dart';

class ConfirmSale extends StatefulWidget {
  const ConfirmSale({Key? key, required this.confirm}) : super(key: key);

  final Function confirm;

  @override
  // ignore: no_logic_in_create_state
  _ConfirmSaleState createState() => _ConfirmSaleState(confirm: confirm);
}

class _ConfirmSaleState extends State<ConfirmSale> {
  _ConfirmSaleState({required this.confirm});

  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  bool loading = false;

  final Function confirm;

  final SaleQuery saleQuery = SaleQuery();
  final ProductQuery productQuery = ProductQuery();

  final _formkey = GlobalKey<FormState>();

  Sale sale = Sale(
      idUsuario: global.userLogged!.id!,
      address: '',
      cvv: '',
      dateSale: '',
      dueDate: '',
      name: '',
      number: '',
      state: '',
      type: '',
      email: '',
      total: 0);

  @override
  void initState() {
    super.initState();
    setState(() {
      addressController.text = '';
      emailController.text = '';
      sale.total = getTotal();
      sale.state = 'Spending';
    });
  }

  getTotal() {
    double total = 0;

    for (var element in global.detailSales) {
      total += element.total;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formkey,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 100,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                const Text(
                  "Confirmar compra",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Positioned(
                  top: 60,
                  height: 80,
                  width: MediaQuery.of(context).size.width - 50,
                  child: const Text(
                    "Datos de la compra",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  height: 80,
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) =>
                        val!.isEmpty ? "Ingrese un correo" : null,
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Correo eléctronico",
                        prefixIcon: const Icon(Icons.mail),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.black26))),
                  ),
                ),
                // * Caja de texto para ingreso de email
                Positioned(
                  top: 180,
                  height: 80,
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) =>
                        val!.isEmpty ? "Ingrese su dirección" : null,
                    controller: addressController,
                    decoration: InputDecoration(
                        hintText: "Dirección",
                        prefixIcon: const Icon(Icons.location_city),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.black26))),
                  ),
                ),
                Positioned(
                  top: 270,
                  height: 80,
                  width: MediaQuery.of(context).size.width - 50,
                  child: const Text(
                    "Datos de la tarjeta",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // * Caja de texto para ingreso de contraseña
                Positioned(
                  top: 310,
                  height: 80,
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: "Titular de la tarjeta",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                Positioned(
                  top: 390,
                  height: 80,
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: InputDecoration(
                        hintText: "Número de la tarjeta",
                        prefixIcon: const Icon(Icons.card_giftcard),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                Positioned(
                  top: 480,
                  height: 80,
                  left: 0,
                  width: (MediaQuery.of(context).size.width / 2) - 30,
                  child: TextFormField(
                    controller: cvvController,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 14),
                        hintText: "cvv",
                        prefixIcon: const Icon(
                          Icons.vpn_key,
                          size: 18,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                Positioned(
                  top: 480,
                  height: 70,
                  right: 0,
                  width: (MediaQuery.of(context).size.width / 2) - 30,
                  child: TextFormField(
                    controller: dueDateController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 14),
                        hintText: "mm/yy",
                        prefixIcon: const Icon(
                          Icons.date_range_sharp,
                          size: 18,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                // * Botón para validar el inicio de sesión
                Positioned(
                  top: 580,
                  height: 60,
                  width: MediaQuery.of(context).size.width - 50,
                  child: MaterialButton(
                    onPressed: loading
                        ? null
                        : () async {
                            var now = DateTime.now();
                            if (_formkey.currentState!.validate()) {
                              sale.address = addressController.text;
                              sale.email = emailController.text;
                              sale.dueDate = dueDateController.text;
                              sale.name = nameController.text;
                              sale.cvv = cvvController.text;
                              sale.total = getTotal();
                              sale.state = 'Completed';
                              sale.number = numberController.text;
                              sale.dateSale = now.toIso8601String();

                              var saleResult = saleQuery.addSale(
                                  context, global.detailSales, sale);

                              var code = 'INV/' +
                                  global.userLogged!.id!.substring(0, 4) +
                                  '/' +
                                  getDate(DateTime.now());

                              try {
                                saleQuery.addVaucher(context, sale, code);
                                await mail(sale, code);
                              } catch (error) {
                                // ignore: avoid_print
                                print(error.toString());
                              }

                              for (var detail in global.detailSales) {
                                var stock =
                                    double.parse(detail.product!.weight!) -
                                        detail.getAmount();

                                var producto = detail.product;
                                producto!.weight = stock.toString();

                                productQuery.productReference
                                    .doc(producto.id)
                                    .update(producto.toMapString());
                              }

                              setState(() {
                                global.detailSales = [];
                                loading = true;
                              });

                              if (saleResult.id != null) {
                                toPrincipal(context, global.userLogged);
                              }
                            }
                          },
                    height: 55,
                    minWidth: double.infinity,
                    color: loading ? Colors.grey.shade700 : kPrimaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    child: const Text(
                      "Realizar compra",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
