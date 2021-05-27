import 'package:url_launcher/url_launcher.dart' show launch;
import 'package:vigneto/dao/crud_model.dart';
import 'package:vigneto/models/cart.dart';
import 'package:vigneto/models/order_store.dart';
import 'package:vigneto/models/reservation_model.dart';
import 'package:vigneto/utils/costants.dart';

class HttpService {

  static sendDeliveryMessage(String number,
      String message,
      String name,
      String total,
      String time,
      List<Cart> cartItems,
      String uniqueId,
      String typeOrder,
      String datePickupDelivery,
      String hourPickupDelivery,
      String city,
      String address
      ) async {

    var url = 'https://api.whatsapp.com/send/?phone=$number&text=$message';
    try{

      await launch(url);
      try{

        CRUDModel crudModel = CRUDModel(ORDERS_TRACKER);

        String idToDelete = '';
        List<OrderStore> fetchCustomersList = await crudModel.fetchCustomersOrder();

        fetchCustomersList.forEach((element) {
          if(element.id == uniqueId){
            idToDelete = element.docId;
          }
        });

        if(idToDelete != ''){
          crudModel.removeProduct(idToDelete);
        }

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
            address);
      }catch(e){
        print('Exception Crud: ' + e.toString());
      }

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
      ) async {

    var url = 'https://api.whatsapp.com/send/?phone=$number&text=$message';
    try{

      await launch(url);
      try{

        CRUDModel crudModel = CRUDModel(RESERVATION_TRACKER);

        String idToDelete = '';
        List<ReservationModel> fetchReservationList = await crudModel.fetchReservation();

        fetchReservationList.forEach((element) {
          if(element.id == uniqueId){
            idToDelete = element.docId;
          }
        });

        if(idToDelete != ''){
          crudModel.removeProduct(idToDelete);
        }

        await crudModel.addReservation(
            uniqueId,
            docId,
            id,
            name,
            date,
            reservationDate,
            customerNumber,
            hour,
            covers,
            confirmed);

      }catch(e){
        print('Exception Crud: ' + e.toString());
      }

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
}
