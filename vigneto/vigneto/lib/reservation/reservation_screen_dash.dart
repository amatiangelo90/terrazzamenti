import'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vigneto/dao/crud_model.dart';
import 'package:vigneto/screen/confirm_order_screen.dart';
import 'package:vigneto/utils/costants.dart';
import 'package:vigneto/utils/round_icon_botton.dart';
import 'package:vigneto/utils/utils.dart';

class TableReservationScreenDash extends StatefulWidget {

  static String id = 'reservation';
  final Function updateFunction;


  TableReservationScreenDash({@required this.updateFunction});

  @override
  _TableReservationScreenDashState createState() => _TableReservationScreenDashState();
}

class _TableReservationScreenDashState extends State<TableReservationScreenDash> {

  DateTime _selectedDateTime;
  final _datePikerController = DatePickerController();
  int _covers = 1;
  ScrollController scrollViewColtroller = ScrollController();

  List<TimeSlotPickup> _slotsPicker = TimeSlotPickup.getReservationSlots();
  List<DropdownMenuItem<TimeSlotPickup>> _dropdownTimeSlotPickup;
  TimeSlotPickup _selectedTimeSlotPikup;

  final _nameController = TextEditingController();
  final _customerNumber = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _customerNumber.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _dropdownTimeSlotPickup = buildDropdownSlotPickup(_slotsPicker);
    _selectedTimeSlotPikup = _dropdownTimeSlotPickup[0].value;
    super.initState();
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Aggiungi Prenotazione by Admin',style: TextStyle(fontSize: 20.0, fontFamily: 'LoraFont'),),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          controller: scrollViewColtroller,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: Center(
                  child: Card(
                    child: TextField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: Center(
                  child: Card(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _customerNumber,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Cellulare',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundIconButton(
                      icon: FontAwesomeIcons.minus,
                      function: () {
                        setState(() {
                          if(_covers > 1)
                            _covers = _covers - 1;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Coperti : ' + _covers.toString(), style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont'),),
                    ),
                    RoundIconButton(
                      icon: FontAwesomeIcons.plus,
                      function: () {
                        setState(() {
                          if(_covers < 40){
                            _covers = _covers + 1;
                          }else{
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(backgroundColor: Colors.red.shade500 ,
                                content: Text('Capienza massima raggiunta')));
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DatePicker(
                      DateTime.now(),
                      initialSelectedDate: DateTime.now(),
                      inactiveDates: Utils.getUnavailableData(),
                      dateTextStyle: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'LoraFont'),
                      dayTextStyle: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'LoraFont'),
                      monthTextStyle: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'LoraFont'),
                      selectionColor: VIGNETO_BROWN,
                      deactivatedColor: Colors.grey,
                      selectedTextColor: Colors.white,
                      daysCount: 30,
                      locale: 'it',
                      controller: _datePikerController,
                      onDateChange: (date) {
                        _setSelectedDate(date);
                      },
                    ),
                  ],
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

              RaisedButton(
                  child: Text('Aggiungi Prenotazione',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                  color: Colors.green,
                  elevation: 5.0,
                  onPressed:  () async {
                    try{
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
                      }else if(_customerNumber.value.text == ''){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                              content: Text('Inserire numero cellulare', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Indietro"),
                                ),
                              ],
                            );
                          },
                        );
                      }else if(_selectedDateTime == null){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                              content: Text('Selezionare la data per la prenotazione', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Indietro"),
                                ),
                              ],
                            );
                          },
                        );
                      } else if(_selectedTimeSlotPikup.slot == 'Seleziona Orario'){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                              content: Text('Seleziona Orario', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Indietro"),
                                ),
                              ],
                            );
                          },
                        );
                      } else if(_covers == 0){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                              content: Text('Seleziona numero coperti', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Indietro"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        CRUDModel crudModel = CRUDModel(RESERVATION_TRACKER);

                        await crudModel.addReservation(
                            '',
                            '',
                            '',
                            _nameController.value.text,
                            getCurrentDateTime(),
                            Utils.getWeekDay(_selectedDateTime.weekday) +" ${_selectedDateTime.day} " + Utils.getMonthDay(_selectedDateTime.month),
                            _customerNumber.value.text,
                            _selectedTimeSlotPikup.slot,
                            _covers.toString(),
                            false);
                        Navigator.of(context).pop(false);
                        this.widget.updateFunction();
                      }
                    }catch(e){
                      CRUDModel crudModel = CRUDModel('errors-report');
                      await crudModel.addException(
                          'Error report',
                          e.toString(),
                          DateTime.now().toString());
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }


  String buildMessageReservation(
      String name,
      String date,
      String slot,
      DateTime selectedDateTime,
      String coperti) {


    String message =
        "RICHIESTA PRENOTAZIONE%0a" +
            "%0aTerrazzamenti Valle D\'Itria%0a"+
            "%0aNome: $name%0a" +
            "%0aIndirizzo: Viale Stazione 12" +
            "%0aCittà: Locorotondo(BR) (72014)" +
            "%0a" +
            "%0aData Prenotazione: " + Utils.getWeekDay(selectedDateTime.weekday) +" ${selectedDateTime.day} " + Utils.getMonthDay(selectedDateTime.month) +

            "%0aOre: $slot " +
            "%0aCoperti : $coperti";

    message = message.replaceAll('&', '%26');
    return message;

  }


  String getCurrentDateTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat.yMd().add_jm();
    return formatter.format(now);
  }

  _setSelectedDate(DateTime date) {
    setState(() {
      _selectedDateTime = date;
    });
  }
}

