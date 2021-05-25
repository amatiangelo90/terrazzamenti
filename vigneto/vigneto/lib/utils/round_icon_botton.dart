import 'package:flutter/material.dart';
import 'costants.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton(
      {@required this.icon, @required this.function});

  final IconData icon;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      child: Icon(icon, color: Colors.white,),
      onPressed: function,
      constraints: BoxConstraints.tightFor(width: 40.0, height: 40.0),
      shape: CircleBorder(),
      fillColor: VIGNETO_BROWN,
    );
  }
}