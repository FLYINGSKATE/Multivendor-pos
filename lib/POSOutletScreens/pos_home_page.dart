import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/ApiRepo/payments.dart';
import 'package:rdipos/POSOutletScreens/CheckOutScreen.dart';
import 'package:rdipos/Utility/Bouncing.dart';
import 'package:rdipos/POSOutletScreens/pos_user_profile.dart';
import 'package:rdipos/ProductModel.dart';
import 'package:rdipos/AddFromInventory.dart';
import 'package:rdipos/Utility/widget_helper.dart';
import 'package:spring/spring.dart';

class POSHomePage extends StatefulWidget {
  final String shopName;
  final List<Map<String,dynamic>> bill;

  const POSHomePage({Key? key,required this.bill, required this.shopName}) : super(key: key);

  @override
  _POSHomePageState createState() => _POSHomePageState();
}

class _POSHomePageState extends State<POSHomePage> with TickerProviderStateMixin{

  bool quantityMode = false;
  bool DiscMode = false;
  bool PriceMode = false;
  bool plusMode = false;

  double totalValue = 0.0;

  String tempQuantity = "0";

  String totalPrice = "0";

  String totalQuantity = "0";

  String totalDiscount = "0";

  double tempPrice = 0;

  double tempDiscount = 0;

  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  late AnimationController controller;
  late Animation<Offset> offset;

  String selectedProductName = "";

  int selectedProductQuantity = 0;

  int selectedProductPrice = 0;

  TextEditingController _posBarcodeTextEditingController = TextEditingController();

  late FocusNode _posBarcodeTextFieldFocusNode;

