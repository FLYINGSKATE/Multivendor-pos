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
import 'package:rdipos/Utility/widget_helper.dart';
import 'dart:ui' as ui;


class ShopOwnerHomePage extends StatefulWidget {
  const ShopOwnerHomePage({Key? key}) : super(key: key);

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
      AddPOSOutletScreen(),
      InventoryScreen(),
      POSOutletList(),
      AddProductScreen(),
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

class POSOutletList extends StatefulWidget {
  const POSOutletList({Key? key}) : super(key: key);

  @override
  _POSOutletListState createState() => _POSOutletListState();
}

class _POSOutletListState extends State<POSOutletList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {


  final databaseRef = FirebaseDatabase.instance.reference();

  TextEditingController _productNameTextEditingController = TextEditingController();
  TextEditingController _productPriceTextEditingController = TextEditingController();
  TextEditingController _productStockTextEditingController = TextEditingController();
  TextEditingController _productSellerContactNumberTextEditingController = TextEditingController();

  bool _showProductNameErrorMessgae = false;
  bool _showProductPriceErrorMessage = false;
  bool _showProductStockErrorMessage = false;
  bool _showProductSellerContactNumberErrorMessage = false;

  String _productNameErrorMessage = "Product Name Name Cannot Be Blank";
  String _productPriceErrorMessage = "Price Value Cannot Be Blank";
  String _productStockErrorMessage = "Stock Value Cannot Be Blank";
  String productSellerContactNumberErrorMessage = "Seller Contact Cannot Be Blank";
  String tempBarcode = "";

