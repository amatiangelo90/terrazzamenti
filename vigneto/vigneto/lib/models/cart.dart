import 'package:flutter/material.dart';
import 'package:vigneto/models/product.dart';

class Cart{

  Product product;
  int numberOfItem;
  List<String> changes;

  Cart({@required this.product,
    @required this.numberOfItem,
    this.changes});

  Map<String, dynamic> toJson() => {
    'product': product,
    'numberOfItem': numberOfItem,
    'changes': changes
  };
}