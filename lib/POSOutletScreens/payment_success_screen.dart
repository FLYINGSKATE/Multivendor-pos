import 'package:flutter/material.dart';
import 'package:rdipos/POSOutletScreens/pos_home_page.dart';
import 'package:rdipos/Utility/widget_helper.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String posName;

  const PaymentSuccessScreen({Key? key, required this.posName}) : super(key: key);

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: WidgetHelper().RdiAppBar(context),
        body: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Text('Payment Successful', textAlign: TextAlign.center, style: TextStyle(
               color: Colors.black,
               fontFamily: 'Inter',
               fontSize: 60,
               letterSpacing: 0.20000001788139343,
               fontWeight: FontWeight.bold,
               height: 1.400000028610228
           ),),
           Image.asset('assets/images/payment_success.gif',height: 200,width: 200,),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               WidgetHelper().CustomPrimaryRoundedButton("Back to HomePage", (() => Navigator.of(context).pushReplacement(MaterialPageRoute(
                   builder: (BuildContext context) => POSHomePage(bill: [], shopName: "Apunki Dukaan", posName: widget.posName,))))),
               WidgetHelper().CustomPrimaryRoundedButton("Print Bill", (() => print("Hola"))),
             ],
           ),
         ],
        )
    );
  }
}
