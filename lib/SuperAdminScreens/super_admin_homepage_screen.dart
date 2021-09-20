import 'package:cloud_firestore/cloud_firestore.dart';
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
      backgroundColor: Colors.white,
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          SizedBox(height: 20,),
          Card(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40), // if you need this
                side: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width/0.9,
              height: 200,
              child: Center(child:Text("Hola")),
            ),
          ),
          SizedBox(height: 20,),
          Expanded(child: AllShopList(),),

      ],
    );
  }

  AllShopList() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return CircularProgressIndicator();
        }
        final List<DocumentSnapshot> documents = projectSnap.data as List<DocumentSnapshot>;
        documents.forEach((data) => print(data.id));
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                // Widget to display the list of project

              ],
            );
          },
        );
      },
      future: FirebaseRepo().FetchListOfAllShops(),
    );
  }

}

class AddShop extends StatefulWidget {
  const AddShop({Key? key}) : super(key: key);

  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  @override
  Widget build(BuildContext context) {
    return Container();
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










