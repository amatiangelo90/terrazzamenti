import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vigneto/models/cart.dart';
import 'package:vigneto/utils/costants.dart';

import 'confirm_order_screen.dart';


class CartScreen extends StatefulWidget {

  final List<Cart> cartItems;
  final Function function;
  final String uniqueId;
  final String covers;
  final String tableNumber;

  CartScreen({@required this.cartItems,
    @required this.function,@required this.uniqueId,@required this.covers,@required this.tableNumber});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  final _discountController = TextEditingController();
  final double _deliveryFeed = 3.0;
  double _total;
  double _totalWithoutDiscount;
  bool _discountApplied = false;
  List<Widget> currentListItems = <Widget>[];

  @override
  void initState() {
    super.initState();
    _getTotal();
  }

  _getTotal() {
    _total = 0.0;
    this.widget.cartItems.forEach((cartItem){
      setState(() {
        _total = _total + (cartItem.product.price * cartItem.numberOfItem);
      });
    });
  }

  _removeItemFromCartList(Cart cartItem){
    setState(() {
      this.widget.cartItems.remove(cartItem);
      _getTotal();
      this.widget.function(cartItem.numberOfItem);
    });
  }

  _emptyCart(List<Cart> cartItems){
    setState(() {
      this.widget.cartItems.clear();
      _getTotal();
      this.widget.function(null);
    });
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Center(child: Column(
          children: [
            Text("Carrello", style: TextStyle(color: Colors.white, fontSize: 19.0, fontFamily: 'LoraFont'),),
            Text('Sessione ' +this.widget.uniqueId , style: TextStyle(color: Colors.white, fontSize: 7.0, fontFamily: 'LoraFont'),),

          ],
        )),
        elevation: 0.0,
        actions: [
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
                    title: const Text("Conferma", style: TextStyle(color: Colors.white, fontSize: 19.0, fontFamily: 'LoraFont'),),
                    content: Text("Svuotare il carrello?", style: TextStyle(color: VIGNETO_BROWN, fontSize: 16.0, fontFamily: 'LoraFont'),),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: (){
                            _emptyCart(this.widget.cartItems);
                            Navigator.of(context).pop(true);
                          },
                          child: const Text("Svuota")
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: this.widget.cartItems.isEmpty ?
          Container(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text("Il Carrello è vuoto",style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'LoraFont'))),
            ],
          ))
              : Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Flexible(
                    flex: 5,
                    child: ListView.builder(
                      itemCount: this.widget.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = this.widget.cartItems[index].product.name;
                        return Dismissible(
                          key: Key(item),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (DismissDirection direction) async {
                            if(direction == DismissDirection.endToStart){
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Conferma"),
                                    content: Text("Eliminare  "+this.widget.cartItems[index].numberOfItem.toString() +
                                        " x " + this.widget.cartItems[index].product.name.toString() + " ?"),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () => Navigator.of(context).pop(true),
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
                            }else{
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Aggiunto"),
                                    content: Text("1 x " + this.widget.cartItems[index].product.name.toString()),
                                  );
                                },
                              );
                            }
                          },

                          onDismissed: (direction) {
                            _removeItemFromCartList(this.widget.cartItems[index]);
                          },

                          background: Container(
                              color: Colors.redAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Center(child: Icon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.black,
                                    ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          child: buildListFromCart(this.widget.cartItems[index]),
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 2.0,
                              blurRadius: 10.0,
                            ),
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                  child: Text('Conferma',style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                                  color: this.widget.cartItems.isNotEmpty ? VIGNETO_BROWN : Colors.grey,
                                  elevation: 5.0,
                                  onPressed: (){

                                    this.widget.cartItems.isNotEmpty ?
                                    isCartProductContainsWine(this.widget.cartItems) ? showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ConfirmScreen(
                                            cartItems: this.widget.cartItems,
                                            total: _total + _deliveryFeed,
                                            uniqueId: this.widget.uniqueId,
                                            covers: this.widget.covers,
                                            tableNumber: this.widget.tableNumber,
                                          );
                                        }
                                    ) : showDialog(
                                        context: context,
                                        builder: (context){
                                          return AlertDialog(
                                            title: Center(child: Text("Inserire almeno una bottiglia di vino nell\'ordine per procedere", style: TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'LoraFont'))),
                                            content: Text(''),
                                          );
                                        }
                                    ) : showDialog(
                                        context: context,
                                        builder: (context){
                                          return AlertDialog(
                                            title: Center(child: Text("Carrello Vuoto", style: TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'LoraFont'))),
                                            content: Text(''),
                                          );
                                        }
                                    );
                                  },
                                ),
                              ],
                            ),
                            _discountApplied ? Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Totale € " , style: TextStyle(color: Colors.teal.shade800, fontSize: 20.0, fontFamily: 'LoraFont')),
                                  Text(_totalWithoutDiscount.toString(), style: TextStyle(decoration: TextDecoration.lineThrough ,color: Colors.deepOrangeAccent, fontSize: 20.0, fontFamily: 'LoraFont')),
                                  Text(" " + _total.toString(), style: TextStyle(color: Colors.teal.shade800, fontSize: 20.0, fontFamily: 'LoraFont')),

                                ],
                              ),
                            ) :Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                children: [
                                  Text("Totale Carrello € " +  _total.toString() ,style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'LoraFont')),
                                  Text("(Costo Servizio € 3)" ,style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'LoraFont')),
                                  Text("Totale € " +  (_total + _deliveryFeed).toString() ,style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'LoraFont')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildListFromCart(cartItem) {
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: VIGNETO_BROWN,
                spreadRadius: 1.0,
                blurRadius: 1.0,
              ),
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                SizedBox(
                  width: 210.0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                          child: Text(cartItem.product.name, overflow: TextOverflow.ellipsis ,style: TextStyle(fontSize: 16.0, color: Colors.white, fontFamily: 'LoraFont'),),
                        ),
                        cartItem.changes.length == 0 ? SizedBox(height: 0.0,) : Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(cartItem.changes.toString(), overflow: TextOverflow.visible , style: TextStyle(fontSize: 11.0, color: Colors.white, fontFamily: 'LoraFont'),),
                        ),
                        Text('',),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0,),
                          child: Text(cartItem.numberOfItem.toString() + ' x ' + cartItem.product.price.toString() + ' €', overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'LoraFont'),),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                      content: Text("Eliminare  " + cartItem.numberOfItem.toString() +
                          " x " + cartItem.product.name.toString() + " ?"),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: (){
                              _removeItemFromCartList(cartItem);
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
      ),
    );
  }




  bool isCartProductContainsWine(List<Cart> cartProductList) {

    bool contains = false;

    cartProductList.forEach((cart) {
      print('cart.product.category : ' + cart.product.category);
      if(listTypeWine.contains(cart.product.category)){
        print('true');
        contains = true;
      }
    });
    return contains;
  }


}
