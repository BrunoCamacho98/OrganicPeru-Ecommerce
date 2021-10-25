// * SERVICES
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
// * CONSTANT
import 'package:organic/constants/theme.dart';
// * MODEL
import 'package:organic/models/product.dart';

class ProductCard extends StatelessWidget {
  ProductCard({Key? key, required this.product}) : super(key: key);

  final Product product;

  CollectionReference productReference =
      FirebaseFirestore.instance.collection('Product');

  Future<void> removeProduct() {
    return productReference.doc(product.id).delete();
  }

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
                        width: 40,
                        height: 40,
                        child: url != null
                            ? Image.network(
                                product.image!,
                                width: 10,
                                height: 10,
                              )
                            : Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Colors.grey,
                                ),
                              ))),
              ),
            ),
            Text(
              product.getName(),
              style: const TextStyle(fontSize: 16),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              product.getPrice(),
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                alignment: Alignment.center,
                color: Colors.blueAccent,
                icon: const Icon(Icons.edit_outlined)),
            IconButton(
                onPressed: () async => removeProduct(),
                alignment: Alignment.center,
                color: Colors.redAccent,
                icon: const Icon(Icons.delete_outline))
          ],
        ),
      ),
    );
  }
}
