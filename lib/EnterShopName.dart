import 'package:flutter/material.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/Utility/widget_helper.dart';

class EnterShopName extends StatefulWidget {
  const EnterShopName({Key? key}) : super(key: key);

  @override
  _EnterShopNameState createState() => _EnterShopNameState();
}

class _EnterShopNameState extends State<EnterShopName> {

  String shopNameErrorMessage = "Shop Does Not Exist!";
  bool showShopNameErrorMessage = false;
  bool doesShopExists = false;
  TextEditingController _shopNameTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().RdiAppBar(),
      body: Center(child:Container(
        width: MediaQuery.of(context).size.width/2,
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      WidgetHelper().CustomTextField("Enter Your Shop Name",Icons.perm_contact_cal_sharp,_shopNameTextEditingController,showShopNameErrorMessage,shopNameErrorMessage),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: ()  async {
                          String shopName = _shopNameTextEditingController.text.trim();
                          doesShopExists = await FirebaseRepo().ShopAlreadyExsists(shopName);
                          if(!doesShopExists){
                            showShopNameErrorMessage = true;
                            setState(() {});
                          }
                          else{
                            ///Navigate to Shop & Pos Login Tabs with the current Shop Name;
                            
                          }
                        },
                        child: Text('Login to Your Shop',maxLines: 1,),
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
