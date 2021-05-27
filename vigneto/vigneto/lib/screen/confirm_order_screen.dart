import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigneto/models/cart.dart';
import 'package:vigneto/screen/services/http_service.dart';
import 'package:vigneto/utils/costants.dart';
import 'package:vigneto/utils/utils.dart';


class ConfirmScreen extends StatefulWidget {

  final List<Cart> cartItems;
  final double total;
  final String uniqueId;
  final String tableNumber;
  final String covers;

  ConfirmScreen({@required this.cartItems, this.total, this.uniqueId, this.tableNumber, this.covers});

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {

  List<TimeSlotPickup> _slotsPicker = TimeSlotPickup.getPickupSlots();

  List<DropdownMenuItem<TimeSlotPickup>> _dropdownTimeSlotPickup;

  TimeSlotPickup _selectedTimeSlotPikup;

  List<PaymentPreference> _paymentType = PaymentPreference
      .getPreferredPayment();

  List<DropdownMenuItem<PaymentPreference>> _dropdownPayments;

  PaymentPreference _selectedPaymentPreference;


  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _dropdownTimeSlotPickup = buildDropdownSlotPickup(_slotsPicker);
    _selectedTimeSlotPikup = _dropdownTimeSlotPickup[0].value;

    _dropdownPayments = buildDropdownPaymentType(_paymentType);
    _selectedPaymentPreference = _dropdownPayments[0].value;

    super.initState();
  }

