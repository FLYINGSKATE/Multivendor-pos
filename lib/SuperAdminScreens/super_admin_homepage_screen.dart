import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/widget_helper.dart';

class SuperAdminHomePage extends StatefulWidget {
  const SuperAdminHomePage({Key? key}) : super(key: key);

  @override
  _SuperAdminHomePageState createState() => _SuperAdminHomePageState();
}

class _SuperAdminHomePageState extends State<SuperAdminHomePage> {

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().RdiAppBar(),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.black, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(0.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOutQuad,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      BlockShopList(),
      AdminDashboard(),
      AddShop(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.block_flipped),
        title: ("Blocked Shop"),
        textStyle: TextStyle(fontFamily: "MPLUSRounded"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.list_dash),
        title: ("Dashboard"),
        activeColorSecondary: Colors.white,
        textStyle: TextStyle(fontFamily: "MPLUSRounded"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.add_circled),
        title: ("Add Shop"),
        textStyle: TextStyle(fontFamily: "MPLUSRounded"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int totalNoOfShops = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child:Column(
      children: [
          SizedBox(height: 20,),
          Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // if you need this
                side: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 4,
              ),
            ),
            child: BlurryContainer(
              bgColor: Colors.black12,
              width: MediaQuery.of(context).size.width/0.9,
              height: 200,
              child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("All Shops",style:TextStyle(fontFamily: "MPLUSRounded",fontSize: 20,color: Colors.white)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home,color: Colors.white,size: 60,),
                          Text(totalNoOfShops.toString(),textAlign:TextAlign.center,style:TextStyle(fontFamily: "MPLUSRounded",fontSize: 40,color: Colors.white,fontWeight: FontWeight.bold)),
                        ],)
                    ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          Expanded(child: AllShopList(),),

      ],
    ));
  }

  AllShopList() {
    String shopName = "";
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return CircularProgressIndicator();
        }
        final List<DocumentSnapshot> documents = projectSnap.data as List<DocumentSnapshot>;
        totalNoOfShops = documents.length;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                // Widget to display the list of project
                ShopCard(documents.elementAt(index).id),

              ],
            );
          },
        );
      },
      future: FirebaseRepo().FetchListOfAllShops(),
    );
  }

  Widget ShopCard(String shopName) {
    return Container(
        child:Card(
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // if you need this
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width/0.9,
          height: 75,
          child: Row(
            children: [
              SizedBox(width: 40,),
              Expanded(flex: 3,child:Text("$shopName",style:TextStyle(fontWeight: FontWeight.bold,fontFamily: "MPLUSRounded",fontSize: 20,color: Colors.black))),
              Expanded(
                flex: 1,
                child:IconButton(
                  iconSize: 36,
                  icon: Icon(Icons.block),
                  onPressed: (){},
                ) ,
              ),
              Expanded(
                flex: 1,
                child:IconButton(
                  iconSize: 36,
                  icon: Icon(Icons.list_alt_outlined),
                  onPressed: (){

                  },
                ) ,
              ),
              SizedBox(width: 10,)
            ],
          )
        ),
      ),
    );
  }

}

class AddShop extends StatefulWidget {
  const AddShop({Key? key}) : super(key: key);

  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {


  final databaseRef = FirebaseDatabase.instance.reference();

  TextEditingController _shopNameTextEditingController = TextEditingController();
  TextEditingController _shopLoginEditingController = TextEditingController();
  TextEditingController _shopPasswordTextEditingController = TextEditingController();
  TextEditingController _shopAddressTextEditingController = TextEditingController();
  TextEditingController _shopShopContactNumberEditingController = TextEditingController();


  bool showShopNameErrorMessgae = false;
  bool showShopLoginErrorMessage = false;
  bool showShopPasswordErrorMessage = false;
  bool showShopAddressErrorMessage = false;
  bool showShopContactNumberErrorMessage = false;

  String shopNameErrorMessage = "Shop Name Name Cannot Be Blank";
  String shopShopLoginErrorMesage = "Shop Login Cannot Be Blank";
  String shopUserPasswordErrorMessage = "Password Cannot Be Blank";
  String shopContactNumberErrorMessage = "Contact Cannot Be Blank";
  String ShopAddressErrorMessage = "Shop Address Cannot be blank";


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,50,10.0,100),
        child: Column(
          children: [
            Icon(Icons.shopping_basket,size: 60,),
            Text('ADD NEW SHOP', textAlign: TextAlign.center, style: TextStyle(
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
                    WidgetHelper().CustomTextField("Enter Shop Name",Icons.perm_contact_cal_sharp,_shopNameTextEditingController,showShopNameErrorMessgae,shopNameErrorMessage),
                    SizedBox(height: 20,),
                    WidgetHelper().CustomTextField("Enter Shop Login Name",Icons.person,_shopLoginEditingController,showShopLoginErrorMessage,shopShopLoginErrorMesage),
                    SizedBox(height: 20,),
                    WidgetHelper().CustomTextField("Enter Shop Password",Icons.remove_red_eye,_shopPasswordTextEditingController,showShopPasswordErrorMessage,shopUserPasswordErrorMessage),
                    SizedBox(height: 20,),
                    WidgetHelper().CustomTextField("Enter Shop Contact Number",Icons.phone,_shopShopContactNumberEditingController,showShopContactNumberErrorMessage,shopContactNumberErrorMessage),
                    SizedBox(height: 20,),
                    SizedBox(
                      height:350,
                      child: TextField(
                      maxLines: 9,
                      controller: _shopAddressTextEditingController,
                      style: TextStyle(color: Colors.grey[100],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                          errorText: showShopAddressErrorMessage?ShopAddressErrorMessage:null,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder:OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ) ,
                          filled: true,
                          focusColor: Colors.white,
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: Padding(padding:
                          const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 250),child:Icon(Icons.location_on,size: 40,color: Colors.white,)),
                          hintStyle: TextStyle(color: Colors.grey[500],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
                          hintText: "Enter Shop Address",
                          fillColor: Colors.black
                      ),
                    ) ,),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () async {
                        showShopNameErrorMessgae =  _shopNameTextEditingController.text.isEmpty;
                        showShopLoginErrorMessage  = _shopLoginEditingController.text.isEmpty;
                        showShopPasswordErrorMessage = _shopPasswordTextEditingController.text.isEmpty;
                        showShopAddressErrorMessage =  _shopAddressTextEditingController.text.isEmpty;
                        showShopContactNumberErrorMessage =  _shopShopContactNumberEditingController.text.isEmpty;
                        setState(() {

                        });
                        if(_shopNameTextEditingController.text.isEmpty&&_shopLoginEditingController.text.isEmpty
                        &&_shopPasswordTextEditingController.text.isEmpty && _shopAddressTextEditingController.text.isEmpty && _shopShopContactNumberEditingController.text.isEmpty
                        ){

                        }
                        else{
                          String ADDSHOPMESSAGE  = await FirebaseRepo().AddNewShop(_shopNameTextEditingController.text.trim(),_shopLoginEditingController.text.trim(),_shopPasswordTextEditingController.text.trim(),_shopShopContactNumberEditingController.text.trim(),_shopAddressTextEditingController.text.trim());
                          print(ADDSHOPMESSAGE);
                        }

                      },
                      child: Text('ADD SHOP',maxLines: 1,),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 130, vertical: 25),
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
      ),
    );
  }
}

class BlockShopList extends StatefulWidget {
  const BlockShopList({Key? key}) : super(key: key);

  @override
  _BlockShopListState createState() => _BlockShopListState();
}

class _BlockShopListState extends State<BlockShopList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}










