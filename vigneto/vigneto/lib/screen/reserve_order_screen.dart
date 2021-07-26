import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vigneto/components/icon_content.dart';
import 'package:vigneto/components/reusable_card.dart';
import 'package:vigneto/dao/crud_model.dart';
import 'package:vigneto/dash_menu/admin_console_scree_reservation.dart';
import 'package:vigneto/dash_menu/admin_console_screen_menu.dart';
import 'package:vigneto/models/configuration.dart';
import 'package:vigneto/reservation/reservation_screen.dart';
import 'package:vigneto/screen/table_covers_screen.dart';
import 'package:vigneto/utils/costants.dart';

class ReserveOrderChooseScreen extends StatefulWidget {

  static String id = 'choosingscreen';

  @override
  _ReserveOrderChooseScreenState createState() => _ReserveOrderChooseScreenState();
}

class _ReserveOrderChooseScreenState extends State<ReserveOrderChooseScreen> {

  CRUDModel crudModelConf = CRUDModel(CONFIGURATION);

  final _passwordController = TextEditingController();
  List<Configuration> confList = <Configuration>[];

  Future<void> retrieveConfiguration() async {
    confList = await crudModelConf.fetchConfiguration();
  }


  @override
  void initState() {
    super.initState();
    retrieveConfiguration();
  }

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
                child: Column(
                  children: [
                    Image.asset('images/terrazzament.png',
                      fit: BoxFit.contain,
                    ),
                    Text('v. 1.0.120', style: TextStyle(fontSize: 7, color: Colors.white),),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: ReusableCard(
                  color: Colors.white,
                  cardChild: IconContent(label: 'Menù', icon: Icons.restaurant_menu,color: VIGNETO_BROWN, description: '',),
                  onPress: () {
                    Navigator.pushNamed(context, TableCoversScreen.id);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: ReusableCard(
                  color: Colors.white,
                  cardChild: IconContent(label: 'Prenota un tavolo', icon: Icons.calendar_today,color: VIGNETO_BROWN, description: '',),
                  onPress: () {
                    _isReservationBlocked(confList) ?
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(backgroundColor: Colors.orange.shade500 ,
                        content: Text('Attenzione - Raggiunta capacità massima del locale. Prenotazioni bloccate. Contattare direttamente la struttura.')))
                        : Navigator.pushNamed(context, TableReservationScreen.id);
                  },
                ),
              ),
              Expanded(
                flex: 1,
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

  _isReservationBlocked(List<Configuration> confList) {
    bool confLocked = false;
    if(confList == null || confList.isEmpty){
      return confLocked;
    }
    confList.forEach((configuration) {
      if(configuration.key == 'reservation-status' && configuration.conf == 'locked'){
        confLocked = true;
      }
    });
    return confLocked;
  }

}
