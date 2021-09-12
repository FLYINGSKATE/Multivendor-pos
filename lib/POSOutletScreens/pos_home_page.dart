import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/ProductModel.dart';
import 'package:rdipos/inventory.dart';


class POSHomePage extends StatefulWidget {
  const POSHomePage({Key? key}) : super(key: key);

  @override
  _POSHomePageState createState() => _POSHomePageState();
}

class _POSHomePageState extends State<POSHomePage> {
  List<int> text = [1,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4];

  List<ProductModel> productOnList = [
    ProductModel("Pepsi", 10.0),
    ProductModel("Mazza", 10.0),
    ProductModel("Coca Cola", 10.0),
    ProductModel("Lays", 5.0),
    ProductModel("Milki Bikis", 20.0),
    ProductModel("Broccoli", 40.0),
  ];

  double totalValue = 0.0;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/rdilogo.png'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.qr_code_scanner,
              color: Colors.green,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if(orientation==Orientation.landscape){
            return Row(
              children: [
                Expanded(
                  flex: 6,
                  child: TopPanel(),
                ),
                Expanded(
                    flex: 5,
                    child: BottomPanel()),
              ],
            );
          }
          else{
            return Column(
              children: [
                Expanded(
                  flex: 6,
                  child: TopPanel(),
                ),
                Expanded(
                    flex: 5,
                    child: BottomPanel()),
              ],
            );
          }
        },
      ),
    );
  }

  ProductLeftPanel() {
    return Container(
        width: MediaQuery.of(context).size.width/2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for ( var i in text ) Column(
                children: [SizedBox(height: 20,),Product()],
              )
            ],
          ),
        )
    );
  }


  void addToTotal(int i) {
    if(i==0){
      //That means we got a Zero
      totalValue *= 10;
      print(totalValue);
    }
    else{
      totalValue += i;
      print(totalValue);
    }
  }

  HomeButton(){
    return MaterialButton(
      onPressed: () {},
      color: Colors.white,
      textColor: Colors.black,
      child: Icon(
        Icons.home,
        size: 24,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );
  }

  ShowNumberButton() {
    return MaterialButton(
      onPressed: () {},
      color: Colors.white,
      textColor: Colors.black,
      child: Icon(
        Icons.format_list_numbered_sharp,
        size: 24,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );
  }

  TopPanel() {
    return Container(
      color: Colors.white10,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          BillHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for ( var i in text )Product(),
                ],
              ),
            ),
          ),
          TotalFooter(),
        ],
      ),
    );
  }

  Widget BillHeader() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text('Products', textAlign: TextAlign.left, style: TextStyle(
              color: Color.fromRGBO(38, 50, 56, 1),
              fontFamily: 'Inter',
              fontSize: 28,
              letterSpacing: 0.20000001788139343,
              fontWeight: FontWeight.bold,
              height: 1.400000028610228
          ),),
        ),
        Expanded(
          flex: 2,
          child: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(
              color: Color.fromRGBO(38, 50, 56, 1),
              fontFamily: 'Intern',
              fontSize: 20,
              letterSpacing: 0.20000001788139343,
              fontWeight: FontWeight.bold,
              height: 1.400000028610228
          ),),
        ),
        Expanded(
          flex: 2,
          child: Text('Price', textAlign: TextAlign.center, style: TextStyle(
              color: Color.fromRGBO(38, 50, 56, 1),
              fontFamily: 'Inter',
              fontSize: 20,
              letterSpacing: 0.20000001788139343,
              fontWeight: FontWeight.bold,
              height: 1.400000028610228
          ),),
        ),
      ],
    );
  }
  Widget Product(){
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text('Pepsi Cola', textAlign: TextAlign.left, style: TextStyle(
              color: Color.fromRGBO(38, 50, 56, 1),
              fontFamily: 'Inter',
              fontSize: 24,
              letterSpacing: 0.20000001788139343,
              fontWeight: FontWeight.normal,
              height: 1.400000028610228
          ),),
        ),
        Expanded(
          flex: 2,
          child: Text('x 10', textAlign: TextAlign.center, style: TextStyle(
              color: Color.fromRGBO(38, 50, 56, 1),
              fontFamily: 'Inter',
              fontSize: 16,
              letterSpacing: 0.20000001788139343,
              fontWeight: FontWeight.normal,
              height: 1.400000028610228
          ),),
        ),
        Expanded(
          flex: 2,
          child: Text('10 ₹', textAlign: TextAlign.center, style: TextStyle(
              color: Color.fromRGBO(38, 50, 56, 1),
              fontFamily: 'Inter',
              fontSize: 16,
              letterSpacing: 0.20000001788139343,
              fontWeight: FontWeight.normal,
              height: 1.400000028610228
          ),),
        ),
      ],
    );
  }
  Widget TotalFooter(){
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text('Total', textAlign: TextAlign.left, style: TextStyle(
              color: Color.fromRGBO(38, 50, 56, 1),
              fontFamily: 'Inter',
              fontSize: 28,
              letterSpacing: 0.20000001788139343,
              fontWeight: FontWeight.bold,
              height: 1.400000028610228
          ),),
        ),
        Expanded(
          flex: 2,
          child: Text('x 100', textAlign: TextAlign.center, style: TextStyle(
              color: Color.fromRGBO(38, 50, 56, 1),
              fontFamily: 'Inter',
              fontSize: 20,
              letterSpacing: 0.20000001788139343,
              fontWeight: FontWeight.bold,
              height: 1.400000028610228
          ),),
        ),
        Expanded(
          flex: 2,
          child: Text('100 ₹', textAlign: TextAlign.center, style: TextStyle(
              color: Color.fromRGBO(38, 50, 56, 1),
              fontFamily: 'Inter',
              fontSize: 20,
              letterSpacing: 0.20000001788139343,
              fontWeight: FontWeight.bold,
              height: 1.400000028610228
          ),),
        ),
      ],
    );
  }

  Widget BottomPanel() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex:1,
                  child: Container(
                    color: Colors.black,
                    child: MaterialButton(
                      onPressed: () => {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InventoryPanel()),
                      )},
                      color: Colors.black,
                      padding: EdgeInsets.all(10.0),
                      child: Column( // Replace with a Row for horizontal icon + text
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.inventory,color: Colors.red,size: 40,),
                          SizedBox(height: 10,),
                          Text('Add From Inventory', textAlign: TextAlign.center, style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Inter',
                              fontSize: 20,
                              letterSpacing: 0.20000001788139343,
                              fontWeight: FontWeight.normal,
                              height: 1.400000028610228
                          ),),
                        ],
                      ),
                    ),
                    //child: RaisedButton.icon(color:Colors.black,onPressed: (){print("OLA");}, icon: Icon(Icons.inventory,color: Colors.red,), label: Text("Add From Inventory",style: TextStyle(color: Colors.red),)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex:1,
                  child: Container(
                    color: Colors.black,
                    child: MaterialButton(
                      onPressed: (){

                      },
                      color: Colors.black,
                      padding: EdgeInsets.all(10.0),
                      child: Column( // Replace with a Row for horizontal icon + text
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.person,color: Colors.red,size: 40,),
                          SizedBox(height: 10,),
                          Text('My Profile', textAlign: TextAlign.center, style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Inter',
                              fontSize: 20,
                              letterSpacing: 0.20000001788139343,
                              fontWeight: FontWeight.normal,
                              height: 1.400000028610228
                          ),),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.black,
                    child: MaterialButton(
                      onPressed: () => {print("")},
                      color: Colors.black,
                      padding: EdgeInsets.all(10.0),
                      child: Column( // Replace with a Row for horizontal icon + text
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.list_alt_outlined,color: Colors.red,size: 40,),
                          SizedBox(height: 10,),
                          Text('Proceed For Billing', textAlign: TextAlign.center, style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Inter',
                              fontSize: 20,
                              letterSpacing: 0.20000001788139343,
                              fontWeight: FontWeight.normal,
                              height: 1.400000028610228
                          ),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
