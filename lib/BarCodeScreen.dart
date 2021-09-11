import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class GenerateBarCodeScreen extends StatefulWidget {
  const GenerateBarCodeScreen({Key? key}) : super(key: key);

  @override
  _GenerateBarCodeScreenState createState() => _GenerateBarCodeScreenState();
}

class _GenerateBarCodeScreenState extends State<GenerateBarCodeScreen> {

  TextEditingController controller = TextEditingController();

  String _scanBarcode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Bar Code'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 200,),
            BarcodeWidget(
              drawText: true,
              barcode: Barcode.code128(), // Barcode type and settings
              data: controller.text,
              width: 200,// Content
            ),
            SizedBox(height: 24,),
            Padding(padding: EdgeInsets.symmetric(horizontal: 32),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Your Product Name Here",
                  fillColor: Colors.white70),
            ),
            ),
            ElevatedButton.icon(onPressed:(){setState(() {});} , icon: Icon(Icons.add), label: Text("Add Product")),
            SizedBox(height: 200,),
            Padding(padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text("Your Generated Barcode result is :"),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(_scanBarcode,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanBarcodeNormal,

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.camera),
        ),
      ),
    );
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      print(barcodeScanRes);
    });

  }
}

late String scanResult;

class ResultScreen extends StatefulWidget {

  const ResultScreen({Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();



}

class _ResultScreenState extends State<ResultScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 200,),
            Padding(padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text("Your Generated Barcode result is :"),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(scanResult,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
            ),
          ],
        ),
      ),
    );
  }
}

