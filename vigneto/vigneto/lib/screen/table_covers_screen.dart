import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vigneto/dash_menu/admin_console_scree_reservation.dart';
import 'package:vigneto/dash_menu/admin_console_screen_menu.dart';
import 'package:vigneto/screen/reserve_order_screen.dart';
import 'package:vigneto/utils/costants.dart';
import 'package:vigneto/utils/round_icon_botton.dart';

import 'home_vigneto.dart';

class TableCoversScreen extends StatefulWidget {

  static String id = 'tablecovers';


  @override
  _TableCoversScreenState createState() => _TableCoversScreenState();
}

class _TableCoversScreenState extends State<TableCoversScreen> {
  bool _isTableSelected = false;
  String _tableSelected = '';
  final _passwordController = TextEditingController();
  int _covers = 1;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: _isTableSelected ? Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: _isTableSelected ? Colors.white : VIGNETO_BROWN),
              onPressed: () => {
                setState(() {
                  _isTableSelected = false;
                  _tableSelected = '';
                }),
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white,),
                onPressed: _showModalSettingsAccess,
              ),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: VIGNETO_BROWN,
            title:  Text('Seleziona Numero Calici', style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'LoraFont'),),
            centerTitle: true,
          ),
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Tavolo: ' + _tableSelected,
                  style: TextStyle(fontSize: 25.0,
                      color: Colors.white,
                      fontFamily: 'LoraFont'),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text('Nota: numero coperti utile esclusivamente per quantitativo calici di cui occorrete',
                      style: TextStyle(overflow: TextOverflow.visible, fontSize: 15.0,
                          color: Colors.white,
                          fontFamily: 'LoraFont'),),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundIconButton(
                      icon: FontAwesomeIcons.minus,
                      function: () {
                        print(DateTime.now().toString());
                        setState(() {
                          if (_covers > 1)
                            _covers = _covers - 1;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                      _covers <= 1 ?
                      Text(_covers.toString() + ' Coperto',
                        style: TextStyle(fontSize: 25.0,
                            color: Colors.white,
                            fontFamily: 'LoraFont'),) :
                      Text(_covers.toString() + ' Coperti',
                        style: TextStyle(fontSize: 25.0,
                            color: Colors.white,
                            fontFamily: 'LoraFont'),),
                    ),
                    RoundIconButton(
                      icon: FontAwesomeIcons.plus,
                      function: () {
                        setState(() {
                          _covers = _covers + 1;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(width: 140.0,),
                MaterialButton(
                  minWidth: 200.0,
                  height: 35,
                  color: VIGNETO_BROWN,
                  child: new Text('Vai al Menù',
                      style: new TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'LoraFont')),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TerrazzamentiHomeScreen(
                        covers: _covers.toString(),
                        tableNumber: _tableSelected,
                      ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ) : Scaffold(

          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: VIGNETO_BROWN,
            title:  Text('Seleziona Tavolo', style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'LoraFont'),),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white,),
                onPressed: _showModalSettingsAccess,
              ),
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: ()=> Navigator.pushNamed(context, ReserveOrderChooseScreen.id),
            ),
          ),
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(20, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isTableSelected = true;
                        _tableSelected = (index+1).toString();
                      });
                    },
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: VIGNETO_BROWN, width: 3.0),
                        ),
                        padding: const EdgeInsets.all(18.0),
                        child: Center(
                          child: Text(
                            'Tavolo ${index+1}',
                            style: TextStyle(fontSize: 14,color: Colors.white, fontFamily: 'LoraFont'),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  _showModalSettingsAccess() {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Settings"),
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

                    if(_passwordController.value.text == CURRENT_PASSWORD_ADMIN){
                      setState(() {
                        _passwordController.clear();
                      });
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, AdminConsoleMenuScreen.id);
                    }else if(_passwordController.value.text == CURRENT_PASSWORD_ADMIN_2_LEV){
                      setState(() {
                        _passwordController.clear();
                      });
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, AdminConsoleReservationScreen.id);
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
