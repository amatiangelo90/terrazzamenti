import 'package:flutter/material.dart';
import 'package:vigneto/models/product.dart';

class Cart{

  Product product;
  int numberOfItem;
  List<String> changes;

  Cart({@required this.product,
    @required this.numberOfItem,
    this.changes});

  @override
  String toString() {
    return 'Cart : ' + this.product.toString() + ' x ' + this.numberOfItem.toString() + ' - Changes: ' + this.changes.toString();
  }

  Map<String, dynamic> toJson() => {
    'product': product,
    'numberOfItem': numberOfItem,
    'changes': changes
  };
}