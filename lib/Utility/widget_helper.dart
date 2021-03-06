import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rdipos/MainHomePage.dart';
import 'package:rdipos/Utility/BarCodeScreen.dart';

import '../main.dart';

class WidgetHelper{

  RdiAppBar(BuildContext context){
    return AppBar(
      title:FlatButton.icon(onPressed: (){
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Go To HomePage'),
                content:Text('Want to Logout?'),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('Logout'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainHomePage()),
                      );
                    },
                  ),
                  new FlatButton(
                    child: new Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }, icon: Image.asset('assets/images/rdilogo.png'), label: Text(""),),
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

  RdiAppBarWithNoContext(){
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

  CustomSnackBar(String Message){
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        Message,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  CustomTextField(String hintText,IconData icon,TextEditingController controller,bool showErrorMessage,String errorMessage,BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.grey[100],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
      decoration: InputDecoration(
          errorStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width*0.03,
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

  CustomNumberTextField(String hintText,IconData icon,TextEditingController controller,bool showErrorMessage,String errorMessage,BuildContext context) {
    return TextField(
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.grey[100],fontSize: MediaQuery.of(context).size.width*0.03,fontFamily: 'MPLUSRounded1c'),
      decoration: InputDecoration(
          errorStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width*0.02,
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
          hintStyle: TextStyle(color: Colors.grey[500],fontSize: MediaQuery.of(context).size.width*0.02,fontFamily: 'MPLUSRounded1c'),
          hintText: hintText,
          fillColor: Colors.black
      ),
    );
  }

  CustomPhoneNumberTextField(String hintText,IconData icon,TextEditingController controller,bool showErrorMessage,String errorMessage,BuildContext context) {
    return TextField(
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')),],
      controller: controller,
      maxLength: 14,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.grey[100],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
      decoration: InputDecoration(
          errorStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width*0.02,
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
          hintStyle: TextStyle(color: Colors.grey[500],fontSize: MediaQuery.of(context).size.width*0.02,fontFamily: 'MPLUSRounded1c'),
          hintText: hintText,
          fillColor: Colors.black
      ),
    );
  }

  CustomPrimaryRoundedButton(String TitleText ,var _onPressedFunction ){
    return ElevatedButton(
      onPressed: _onPressedFunction,
      child: Text('$TitleText'),
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        primary: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 150, vertical: 25),
        textStyle: TextStyle(color: Colors.grey[100],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
      ),
    );
  }

  CustomSecondaryRoundedButton(String TitleText ,var _onPressedFunction ){
    return ElevatedButton(
      onPressed: _onPressedFunction,
      child: Text('$TitleText'),
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        primary: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 150, vertical: 25),
        textStyle: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'MPLUSRounded1c'),
      ),
    );
  }

}
