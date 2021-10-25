// * SERVICES
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
  String? url;

  Future loadFile(String? image) async {
    if (image == null) return null;

    final fileName = basename(image);
    final destination = 'files/$fileName';

    final ref = FirebaseStorage.instance.ref().child('files').child(fileName);
    var url = await ref.getDownloadURL();
    print(url);
    return url;
  }

  @override
  Widget build(BuildContext context) {
    loadFile(product.image).then((value) => url = (value as String));

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
                        child: url != null
                            ? Image.network(url!)
                            : Container(
                                width: 15,
                                height: 15,
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
            ),
          ],
        ),
      ),
    );
  }
}
