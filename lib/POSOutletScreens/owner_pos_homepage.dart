import'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rdipos/AddFromInventory.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/POSOutletScreens/pos_home_page.dart';
import 'package:rdipos/ShopOwnerScreens/ShopOwnerHomePage.dart';
import 'package:rdipos/Utility/widget_helper.dart';


class HomePage extends StatefulWidget {
  final String shopName;
  const HomePage({Key? key, required this.shopName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WidgetHelper().RdiAppBar(context),
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
      ShopOwnerLogin(shopName: widget.shopName,),
      POSLogin(shopName: widget.shopName,),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_basket),
        title: ("Shop Login"),
        textStyle: TextStyle(fontFamily: "MPLUSRounded"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person_crop_circle_fill),
        title: ("POS Login"),
        textStyle: TextStyle(fontFamily: "MPLUSRounded"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}

class ShopOwnerLogin extends StatefulWidget {
  final String shopName;
  const ShopOwnerLogin({Key? key, required this.shopName}) : super(key: key);

  @override
  _ShopOwnerLoginState createState() => _ShopOwnerLoginState();
}

class _ShopOwnerLoginState extends State<ShopOwnerLogin> {
  final databaseRef = FirebaseDatabase.instance.reference();

  TextEditingController _userNameTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();

  bool showUsernameErrorMessgae = false;
  bool showPasswordErrorMessage = false;

  String userErrorMessage = "Shop doesn't Exists!";
  String passwordErrorMessage = "Wrong Password";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,100,10.0,100),
        child: Column(
          children: [
            Icon(Icons.shopping_basket,size: 60,),
            Text('Shop Login', textAlign: TextAlign.center, style: TextStyle(
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
                    CustomTextField("Username",Icons.shopping_basket,_userNameTextEditingController,showUsernameErrorMessgae,userErrorMessage),
                    SizedBox(height: 20,),
                    CustomTextField("Password",Icons.remove_red_eye,_passwordTextEditingController,showPasswordErrorMessage,passwordErrorMessage),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: ()  async {
                        String result = await FirebaseRepo().validateShopUser(widget.shopName, _userNameTextEditingController.text,_passwordTextEditingController.text);
                        print("Shop LOGIN Results : "+result);
                        if(result=="Login Successful"){
                          print("Shop Login Successfully");
                          Map<String,dynamic> map={};
                          pushNewScreen(context, withNavBar: false, screen: ShopOwnerHomePage(shopName: widget.shopName,),);
                        }
                        else if(result == "Wrong Shop User name"){
                          userErrorMessage = result;
                          showUsernameErrorMessgae = true;
                          setState(() {});
                        }
                        else{
                          showUsernameErrorMessgae = false;
                          passwordErrorMessage = result;
                          showPasswordErrorMessage = true;
                          setState(() {});
                        }
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 150, vertical: 25),
                        textStyle: TextStyle(color: Colors.grey[100],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
                      ),),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextButton(onPressed: (){}, child: Text('Forgot Password ?', textAlign: TextAlign.center, style: TextStyle(
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

class POSLogin extends StatefulWidget {
  final String shopName;

  const POSLogin({Key? key, required this.shopName}) : super(key: key);

  @override
  _POSLoginState createState() => _POSLoginState();
}

class _POSLoginState extends State<POSLogin> {
  final databaseRef = FirebaseDatabase.instance.reference();

  TextEditingController _userNameTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();

  bool showUsernameErrorMessgae = false;
  bool showPasswordErrorMessage = false;

  String userErrorMessage = "POS Outlet doesn't Exists!";
  String passwordErrorMessage = "Wrong Password";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,100,10.0,100),
        child: Column(
          children: [
            Icon(Icons.perm_contact_cal,size: 60,),
            Text('POS Login', textAlign: TextAlign.center, style: TextStyle(
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
                    WidgetHelper().CustomTextField("Username",Icons.perm_contact_cal_sharp,_userNameTextEditingController,showUsernameErrorMessgae,userErrorMessage,context),
                    SizedBox(height: 20,),
                    WidgetHelper().CustomTextField("Password",Icons.remove_red_eye,_passwordTextEditingController,showPasswordErrorMessage,passwordErrorMessage,context),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: ()  async {
                            String result = await FirebaseRepo().validatePOSUser(widget.shopName, _userNameTextEditingController.text,_passwordTextEditingController.text);
                            print("POS OUTLET LOGIN : "+result);
                            if(result=="Login Successful"){
                              print("OUTLET Login Successfully");
                              Map<String,dynamic> map={};
                              pushNewScreen(context, withNavBar: false, screen: POSHomePage(shopName: widget.shopName,bill: [], posName:_userNameTextEditingController.text,),);
                            }
                            else{
                              passwordErrorMessage = result;
                              showPasswordErrorMessage = true;
                              setState(() {});
                            }
                          },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 150, vertical: 25),
                        textStyle: TextStyle(color: Colors.grey[100],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
                      ),),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextButton(onPressed: (){}, child: Text('Forgot Password ?', textAlign: TextAlign.center, style: TextStyle(
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