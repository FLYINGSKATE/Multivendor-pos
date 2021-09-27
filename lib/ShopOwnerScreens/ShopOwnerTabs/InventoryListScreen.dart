import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("ShopList").doc("Apunki Dukaan").collection("ProductList").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>
        snapshot) {
          if (!snapshot.hasData) return new Text("There is no expense");
          return new ListView(children: getExpenseItems(snapshot));
        });
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    print(snapshot.data!.docs.length);
    double _value = 0.0;
    return snapshot.data!.docs.map((doc) => new Container(
      color: Colors.black,
        child: GestureDetector(onTap:(){
          showModalBottomSheet(context: context, builder: (context) {
          return StatefulBuilder(builder:(BuildContext context,StateSetter setState){
            return Container(
              child: Column(
                children: [
                  SfSlider(
                    min: 0.0,
                    max: double.parse(doc["ProductStock"]),
                    value: _value,
                    interval: 1,
                    stepSize: 1,
                    showTicks: true,
                    showLabels: true,
                    showDividers: false,
                    enableTooltip: true,
                    minorTicksPerInterval: 1,
                    onChanged: (dynamic value){
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                  FlatButton(onPressed: (){}, child: Text("Hola"))
                ],
              )
            );
          });
          });
          }, child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doc["ProductName"], textAlign: TextAlign.center, style: TextStyle(
                color: Colors.white,
                fontFamily: 'Intern',
                fontSize: 40,
                letterSpacing: 0.20000001788139343,
                height: 1.400000028610228
            ),),
            Text(doc["ProductStock"], textAlign: TextAlign.center, style: TextStyle(
                color: Colors.white,
                fontFamily: 'Intern',
                fontSize: 20,
                letterSpacing: 0.20000001788139343,
                height: 1.400000028610228
            ),),
            Divider(height: 1,color: Colors.white,)
          ],
        ),
    ),)
    ).toList();
  }
}