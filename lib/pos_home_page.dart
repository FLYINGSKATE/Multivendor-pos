import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:math' as math;

class POSHomePage extends StatefulWidget {
  const POSHomePage({Key? key}) : super(key: key);

  @override
  _POSHomePageState createState() => _POSHomePageState();
}

class _POSHomePageState extends State<POSHomePage> {
  List<int> text = [1,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4,2,3,4];
  double totalValue = 0.0;

  @override
  initState() {
    super.initState();
    goFullScreen();
  }

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              for ( var i in text ) Column(
                children: [SizedBox(height: 20,),ProductTemplate()],
              )
            ],
          ),
        )
    );
  }

  ProductTemplate(){
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width/2.2,
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Neumorphic(
        style: NeumorphicStyle(
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: 8,
        lightSource: LightSource.topLeft,
        ),
        child:Row(
            children: [
              Expanded(
                flex: 2,
                child: Image.asset('assets/images/sampletee.jpg'),),
              Expanded(
                flex: 7,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                children: [
                // Figma Flutter Generator TshirtWidget - TEXT
                Text('T-Shirt', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Lato',
                    fontSize: 24,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),),
                // Figma Flutter Generator 2Widget - TEXT
                Text('2\$', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Lato',
                    fontSize: 16,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),),
              ],
            ),
          ),
          Divider(height: 10),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                // Figma Flutter Generator QtyWidget - TEXT
                Text('QTY', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Lato',
                    fontSize: 16,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),),
                // Figma Flutter Generator 10Widget - TEXT
                Text('10', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Lato',
                    fontSize: 16,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),),
              ],
            ),
          ),
        ],
      )
    ));
  }

  NumberPadRightPanel(){
    return Container(
      width: MediaQuery.of(context).size.width/2,
      child: Center(
        child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 8,
                lightSource: LightSource.topLeft,

            ),
            child: Column(
              children: [
                Row(children: [
                  Expanded(
                    flex: 1,
                    child: ShowNumberButton(),
                  ),
                  Expanded(
                    flex: 1,
                    child: HomeButton(),
                  ),
                  Expanded(
                    flex: 10,
                    child: SearchBox(),
                  )
                ],),
                Padding(padding: EdgeInsets.all(20),
                  child:NumberPad(),
                )
              ],
            ),
        ),
      ),
    );
  }

  NumberPad(){
    return Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            depth: 8,
            lightSource: LightSource.topLeft,
            color: Colors.black
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                  NeumorphicButton(
                    style: NeumorphicStyle(
                        border: NeumorphicBorder(
                          color: Color(0x33000000),
                          width: 0.8,
                        )
                    ),
                    onPressed: (){
                    },
                    child:CustomText("Qty") ,
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
                  NeumorphicButton(
                    style: NeumorphicStyle(
                        border: NeumorphicBorder(
                          color: Color(0x33000000),
                          width: 0.8,
                        )
                    ),
                    onPressed: (){
                    },
                    child:CustomText("Disc.") ,
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
                  NeumorphicButton(
                    style: NeumorphicStyle(
                        border: NeumorphicBorder(
                          color: Color(0x33000000),
                          width: 0.8,
                        )
                    ),
                    onPressed: (){
                    },
                    child:CustomText("Price") ,
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
                  NeumorphicButton(
                    style: NeumorphicStyle(
                        border: NeumorphicBorder(
                          color: Color(0x33000000),
                          width: 0.8,
                        )
                    ),
                    onPressed: (){
                    },
                    child:Icon(Icons.arrow_back_ios) ,
                  ),
                ],
              ),

            ],
          ),
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

  SearchBox() {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          filled: true,
          prefixIcon:Icon(Icons.search) ,
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: "Type in your text",
          fillColor: Colors.white),
    );
  }

  HomeButton(){
    return MaterialButton(
      onPressed: () {},
      color: Colors.white,
      textColor: Colors.black,
      child: Icon(
        Icons.home,
        size: 24,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );
  }

  ShowNumberButton() {
    return MaterialButton(
      onPressed: () {},
      color: Colors.white,
      textColor: Colors.black,
      child: Icon(
        Icons.format_list_numbered_sharp,
        size: 24,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );
  }

  void goFullScreen() {
    document.documentElement!.requestFullscreen();
  }
}
