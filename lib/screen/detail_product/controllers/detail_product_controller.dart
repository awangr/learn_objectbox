import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailProductController extends GetxController {
  final key = GlobalKey<FormState>();
  final productNameC = TextEditingController();
  final priceC = TextEditingController();
  final detailC = TextEditingController();
}
