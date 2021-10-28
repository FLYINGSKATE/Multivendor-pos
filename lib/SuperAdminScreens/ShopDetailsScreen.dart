import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/Utility/widget_helper.dart';
import '../ApiRepo/FirebaseRepo.dart';


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
      appBar: WidgetHelper().RdiAppBar(context),
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
                ShopDetailsUI(shopDets["ShopUserName"],shopDets["ShopUserName"],shopDets["ShopLoginName"],
                    shopDets["ShopStatus"],
                    shopDets["ShopAddress"],shopDets["ShopContactNumber"],
                )
              );
            },
            future: FirebaseRepo().fetchShopDetails(widget.shopName),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {  },
        backgroundColor: Colors.black,
        child: Icon(Icons.delete),
      ),
    );
  }

  ShopDetailsUI(shopName, shopUserName, shopLoginName, shopStatus, shopAddress,shopContactNumber) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,100,10.0,100),
        child: Column(
          children: [
            Icon(Icons.perm_contact_cal,size: 60,),
            Text('$shopName', textAlign: TextAlign.center, style: TextStyle(
                color: Color.fromRGBO(38, 50, 56, 1),
                fontFamily: 'MPLUSRounded',
                fontSize: 40,
                letterSpacing: 0.20000001788139343,
                fontWeight: FontWeight.bold,
                height: 1.400000028610228
            ),),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 0),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topLeft,
                      child:Text('Shop Login Name', textAlign: TextAlign.left, style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Intern',
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.20000001788139343,
                        fontWeight: FontWeight.bold,
                        height: 1.400000028610228
                    ),),),
                    Row(
                          children: [
                            Padding(padding: EdgeInsets.all(0),child:Icon(Icons.person,color: Colors.white,size: 40,),),
                            Expanded(child:Text('$shopLoginName', textAlign: TextAlign.center, style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Intern',
                                fontSize: 16,
                                letterSpacing: 0.20000001788139343,
                                fontWeight: FontWeight.bold,
                                height: 1.400000028610228
                            ),),)
                          ],
                        ),
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topLeft,
                      child:Text('Shop Status', textAlign: TextAlign.left, style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Intern',
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.20000001788139343,
                          fontWeight: FontWeight.bold,
                          height: 1.400000028610228
                      ),),),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.all(0),child:Icon(Icons.person,color: Colors.white,size: 40,),),
                        Expanded(child:Text('$shopStatus', textAlign: TextAlign.center, style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Intern',
                            fontSize: 16,
                            letterSpacing: 0.20000001788139343,
                            fontWeight: FontWeight.bold,
                            height: 1.400000028610228
                        ),),)
                      ],
                    ),
                    SizedBox(height: 10,),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}