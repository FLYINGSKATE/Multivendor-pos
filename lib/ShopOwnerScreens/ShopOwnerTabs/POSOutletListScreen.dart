import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/Utility/widget_helper.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class POSOutletList extends StatefulWidget {

  final String shopName;
  const POSOutletList({Key? key, required this.shopName}) : super(key: key);

  @override
  _POSOutletListState createState() => _POSOutletListState();
}

class _POSOutletListState extends State<POSOutletList> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("ShopList").doc(widget.shopName).collection("POSOutlets").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>
        snapshot) {
          if (!snapshot.hasData) return new Text("There is no POS Outlets in Your Shop!");
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
                            Expanded(flex:1,child:Text(doc["POSUSerName"],style:TextStyle(color: Colors.black,fontSize: 40,fontWeight: FontWeight.bold,fontFamily: 'MPLUSRounded1c'))),
                            Expanded(flex:1,child:Text(doc["POSUserPassword"] +'₹',style:TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: 'MPLUSRounded1c'))),
                            SizedBox(width: 2,),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            WidgetHelper().CustomSecondaryRoundedButton("Cancel", (){Navigator.pop(context);}),
                            WidgetHelper().CustomPrimaryRoundedButton("Add Stock", (){
                              //FirebaseRepo().AddStock(doc["ProductName"], _value.toString());
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
                  Expanded(child:Text(doc["POSUserName"], textAlign: TextAlign.start, style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Intern',
                      fontSize: MediaQuery.of(context).size.width*0.04,
                      letterSpacing: 0.20000001788139343,
                      height: 1.400000028610228
                  ),)),
                  Expanded(child:Text(doc["POSUserContact"], textAlign: TextAlign.end, style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Intern',
                      fontSize: MediaQuery.of(context).size.width*0.04,
                      letterSpacing: 0.20000001788139343,
                      height: 1.400000028610228
                  ),)),
                ],
              ),
              Divider(height: 1,color: Colors.white,)
            ],
          ),
        ),))
    ).toList();
  }
}