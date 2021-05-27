import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vigneto/components/icon_content.dart';
import 'package:vigneto/components/reusable_card.dart';
import 'package:vigneto/dash_menu/admin_console_screen_menu.dart';
import 'package:vigneto/reservation/reservation_screen.dart';
import 'package:vigneto/screen/table_covers_screen.dart';
import 'package:vigneto/utils/costants.dart';

class ReserveOrderChooseScreen extends StatefulWidget {

  static String id = 'choosingscreen';

  final String uniqueId;

  ReserveOrderChooseScreen({@required this.uniqueId});

  @override
  _ReserveOrderChooseScreenState createState() => _ReserveOrderChooseScreenState();
}

class _ReserveOrderChooseScreenState extends State<ReserveOrderChooseScreen> {

  final _passwordController = TextEditingController();

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
                  cardChild: IconContent(label: 'Menù', icon: Icons.restaurant_menu,color: VIGNETO_BROWN, description: '',),
                  onPress: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TableCoversScreen(
                        uniqueId: this.widget.uniqueId,
                      ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ReusableCard(
                  color: Colors.white,
                  cardChild: IconContent(label: 'Prenota un tavolo', icon: Icons.calendar_today,color: VIGNETO_BROWN, description: '',),
                  onPress: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TableReservationScreen(
                        uniqueId: this.widget.uniqueId,
                      ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ReusableCard(
                  color: Colors.white,
                  cardChild: IconContent(label: 'Settings', icon: Icons.settings,color: VIGNETO_BROWN, description: '',),
                  onPress: _showModalSettingsAccess,
                ),
              ),
            ],

          ),
        ),
      ),
    );

  }

  _showModalSettingsAccess() {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: Center(child: new Text("Settings")),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Center(
              child: Card(
                color: Colors.white,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  controller: _passwordController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 0.0),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.black,
                    labelText: 'Password',
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                child: Text('Chiudi'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text('Accedi'),
                  onPressed: (){

                    if(_passwordController.value.text == CURRENT_PASSWORD){
                      setState(() {
                        _passwordController.clear();
                      });
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, AdminConsoleMenuScreen.id);
                    }else{
                      setState(() {
                        _passwordController.clear();
                      });

                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(backgroundColor: Colors.red.shade500 ,
                          content: Text('Password errata')));
                    }
                  }
              ),
            ],
          )
        ],
      ),
    );
  }
}
