import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  int _covers = 1;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: _isTableSelected ? Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,

            backgroundColor: VIGNETO_BROWN,
            title:  Text('Seleziona Numero Coperti', style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'LoraFont'),),
            centerTitle: true,
          ),
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Tavolo : ' + _tableSelected,
                  style: TextStyle(fontSize: 25.0,
                      color: Colors.white,
                      fontFamily: 'LoraFont'),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundIconButton(
                      icon: FontAwesomeIcons.minus,
                      function: () {
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
                          if(_covers<4){
                            _covers = _covers + 1;
                          }else{
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(backgroundColor: Colors.red.shade500 ,
                                content: Text('Avvertenza Covid19 - I coperti per tavolo possono essere al massimo 4')));
                          }
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
                            style: TextStyle(fontSize: 13,color: Colors.white, fontFamily: 'LoraFont'),
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
}
