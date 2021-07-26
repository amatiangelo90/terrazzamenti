import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' show canLaunch, launch;
import 'package:uuid/uuid.dart';
import 'package:vigneto/dao/crud_model.dart';
import 'package:vigneto/models/cart.dart';
import 'package:vigneto/utils/costants.dart';
import '../reserve_order_screen.dart';

class HttpService {

  static sendTextMessage(
      String number,
      String message,
      String name,
      String calici,
      String total,
      String time,
      List<Cart> cartItems,
      String uniqueId,
      String typeOrder,
      String datePickupDelivery,
      String hourPickupDelivery,
      String city,
      String address,
      dynamic context) async {

    /*var url = 'https://api.callmebot.com/whatsapp.php?phone=+393450330750&text=$message&apikey=530988';
    await launch(url);*/

    try {

      CRUDModel crudModel = CRUDModel(ORDERS_TRACKER_IOS);
      var _separator = Uuid().v1();

      var _url = 'http://217.160.242.158:8080/terrazzamenti/api/sendorder?covers=$calici&table=$address&separator=$_separator';

      cartItems.forEach((element) {
        _url = _url + '&order=${element.product.name}' + _separator + '${element.product.discountApplied.toString()}' +_separator+ '${element.numberOfItem}' +_separator+ '${element.product.price}';
      });

      /*await canLaunch(_url) ?
       :
      throw 'Could not launch $_url';*/
      /*await canLaunch(_url) ?*/


      //TODO decommentare questa riga per inviare l'ordine a db
      await launch(_url);


      /*throw 'Could not launch $_url';*/
      await crudModel.addOrder(
          uniqueId,
          name,
          total,
          time,
          cartItems,
          false,
          typeOrder,
          datePickupDelivery,
          hourPickupDelivery,
          city,
          'Tavolo: ' + address + ' - Calici: ' + calici);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(backgroundColor: Colors.green ,
          duration: Duration(seconds: 1),
          content: Text('Ordine Inviato')));
      Timer(
          Duration(milliseconds: 2000),
              ()=> Navigator.pushNamed(context, ReserveOrderChooseScreen.id));

    } catch (error) {
      try{
        CRUDModel crudModele = CRUDModel(ERRORS_REPORT);
        await crudModele.addException(
            name,
            'Cannot launch command. $error',
            time);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(backgroundColor: Colors.orangeAccent ,
            content: Text('Attenzione! Impossibile inviare l\'ordine. Errore: ${error}')));

      }catch (e){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(backgroundColor: Colors.red ,
            content: Text('Error - $e')));
      }
    }
  }

  static sendReservationMessage(
      number,
      message,
      time,
      String docId,
      String id,
      String name,
      String date,
      String reservationDate,
      String customerNumber,
      String hour,
      String covers,
      bool confirmed,
      String uniqueId,
      dynamic context
      ) async {
    try {
      if (Platform.isAndroid) {
        print('Siamo su android');



        CRUDModel crudModelNotTracker = CRUDModel(RESERVATION_TRACKER);

        await crudModelNotTracker.addReservation(
            uniqueId,
            docId,
            time,
            name,
            date,
            reservationDate,
            customerNumber,
            hour,
            covers,
            confirmed);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(backgroundColor: Colors.green ,
            content: Text('Prenotazione Inviate - Android')));

      } else if (Platform.isIOS) {
        print('Siamo su android');
        /*SmsSender sender = new SmsSender();
        sender.sendSms(new SmsMessage('3791792800', message));*/

        CRUDModel crudModelNotTracker = CRUDModel(RESERVATION_TRACKER);

        await crudModelNotTracker.addReservation(
            uniqueId,
            docId,
            time,
            name,
            date,
            reservationDate,
            customerNumber,
            hour,
            covers,
            confirmed);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(backgroundColor: Colors.green ,
            content: Text('Prenotazione Inviate - IOS')));
      }
      print('Send message...');

      /*postData(refactorNumber(customerNumber), message);*/

      Timer(
          Duration(milliseconds: 2000),
              ()=> Navigator.pushNamed(context, ReserveOrderChooseScreen.id));
    } catch (error) {
      try{
        CRUDModel crudModel = CRUDModel(ERRORS_REPORT);
        await crudModel.addException(
            name,
            'Cannot launch command. $error',
            time);
        CRUDModel crudModelNotTracker = CRUDModel(RESERVATION_TRACKER);

        await crudModelNotTracker.addReservation(
            uniqueId,
            docId,
            time,
            name,
            date,
            reservationDate,
            customerNumber,
            hour,
            covers,
            confirmed);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(backgroundColor: Colors.orangeAccent ,
            content: Text('Prenotazione Inviata - IOS')));
      }catch (e){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(backgroundColor: Colors.red ,
            content: Text('Error - $e')));
        print(' could not launch error');
      }
      Timer(
          Duration(milliseconds: 2000),
              ()=> Navigator.pushNamed(context, ReserveOrderChooseScreen.id));
    }

  }

  /*static postData(String customerNumber, String message) async {
    print('Seinding message to [' +customerNumber+ '] - [' + message +' ]');

    final Uri uri = Uri.parse("https://onyxberry.com/services/wapi/Client/sendMessage/1175/5ddcb8df845546f2fc83ac8dfb40cc0fd21cb02b");
    final response = await httpClient.post(
      uri,
      body: {
        "to": customerNumber,
        "msg": message
      },
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );
    return response.body;
  }*/

  /*static String refactorNumber(String number) {
    if(number.contains('+39')){
      return number;
    }else{
      number = '+39' + number;
    }
    return number;
  }*/
}
