import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.zero),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: kBackgroundColor,
                child: ClipOval(
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.asset("assets/images/saco-organic.jpeg"))),
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
