import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/Product.dart';
import 'package:rdipos/widget_helper.dart';

class InventoryPanel extends StatefulWidget {
  const InventoryPanel({Key? key}) : super(key: key);

  @override
  _InventoryPanelState createState() => _InventoryPanelState();
}

class _InventoryPanelState extends State<InventoryPanel> {

  Map tempinventoryProductList = {};
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().RdiAppBar(),
      body:Container(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

        },
        backgroundColor: Colors.red,
        icon: Icon(Icons.add),
        label: Text("Add to Bill"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
  SearchBox() {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(100.0),

          ),
          filled: true,
          focusColor: Colors.red,
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(100.0),

          ),
          prefixIcon:Icon(Icons.search,size: 40,color: Colors.white,),
          hintStyle: TextStyle(color: Colors.grey[100],fontSize: 20),
          hintText: "Search Products",
          fillColor: Colors.black
      ),
    );
  }


  ProductListCard(String name,String quantity) {
    bool _visibleFullCard = false;
    return GestureDetector(
      onDoubleTap: (){_visibleFullCard=!_visibleFullCard;print(_visibleFullCard);setState(() {});},
      child:Column(children: [
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('$name', textAlign: TextAlign.left, style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 20,
                      letterSpacing: 0.20000001788139343,
                      fontWeight: FontWeight.bold,
                      height: 1.400000028610228
                  ),),
                ),
                Expanded(
                  flex: 1,
                  child: Text('$quantity SKU', textAlign: TextAlign.left, style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 20,
                      letterSpacing: 0.20000001788139343,
                      fontWeight: FontWeight.bold,
                      height: 1.400000028610228
                  ),),
                ),
                Expanded(
                  flex: 4,
                  child:QuantityCounter() ,
                )
              ],
            )
        ),
        Visibility(
          visible: _visibleFullCard,
          child:Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('$name', textAlign: TextAlign.left, style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 20,
                      letterSpacing: 0.20000001788139343,
                      fontWeight: FontWeight.bold,
                      height: 1.400000028610228
                  ),),
                ),
                Expanded(
                  flex: 1,
                  child: Text('$quantity SKU', textAlign: TextAlign.left, style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 20,
                      letterSpacing: 0.20000001788139343,
                      fontWeight: FontWeight.bold,
                      height: 1.400000028610228
                  ),),
                ),
                Expanded(
                  flex: 4,
                  child:QuantityCounter() ,
                )
              ],
            )
        ) ),
      ],) ,
    );
  }

  QuantityCounter() {
    int counter = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            counter = counter+1;
            setState(() {
              print(counter);
            });
          },
          child: Text("+",style: TextStyle(color:Colors.white,fontSize: 28)),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(5),
            primary: Colors.red, // <-- Button color
            onPrimary: Colors.black, // <-- Splash color
          ),
        ),
        Container(
          width: 60,
          height: 60,
          child: Center(child: Text("$counter",style: TextStyle(fontSize: 28),)),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFe0f2f1)),
        ),
        ElevatedButton(
          onPressed: () {
            counter--;
            setState(() {
              print(counter);
            });
          },
          child: Text("-",style: TextStyle(color:Colors.white,fontSize: 28)),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(5),
            primary: Colors.red, // <-- Button color
            onPrimary: Colors.black, // <-- Splash color
          ),
        ),
      ],
    );
  }
}
