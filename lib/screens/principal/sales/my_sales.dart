import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
// Widget
import 'package:date_time_picker/date_time_picker.dart';
import 'package:organic/models/sale.dart';
import 'package:organic/screens/principal/sales/sales_card.dart';
import 'package:organic/util/queries/sales/sales_query.dart';
// global
import 'package:organic/constants/globals.dart' as global;

class MySales extends StatefulWidget {
  const MySales({Key? key}) : super(key: key);

  @override
  _MySalesState createState() => _MySalesState();
}

class _MySalesState extends State<MySales> {
  final SaleQuery saleQuery = SaleQuery();

  List<Sale> saleList = [];

  DateTime date = DateTime.now();

  @override
  void initState() {
    getSaleList();

    super.initState();
  }

  getSaleList() {
    saleQuery
        .getSalesByUserProductsAndDate(global.userLogged!, date)
        .then((value) {
      setState(() {
        saleList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: 20),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Mis ventas",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DateTimePicker(
                type: DateTimePickerType.date,
                dateMask: 'dd MMMM, yyyy',
                initialValue: DateTime.now().toIso8601String(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2500),
                dateLabelText: 'Date',
                icon: const Icon(Icons.event),
                onChanged: (val) {
                  setState(() {
                    date = DateTime.parse(val);
                    getSaleList();
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: saleList.isNotEmpty
                    ? saleList.map((sale) {
                        return SalesCard(
                            sale: sale, showUser: true, useTax: false);
                      }).toList()
                    : [
                        Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height / 2,
                            child: const Text(
                                'No ha vendido sus productos en esta fecha'))
                      ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
