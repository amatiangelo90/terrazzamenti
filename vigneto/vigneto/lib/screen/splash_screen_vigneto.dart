import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vigneto/screen/reserve_order_screen.dart';
import 'package:vigneto/utils/costants.dart';

class SplashScreenTerrazzamenti extends StatefulWidget {
  static String id = 'splash';
  @override
  _SplashScreenTerrazzamentiState createState() => _SplashScreenTerrazzamentiState();
}

class _SplashScreenTerrazzamentiState extends State<SplashScreenTerrazzamenti> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ReserveOrderChooseScreen.id);
        },
        child: Container(
          color: VIGNETO_BROWN,
          child: Image.asset('images/logo.jpg',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 3000), ()=> Navigator.pushNamed(context, ReserveOrderChooseScreen.id));
  }
}