import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String Price;
  final String SellerEmail;
  final String SellerContactNo;
  final String SellerName;
  final String Stock;
  final String Name;

  const Product(this.Price,
      this.SellerEmail,
      this.SellerContactNo,
      this.SellerName,
      this.Stock,
      this.Name);

  factory Product.fromDocument(DocumentSnapshot document) {
    return Product(
        document['Price'],
        document['SellerEmail'],
        document['SellerContactNo'],
        document['SellerName'],
        document['Stock'],
        document['Name']
    );
  }

  Product.fromJson(Map<String, dynamic> json)
      : Price = json['Price'],
        SellerContactNo = json['SellerContactNo'],
        SellerEmail = json['SellerEmail'],
        SellerName = json['SellerName'],
        Stock = json['Stock'],
        Name = json['Name'];

  Map<String, dynamic> toJson() => {
    'Price': Price,
    'SellerContactNo':SellerContactNo,
    'SellerEmail': SellerEmail,
    'SellerName': SellerName,
    'Stock': Stock,
    'Name': Name,
  };
}