import 'package:flutter/material.dart';
import 'package:rdipos/BarCodeScreen.dart';

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

  CustomTextField(String hintText,IconData icon,TextEditingController controller,bool showErrorMessage,String errorMessage) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.grey[100],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
      decoration: InputDecoration(
          errorStyle: TextStyle(
            fontSize: 16.0,
          ),
          errorText: showErrorMessage?errorMessage:null,
          border: OutlineInputBorder(
            borderSide: BorderSide(),
            borderRadius: BorderRadius.circular(100.0),
          ),
          enabledBorder:OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(100.0),
          ) ,
          filled: true,
          focusColor: Colors.white,
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(100.0),
          ),
          prefixIcon:Padding(
            padding: const EdgeInsets.all(20.0),
            child: Icon(icon,size: 40,color: Colors.white,),
          ),
          hintStyle: TextStyle(color: Colors.grey[500],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
          hintText: hintText,
          fillColor: Colors.black
      ),
    );
  }
}