  bool enableDownloadBarcodeButton = false;

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 50, 10.0, 100),
          child: Column(
            children: [
              Icon(Icons.move_to_inbox_rounded, size: 60,),
              Text('ADD NEW PRODUCT', maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(38, 50, 56, 1),
                    fontFamily: 'MPLUSRounded',
                    fontSize: 30,
                    letterSpacing: 0.20000001788139343,
                    fontWeight: FontWeight.bold,
                    height: 1.400000028610228
                ),),
              Row(
                children: [
                  Expanded(flex: 1, child: ProductBarCodeGenerateSection()),
                  SizedBox(width: 10,),
                  Expanded(flex: 1, child: Container(
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
                          WidgetHelper().CustomTextField("Enter Product Name",
                              Icons.perm_contact_cal_sharp,
                              _productNameTextEditingController,
                              _showProductNameErrorMessgae,
                              _productNameErrorMessage),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Expanded(
                                  child: WidgetHelper().CustomNumberTextField(
                                      "Enter Price", Icons.money,
                                      _productPriceTextEditingController,
                                      _showProductPriceErrorMessage,
                                      _productPriceErrorMessage)),
                              SizedBox(width: 20,),
                              Expanded(
                                  child: WidgetHelper().CustomNumberTextField(
                                      "Enter Stock Unit",
                                      Icons.all_inbox_rounded,
                                      _productStockTextEditingController,
                                      _showProductStockErrorMessage,
                                      _productStockErrorMessage)),
                            ],
                          ),
                          SizedBox(height: 20,),
                          WidgetHelper().CustomPhoneNumberTextField(
                              "Enter Seller Contact Number", Icons.phone,
                              _productSellerContactNumberTextEditingController,
                              _showProductSellerContactNumberErrorMessage,
                              productSellerContactNumberErrorMessage),
                          SizedBox(height: 20,),
                          SizedBox(height: 10,),
                          ElevatedButton(
                            onPressed: () async {
                              _showProductNameErrorMessgae =
                                  _productNameTextEditingController.text
                                      .isEmpty;
                              _showProductPriceErrorMessage =
                                  _productPriceTextEditingController.text
                                      .isEmpty;
                              _showProductStockErrorMessage =
                                  _productStockTextEditingController.text
                                      .isEmpty;
                              _showProductSellerContactNumberErrorMessage =
                                  _productSellerContactNumberTextEditingController
                                      .text.isEmpty;
                              setState(() {

                              });
                              if (((_productNameTextEditingController.text
                                  .isNotEmpty &&
                                  _productPriceTextEditingController.text
                                      .isNotEmpty)
                                  && (_productStockTextEditingController.text
                                      .isNotEmpty)) &&
                                  (_productSellerContactNumberTextEditingController
                                      .text.isNotEmpty)
                              ) {
                                tempBarcode = await GenerateBarcodeForProduct();
                                String AddProductMessage = await FirebaseRepo()
                                    .AddNewProduct(
                                    _productNameTextEditingController.text
                                        .trim(),
                                    _productPriceTextEditingController.text
                                        .trim(),
                                    _productStockTextEditingController.text
                                        .trim(),
                                    _productSellerContactNumberTextEditingController
                                        .text.trim(), tempBarcode);
                                print(AddProductMessage);
                                _productNameTextEditingController.text = "";
                                _productPriceTextEditingController.text = "";
                                _productStockTextEditingController.text = "";
                                _productSellerContactNumberTextEditingController
                                    .text = "";
                                Color snackBarColor = Colors.red;
                                if(AddProductMessage=="Congratulations! Product Added Successfully!"){
                                  snackBarColor = Colors.green;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.black,
                                      content: Text(
                                        "$AddProductMessage",
                                        style: TextStyle(color: snackBarColor,
                                            letterSpacing: 0.5),
                                      ),
                                    ));
                                enableDownloadBarcodeButton = true;
                                setState(() {

                                });
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.black,
                                      content: Text(
                                        "Please Fill in all the details Properly",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            letterSpacing: 0.5),
                                      ),
                                    ));
                                return;
                              }
                            },
                            child: Text(
                              "ADD PRODUCT", textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'MPLUSRounded',
                                  fontSize: 40,
                                  letterSpacing: 0.20000001788139343,
                                  fontWeight: FontWeight.bold,
                                  height: 1.400000028610228
                              ),),
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Colors.red,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25),
                              textStyle: TextStyle(color: Colors.grey[100],
                                  fontSize: 18,
                                  fontFamily: 'MPLUSRounded1c'),
                            ),),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
              SizedBox(height: 10,),
              TextButton(onPressed: () {},
                child: Text('', textAlign: TextAlign.center, style: TextStyle(
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

  ProductBarCodeGenerateSection() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width - 60,
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(20),
              child: Container(color: Colors.white,
                child: Padding(
                    padding: EdgeInsets.all(20), child: RepaintBoundary(
                  key: globalKey,
                  child: BarcodeWidget(
                    drawText: true,
                    barcode: Barcode.code128(), // Barcode type and settings
                    data: tempBarcode,
                    width: 200, // Content
                  ),)),)),
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(40),
              textStyle: TextStyle(color: Colors.yellow),
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  side: BorderSide(color: Colors.white, width: 2)
              ),
            ),
            onPressed: enableDownloadBarcodeButton ? () {
              DownloadTheGeneratedBarCode();
            } : null,
            icon: Icon(Icons.qr_code, color: Colors.white, size: 40,),
            label: Text('Download Bar Code', textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'MPLUSRounded',
                  letterSpacing: 0.20000001788139343,
                  height: 1.400000028610228
              ),),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              _showProductNameErrorMessgae = false;
              _showProductPriceErrorMessage = false;
              _showProductStockErrorMessage = false;
              _showProductSellerContactNumberErrorMessage = false;
              _productNameTextEditingController.text = "";
              _productPriceTextEditingController.text = "";
              _productStockTextEditingController.text = "";
              _productSellerContactNumberTextEditingController.text = "";
              setState(() {

              });
            },
            child: Text("CLEAR", textAlign: TextAlign.center, style: TextStyle(
                color: Colors.white,
                fontFamily: 'MPLUSRounded',
                fontSize: 40,
                letterSpacing: 0.20000001788139343,
                fontWeight: FontWeight.bold,
                height: 1.400000028610228
            ),),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              primary: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 25),
              textStyle: TextStyle(color: Colors.grey[100],
                  fontSize: 18,
                  fontFamily: 'MPLUSRounded1c'),
            ),),
          SizedBox(height: 20,),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
        boxShadow: [
          BoxShadow(color: Colors.white, spreadRadius: 3),
        ],
      ),
    );
  }

  String GenerateBarcodeForProduct() {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return getRandomString(20);
  }

  Future<void> DownloadTheGeneratedBarCode() async {
    //Get the render object from context.
    return new Future.delayed(const Duration(milliseconds: 100), () async {
      final RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary; //get the render object from context
      final ui.Image image = await boundary.toImage(); // Convert
      dynamic bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      bytes =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

      if (image != null) {
        final Directory documentDirectory =
        await getApplicationDocumentsDirectory();
        final String path = documentDirectory.path;
        final String imageName = 'barcode.png';
        imageCache!.clear();
        File file = new File('$path/$imageName');
        file.writeAsBytesSync(bytes);

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Container(
                    color: Colors.white,
                    child: Image.file(file),
                  ),
                ),
              );
            },
          ),
        );
      }
    });
  }
}

class AddPOSOutletScreen extends StatefulWidget {
  const AddPOSOutletScreen({Key? key}) : super(key: key);

  @override
  _AddPOSOutletScreenState createState() => _AddPOSOutletScreenState();
}

class _AddPOSOutletScreenState extends State<AddPOSOutletScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
