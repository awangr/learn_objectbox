import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  final nameC = TextEditingController();
  final dateC = TextEditingController();
  final amountC = TextEditingController();
  final detailC = TextEditingController();
  final key = GlobalKey<FormState>();
}
