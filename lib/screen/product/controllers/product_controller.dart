import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../entitas/product.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';

class ProductController extends GetxController {
  Box<Product> productBox = store.box<Product>();
  final key = GlobalKey<FormState>();
  final productNameC = TextEditingController();
  final priceC = TextEditingController();
  final imageC = TextEditingController();
  final nameSearch = TextEditingController();

  String? photoString;
  Future<List<Product>> getProducts() async {
    return productBox.getAll();
  }
}
