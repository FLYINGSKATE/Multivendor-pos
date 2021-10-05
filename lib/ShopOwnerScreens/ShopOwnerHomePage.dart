import 'dart:io';
import 'dart:math';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rdipos/ShopOwnerScreens/ShopOwnerTabs/AddProductScreen.dart';
import 'package:rdipos/ShopOwnerScreens/ShopOwnerTabs/InventoryListScreen.dart';
import 'package:rdipos/Utility/widget_helper.dart';

import 'ShopOwnerTabs/AddPOSOutletScreen.dart';
import 'ShopOwnerTabs/POSOutletListScreen.dart';

class ShopOwnerHomePage extends StatefulWidget {

  final String shopName;
  const ShopOwnerHomePage({Key? key, required this.shopName}) : super(key: key);

  @override
  _ShopOwnerHomePageState createState() => _ShopOwnerHomePageState();
}

class _ShopOwnerHomePageState extends State<ShopOwnerHomePage> {

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
      AddPOSOutletScreen(shopName: widget.shopName,),
      InventoryScreen(shopName: widget.shopName,),
      POSOutletList(shopName: widget.shopName,),
      AddProductScreen(shopName: widget.shopName,),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_basket),
        title: ("Add POS Outlet"),
        textStyle: TextStyle(fontFamily: "MPLUSRounded"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.list_dash),
        title: ("Inventory"),
        activeColorSecondary: Colors.white,
        textStyle: TextStyle(fontFamily: "MPLUSRounded"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.list_dash),
        title: ("POS Outlets"),
        activeColorSecondary: Colors.white,
        textStyle: TextStyle(fontFamily: "MPLUSRounded"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.add_circled),
        title: ("Add Product"),
        textStyle: TextStyle(fontFamily: "MPLUSRounded"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}



