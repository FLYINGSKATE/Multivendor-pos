import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/AddFromInventory.dart';
import 'package:rdipos/EnterShopName.dart';
import 'package:rdipos/MainHomePage.dart';
import 'package:rdipos/POSOutletScreens/CheckOutScreen.dart';
import 'package:rdipos/POSOutletScreens/owner_pos_homepage.dart';
import 'package:rdipos/POSOutletScreens/payment_success_screen.dart';
import 'package:rdipos/POSOutletScreens/pos_home_page.dart';
import 'package:rdipos/ShopOwnerScreens/ShopOwnerHomePage.dart';
import 'package:rdipos/ShopOwnerScreens/ShopOwnerTabs/AddProductScreen.dart';
import 'package:rdipos/Utility/BarCodeScreen.dart';
import 'package:rdipos/Utility/ScanWithGun.dart';

import 'SuperAdminScreens/super_admin_homepage_screen.dart';

Future<void> main() async {
  ///TO hide Red Screen of Death!
  ErrorWidget.builder = (FlutterErrorDetails details) => Container(
    color : Colors.black,
  );
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  Map<String,dynamic> map = {};

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.black,
      ),
      //home: POSHomePage(posName: 'AndeRam@rdipos.com', shopName: 'Apunki Dukaan', bill: [],)
      home: ShopOwnerHomePage(shopName: 'Apunki Dukaan',),
    );
  }
}