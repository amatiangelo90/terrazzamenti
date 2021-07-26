import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vigneto/models/configuration.dart';
import 'package:vigneto/models/reservation_model.dart';
import 'package:vigneto/dao/crud_model.dart';
import 'package:vigneto/models/cart.dart';
import 'package:vigneto/models/order_store.dart';
import 'package:vigneto/models/product.dart';
import 'package:vigneto/reservation/reservation_screen_dash.dart';
import 'package:vigneto/screen/table_covers_screen.dart';
import 'package:vigneto/utils/costants.dart';
import 'package:vigneto/utils/utils.dart';

import 'add_new_product.dart';
import 'manage_menu_item_page.dart';
import 'manage_wine_item.dart';

class AdminConsoleMenuScreen extends StatefulWidget {
  static String id = 'admin_console';

  @override
  _AdminConsoleMenuScreenState createState() => _AdminConsoleMenuScreenState();
}

class _AdminConsoleMenuScreenState extends State<AdminConsoleMenuScreen> {

  List<Product> pugliesitaProductList = <Product>[];
  List<Product> wineProductList = <Product>[];
  DateTime _selectedDateTime = new DateTime.now();
  CRUDModel crudModelConf = CRUDModel(CONFIGURATION);
  double width;
  double height;

  final _datePikerController = DatePickerController();

  List<OrderStore> ordersList = <OrderStore>[];
  List<Configuration> confList = <Configuration>[];

  ScrollController scrollViewController = ScrollController();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> updateStatus() async {
    await retrieveConfiguration();
    setState((){});
  }


  @override
  void initState() {
    super.initState();
    retrieveConfiguration();
  }

