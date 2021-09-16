import 'package:flutter/material.dart';

class WidgetHelper{
  RdiAppBar(){
    return AppBar(
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
    );
  }
}
