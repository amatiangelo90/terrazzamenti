import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:url_launcher/url_launcher.dart' show canLaunch, launch;
import 'package:vigneto/dao/crud_model.dart';
import 'package:vigneto/models/cart.dart';
import 'package:vigneto/utils/costants.dart';
import '../reserve_order_screen.dart';
import 'package:http/http.dart' as httpClient;

class HttpService {

  static sendDeliveryMessage(
      String number,
      String message,
      String name,
      String total,
      String time,
      List<Cart> cartItems,
      String uniqueId,
      String typeOrder,
      String datePickupDelivery,
      String hourPickupDelivery,
      String phoneNumber,
      String address) async {

    var url = 'https://api.whatsapp.com/send/?phone=$number&text=$message';
    try{

      await launch(url);

      CRUDModel crudModel = CRUDModel(ORDERS_TRACKER_IOS);

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
          phoneNumber,
          address);
    }catch(e){
      print('Exception' + e.toString());
      try{
        CRUDModel crudModel = CRUDModel(ERRORS_REPORT);

        await crudModel.addException(
            name,
            e.toString(),
            time);

      }catch(e){
        print('Exception Crud' + e.toString());
      }
    }

  }

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

    /* var url = 'https://api.callmebot.com/whatsapp.php?phone=+393450330750&text=$message&apikey=530988';
    await launch(url);*/

    try {

      MySqlConnection conn = await MySqlConnection.connect(ConnectionSettings(
          host: '51.77.174.68',
          port: 3306,
          user: 'ventimq_user1',
          db: 'ventimq_newfood',
          password: 'TycAsnOeL'));

      Results result = await conn.query(
          'INSERT INTO ce_testa (TAVOLO, COP, DATA, FATTO) VALUES (?,?,?,?)',
          [address, int.parse(calici), Timestamp.now().toString(), 99]);

      int _currentId = result.insertId;
      print('Result from query (row id inserted): ' + _currentId.toString());


      cartItems.forEach((cartItem) async {

        Results result = await conn.query(
            'INSERT INTO ce_coda (LINK, CODICE, DESCR, QT, PREZZOU, ID_MENU) VALUES (?,?,?,?,?,?)',
            [_currentId, cartItem.product.discountApplied, cartItem.product.name, cartItem.numberOfItem, cartItem.product.price, 0]);
        print('Inserted record into CE_CODA. Record id : ${result.insertId}' );
      });


      Results resultUpdateQuery = await conn.query(
          'UPDATE ce_testa SET FATTO = 0 WHERE ID = ? AND FATTO = 99',
          [_currentId]);

      print('Result from update query : ${resultUpdateQuery.insertId}');
      CRUDModel crudModel = CRUDModel(ORDERS_TRACKER_IOS);
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
          address + ' - Calici: ' + calici);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(backgroundColor: Colors.green ,
          content: Text('Ordine Inviato')));


      print('Connect to the db..');
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(backgroundColor: Colors.orangeAccent ,
            content: Text('Attenzione! Impossibile inviare l\'ordine. Errore: ${error}')));
      }catch (e){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(backgroundColor: Colors.red ,
            content: Text('Error - $e')));
      }
      Timer(
          Duration(milliseconds: 2000),
              ()=> Navigator.pushNamed(context, ReserveOrderChooseScreen.id));
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

  static postData(String customerNumber, String message) async {
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
  }

  static String refactorNumber(String number) {
    if(number.contains('+39')){
      return number;
    }else{
      number = '+39' + number;
    }
    return number;
  }
}
