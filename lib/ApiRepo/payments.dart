import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'UiFake.dart' if (dart.library.html) 'dart:ui' as ui;

class Webpayment extends StatelessWidget{
  final String? name;
  final String? image;
  final int? price;
  final String? mobile;
  final String? email;

  final String? shopName;

  final String? shopApiKey;

  final String description = "A Partner shop of RDI Digital!";

  Webpayment({required this.name,required this.price,this.image,required this.mobile,required this.email, required this.shopName,required this.shopApiKey});


  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory("rzp-html",(int viewId){
      IFrameElement element=IFrameElement();
      window.onMessage.forEach((element) {
        print('Event Received in callback: ${element.data}');
        if(element.data=='MODAL_CLOSED'){
          Navigator.pop(context);
        }
        else if(element.data=='SUCCESS'){
          print('PAYMENT SUCCESSFULL!!!!!!!');
        }
        //FirebaseFirestore.instance.collection('Products').doc('iphone12').update({
        //  'payment':"Done"
        //});
      });

      element.src='assets/payments.html?name=$name&price=$price&image=$image&email=$email&mobile=$mobile&apikey=$shopApiKey&shopname=$shopName&shopdescription=$description';
      element.style.border = 'none';

      return element;
    });
    return  Scaffold(
        body: Builder(builder: (BuildContext context) {
          return Container(
            child: HtmlElementView(viewType: 'rzp-html'),
          );
        }));
  }


}