import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vigneto/components/icon_content.dart';
import 'package:vigneto/components/reusable_card.dart';
import 'package:vigneto/reservation/reservation.dart';
import 'package:vigneto/screen/table_covers_screen.dart';
import 'package:vigneto/utils/costants.dart';

import 'home_vigneto.dart';


class ReserveOrderChooseScreen extends StatefulWidget {

  static String id = 'choosingscreen';

  @override
  _ReserveOrderChooseScreenState createState() => _ReserveOrderChooseScreenState();
}

class _ReserveOrderChooseScreenState extends State<ReserveOrderChooseScreen> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: VIGNETO_BROWN,
        child: Scaffold(
          backgroundColor: VIGNETO_BROWN,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                child: Image.asset('images/terrazzament.png',
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: ReusableCard(
                  color: Colors.white,
                  cardChild: IconContent(label: 'Prenota un tavolo', icon: Icons.calendar_today,color: VIGNETO_BROWN, description: '',),
                  onPress: () {
                    Navigator.pushNamed(context, TableReservationScreen.id);
                  },
                ),
              ),
              Expanded(
                child: ReusableCard(
                  color: Colors.white,
                  cardChild: IconContent(label: 'Menù', icon: Icons.restaurant_menu,color: VIGNETO_BROWN, description: '',),
                  onPress: () {
                    Navigator.pushNamed(context, TableCoversScreen.id);
                  },
                ),
              ),
            ],

          ),
        ),
      ),
    );

  }
}
