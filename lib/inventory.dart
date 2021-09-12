import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InventoryPanel extends StatefulWidget {
  const InventoryPanel({Key? key}) : super(key: key);

  @override
  _InventoryPanelState createState() => _InventoryPanelState();
}

class _InventoryPanelState extends State<InventoryPanel> {

  late int County = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/rdilogo.png'),),
      body:Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(height: 10,),
            SearchBox(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    ProductListCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ) ,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          getDocs();
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

  Future getDocs() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("/Aflatoon General Store").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      print(a.data());
    }
  }

  ProductListCard() {
    return Container(
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
              child: Text('Pepsi Cola', textAlign: TextAlign.left, style: TextStyle(
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
            child: Text('10 ₹', textAlign: TextAlign.left, style: TextStyle(
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
    );
  }

  QuantityCounter() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            County = County+1;
            setState(() {
              print(County);
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
          child: Center(child: Text("$County",style: TextStyle(fontSize: 28),)),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFe0f2f1)),
        ),
        ElevatedButton(
          onPressed: () {
            County--;
            setState(() {
              print(County);
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