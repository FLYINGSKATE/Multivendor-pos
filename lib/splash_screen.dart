import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rdipos/BarCodeScreen.dart';

import 'POSOutletScreens/pos_home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 0),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomePage())));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/rdilogo.png'),
              CircularProgressIndicator(color: Colors.white,),
            ],
          ),
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}





class _HomePageState extends State<HomePage> {

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      ),
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
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
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
      AdminLogin(),
      POSLogin(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person_crop_circle_fill_badge_plus),
        title: ("Admin Login"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person_crop_circle_fill),
        title: ("POS Login"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  @override
  Widget build(BuildContext context) {
    return Container(child:Center(
      child: Center(child:Container(
        height: MediaQuery.of(context).size.height/2,
        color: Colors.black,
        child: MaterialButton(
          onPressed: () => {
            pushNewScreen(
              context,
              withNavBar: false,
              screen: GenerateBarCodeScreen(),
            ),
          },
          color: Colors.black,
          padding: EdgeInsets.all(10.0),
          child: Column( // Replace with a Row for horizontal icon + text
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.qr_code_scanner,color: Colors.red,size: 40,),
              SizedBox(height: 10,),
              Text('Barcode Demo', textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Inter',
                  fontSize: 20,
                  letterSpacing: 0.20000001788139343,
                  fontWeight: FontWeight.normal,
                  height: 1.400000028610228
              ),),
            ],
          ),
        ),
        //child: RaisedButton.icon(color:Colors.black,onPressed: (){print("OLA");}, icon: Icon(Icons.inventory,color: Colors.red,), label: Text("Add From Inventory",style: TextStyle(color: Colors.red),)),
      ),),
    ));
  }
}

class POSLogin extends StatefulWidget {
  const POSLogin({Key? key}) : super(key: key);

  @override
  _POSLoginState createState() => _POSLoginState();
}

class _POSLoginState extends State<POSLogin> {
  @override
  Widget build(BuildContext context) {
    return Center(child:Container(
      color: Colors.black,
      child: MaterialButton(
        onPressed: () => {
          pushNewScreen(
            context,
            withNavBar: false,
            screen: POSHomePage(
            ),
          ),
        },
        color: Colors.black,
        padding: EdgeInsets.all(10.0),
        child: Column( // Replace with a Row for horizontal icon + text
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.inventory,color: Colors.red,size: 40,),
            SizedBox(height: 10,),
            Text('Add From Inventory', textAlign: TextAlign.center, style: TextStyle(
                color: Colors.red,
                fontFamily: 'Inter',
                fontSize: 20,
                letterSpacing: 0.20000001788139343,
                fontWeight: FontWeight.normal,
                height: 1.400000028610228
            ),),
          ],
        ),
      ),
      //child: RaisedButton.icon(color:Colors.black,onPressed: (){print("OLA");}, icon: Icon(Icons.inventory,color: Colors.red,), label: Text("Add From Inventory",style: TextStyle(color: Colors.red),)),
    ),);
  }
}



