import 'package:flutter/material.dart';
import 'package:vigneto/utils/costants.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({@required this.color, this.cardChild, this.onPress, this.height});

  final Color color;
  final Widget cardChild;
  final Function onPress;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: height,
        child: cardChild,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: VIGNETO_BROWN,
                spreadRadius: 2.0,
                blurRadius: 5.0,
              ),
            ]
        ),
      ),
    );
  }
}