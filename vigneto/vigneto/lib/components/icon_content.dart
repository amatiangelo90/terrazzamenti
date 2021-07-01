import 'package:flutter/material.dart';
import 'package:vigneto/utils/costants.dart';

class IconContent extends StatelessWidget {

  IconContent({@required this.label, @required this.icon, this.color, this.description});

  final String label;
  final IconData icon;
  final Color color;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 70.0,
          color: color,
        ),
        SizedBox(width: 30.0,),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            label,
            style: TextStyle(color: VIGNETO_BROWN, fontSize: 16.0, fontFamily: 'LoraFont'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                description,
                style: TextStyle(color: VIGNETO_BROWN, fontSize: 16.0, fontFamily: 'LoraFont'),
              ),
            ),
          ),
        )
      ],
    );
  }
}
