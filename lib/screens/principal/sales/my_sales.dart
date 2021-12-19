import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';

class MySales extends StatefulWidget {
  const MySales({Key? key}) : super(key: key);

  @override
  _MySalesState createState() => _MySalesState();
}

class _MySalesState extends State<MySales> {
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
            children: const [
              Text(
                "Mis ventas",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
