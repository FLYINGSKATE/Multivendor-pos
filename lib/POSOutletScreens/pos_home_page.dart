import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rdipos/Bouncing.dart';
import 'package:rdipos/POSOutletScreens/pos_user_profile.dart';
import 'package:rdipos/ProductModel.dart';
import 'package:rdipos/inventory.dart';
import 'package:rdipos/widget_helper.dart';
import 'package:spring/spring.dart';


class POSHomePage extends StatefulWidget {
  const POSHomePage({Key? key}) : super(key: key);

  @override
  _POSHomePageState createState() => _POSHomePageState();
}

class _POSHomePageState extends State<POSHomePage> with TickerProviderStateMixin{
  List<int> text = [1,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4];

  bool quantityMode = false;
  bool DiscMode = false;
  bool PriceMode = false;
  bool plusMode = false;

  List<ProductModel> productOnList = [
    ProductModel("Pepsi", 10.0),
    ProductModel("Mazza", 10.0),
    ProductModel("Coca Cola", 10.0),
    ProductModel("Lays", 5.0),
    ProductModel("Milki Bikis", 20.0),
    ProductModel("Broccoli", 40.0),
  ];

  double totalValue = 0.0;

  int tempQuantity = 0;

  double tempPrice = 0;

  double tempDiscount = 0;

  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  late AnimationController controller;
  late Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 400));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:WidgetHelper().RdiAppBar(),
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
                  Product(),
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
          child: Text('$tempQuantity', textAlign: TextAlign.center, style: TextStyle(
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
          child: Text('$tempPrice ₹', textAlign: TextAlign.center, style: TextStyle(
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
                            openCheckout()
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
            else{
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

  applyLogic(String s){
    if(!plusMode){
      if(quantityMode){
        tempQuantity +=int.parse(s);
        print(tempQuantity);
        setState(() {
        });
      }
      else if(DiscMode){
        tempDiscount+=int.parse(s);;
        print(tempDiscount);
        setState(() {
        });
      }
      else if(PriceMode){
        tempPrice +=int.parse(s);;
        print(tempPrice);
        setState(() {
        });
      }
    }
    else {
      if (quantityMode) {
        tempQuantity -= int.parse(s);
        setState(() {});
      }
      else if (DiscMode) {
        tempDiscount -= int.parse(s);
        setState(() {});
      }
      else if (PriceMode) {
        tempPrice -= int.parse(s);
        setState(() {});
      }
    }
    }
}
