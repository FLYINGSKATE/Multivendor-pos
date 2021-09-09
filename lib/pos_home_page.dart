import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class POSHomePage extends StatefulWidget {
  const POSHomePage({Key? key}) : super(key: key);

  @override
  _POSHomePageState createState() => _POSHomePageState();
}

class _POSHomePageState extends State<POSHomePage> {

  double totalValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: OrientationBuilder(
        builder: (context, orientation) {
          if(orientation==Orientation.portrait){
            return Column(
              children: [
                ProductLeftPanel(),
                NumberPadRightPanel(),
              ],
            );
          }
          else{
            return Row(
              children: [
                ProductLeftPanel(),
                NumberPadRightPanel(),
              ],
            );
          }
        },
      ),
    );
  }

  ProductLeftPanel() {
    return Container(
        width: MediaQuery.of(context).size.width/2,
        child: Text("Product Panel")
    );
  }

  NumberPadRightPanel(){
    return Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            depth: 8,
            lightSource: LightSource.topLeft,
            color: Colors.white
        ),
        child: Column(
          children: [
            Row(
              children: [
                NeumorphicButton(
                  style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Color(0x33000000),
                        width: 0.8,
                      )
                  ),
                  onPressed: (){
                    addToTotal(1);
                  },
                  child:CustomText("1") ,
                ),
                NeumorphicButton(
                  style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Color(0x33000000),
                        width: 0.8,
                      )
                  ),
                  child:CustomText("2") ,
                  onPressed: (){
                    addToTotal(2);
                  },
                ),
                NeumorphicButton(
                  style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Color(0x33000000),
                        width: 0.8,
                      )
                  ),
                  onPressed: (){
                    addToTotal(3);
                  },
                  child:CustomText("3") ,
                ),
              ],
            ),
            Row(
              children: [
                NeumorphicButton(
                  style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Color(0x33000000),
                        width: 0.8,
                      )
                  ),
                  child:CustomText("4") ,
                  onPressed: (){
                    addToTotal(4);
                  },
                ),
                NeumorphicButton(
                  style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Color(0x33000000),
                        width: 0.8,
                      )
                  ),
                  child:CustomText("5") ,
                  onPressed: (){
                    addToTotal(5);
                  },
                ),
                NeumorphicButton(
                  style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Color(0x33000000),
                        width: 0.8,
                      )
                  ),
                  child:CustomText("6") ,
                  onPressed: (){
                    addToTotal(6);
                  },
                ),
              ],
            ),
            Row(
              children: [
                NeumorphicButton(
                  style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Color(0x33000000),
                        width: 0.8,
                      )
                  ),
                  child:CustomText("7") ,
                  onPressed: (){
                    addToTotal(7);
                  },
                ),
                NeumorphicButton(
                  style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Color(0x33000000),
                        width: 0.8,
                      )
                  ),
                  child:CustomText("8") ,
                  onPressed: (){
                    addToTotal(8);
                  },
                ),
                NeumorphicButton(
                  style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Color(0x33000000),
                        width: 0.8,
                      )
                  ),
                  child:CustomText("9") ,
                  onPressed: (){
                    addToTotal(9);
                  },
                ),
              ],
            ),
            Row(
              children: [
                NeumorphicButton(
                  style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Color(0x33000000),
                        width: 0.8,
                      )
                  ),
                  child:CustomText("+") ,
                ),
                NeumorphicButton(
                  onPressed: (){
                    print("zero pressed");
                    addToTotal(0);
                  },
                  style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Color(0x33000000),
                        width: 0.8,
                      )
                  ),
                  child:CustomText("0") ,
                ),
                NeumorphicButton(
                  style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Color(0x33000000),
                        width: 0.8,
                      )
                  ),
                  onPressed: (){
                    addToTotal(99);
                  },
                  child:CustomText(" . "),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget CustomText(String value){
    return Text(value,style: TextStyle(fontSize: 40),);
  }

  void addToTotal(int i) {
    if(i==0){
      //That means we got a Zero
      totalValue *= 10;
      print(totalValue);
    }
    else{
      totalValue += i;
      print(totalValue);
    }

  }
}
