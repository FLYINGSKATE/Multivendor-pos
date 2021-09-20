import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/owner_pos_homepage.dart';

import 'POSOutletScreens/pos_home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 1),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomePage())));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/rdilogo.png'),
              SizedBox(height: 60,),
              CircularProgressIndicator(color: Colors.white,),
            ],
          ),
      ),
    );
  }
}



