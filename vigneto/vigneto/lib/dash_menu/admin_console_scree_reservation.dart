import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vigneto/models/reservation_model.dart';
import 'package:vigneto/dao/crud_model.dart';
import 'package:vigneto/models/order_store.dart';
import 'package:vigneto/models/product.dart';
import 'package:vigneto/reservation/reservation_screen_dash.dart';
import 'package:vigneto/screen/table_covers_screen.dart';
import 'package:vigneto/utils/costants.dart';
import 'package:vigneto/utils/utils.dart';


class AdminConsoleReservationScreen extends StatefulWidget {
  static String id = 'admin_reservation';

  @override
  _AdminConsoleReservationScreenState createState() => _AdminConsoleReservationScreenState();
}

class _AdminConsoleReservationScreenState extends State<AdminConsoleReservationScreen> {

  List<Product> pugliesitaProductList = <Product>[];
  List<Product> wineProductList = <Product>[];
  DateTime _selectedDateTime = new DateTime.now();

  double width;
  double height;

  final _datePikerController = DatePickerController();

  List<OrderStore> ordersList = <OrderStore>[];

  ScrollController scrollViewController = ScrollController();

  void updateStatus(){
    setState((){});
  }
  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, TableCoversScreen.id),
          ),
          backgroundColor: VIGNETO_BROWN,
          title: Center(child: Text('Reservation Screen')),
          actions: [
            IconButton(icon: Icon(Icons.refresh ,size: 30.0, color: Colors.white,), onPressed: (){
              setState(() {});
            }
            ),

            IconButton(
                icon: Icon(Icons.add_circle ,size: 30.0, color: Colors.white,),
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TableReservationScreenDash(
                      updateFunction: updateStatus,
                    ),
                    ),
                  );
                  setState(() {});
                }
            ),
          ],
        ),
        body: buildReservationManagerPage(),
      ),
    );
  }


  void setSelectedDate(DateTime date) {
    setState(() {
      _selectedDateTime = date;
    });
  }



  Map buildMapForRecapTable(List<OrderStore> ordersList, String selectedDatePickupDelivery) {


    Map<String, int> recapMap = {};

    ordersList.forEach((order) {
      if(order.datePickupDelivery == selectedDatePickupDelivery){
        order.cartItemsList.forEach((cartElement) {
          print(cartElement.product.name + ' - n° ' + cartElement.numberOfItem.toString());
          if(recapMap.containsKey(cartElement.product.name)){
            recapMap.update(cartElement.product.name, (value) => value + cartElement.numberOfItem);
          }else{
            recapMap[cartElement.product.name] = cartElement.numberOfItem;
          }
        });
      }
    });
    return recapMap;
  }

  Map buildMapForRecapTableReservation(List<ReservationModel> reservationList, String selectedDatePickupDelivery) {


    Map<String, int> recapMap = {};

    reservationList.forEach((reservation) {
      if(reservation.date == selectedDatePickupDelivery){

      }
    });
    return recapMap;
  }

  buildReservationManagerPage() {
    return SingleChildScrollView(
      controller: scrollViewController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DatePicker(
                DateTime.now().subtract(Duration(days: 3, hours: 0, minutes: 0, seconds: 0)),
                initialSelectedDate: DateTime.now(),
                inactiveDates: Utils.getUnavailableData(),
                dateTextStyle: TextStyle(color: VIGNETO_BROWN, fontSize: 16.0),
                dayTextStyle: TextStyle(color: VIGNETO_BROWN, fontSize: 14.0),
                monthTextStyle: TextStyle(color: VIGNETO_BROWN, fontSize: 12.0),
                selectionColor: VIGNETO_BROWN,
                deactivatedColor: Colors.grey,
                selectedTextColor: Colors.white,
                daysCount: 30,
                locale: 'it',
                controller: _datePikerController,
                onDateChange: (date) {
                  setSelectedDate(date);
                },
              ),
            ],
          ),
          Container(
              child: FutureBuilder(
                initialData: <Widget>[Column(
                  children: [
                    Center(child: CircularProgressIndicator()),
                    SizedBox(),
                    Center(child: Text('Caricamento ordini..',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),),
                  ],
                )],
                future: createReservationListByDateTime(DateTime.utc(_selectedDateTime.year ,_selectedDateTime.month, _selectedDateTime.day ,0 ,0 ,0 ,0 ,0)),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        children: snapshot.data,
                      ),
                    );
                  }else{
                    return CircularProgressIndicator();
                  }
                },
              )
          ),
        ],
      ),
    );
  }

  Future<List<Widget>> createReservationListByDateTime(DateTime date) async {

    List<Widget> items = <Widget>[];
    print(date);

    String selectedReservationDate = Utils.getWeekDay(date.weekday) +" ${date.day} " + Utils.getMonthDay(date.month);
    CRUDModel crudModel = CRUDModel(RESERVATION_TRACKER);

    List<ReservationModel> reservationList = await crudModel.fetchReservation();
    reservationList.forEach((orderItem) {
      orderItem.date == selectedReservationDate ?
      items.add(
        ClipRRect(
          child: Banner(
            message: orderItem.confirmed ? 'Confermato' : 'Non Confermato',
            color: orderItem.confirmed ? Colors.greenAccent : Colors.red,
            location: BannerLocation.topEnd,
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2.0,
                        blurRadius: 5.0,
                      ),
                    ]
                ),
                child: ExpansionCard(
                    borderRadius: 20,
                    title: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    orderItem.name,
                                    style: TextStyle(fontSize: 20, color: Colors.black),
                                  ),
                                  Text(
                                    orderItem.hour,
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                          SizedBox(height: 5.0,),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'cell. ' + orderItem.customerNumber,
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  ),
                                  Text(
                                    'Coperti : ' + orderItem.covers,
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ],
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          border: TableBorder(
                              horizontalInside: BorderSide(
                                  width: 1,
                                  color: orderItem.confirmed ? Colors.orangeAccent : Colors.blue.shade800, style: BorderStyle.solid)),
                          children: <TableRow>[],
                        ),
                      ),
                      SizedBox(height: 30,),

                      Column(
                        children: [
                          Text(orderItem.id),
                        ],
                      ),
                      SizedBox(height: 30,),

                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.trash,
                          color: Colors.redAccent,
                        ),
                        onPressed: () async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Conferma"),
                                content: Text("Eliminare l'ordine di " + orderItem.name +"?"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () async {
                                        await crudModel.removeProduct(orderItem.docId);
                                        setState(() {});
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text("Cancella")
                                  ),
                                  FlatButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("Indietro"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ]
                ),
              ),
            ),
          ),
        ),
      ) : SizedBox(height: 0,);
    });

    if(items.length == 0){
      items.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text("Nessuna prenotazione per la data corrente",style: TextStyle(color: Colors.black, fontSize: 16.0,))),
            ],
          )
      );
    }
    return items;
  }
}