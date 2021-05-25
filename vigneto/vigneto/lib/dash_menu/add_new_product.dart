import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vigneto/dao/crud_model.dart';
import 'package:vigneto/models/product.dart';
import 'package:vigneto/utils/costants.dart';
import 'package:vigneto/utils/round_icon_botton.dart';
import 'package:vigneto/utils/utils.dart';

import 'admin_console_screen_menu.dart';


class AddNewProductScreen extends StatefulWidget {

  static String id = 'add_product';

  @override
  _AddNewProductScreenState createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {

  Product productBase;
  double _price;
  TextEditingController _nameController;
  TextEditingController _ingredientsController;
  TextEditingController _cantinaController;

  Category _selectedCategory;
  List<Category> _categoryPicker;
  List<DropdownMenuItem<Category>> _dropdownCategory;


  @override
  void initState() {
    super.initState();
    productBase = Product('', '', 'images/sushi/default_sushi.jpg', [""], [""], 0.0, 0, ["-"], '', 'true');
    _nameController = TextEditingController(text: productBase.name);
    _ingredientsController = TextEditingController(text: Utils.getIngredientsFromProduct(productBase));
    _cantinaController = TextEditingController(text: '');
    _price = 0.0;
    _categoryPicker = Category.getCategoryList();
    _dropdownCategory = buildDropdownSlotPickup(_categoryPicker);
    _selectedCategory = _dropdownCategory[0].value;
  }

  onChangeCategory(Category currentCategory) {
    setState(() {
      _selectedCategory = currentCategory;
    });
  }

  List<DropdownMenuItem<Category>> buildDropdownSlotPickup(List category) {
    List<DropdownMenuItem<Category>> items = [];
    for (Category category in category) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Center(child: Text(category.nameItalian, style: TextStyle(color: Colors.black, fontSize: 16.0,),)),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Aggiungi Nuovo Prodotto',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 0.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 3.0),
                          child: Center(
                            child: Card(
                              borderOnForeground: true,
                              elevation: 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: _selectedCategory,
                                      items: _dropdownCategory,
                                      onChanged: onChangeCategory,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
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
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              child: TextField(
                                controller: _ingredientsController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: _selectedCategory.menuType == VIGNETO_WINELIST ? 'Uvaggio' :'Ingredienti',
                                ),
                                maxLines: 4,
                              ),
                            ),
                          ),
                        ),
                        Text('*Ricorda di dividere la lista ingredienti con la virgola (,)', style: TextStyle(fontSize: 10),),
                        _selectedCategory.menuType == VIGNETO_WINELIST ? Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              child: TextField(
                                controller: _cantinaController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Cantina',
                                ),
                              ),
                            ),
                          ),
                        ) : SizedBox(height: 0,),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.minus,
                                    function: () {
                                      setState(() {
                                        if(_price > 5)
                                          _price = _price - 5;
                                      });
                                    },
                                  ),
                                  Text('- 5')
                                ],
                              ),
                              Column(
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.minus,
                                    function: () {
                                      setState(() {
                                        if(_price > 1)
                                          _price = _price - 0.5;
                                      });
                                    },
                                  ),
                                  Text('- 0.5')
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(_price.toString() + ' €', style: TextStyle(fontSize: 20.0,),),
                                    Text('')
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.plus,
                                    function: () {
                                      setState(() {
                                        _price = _price + 0.5;
                                      });
                                    },
                                  ),
                                  Text('+ 0.5')
                                ],
                              ),
                              Column(
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.plus,
                                    function: () {
                                      setState(() {
                                        if(_price < 1000)
                                          _price = _price + 5;
                                      });
                                    },
                                  ),
                                  Text('+ 5')
                                ],
                              ),
                            ],
                          ),
                        ),
                        _selectedCategory.menuType == VIGNETO_WINELIST ? ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                                child: Text('Rosso',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.category == 'redwine' ? Colors.red : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseCategoryWine('redwine');
                                }
                            ),
                            RaisedButton(
                                child: Text('Rosato',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.category == 'rosewine' ? Colors.pinkAccent : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseCategoryWine('rosewine');
                                }
                            ),
                            RaisedButton(
                                child: Text('Bianco',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.category == 'whitewine' ? Colors.yellow : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseCategoryWine('whitewine');
                                }
                            ),
                            RaisedButton(
                                child: Text('Bollicine',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.category == 'bollicine' ? Colors.blue : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseCategoryWine('bollicine');
                                }
                            ),
                          ],
                        ) : SizedBox(height: 0,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RaisedButton(
                                  child: Text('Disponibile',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                  color: productBase.available == 'true' ? Colors.blueAccent : Colors.grey,
                                  elevation: 5.0,
                                  onPressed: () async {
                                    updateProductBase('true');
                                  }
                              ),
                              RaisedButton(
                                  child: Text('Esaurito',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                  color: productBase.available == 'false' ? Colors.red : Colors.grey,
                                  elevation: 5.0,
                                  onPressed: () async {
                                    updateProductBase('false');
                                  }
                              ),
                              RaisedButton(
                                  child: Text('Novità',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                  color: productBase.available == 'new' ? Colors.green : Colors.grey,
                                  elevation: 5.0,
                                  onPressed: () async {
                                    updateProductBase('new');
                                  }
                              ),
                            ],
                          ),
                        ),
                        RaisedButton(
                            child: Text(_selectedCategory.menuType == VIGNETO_WINELIST ? 'Crea Vino' : 'Crea Prodotto',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                            color: Colors.teal.shade800,
                            elevation: 5.0,
                            onPressed: () async {
                              if(_selectedCategory.menuType != 'Scegli Tipo Menu'){
                                if(_price == 0.0){
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(backgroundColor: Colors.deepOrange.shade800 ,
                                      content: Text('Prezzo mancante')));
                                }else{
                                  if(_nameController.value.text == ''){
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(backgroundColor: Colors.deepOrange.shade800 ,
                                        content: Text('Nome prodotto mancante')));
                                  }else{
                                    if(_selectedCategory.menuType == VIGNETO_WINELIST && productBase.category == ''){
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(backgroundColor: Colors.deepOrange.shade800 ,
                                          content: Text('Selezionare una fra le voci rosso, bianco, rosato o bollicine')));
                                    }else{
                                      print('Creazione Prodotto');
                                      CRUDModel crudModel = CRUDModel(_selectedCategory.menuType);
                                      productBase.name = _nameController.value.text;
                                      productBase.price = _price;
                                      productBase.listIngredients = _ingredientsController.value.text.split(",");
                                      productBase.changes[0] = _cantinaController.value.text;
                                      print(productBase.toJson());
                                      await crudModel.addProduct(productBase);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(backgroundColor: Colors.green.shade500 ,
                                          content: Text('${_nameController.value.text} creato per la categoria ${_selectedCategory.nameItalian}')));
                                      Navigator.pushNamed(context, AdminConsoleMenuScreen.id);
                                    }
                                  }

                                }

                              }else{
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(backgroundColor: Colors.deepOrange.shade800 ,
                                    content: Text('Seleziona un tipo di menu')));
                              }
                            }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void updateProductBase(String state) {
    setState(() {
      productBase.available = state;
    });
  }

  void updateProductBaseCategoryWine(String categoryWine) {
    setState(() {
      productBase.category = categoryWine;
    });
  }
}

class Category {
  int id;
  String menuType;
  String nameItalian;

  Category(this.id, this.menuType, this.nameItalian);

  static List<Category> getCategoryList() {

    return <Category>[
      Category(1, 'Scegli Tipo Menu', 'Scegli Tipo Menu'),
      Category(2, VIGNETO_MENU, 'Pugliesità'),
      Category(8, VIGNETO_WINELIST, 'Vini'),

    ];
  }
}