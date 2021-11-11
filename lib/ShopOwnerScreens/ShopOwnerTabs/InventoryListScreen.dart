import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/Utility/widget_helper.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class InventoryScreen extends StatefulWidget {
  final String shopName;
  const InventoryScreen({Key? key, required this.shopName}) : super(key: key);

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
          if (!snapshot.hasData) return new Text("There is no Inventory in Stock!");
          return new ListView(children: getExpenseItems(snapshot));
        });
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    print(snapshot.data!.docs.length);
    double _value = 0.0;
    return snapshot.data!.docs.map((doc) => new Container(
      color: Colors.black,
        child: GestureDetector(
          onTap:(){
          showModalBottomSheet(context: context, builder: (context) {
          return StatefulBuilder(builder:(BuildContext context,StateSetter setState){
            return Container(
              padding:
              EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 2,),
                      Text(doc["ProductName"],style:TextStyle(color: Colors.black,fontSize: 40,fontWeight: FontWeight.bold,fontFamily: 'MPLUSRounded1c')),
                      Text(doc["Product Price"] +'₹',style:TextStyle(color: Colors.black,fontSize: 40,fontWeight: FontWeight.bold,fontFamily: 'MPLUSRounded1c')),
                      SizedBox(width: 2,),
                    ],
                  ),
                  SfSlider(
                    min: 1.0,
                    max: double.parse(doc["ProductStock"])+10,
                    value: _value,
                    interval: double.parse(doc["ProductStock"])>50?double.parse(doc["ProductStock"])/10:1,
                    stepSize: 1,
                    showTicks: true,
                    showLabels: true,
                    showDividers: false,
                    enableTooltip: true,
                    onChanged: (dynamic value){
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WidgetHelper().CustomSecondaryRoundedButton("Cancel", (){Navigator.pop(context);}),
                      WidgetHelper().CustomPrimaryRoundedButton("Add Stock", (){
                        FirebaseRepo().AddStock(widget.shopName,doc["ProductName"], _value.toString());
                        setState;
                        Navigator.pop(context);
                      }),
                    ],
                  )
                ],
              )
            );
          });
          });
          }, child:Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left:10,right: 10),
          child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child:Text(doc["ProductName"], textAlign: TextAlign.start, style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Intern',
                    fontSize:  MediaQuery.of(context).size.width*0.04,
                    letterSpacing: 0.20000001788139343,
                    height: 1.400000028610228
                ),)),
                Text(doc["Product Price"]+"₹", textAlign: TextAlign.center, style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Intern',
                    fontSize:  MediaQuery.of(context).size.width*0.04,
                    letterSpacing: 0.20000001788139343,
                    height: 1.400000028610228
                ),),
              ],
            ),
            Text((int.parse(doc["ProductStock"])>0)?"In Stock : "+doc["ProductStock"]:"Out Of Stock", textAlign: TextAlign.center, style: TextStyle(
                color: (int.parse(doc["ProductStock"])>0)?Colors.white:Colors.red,
                fontFamily: 'Intern',
                fontSize:  MediaQuery.of(context).size.width*0.03,
                letterSpacing: 0.20000001788139343,
                height: 1.400000028610228
            ),),
            Divider(height: 1,color: Colors.white,)
          ],
        ),
    ),))
    ).toList();
  }
}