  void _requestPosBarcodeTextFieldFocusNode() {
    setState(() {
      FocusScope.of(context).requestFocus(_posBarcodeTextFieldFocusNode);
    });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    _posBarcodeTextFieldFocusNode = FocusNode();

    //Adding Products to bill
    for(Map<String,dynamic> singleProduct in widget.bill){
      int priceTemp = int.parse(singleProduct["Product Price"]) * int.parse(singleProduct["ProductStock"]);
      tempPrice = tempPrice+priceTemp;
      String stockTemp = singleProduct["ProductStock"];
      //tempQuantity = tempQuantity+stockTemp;
    }

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0)).animate(controller);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);


  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:WidgetHelper().RdiAppBar(context),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if(orientation==Orientation.landscape){
            return Column(
              children: [
                Expanded(
                  flex:1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child:TextField(
                        autofocus: true,
                        focusNode: _posBarcodeTextFieldFocusNode,
                        onTap: _requestPosBarcodeTextFieldFocusNode,
                        onChanged: (value) async {
                          if(value.length>=10){
                            //Remove Product From to Stock
                            print(value);
                            Map<String,dynamic>? productDetails = await FirebaseRepo().FetchProductFromBarcode(widget.shopName,value);
                            if(productDetails==null){
                              SnackBar(
                                backgroundColor: Colors.black,
                                content: Text(
                                  "Product Doesn't Exists - Contact Shop Owner",
                                  style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
                                ),
                              );
                              return;
                            }
                            await FirebaseRepo().RemoveStock(widget.shopName, productDetails["ProductName"],"1").then((value) =>AddProductToBill(productDetails));
                          }
                        },
                      )),
                    ],
                  ),
                ),
                Expanded(
                  flex:9,
                  child:Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: TopPanel(),
                    ),
                    Expanded(
                        flex: 5,
                        child: BottomPanel()),
                  ],
                ),),
              ],
            );
          }
          else{
            return Column(
              children: [
                Expanded(flex: 1,child:TextField(
                  autofocus: true,
                  focusNode: _posBarcodeTextFieldFocusNode,
                  onTap: _requestPosBarcodeTextFieldFocusNode,
                  onChanged: (value) async {
                    if(value.length>=10){
                      //Remove Product From to Stock
                      print(value);
                      Map<String,dynamic>? productDetails = await FirebaseRepo().FetchProductFromBarcode(widget.shopName,value);
                      if(productDetails==null){
                        SnackBar(
                          backgroundColor: Colors.black,
                          content: Text(
                            "Product Doesn't Exists - Contact Shop Owner",
                            style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
                          ),
                        );
                        return;
                      }
                      await FirebaseRepo().RemoveStock(widget.shopName, productDetails["ProductName"],"1").then((value) =>AddProductToBill(productDetails));
                    }
                  },
                )),
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

  //UIs
  ProductLeftPanel() {
    return Container(
        width: MediaQuery.of(context).size.width/2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(children: [SizedBox(height: 20,)],
              )
            ],
          ),
        )
    );
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

  /*TopPanel() {
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
                  Product(),
                ],
              ),
            ),
          ),
          TotalFooter(),
        ],
      ),
    );
  }*/

  TopPanel() {
    return Container(
      color: Colors.white10,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          BillHeader(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.bill.length,
              itemBuilder: (BuildContext context, int index){
                return Product(
                    widget.bill[index]['ProductName'],
                    int.parse(widget.bill[index]['ProductStock'])*int.parse(widget.bill[index]['Product Price']),
                    int.parse(widget.bill[index]['ProductStock']));
              },
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

  Widget Product(String productName,int productPrice,int productStock){
    return GestureDetector(onTap:(){
      ///When Product Selected Make all the temp calculated value to Zero
      tempQuantity = "0";
      tempPrice = 0;
      tempDiscount = 0;
      selectedProductName = productName;
      selectedProductQuantity = productStock;
      selectedProductPrice = productPrice;
      print(productName);} ,child:Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Text('$productName', textAlign: TextAlign.left, style: TextStyle(
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
              child: Text(productStock.toString(), textAlign: TextAlign.center, style: TextStyle(
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
              child: Text( productPrice.toString()+'₹', textAlign: TextAlign.center, style: TextStyle(
                  color: Color.fromRGBO(38, 50, 56, 1),
                  fontFamily: 'Inter',
                  fontSize: 16,
                  letterSpacing: 0.20000001788139343,
                  fontWeight: FontWeight.normal,
                  height: 1.400000028610228
              ),),
            ),
          ],
        ),
        //Messages to show are : -
        //Added 10 more banana to bill
        //Removed 10 banana from bill
        //Added 10% Dicount to Banana
        //Reduced 10% Discount from Banana
        //No More Stock Available
        Visibility(
          visible: true,
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(text: 'Added', style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                children: <TextSpan>[
                TextSpan(text: '10 Stock more',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline)
                ),
                  TextSpan(text: 'to $selectedProductName',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)
                  )
            ]),
            ),
          ),
          ],
    )
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
          child: Text('$tempQuantity', textAlign: TextAlign.center, style: TextStyle(
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
          child: Text('$tempPrice ₹', textAlign: TextAlign.center, style: TextStyle(
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
    return Stack(
      children: [
        Container(
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
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(0.0),
                              bottomRight: Radius.circular(0.0),
                              topLeft: Radius.circular(60.0),
                              bottomLeft: Radius.circular(0.0)),
                        ),

                        child: FlatButton(
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => POSUserProfile()));
                          },
                          color: Colors.transparent,
                          padding: EdgeInsets.all(10.0),
                          child: Column( // Replace with a Row for horizontal icon + text
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.userAlt,color: Colors.red,size: 40,),
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
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(60.0),
                              bottomRight: Radius.circular(0.0),
                              topLeft: Radius.circular(0.0),
                              bottomLeft: Radius.circular(0.0)),
                        ),
                        child: FlatButton(
                          onPressed: () => {
                            //int totalAmountToPay = 0;
                            //for(int i = 0;i<widget.bill.length;i++){

                            //}
                            if(kIsWeb){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>CheckoutScreen(shopName: widget.shopName, price: 2 ,)))
                            }
                            else{
                              openCheckout()
                            }
                          },
                          color: Colors.transparent,
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
                            MaterialPageRoute(builder: (context) => AddFromInventoryPanel(shopName:widget.shopName,bill:widget.bill)),
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
                    Expanded(
                      flex:1,
                      child: Container(
                        color: Colors.black,
                        child: MaterialButton(
                          onPressed: () {

                            controller.reverse();
                            setState(() {
                            });
                          },
                          color: Colors.black,
                          padding: EdgeInsets.all(10.0),
                          child: Column( // Replace with a Row for horizontal icon + text
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.keyboard,color: Colors.red,size: 40,),
                              SizedBox(height: 10,),
                              Text('Number Pad', textAlign: TextAlign.center, style: TextStyle(
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SlideTransition(position: offset,child: NumberPad(),)
      ],
    );
  }

  NumberPad() {
    return Container(
      color: Colors.white,
      child:Column(
        children: [
          Expanded(flex: 1,
            child: Row(
              children: [
                Expanded(flex:1,child: SingleBTN("1"),),
                Expanded(flex:1,child: SingleBTN("2"),),
                Expanded(flex:1,child: SingleBTN("3"),),
                Expanded(flex:1,child: SingleBTN("QTY"),),
              ],
            ),
          ),
          Expanded(flex: 1,child:Row(
            children: [
              Expanded(flex:1,child: SingleBTN("4"),),
              Expanded(flex:1,child: SingleBTN("5"),),
              Expanded(flex:1,child: SingleBTN("6"),),
              Expanded(flex:1,child: SingleBTN("Disc"),),
            ],
          ) ,),
          Expanded(flex: 1,child: Row(
            children: [
              Expanded(flex:1,child: SingleBTN("7"),),
              Expanded(flex:1,child: SingleBTN("8"),),
              Expanded(flex:1,child: SingleBTN("9"),),
              Expanded(flex:1,child: SingleBTN("Price"),),
            ],
          ),),
          Expanded(flex: 1,child: Row(
            children: [
              Expanded(flex:1,child: SingleBTN("+/-"),),
              Expanded(flex:1,child: SingleBTN("0"),),
              Expanded(flex:1,child: SingleBTN("."),),
              Expanded(flex:1,child: SingleBTN("<"),),
            ],
          ),),
        ],
      ) ,
    );
  }

  SingleBTN(String s) {
    switch(s){
      case "QTY":
        return Bouncing(
          onPress: () {
          quantityMode = !quantityMode;
          DiscMode = false;
          PriceMode = false;
          plusMode = false;
          setState(() {

          });
          },
          child: GestureDetector(
            onTap: () {


            },
            child: Container(
              decoration: BoxDecoration(
                  color: !quantityMode?Colors.black:Colors.red,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(0))
              ),
              height: MediaQuery.of(context).size.height,
              child: Center(child: Text(s, textAlign: TextAlign.left, style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: 28,
                  letterSpacing: 0.20000001788139343,
                  fontWeight: FontWeight.bold,
                  height: 1.400000028610228
              ),),),


            )
          ),
        );
      case "Disc":
        return Bouncing(
          onPress: () {
            DiscMode = !DiscMode;
            plusMode=false;
            quantityMode = false;
            PriceMode = false;
            setState(() {
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: !DiscMode?Colors.black:Colors.red,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(0))
            ),
            height: MediaQuery.of(context).size.height,
            child: Center(child: Text(s, textAlign: TextAlign.left, style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 28,
                letterSpacing: 0.20000001788139343,
                fontWeight: FontWeight.bold,
                height: 1.400000028610228
            ),),),


          ),);
      case "Price":
        return Bouncing(
          onPress: () {
            PriceMode=!PriceMode;
            plusMode=false;
            quantityMode = false;
            DiscMode = false;
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
                color: !PriceMode?Colors.black:Colors.red,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(0))
            ),
            height: MediaQuery.of(context).size.height,
            child: Center(child: Text(s, textAlign: TextAlign.left, style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 28,
                letterSpacing: 0.20000001788139343,
                fontWeight: FontWeight.bold,
                height: 1.400000028610228
            ),),),
          ),);
      case "+/-":
        return Bouncing(
          onPress: () {
            plusMode=!plusMode;
            tempQuantity = "0";
            setState(() {

            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: !plusMode?Colors.black:Colors.red,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(0))
            ),
            height: MediaQuery.of(context).size.height,
            child: Center(child: Text(plusMode?"-":"+",textAlign: TextAlign.left, style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 28,
                letterSpacing: 0.20000001788139343,
                fontWeight: FontWeight.bold,
                height: 1.400000028610228
            ),),),


          ),);
      default:
        return Bouncing(
          onPress: () {
            if(s=="<"){
              controller.forward();
              setState(() {

              });


            }
            if(s=="."){
              print(widget.bill);
            }
            else{
              //If Pressed Any Number
              applyLogic(s);
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(0))
            ),
            height: MediaQuery.of(context).size.height,
            child: Center(child: Text(s, textAlign: TextAlign.left, style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 28,
                letterSpacing: 0.20000001788139343,
                fontWeight: FontWeight.bold,
                height: 1.400000028610228
            ),),),

          ),);
    }
  }
  //endregion



  //LOGICS
  applyLogic(String s) async {
    //Positive Operations
    if(!plusMode){
      if(quantityMode){
        //Positively adding stocks.
        int initialSelectedProductQuantity = selectedProductQuantity;
        int t = selectedProductQuantity+int.parse(s);

        //As it is a positive operation we will add stock quantity even if it is 0 product in bill
        //First Check if there is any stock in database.
        String stockUnitInDatabase = await FirebaseRepo().FetchStockUnit(widget.shopName, selectedProductName);
        if(stockUnitInDatabase!="0" && int.parse(stockUnitInDatabase) > int.parse(s)){
          bool isStockRemovedSuccessfully = await FirebaseRepo().RemoveStock(widget.shopName, selectedProductName, s.toString());
          if(isStockRemovedSuccessfully){
            ///Remove it from Bill map too here
            AddStockUnitsToBill(int.parse(s));
            setState(() {});
            return;
          }
          else{
            selectedProductQuantity = initialSelectedProductQuantity;
          }
        }

        if(tempQuantity!="0" && int.parse(tempQuantity) > 0){
          String remainingStock = await FirebaseRepo().FetchStockUnit(widget.shopName, selectedProductName);
          if(remainingStock == "0"){
            print("No stock remaining for $selectedProductName");
            return;
          }
          bool isProductRemovedSuccessfully = await FirebaseRepo().RemoveStock(widget.shopName, selectedProductName, selectedProductQuantity.toString());
          if(!isProductRemovedSuccessfully){
            selectedProductQuantity -=int.parse(s);
          }
          if(isProductRemovedSuccessfully){
            print("Executing Post Product Removal");
            widget.bill.forEach((e){
              if(e["ProductName"] == selectedProductName){
                e["ProductStock"] = selectedProductQuantity.toString();
                print("Now inside bill :"+selectedProductName+" ki quantity hai "+e["ProductStock"]+"Same"
                    "Same naa ?"+selectedProductQuantity.toString());
              }
            });
          }

          //
          setState(() {});
          //And Check if the product quantity comes to zero show Product is out of stock
        }
        setState(() {});
      }
      else if(DiscMode){
        tempDiscount+=int.parse(s);
        print(tempDiscount);
        setState(() {
        });
      }
      else if(PriceMode){
        print("Price Badhane ke Pehle" + selectedProductPrice.toString());
        selectedProductPrice +=int.parse(s);
        //Write Price Logic Here
        print("Price Badhane ke Baad" + selectedProductPrice.toString());
        print(selectedProductPrice);
        ///Now Update The Bill to
        Update_Selected_Product_Price_In_Bill(selectedProductPrice);
        setState(() {
        });
      }
    }

    ///Negative Operations
    else {
      if (quantityMode) {
        if(selectedProductQuantity<=0){
          ///Remove the product from bill
          print("You Should Remove the product from bill");
        }
        else{
          selectedProductQuantity = selectedProductQuantity - int.parse(s);
          bool isStockRemovedSuccesfully = await FirebaseRepo().RemoveStock(widget.shopName, selectedProductName, tempQuantity);
          if(!isStockRemovedSuccesfully){
            selectedProductQuantity = selectedProductQuantity + int.parse(s);
          }
        }
        setState(() {});
      }
      else if (DiscMode) {
        tempDiscount -= int.parse(s);
        setState(() {});
      }
      else if (PriceMode) {
        //Write Negative Logic of Price Here.
        print("Price Badhane ke Pehle" + selectedProductPrice.toString());
        selectedProductPrice -=int.parse(s);
        //Write Price Logic Here
        print("Price Badhane ke Baad" + selectedProductPrice.toString());
        print(selectedProductPrice);
        ///Now Update The Bill to
        Update_Selected_Product_Price_In_Bill(selectedProductPrice);
        setState(() {
        });
        setState(() {});
      }
    }
    }

  void AddStockUnitsToBill(int s) {
    for(int i = 0;i<widget.bill.length;i++){
      if(widget.bill[i]["ProductName"]==selectedProductName){
        print("ADDING "+s.toString() +"to BILL for "+widget.bill[i]["ProductName"]);
        print(widget.bill[i]["ProductStock"].toString() + "Before Adding Stock");
        int temp = int.parse(widget.bill[i]["ProductStock"])+s;
        print("TOTAL = wdewew"+temp.toString());
        widget.bill[i]["ProductStock"] = temp.toString();
        print(widget.bill[i]["ProductStock"].toString() + "After Adding Stock");
      }
    }
    setState(() {});
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

  void Update_Selected_Product_Price_In_Bill(int s) {
    for(int i = 0;i<widget.bill.length;i++){
      if(widget.bill[i]["ProductName"]==selectedProductName){
        print("Increasing "+s.toString() +"Price to BILL for "+widget.bill[i]["ProductName"]);
        print(widget.bill[i]["Product Price"].toString() + "Before Updating Price");
        String newPrice = (s*int.parse(widget.bill[i]['ProductStock'])).toString();
        widget.bill[i]["Product Price"] = s.toString();
        print(widget.bill[i]["Product Price"].toString() + "After Updating Price");
      }
    }
    setState(() {});
  }

  AddProductToBill(Map<String,dynamic> productDetails) {




    //Check if the product already exists then add one stock to it.
    print("Checking If Product Name Exists in Bill :"+productDetails["ProductName"]);
    for(int i = 0;i<widget.bill.length;i++){
      if(widget.bill[i]["ProductName"]==productDetails["ProductName"]){
        print(productDetails["ProductName"]+"Product Name Already Exists in the Bill");
        print(widget.bill[i]["ProductStock"].toString() + "Before Adding Stock");
        widget.bill[i]["ProductStock"] = (int.parse(widget.bill[i]["ProductStock"])+int.parse(productDetails["ProductStock"])).toString();
        print(widget.bill[i]["ProductStock"].toString() + "After Adding Stock");
        setState(() {});
        return;
      }
    }
    print(productDetails["ProductName"]+"Product Doesn't Exsists in the Bill");
    widget.bill.add(productDetails);
    print(widget.bill.toString());
    setState(() {});
  }
  //endregion


  //RAYZOR PAY MOBILE METHODS
  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 2000,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }
  //endregion

}
