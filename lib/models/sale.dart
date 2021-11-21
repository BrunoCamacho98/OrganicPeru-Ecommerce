import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Sale {
  String? id;
  String? name;
  String? description;
  String? image;
  String? price;
  String? weight;
  String? userId;

  DocumentReference? reference;

  Sale(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.price,
      this.weight,
      this.userId,
      this.reference});

  factory Sale.fromSnapshot(QueryDocumentSnapshot snapshot) {
    Sale newSale = Sale.fromJson(snapshot.data() as Map<String, dynamic>);
    newSale.reference = snapshot.reference;
    return newSale;
  }

  factory Sale.fromJson(Map<String, dynamic> json) => _saleFromJson(json);

  getName() {
    return (name != null ? name! : " - ");
  }

  getDescription() {
    return description;
  }

  getPrice() {
    return 'S/. ' + (price != null ? price! : " - ");
  }

  getWeight() {
    return weight;
  }

  getImageUrl() {
    return image;
  }

  Sale.fromSnapShot(DataSnapshot snapshot) {
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

Sale _saleFromJson(Map<String, dynamic> json) {
  return Sale(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      weight: json['weight'],
      userId: json['userId']);
}
