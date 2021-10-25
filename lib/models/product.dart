import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Product {
  String? id;
  String? name;
  String? description;
  String? image;
  String? price;
  String? weight;
  String? userId;

  DocumentReference? reference;

  Product(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.price,
      this.weight,
      this.userId,
      this.reference});

  factory Product.fromSnapshot(QueryDocumentSnapshot snapshot) {
    Product newProduct =
        Product.fromJson(snapshot.data() as Map<String, dynamic>);
    newProduct.reference = snapshot.reference;
    return newProduct;
  }

  factory Product.fromJson(Map<String, dynamic> json) => _productFromJson(json);

  getName() {
    return name;
  }

  getDescription() {
    return description;
  }

  getPrice() {
    return 'S/. ' + price!;
  }

  getWeight() {
    return weight;
  }

  getImageUrl() {
    return image;
  }

  Product.fromSnapShot(DataSnapshot snapshot) {
    id = snapshot.key;
    name = snapshot.value['name'];
    description = snapshot.value['description'];
    price = snapshot.value['price'];
    weight = snapshot.value['weight'];
    image = snapshot.value['image'];
    userId = snapshot.value['userId'];
  }

  toMapString() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'description': description,
      'weight': weight,
      'price': price,
      'userId': userId,
      'image': image
    };

    return map;
  }
}

Product _productFromJson(Map<String, dynamic> json) {
  return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      weight: json['weight'],
      userId: json['userId']);
}
