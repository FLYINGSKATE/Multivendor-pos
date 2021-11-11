import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/Utility/widget_helper.dart';
import 'package:web_scraper/web_scraper.dart';

class AddProductScreen extends StatefulWidget {
  final String shopName;
  const AddProductScreen({Key? key, required this.shopName}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {


  final databaseRef = FirebaseDatabase.instance.reference();

  TextEditingController _productBarCodeTextEditingController = TextEditingController();
  TextEditingController _productNameTextEditingController = TextEditingController();
  TextEditingController _productPriceTextEditingController = TextEditingController();
  TextEditingController _productStockTextEditingController = TextEditingController();
  TextEditingController _productSellerContactNumberTextEditingController = TextEditingController();

  bool _showProductNameErrorMessgae = false;
  bool _showProductPriceErrorMessage = false;
  bool _showProductStockErrorMessage = false;
  bool _showProductSellerContactNumberErrorMessage = false;
  bool _showProductBarCodeErrorMessage = false;

  String _productNameErrorMessage = "Product Name Name Cannot Be Blank";
  String _productPriceErrorMessage = "Price Value Cannot Be Blank";
  String _productStockErrorMessage = "Stock Value Cannot Be Blank";
  String productSellerContactNumberErrorMessage = "Seller Contact Cannot Be Blank";
  String _barCodeErrorMessage = "No Such Product Exists";

  String tempBarcode = "";

  bool enableDownloadBarcodeButton = false;

  String productNameFromApi = "";

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
                        TextField(
                          controller: _productBarCodeTextEditingController,
                          onChanged: (value) async {
                            if(value.length>=10){
                              final webScraper = WebScraper('https://www.barcodespider.com');
                              if (await webScraper.loadWebPage('/$value')) {
                                List<Map<String, dynamic>> elements = webScraper.getElement('div.detailtitle > h2', ['title']);
                                print(elements);
                                productNameFromApi = elements[0]['title'];
                                _productNameTextEditingController.text = productNameFromApi;
                                print(elements[0]['title']);
                                setState(() {

                                });
                              }
                            }
                          },
                          style: TextStyle(color: Colors.grey[100],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
                          decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: 16.0,
                              ),
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
                                child: Icon(Icons.scanner,size: 40,color: Colors.white,),
                              ),
                              hintStyle: TextStyle(color: Colors.grey[500],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
                              hintText: "Use Your Scanner",
                              fillColor: Colors.black
                          ),
                        ),
                        SizedBox(height: 20,),
                        TextField(
                          controller: _productNameTextEditingController,
                          style: TextStyle(color: Colors.grey[100],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
                          decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              enabledBorder:OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(100.0),
                              ) ,
                              filled: true,
                              errorText: _showProductNameErrorMessgae?_productNameErrorMessage:null,
                              focusColor: Colors.white,
                              focusedBorder:OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              prefixIcon:Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(Icons.perm_contact_cal_sharp,size: 40,color: Colors.white,),
                              ),
                              hintStyle: TextStyle(color: Colors.grey[500],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
                              hintText: "Enter Product Name",
                              fillColor: Colors.black
                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Expanded(
                                child: WidgetHelper().CustomNumberTextField(
                                    "Enter Price", Icons.money,
                                    _productPriceTextEditingController,
                                    _showProductPriceErrorMessage,
                                    _productPriceErrorMessage,context)),
                            SizedBox(width: 20,),
                            Expanded(
                                child: WidgetHelper().CustomNumberTextField(
                                    "Enter Stock Unit",
                                    Icons.all_inbox_rounded,
                                    _productStockTextEditingController,
                                    _showProductStockErrorMessage,
                                    _productStockErrorMessage,context)),
                          ],
                        ),
                        SizedBox(height: 20,),
                        WidgetHelper().CustomPhoneNumberTextField(
                            "Enter Seller Contact Number", Icons.phone,
                            _productSellerContactNumberTextEditingController,
                            _showProductSellerContactNumberErrorMessage,
                            productSellerContactNumberErrorMessage,context),
                        SizedBox(height: 20,),
                        SizedBox(height: 10,),
                        ElevatedButton(
                          onPressed: () async {
                            _showProductNameErrorMessgae =
                                _productNameTextEditingController.text
                                    .isEmpty;
                            _showProductBarCodeErrorMessage =
                                _productBarCodeTextEditingController.text
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
                                    .isNotEmpty)) && (_productBarCodeTextEditingController.text.isNotEmpty &&
                                _productSellerContactNumberTextEditingController
                                    .text.isNotEmpty)
                            ) {

                              String AddProductMessage = await FirebaseRepo()
                                  .AddNewProduct(widget.shopName,
                                  _productNameTextEditingController.text
                                      .trim(),
                                  _productPriceTextEditingController.text
                                      .trim(),
                                  _productStockTextEditingController.text
                                      .trim(),
                                  _productSellerContactNumberTextEditingController
                                      .text.trim(), _productBarCodeTextEditingController.text.trim());
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
                                fontSize: MediaQuery.of(context).size.width*0.03,
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


  ///Legacy Methods used for Product Stock
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

