import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/Utility/widget_helper.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'POSOutletScreens/pos_home_page.dart';


class AddFromInventoryPanel extends StatefulWidget {
  final String shopName;
  final List<Map<String,dynamic>> bill;

  const AddFromInventoryPanel({Key? key,required this.shopName, required this.bill}) : super(key: key);

  @override
  _AddFromInventoryPanelState createState() => _AddFromInventoryPanelState();
}

class _AddFromInventoryPanelState extends State<AddFromInventoryPanel> {

  bool showDoneButton = false;
  List<Map<String,dynamic>> bill=new List<Map<String,dynamic>>.empty(growable: true);

  refereshScaffold(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetHelper().RdiAppBar(context),
        floatingActionButton:showDoneButton?FloatingActionButton.extended(
          onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => POSHomePage(bill: bill, shopName: widget.shopName,)));
          },
          backgroundColor: Colors.red,
          icon: Icon(Icons.check),
          label: Text("Done Adding!"),
        ):null,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("ShopList").doc("Apunki Dukaan").collection("ProductList").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>
        snapshot) {
          if (!snapshot.hasData) return new Text("There is no Stock in Inventory!");
          return new ListView(children: getExpenseItems(snapshot));
        }));
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
                          max: int.parse(doc["ProductStock"])+10,
                          value: _value,
                          interval: int.parse(doc["ProductStock"])>50?(int.parse(doc["ProductStock"])/10):1,
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
                            WidgetHelper().CustomPrimaryRoundedButton("Add To Bill", () async {
                              bool removedSuccessFully = await FirebaseRepo().RemoveStock(widget.shopName,doc["ProductName"], _value.toString());
                              showDoneButton = true;
                              if(removedSuccessFully){
                                Map<String,dynamic> tempProduct = doc.data() as Map<String,dynamic>;
                                tempProduct["ProductStock"] = _value.toString();
                                print("Adding "+tempProduct["ProductStock"]+" "+tempProduct["ProductName"]+ " To Bill");
                                AddThisProductToBill(tempProduct);
                              }
                              setState;
                              refereshScaffold();
                              print(showDoneButton);
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
                  Text(doc["ProductName"], textAlign: TextAlign.center, style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Intern',
                      fontSize: 40,
                      letterSpacing: 0.20000001788139343,
                      height: 1.400000028610228
                  ),),
                  Text(doc["Product Price"]+"₹", textAlign: TextAlign.center, style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Intern',
                      fontSize: 40,
                      letterSpacing: 0.20000001788139343,
                      height: 1.400000028610228
                  ),),
                ],
              ),
              Text((int.parse(doc["ProductStock"])>0)?"In Stock : "+doc["ProductStock"]:"Out Of Stock", textAlign: TextAlign.center, style: TextStyle(
                  color: (int.parse(doc["ProductStock"])>0)?Colors.white:Colors.red,
                  fontFamily: 'Intern',
                  fontSize: 20,
                  letterSpacing: 0.20000001788139343,
                  height: 1.400000028610228
              ),),
              Divider(height: 1,color: Colors.white,)
            ],
          ),
        ),))
    ).toList();
  }

  void AddThisProductToBill(Map<String,dynamic> product) {
    //Traverse the Products and
    print("OH BHAI YEH HAI PRODUCT LIST :"+product.toString());
    for(int i = 0;i<widget.bill.length;i++){
      if(widget.bill[i]["ProductName"]==product["ProductName"]){
        print(product["ProductName"]+"Product Already Exists in the Bill");
        print(widget.bill[i]["ProductStock"].toString() + "Before Adding Stock");
        widget.bill[i]["ProductStock"] = (int.parse(widget.bill[i]["ProductStock"])+int.parse(product["ProductStock"])).toString();
        print(widget.bill[i]["ProductStock"].toString() + "After Adding Stock");
        bill = widget.bill;
        return;
      }
    }
    print(product["ProductName"]+"Product Doesn't Exsists in the Bill");
    bill = widget.bill;
    bill.add(product);
    return;
    //Traverse Full Bill Check if Product Exists then Add Stock instead of doing so.
  }

}
