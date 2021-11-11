import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/Utility/widget_helper.dart';

import 'POSOutletScreens/owner_pos_homepage.dart';

class EnterShopName extends StatefulWidget {
  const EnterShopName({Key? key}) : super(key: key);

  @override
  _EnterShopNameState createState() => _EnterShopNameState();
}

class _EnterShopNameState extends State<EnterShopName> {

  String shopNameErrorMessage = "Shop Does Not Exist!";
  bool showShopNameErrorMessage = false;
  bool doesShopExists = false;
  bool showAdminContact = false;
  TextEditingController _shopNameTextEditingController = TextEditingController();

  bool isShopRunning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showAdminContact?FloatingActionButton(
        backgroundColor: showAdminContact?Colors.black:Colors.transparent,
        child: Icon(Icons.call,color: showAdminContact?Colors.white:Colors.transparent,),
        onPressed: () {},
      ):null,
      appBar: WidgetHelper().RdiAppBarWithNoContext(),
      body: Center(child:Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag,size: 60,),
              Text('Enter Your Shop Name', textAlign: TextAlign.center, style: TextStyle(
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
                width: MediaQuery.of(context).size.width/1.4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      WidgetHelper().CustomTextField("Enter Your Shop Name",Icons.perm_contact_cal_sharp,_shopNameTextEditingController,showShopNameErrorMessage,shopNameErrorMessage,context),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: ()  async {
                          String shopName = _shopNameTextEditingController.text.trim();
                          doesShopExists = await FirebaseRepo().ShopAlreadyExsists(shopName);
                          print(shopName+" does exists "+doesShopExists.toString());
                          if(!doesShopExists){
                            showShopNameErrorMessage = true;
                            showAdminContact = true;
                            setState((){});
                          }
                          else{
                            isShopRunning = await FirebaseRepo().isShopRunning(shopName);
                            if(isShopRunning){
                              showShopNameErrorMessage = false;
                              setState((){});
                              ///Navigate to Shop & Pos Login Tabs with the current Shop Name;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage(shopName: shopName,)),
                              );
                            }
                            else{
                              shopNameErrorMessage = "$shopName is Blocked . Please Contact Admin";
                              showShopNameErrorMessage = true;
                              showAdminContact = true;
                              setState((){});
                              return;
                            }
                          }
                        },
                        child: Text('Login to Your Shop',maxLines: 1,style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'MPLUSRounded',
                            fontSize: 16,
                            letterSpacing: 0.20000001788139343,
                            height: 1.400000028610228
                        ),),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          primary: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 25),
                          textStyle: TextStyle(color: Colors.grey[100],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
                        ),),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              TextButton(onPressed: (){}, child: Text('', textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'MPLUSRounded',
                  fontSize: 15,
                  letterSpacing: 0.20000001788139343,
                  fontWeight: FontWeight.w200,
                  height: 1.400000028610228
              ),),)
            ],
          ),
        )),
    );
  }
}
