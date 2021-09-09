import 'dart:async';

import 'package:flutter/material.dart';

import 'pos_home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 2),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => POSHomePage())));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/rdilogo.png'),
              CircularProgressIndicator(color: Colors.white,),
            ],
          ),
      ),
    );
  }
}
