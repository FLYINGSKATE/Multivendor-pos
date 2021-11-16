import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/ShopOwnerScreens/BillDetailsScreen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:rdipos/Utility/widget_helper.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BillsListScreen extends StatefulWidget {
  final String shopName;
  const BillsListScreen({Key? key, required this.shopName}) : super(key: key);

  @override
  _BillsListScreenState createState() => _BillsListScreenState();
}

class _BillsListScreenState extends State<BillsListScreen> {

  List<String> PosOutletList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for ( String posName in PosOutletList )
          StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("ShopList").doc(widget.shopName).collection("POSOutlets").doc(posName).collection("Bills").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>
          snapshot) {
          if (!snapshot.hasData) return new Text("There is no Bills in $posName");
                return new ListView(
                    shrinkWrap: true,children: getExpenseItems(snapshot));
          }),
      ],
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("Length of the Snapshot");
    print(snapshot.data!.docs.length);
    double _value = 0.0;
    print(snapshot.data!.docs.toList());
    return snapshot.data!.docs.map((doc) => new Container(
        color: Colors.black,
        child: InkWell(onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BillDetailsScreen( doc: doc,)),
          );
        }
        ,child:Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left:10,right: 10),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child:Text(doc["CustomerName"], textAlign: TextAlign.start, style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Intern',
                      fontSize:  MediaQuery.of(context).size.width*0.02,
                      letterSpacing: 0.20000001788139343,
                      height: 1.400000028610228
                  ),)),
                  Text(timeago.format(DateTime.parse(doc["Date"].toDate().toString())).toString(), textAlign: TextAlign.center, style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Intern',
                      fontSize:  MediaQuery.of(context).size.width*0.02,
                      letterSpacing: 0.20000001788139343,
                      height: 1.400000028610228
                  ),),
                ],
              ),
              Expanded(child:Text("Total :"+doc["totalPrice"], textAlign: TextAlign.start, style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Intern',
                  fontSize:  MediaQuery.of(context).size.width*0.02,
                  letterSpacing: 0.20000001788139343,
                  height: 1.400000028610228
              ),)),
              Divider(height: 1,color: Colors.white,)
            ],
          ),
        ),))
    ).toList();
  }

  @override
  void initState() {
    FetchPosOutLetList();
  }

  Future<void> FetchPosOutLetList() async {
   PosOutletList  = await FirebaseRepo().POSOutletList(widget.shopName);
   print(PosOutletList);
   setState(() {});
  }
}