  Future<void> retrieveConfiguration() async {
    confList = await crudModelConf.fetchConfiguration();
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
          title: Center(child: Text('Dashboard')),
          actions: [
            IconButton(icon: Icon(Icons.refresh ,size: 30.0, color: Colors.white,), onPressed: (){
              setState(() {});
            }
            ),

            _selectedIndex == 3 ? IconButton(
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
            ) : SizedBox(height: 0,),
          ],
        ),
        floatingActionButton: _selectedIndex < 2 ? FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNewProductScreen())
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ) : SizedBox(height: 0,),
        body: buildPage(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank),
              label: 'Pugliesità',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wine_bar),
              label: 'Vini',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online),
              label: 'Ordini',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Prenotazioni',
            ),
          ],
          currentIndex: _selectedIndex,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          selectedItemColor: VIGNETO_BROWN,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Future<List<Widget>> createList(String currentMenuType) async{

    List<Product> productList = await getCurrentProductList(currentMenuType);
    productList.forEach((element) {
      print(element.category);
    });
    List<Widget> items = <Widget>[];


    productList.forEach((product) {
      if(listTypeBeverage.contains(product.category)){
        items.add(
          InkWell(
            onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ManageMenuWinePage(product: product, menuType: currentMenuType,),),),
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: product.available == 'false' ? Colors.redAccent : Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRect(
                  child: Banner(
                    message: Utils.getNameByType(product.category),
                    color: Utils.getColorByType(product.category),
                    location: BannerLocation.topEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(
                          width: width - 200,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                product.available == 'false' ? Padding(
                                  padding: const EdgeInsets.fromLTRB(100,0,10,0),
                                  child: Text('Esaurito', style: TextStyle(fontSize: 19, color: Colors.red),),
                                ) : SizedBox(width: 0,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                                  child: Text(product.name, style: TextStyle(color: VIGNETO_BROWN, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                ),
                                Utils.getIngredientsFromProduct(product) == '' ? SizedBox(height: 0,) : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.fade , style: TextStyle(fontSize: 13.0, fontFamily: 'LoraFont'),),
                                ),
                                product.changes != null ? Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text('Cantina: ' + product.changes[0], overflow: TextOverflow.fade , style: TextStyle(fontSize: 13.0, color: Colors.black, fontFamily: 'LoraFont'),),
                                ) : SizedBox(width: 0,),

                                Text('',),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(color: VIGNETO_BROWN, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else{
        items.add(
            product.available == 'true' ? Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                child: getRowFromProduct(product, currentMenuType),
              ),
            ) : Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                child: ClipRect(
                  child: Banner(
                    message: product.available == 'new' ? 'Novità' : 'Esaurito',
                    color: product.available == 'new' ? Colors.green.shade500 : Colors.red.shade900,
                    location: BannerLocation.topEnd,
                    child: getRowFromProduct(product, currentMenuType),
                  ),
                ),
              ),
            )
        );
      }
    });
    return items;
  }

  getRowFromProduct(Product product, String currentMenuType) {
    return InkWell(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (context) => ManageMenuItemPage(product: product, menuType: currentMenuType,),
        ),
      ),
      child: ClipRect(
        child: Banner(
          color: product.available.toLowerCase() == 'true' ? Colors.green : product.available.toLowerCase() == 'new' ? Colors.yellow.shade500 : Colors.redAccent,
          message: product.available.toLowerCase() == 'true' ? 'Disponibile' : product.available.toLowerCase() == 'new' ? 'Novità' : 'Esaurito',
          location: BannerLocation.topEnd,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                child: Image.asset(product.image, width: 90.0, height: 90.0, fit: BoxFit.cover,),
              ),
              SizedBox(
                width: 250.0,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                        child: Text(product.name, style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.black, fontSize: 11.0, fontFamily: 'LoraFont'),),
                      ),
                      Text('',),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Product>> getCurrentProductList(String currentMenuType) async {

    CRUDModel crudModel = CRUDModel(currentMenuType);

    switch(currentMenuType){
      case VIGNETO_MENU:
        pugliesitaProductList = await crudModel.fetchProducts();
        return pugliesitaProductList;
        break;
      case VIGNETO_WINELIST:
        wineProductList = await crudModel.fetchProducts();
        return wineProductList;
        break;
    }
  }

  String getMenuTypeByPageNumber(int selectedIndex) {
    switch(selectedIndex){
      case 0:
        return VIGNETO_MENU;
      case 1:
        return VIGNETO_WINELIST;
    }
  }

  getWorkingWidgetByItem(int selectedIndex) {
    return SingleChildScrollView(
      controller: scrollViewController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              child: FutureBuilder(
                initialData: <Widget>[Column(
                  children: [
                    Center(child: CircularProgressIndicator()),
                    SizedBox(),
                    Center(child: Text('Caricamento menù..',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),),
                  ],
                )],
                future: createList(getMenuTypeByPageNumber(selectedIndex)),
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
  Future<List<Widget>> createOrdersListByDateTime(DateTime date, String schema) async{

    List<Widget> items = <Widget>[];
    try{
      String selectedDatePickupDelivery = Utils.getWeekDay(date.weekday) +" ${date.day} " + Utils.getMonthDay(date.month);
      CRUDModel crudModel = CRUDModel(schema);

      List<OrderStore> ordersList = await crudModel.fetchCustomersOrder();
      items.add(buildTableRecap(ordersList, selectedDatePickupDelivery));

      ordersList.forEach((orderItem) {
        orderItem.datePickupDelivery == selectedDatePickupDelivery ?
        items.add(
            ClipRRect(
              child: Banner(
                message: orderItem.confirmed == false ? 'Da Confermare' : 'Confermato',
                color: orderItem.confirmed == false ? Colors.orangeAccent : Colors.green,
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
                        onExpansionChanged: (boolV) async {
                          if(boolV){
                            if(!orderItem.confirmed){
                              orderItem.confirmed = true;
                              await crudModel.updateOrder(orderItem, orderItem.docId);
                              setState(() {});
                            }
                          }
                        },
                        borderRadius: 20,
                        title: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    orderItem.city,
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  ),
                                  Text(
                                    orderItem.hourPickupDelivery,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 10.0,),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        orderItem.name,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Tot. ' + orderItem.total + ' €',
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
                              border: TableBorder(horizontalInside: BorderSide(width: 1, color: orderItem.confirmed == false ? Colors.orangeAccent : Colors.green, style: BorderStyle.solid)),
                              children: buildListWidgetFromCart(orderItem.cartItemsList),
                            ),
                          ),
                          SizedBox(height: 30,),
                          orderItem.typeOrder == DELIVERY_TYPE ?
                          Column(
                            children: [
                              Text(orderItem.address),
                              Text(orderItem.city),
                              Text('Ora Consegna: ' + orderItem.hourPickupDelivery),
                            ],
                          ) : Text('Ora Asporto: ' + orderItem.hourPickupDelivery),
                          SizedBox(height: 30,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.check,
                                  color: orderItem.confirmed == false ? Colors.redAccent : Colors.green ,
                                ),
                                onPressed: () async {
                                  if(orderItem.confirmed){
                                    orderItem.confirmed = false;
                                    await crudModel.updateOrder(orderItem, orderItem.docId);
                                    setState(() {});
                                  }else{
                                    orderItem.confirmed = true;
                                    await crudModel.updateOrder(orderItem, orderItem.docId);
                                    setState(() {});
                                  }

                                },
                              ),
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
                            ],
                          ),

                        ]
                    ),
                  ),
                ),
              ),
            )
        ) : print('');
      });
      if(items.length == 1){
        items.add(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text("Nessun ordine per la data corrente",style: TextStyle(color: Colors.black, fontSize: 16.0,))),
              ],
            )
        );
      }
      return items;
    }catch(e){

      print(e);

    }

    return items;

  }

  Future<List<Widget>> createSettingsListItem(DateTime date) async{
    List<Widget> items = <Widget>[];
    print(date);
    if(Utils.getUnavailableData().contains(date)){
      items.add(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Text('Nessuna apertura in programma per il giorno corrente', style: TextStyle(color: Colors.black, fontSize: 13.0)),
                    SizedBox(height: 20.0,),
                  ],
                ),
              ),
            ),
            ClipRRect(
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
                      initiallyExpanded: true,
                      borderRadius: 20,
                      title: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5.0,),
                            Column(
                              children: [
                                SizedBox(height: 10,),
                              ],
                            ),
                          ],
                        ),
                      ),
                      children: [
                        SizedBox(height: 30,),
                        RaisedButton(
                            child: Text('Apri', style: TextStyle(color: Colors.white, fontSize: 20.0)),
                            color: Colors.green,
                            elevation: 5.0,
                            onPressed: (){
                            }
                        ),
                      ]
                  ),
                ),
              ),
            )
          ],
        ),
      );
      return items;

    }else{

      return items;
    }
  }

  buildListWidgetFromCart(List<Cart> cartItemsList) {
    List<TableRow> rowTable = <TableRow>[];
    rowTable.add(
      TableRow(
          children: [
            Column(children:[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Prodotto'),
              )
            ]),
            Column(children:[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Quantità'),
              )
            ]),
          ]),
    );
    cartItemsList.forEach((element) {
      rowTable.add(
        TableRow(
            children: [
              Column(children:[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(element.product.name),
                )
              ]),
              Column(children:[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(element.numberOfItem.toString()),
                )
              ]),
            ]),
      );
    });

    return rowTable;
  }

  void setSelectedDate(DateTime date) {
    setState(() {
      _selectedDateTime = date;
    });
  }
  Widget buildTableRecap(List<OrderStore> ordersList,
      String selectedDatePickupDelivery){


    double total = calculateTotal(ordersList, selectedDatePickupDelivery);
    Map mapForRecapTable = buildMapForRecapTable(ordersList, selectedDatePickupDelivery);

    return ClipRRect(
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Ultimo Aggiornamento - Ore: ' + DateTime.now().hour.toString() +':'+DateTime.now().minute.toString() +':' +DateTime.now().second.toString() ,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        'Resoconto Giornaliero',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Incasso Servizi: € ' + calculateService(ordersList, selectedDatePickupDelivery).toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ExpansionCard(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Totale ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.teal,
                        ),
                      ),
                      Text(
                        total.toString() + " €",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        border: TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.teal.shade700, style: BorderStyle.solid)),
                        children: buildTableFromMapForRecapTable(mapForRecapTable),
                      ),
                    ),
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateTotal(List<OrderStore> ordersList, String selectedDatePickupDelivery) {

    try{
      double total = 0.0;
      ordersList.forEach((order) {
        if(order.datePickupDelivery == selectedDatePickupDelivery){
          total = total + double.parse(order.total.replaceAll(" €", ""));
        }
      });

      return total;
    }catch(e){
      print('Exception : ' + e);
      return 0.0;
    }
  }

  double calculateService(List<OrderStore> ordersList, String selectedDatePickupDelivery) {

    try{
      double total = 0.0;
      ordersList.forEach((order) {
        if(order.datePickupDelivery == selectedDatePickupDelivery){
          total = total + 3;
        }
      });

      return total;
    }catch(e){
      print('Exception : ' + e);
      return 0.0;
    }
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


  buildTableFromMapForRecapTable(Map<String, int> mapForRecapTable) {
    List<TableRow> rowTable = <TableRow>[];
    rowTable.add(
      TableRow(
          children: [
            Column(children:[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Prodotto'),
              )
            ]),
            Column(children:[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Quantità'),
              )
            ]),
          ]),
    );
    mapForRecapTable.forEach((key, value) {
      print(key);
      rowTable.add(
        TableRow(
            children: [
              Column(children:[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(key),
                )
              ]),
              Column(children:[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(value.toString()),
                )
              ]),
            ]),
      );
    });


    return rowTable;
  }

  buildPage(int _selectedIndex) {
    switch(_selectedIndex){
      case 0:
        return getWorkingWidgetByItem(_selectedIndex);
      case 1:
        return getWorkingWidgetByItem(_selectedIndex);
      /*case 2:
        return buildOrdersManagerPage();*/
      case 2:
        return buildOrdersManagerPageIos();
      case 3:
        return buildReservationManagerPage();
    }
  }

  /*buildOrdersManagerPage() {
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
                dateTextStyle: TextStyle(color: Colors.green, fontSize: 16.0),
                dayTextStyle: TextStyle(color: Colors.green, fontSize: 14.0),
                monthTextStyle: TextStyle(color: Colors.green, fontSize: 12.0),
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
                future: createOrdersListByDateTime(DateTime.utc(_selectedDateTime.year ,_selectedDateTime.month, _selectedDateTime.day ,0 ,0 ,0 ,0 ,0), ORDERS_TRACKER_IOS),
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
  }*/

  buildOrdersManagerPageIos() {
    return SingleChildScrollView(
      controller: scrollViewController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DatePicker(
                DateTime.now().subtract(Duration(days: 9, hours: 0, minutes: 0, seconds: 0)),
                initialSelectedDate: DateTime.now(),
                inactiveDates: Utils.getUnavailableData(),
                dateTextStyle: TextStyle(color: Colors.green, fontSize: 16.0),
                dayTextStyle: TextStyle(color: Colors.green, fontSize: 14.0),
                monthTextStyle: TextStyle(color: Colors.green, fontSize: 12.0),
                selectionColor: VIGNETO_BROWN,
                deactivatedColor: Colors.grey,
                selectedTextColor: Colors.white,
                daysCount: 35,
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
                future: createOrdersListByDateTime(DateTime.utc(_selectedDateTime.year ,_selectedDateTime.month, _selectedDateTime.day ,0 ,0 ,0 ,0 ,0), ORDERS_TRACKER_IOS),
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

  buildReservationManagerPage() {
    return SingleChildScrollView(
      controller: scrollViewController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(

                child: Text(_isReservationBlocked(confList) ? 'Sblocca Prenotazioni' : 'Blocca Prenotazioni' ,style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                color: _isReservationBlocked(confList) ? Colors.green :  Colors.red,
                elevation: 5.0,
                onPressed: () async {
                  if(_isReservationBlocked(confList)){
                    removeConfiguration(confList);
                    updateStatus();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(backgroundColor: Colors.green ,
                        content: Text('Prenotazioni Abilitate')));
                  }else{
                    await addConfiguration();
                    updateStatus();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(backgroundColor: Colors.red.shade500 ,
                        content: Text('Prenotazioni Disabilitate')));
                  }
                },
              ),
              DatePicker(
                DateTime.now().subtract(Duration(days: 9, hours: 0, minutes: 0, seconds: 0)),
                initialSelectedDate: DateTime.now(),
                inactiveDates: Utils.getUnavailableData(),
                dateTextStyle: TextStyle(color: VIGNETO_BROWN, fontSize: 16.0),
                dayTextStyle: TextStyle(color: VIGNETO_BROWN, fontSize: 14.0),
                monthTextStyle: TextStyle(color: VIGNETO_BROWN, fontSize: 12.0),
                selectionColor: VIGNETO_BROWN,
                deactivatedColor: Colors.grey,
                selectedTextColor: Colors.white,
                daysCount: 35,
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

  Future<List<Widget>> createReservationListByDateTime(DateTime date) async{

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
                                    style: TextStyle(fontSize: 17, color: Colors.black),
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

  Future<void> addConfiguration() async {
    await crudModelConf.addConfiguration('', 'reservation-status','locked');
  }

  void removeConfiguration(List<Configuration> confList) {
    confList.forEach((configuration) async {
      if(configuration.key == 'reservation-status' && configuration.conf == 'locked'){
        await crudModelConf.removeConfiguration(configuration.id);
      }
    });
  }
}

