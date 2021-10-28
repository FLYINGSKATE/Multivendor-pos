import 'package:flutter/material.dart';
import 'package:rdipos/Utility/widget_helper.dart';
import 'package:web_scraper/web_scraper.dart';

class ScanWithGun extends StatefulWidget {
  const ScanWithGun({Key? key}) : super(key: key);

  @override
  _ScanWithGunState createState() => _ScanWithGunState();
}

class _ScanWithGunState extends State<ScanWithGun> {
  TextEditingController controller = TextEditingController();
  String scanRes="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().RdiAppBar(context),
      body: Container(
        child: Column(
          children: [
          TextField(
          controller: controller,
          onChanged: (value) async {
            if(value.length>=12){
              final webScraper = WebScraper('https://www.barcodespider.com');
              //.detailtitle h2
              if (await webScraper.loadWebPage('/$value')) {
              List<Map<String, dynamic>> elements = webScraper.getElement('div.detailtitle > h2', ['title']);
              print(elements);
              scanRes = elements[0]['title'];
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
              hintText: "Use Your Shaktimaan",
              fillColor: Colors.black
          ),
        ),
            Text( "$scanRes", textAlign: TextAlign.center, style: TextStyle(
                color: Color.fromRGBO(38, 50, 56, 1),
                fontFamily: 'Inter',
                fontSize: 16,
                letterSpacing: 0.20000001788139343,
                fontWeight: FontWeight.normal,
                height: 1.400000028610228
            ),),
          ],
        )
      )
    );
  }


}
