import 'package:flutter/material.dart';
import 'package:rdipos/widget_helper.dart';
class POSUserProfile extends StatefulWidget {
  const POSUserProfile({Key? key}) : super(key: key);

  @override
  _POSUserProfileState createState() => _POSUserProfileState();
}

class _POSUserProfileState extends State<POSUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().RdiAppBar(),
      body:ClipPath(
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
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
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
