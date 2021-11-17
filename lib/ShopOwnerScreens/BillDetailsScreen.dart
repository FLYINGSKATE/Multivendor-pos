import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BillDetailsScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> doc;
  const BillDetailsScreen({Key? key, required this.doc}) : super(key: key);

  @override
  _BillDetailsScreenState createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<BillDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(""),);
  }
}
