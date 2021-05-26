import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vigneto/reservation/reservation.dart';
import 'package:vigneto/screen/home_vigneto.dart';
import 'package:vigneto/screen/reserve_order_screen.dart';
import 'package:vigneto/screen/splash_screen_vigneto.dart';
import 'package:vigneto/screen/table_covers_screen.dart';

import 'dash_menu/admin_console_screen_menu.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot){
          if(snapshot.hasError){
            print(snapshot.error);
            return Container(color: Colors.redAccent,);
          }
          if(snapshot.connectionState == ConnectionState.done){
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Terrazzamenti Menu',
                initialRoute: SplashScreenTerrazzamenti.id,
                routes:{
                  SplashScreenTerrazzamenti.id : (context) => SplashScreenTerrazzamenti(),
                  TerrazzamentiHomeScreen.id : (context) => TerrazzamentiHomeScreen(),
                  TableCoversScreen.id : (context) => TableCoversScreen(),
                  AdminConsoleMenuScreen.id : (context) => AdminConsoleMenuScreen(),
                  ReserveOrderChooseScreen.id : (context) => ReserveOrderChooseScreen(),
                  TableReservationScreen.id : (context) => TableReservationScreen(),
                }
            );
          }
          return CircularProgressIndicator();
        }
    );

  }
}