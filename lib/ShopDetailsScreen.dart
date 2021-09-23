import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/Utility/widget_helper.dart';

import 'ApiRepo/FirebaseRepo.dart';


class ShopDetails extends StatefulWidget {
  final String shopName;
  const ShopDetails({Key? key,required this.shopName}) : super(key: key);

  @override
  _ShopDetailsState createState() => _ShopDetailsState();
}




class _ShopDetailsState extends State<ShopDetails> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WidgetHelper().RdiAppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: FutureBuilder(
            builder: (context, projectSnap) {
              if (projectSnap.connectionState == ConnectionState.none &&
                  projectSnap.hasData == null) {
                //print('project snapshot data is: ${projectSnap.data}');
                return CircularProgressIndicator();
              }
              Map<String,dynamic> shopDets = projectSnap.data as Map<String,dynamic>;
              return (
                ShopDetailsUI(shopDets["ShopName"],shopDets["ShopUserName"],shopDets["ShopLoginName"],
                    shopDets["ShopStatus"],
                    shopDets["ShopAddress"],shopDets["ShopContactNumber"],
                )
              );
            },
            future: FirebaseRepo().fetchShopDetails(widget.shopName),
          ),
        ),
      ),
    );
  }

  ShopDetailsUI(shopName, shopUserName, shopLoginName, shopStatus, shopAddress,shopContactNumber) {
    return Center(child:Container(
      width: MediaQuery.of(context).size.height/2,
        height: MediaQuery.of(context).size.width/1.3,
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(width: 0),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child:Column(
      children: [
        Center(child: Container(
          height: 80.0,
          width: 200.0,
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                alignment: Alignment(-.2, 0),
                image: NetworkImage('https://www.vistamalls.com.ph/wp-content/uploads/2021/02/logo-vistamall-bataan.png'),
                fit: BoxFit.fitWidth),
          ),
        )),
        Row(
          children: [
            Icon(Icons.person,size: 40,color: Colors.white,),
            Text('$shopLoginName', textAlign: TextAlign.center, style: TextStyle(
                color: Colors.white,
                fontFamily: 'Intern',
                fontSize: 20,
                letterSpacing: 0.20000001788139343,
                fontWeight: FontWeight.bold,
                height: 1.400000028610228
            ),),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on,size: 40,color: Colors.white,),
            Expanded(child:Text('$shopAddress', textAlign: TextAlign.center, style: TextStyle(
                color: Colors.white,
                fontFamily: 'Intern',
                fontSize: 20,
                letterSpacing: 0.20000001788139343,
                fontWeight: FontWeight.bold,
                height: 1.400000028610228
            ),),)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android,size: 40,color: Colors.white,),
            Expanded(child:Text('$shopContactNumber', textAlign: TextAlign.left, style: TextStyle(
                color: Colors.white,
                fontFamily: 'Intern',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.20000001788139343,
                height: 1.400000028610228
            ),),)
          ],
        ),
        SizedBox(height: 20,),
      ],
    )));
  }
}