  List<DropdownMenuItem<PaymentPreference>> buildDropdownPaymentType(
      List paymentType) {
    List<DropdownMenuItem<PaymentPreference>> items = [];
    for (PaymentPreference payType in paymentType) {
      items.add(
        DropdownMenuItem(
          value: payType,
          child: Center(child: Text(payType.type, style: TextStyle(
              color: Colors.white, fontSize: 16.0, fontFamily: 'LoraFont'),)),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<TimeSlotPickup>> buildDropdownSlotPickup(List slots) {
    List<DropdownMenuItem<TimeSlotPickup>> items = [];
    for (TimeSlotPickup slotItem in slots) {
      items.add(
        DropdownMenuItem(
          value: slotItem,
          child: Center(child: Text(slotItem.slot, style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'LoraFont'),)),
        ),
      );
    }
    return items;
  }

  onChangeDropTimeSlotPickup(TimeSlotPickup currentPickupSlot) {
    setState(() {
      _selectedTimeSlotPikup = currentPickupSlot;
    });
  }


  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text('Conferma ordine', style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont')),
        ),
        body: ListView(
          children: [

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: screenHeight - 50,
                width: screenWidth - 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Image.asset('images/terrazzament.png',
                          fit: BoxFit.contain,
                        ),
                        Card(
                          color: Colors.black,
                          elevation: 0.0,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Totale € ' + this.widget.total.toString() , style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont'),),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Tavolo: ' + this.widget.tableNumber, style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont')),

                              Text('Coperti: ' + this.widget.covers, style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont')),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              color: Colors.black,
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                controller: _nameController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white, width: 0.0),
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white,
                                  labelText: 'Nome',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 3.0),
                          child: Center(
                            child: Card(
                              color: Colors.black,
                              borderOnForeground: true,
                              elevation: 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: DropdownButton(
                                      dropdownColor: VIGNETO_BROWN,
                                      isExpanded: true,
                                      value: _selectedTimeSlotPikup,
                                      items: _dropdownTimeSlotPickup,
                                      onChanged: onChangeDropTimeSlotPickup,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              color: Colors.black,
                              borderOnForeground: true,
                              elevation: 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: DropdownButton(
                                      dropdownColor: VIGNETO_BROWN,
                                      isExpanded: true,
                                      value: _selectedPaymentPreference,
                                      items: _dropdownPayments,
                                      onChanged: onChangePaymentSelected,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Image.asset('images/whatappicon.png'),
                            iconSize: 90.0, onPressed: (){
                          if(_nameController.value.text == ''){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  content: Text('Inserire il nome', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("Indietro"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if(_selectedTimeSlotPikup.slot == 'Seleziona Orario Consegna'){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  content: Text('Seleziona Orario Consegna', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("Indietro"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if(_selectedPaymentPreference.type == 'Selezione Preferenza Pagamento'){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  content: Text('Selezione Preferenza Pagamento', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("Indietro"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else{
                            HttpService.sendDeliveryMessage(numberTerrazzamenti,
                                buildMessageFromCartPickUp(
                                    this.widget.cartItems,
                                    _nameController.value.text,
                                    this.widget.total.toString(),
                                    getCurrentDateTime(),
                                    _selectedTimeSlotPikup.slot,
                                    this.widget.tableNumber,
                                    this.widget.covers,
                                    _selectedPaymentPreference.type
                                ),
                                _nameController.value.text,
                                this.widget.total.toString(),
                                getCurrentDateTime(),
                                this.widget.cartItems,
                                this.widget.uniqueId,
                                'Delivery',
                                Utils.getWeekDay(DateTime.now().weekday) +" ${DateTime.now().day} " + Utils.getMonthDay(DateTime.now().month),
                                _selectedTimeSlotPikup.slot,
                                EMPTY_STRING,
                                EMPTY_STRING);
                          }
                        }
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String buildMessageFromCartPickUp(
      List<Cart> cartItems,
      String name,
      String total,
      String date,
      String slot,
      String tableNumber,
      String covers,
      String paymentPreference) {

    String itemList = '';

    cartItems.forEach((element) {
      itemList = itemList + "%0a" + element.numberOfItem.toString() + " x " + element.product.name;
      if(element.changes.length != 0){
        itemList = itemList + "%0a  " + element.changes.toString();
      }
    });

    String message;

    message =
        "%0a Terrazzamenti Valle D'Itria%0a"+
            "%0a Tavolo: $tableNumber%0a"+
            " Coperti: $covers%0a%0a"+
            "%0a Nome: $name" +
            "%0a Data Ordine: " + Utils.getWeekDay(DateTime.now().weekday) +" ${DateTime.now().day} " + Utils.getMonthDay(DateTime.now().month) +
            "%0a Ore Consegna: $slot " +
            "%0a%0a-------------------------------------------------%0a"
                "%0aOrdine"
                "%0a"
            + itemList + "%0a"
            + "%0a--------------------------------------------------"
            + "%0a%0a Preferenza Pagamento: " + paymentPreference
            + "%0a%0a Totale: " + total + " € "
            + "%0a%0a (Costo servizio 3 € incluso nel totale)";

    message = message.replaceAll('&', '%26');
    return message;

  }


  String getCurrentDateTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat.yMd().add_jm();
    return formatter.format(now);
  }

  onChangePaymentSelected(PaymentPreference currentPaymentPreferred) {
    setState(() {
      _selectedPaymentPreference = currentPaymentPreferred;
    });
  }
}

class TimeSlotPickup {
  int id;
  String slot;

  TimeSlotPickup(this.id, this.slot);

  static List<TimeSlotPickup> getPickupSlots() {

    DateTime currentDatePlus10Min = DateTime.now().add(Duration(minutes: 10));

    String firstSlot;
    String secondSlot;

    if(currentDatePlus10Min.hour < 17){
      firstSlot = '17:15';
      secondSlot = '17:30';
    }else{
      if(currentDatePlus10Min.minute >= 0 && currentDatePlus10Min.minute < 15){
        firstSlot = currentDatePlus10Min.hour.toString() + ':15';
        secondSlot = currentDatePlus10Min.hour.toString() + ':30';
      }else if(currentDatePlus10Min.minute >= 15 && currentDatePlus10Min.minute < 30){
        firstSlot = currentDatePlus10Min.hour.toString() + ':30';
        secondSlot = currentDatePlus10Min.hour.toString() + ':45';
      }else if(currentDatePlus10Min.minute >= 30 && currentDatePlus10Min.minute < 45){
        firstSlot = currentDatePlus10Min.hour.toString() + ':45';
        secondSlot = (currentDatePlus10Min.hour + 1).toString() + ':00';
      }else if(currentDatePlus10Min.minute >= 45 && currentDatePlus10Min.minute <= 59){
        firstSlot = (currentDatePlus10Min.hour + 1).toString() + ':00';
        secondSlot = (currentDatePlus10Min.hour + 1).toString() + ':15';
      }
    }

    return <TimeSlotPickup>[
      TimeSlotPickup(1, 'Seleziona Orario Consegna'),
      TimeSlotPickup(2, firstSlot),
      TimeSlotPickup(3, secondSlot),
    ];
  }

  static List<TimeSlotPickup> getReservationSlots() {
    return <TimeSlotPickup>[
      TimeSlotPickup(1, 'Seleziona Orario'),
      TimeSlotPickup(2, '17:00'),
      TimeSlotPickup(3, '17:30'),
      TimeSlotPickup(4, '18:00'),
      TimeSlotPickup(5, '18:30'),
      TimeSlotPickup(6, '19:00'),
      TimeSlotPickup(7, '19:30'),
      TimeSlotPickup(8, '20:00'),
      TimeSlotPickup(9, '20:30'),
      TimeSlotPickup(10, '21:00'),
      TimeSlotPickup(11, '21:30'),
      TimeSlotPickup(12, '22:00'),
    ];
  }
}

class PaymentPreference {
  int id;
  String type;

  PaymentPreference(this.id, this.type);

  static List<PaymentPreference> getPreferredPayment() {
    return <PaymentPreference>[
      PaymentPreference(1, 'Selezione Preferenza Pagamento'),
      PaymentPreference(1, 'Cash'),
      PaymentPreference(2, 'Carta di Credito/Debito'),
    ];
  }
}

