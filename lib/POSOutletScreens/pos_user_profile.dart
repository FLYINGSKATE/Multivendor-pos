import 'package:flutter/material.dart';
import 'package:rdipos/POSOutletScreens/pos_home_page.dart';
import 'package:rdipos/Utility/widget_helper.dart';

import '../Bouncing.dart';
class POSUserProfile extends StatefulWidget {
  const POSUserProfile({Key? key}) : super(key: key);

  @override
  _POSUserProfileState createState() => _POSUserProfileState();
}

class _POSUserProfileState extends State<POSUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: WidgetHelper().RdiAppBar(),
      body:Column(
        children: [
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              height: 400.0,
              decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    alignment: Alignment(-.2, 0),
                    image: NetworkImage('https://i.pinimg.com/564x/47/7a/98/477a9879ad751b9a0773ae8571f772ea.jpg'),
                    fit: BoxFit.cover),
              ),

            ),
          ),
          Center(child: Container(
            height: 80.0,
            width: 200.0,
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  alignment: Alignment(-.2, 0),
                  image: NetworkImage('https://www.vistamalls.com.ph/wp-content/uploads/2021/02/logo-vistamall-bataan.png'),
                  fit: BoxFit.fitWidth),
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Name :', textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Intern',
                  fontSize: 20,
                  letterSpacing: 0.20000001788139343,
                  fontWeight: FontWeight.bold,
                  height: 1.400000028610228
              ),),
              Text('Shayna Hashmi', textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Intern',
                  fontSize: 20,
                  letterSpacing: 0.20000001788139343,
                  height: 1.400000028610228
              ),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Age :', textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Intern',
                  fontSize: 20,
                  letterSpacing: 0.20000001788139343,
                  fontWeight: FontWeight.bold,
                  height: 1.400000028610228
              ),),
              Text('21', textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Intern',
                  fontSize: 20,
                  letterSpacing: 0.20000001788139343,
                  height: 1.400000028610228
              ),),
            ],
          ),
          SizedBox(height: 20,),
          Bouncing(
            onPress: () {  },
            child: MaterialButton(
              onPressed: () async {
                //await Future.delayed(const Duration(milliseconds: 100), (){});
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => POSHomePage()));
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 70,
              ),
              padding: EdgeInsets.all(16),
              shape: CircleBorder(),
            ),
          )
        ],
      )
    );
  }


}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    int curveHeight = 80;
    Offset controlPoint = Offset(size.width / 1.2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;

  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
