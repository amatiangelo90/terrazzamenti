import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vigneto/screen/table_covers_screen.dart';

class SplashScreenVigneto extends StatefulWidget {
  static String id = 'splash';
  @override
  _SplashScreenVignetoState createState() => _SplashScreenVignetoState();
}

class _SplashScreenVignetoState extends State<SplashScreenVigneto> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, TableCoversScreen.id);
        },
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('images/logo.jpg',
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 3000), ()=> Navigator.pushNamed(context, TableCoversScreen.id));
  }
}