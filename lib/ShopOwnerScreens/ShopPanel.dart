import 'package:flutter/material.dart';
import 'package:rdipos/Utility/widget_helper.dart';

class ShopPanel extends StatefulWidget {
  const ShopPanel({Key? key}) : super(key: key);

  @override
  _ShopPanelState createState() => _ShopPanelState();
}

class _ShopPanelState extends State<ShopPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().RdiAppBar(context),
      body: Column(
        children: [
          Icon(Icons.perm_contact_cal,size: 60,),
          Text('POS Login', textAlign: TextAlign.center, style: TextStyle(
              color: Color.fromRGBO(38, 50, 56, 1),
              fontFamily: 'MPLUSRounded',
              fontSize: 40,
              letterSpacing: 0.20000001788139343,
              fontWeight: FontWeight.bold,
              height: 1.400000028610228
          ),),
        ],
      ),
    );
  }
}
