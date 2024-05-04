import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:object_box/entitas/hutang.dart';
import 'package:object_box/objectbox.g.dart';
import '../../../main.dart';

class HomeController extends GetxController {
  final nameC = TextEditingController();
  final amountC = TextEditingController();
  final detailC = TextEditingController();
  final dateC = TextEditingController();
  Box<Hutang> productss = store.box<Hutang>();

  @override
  void dispose() {
    nameC.dispose();
    amountC.dispose();
    detailC.dispose();
    dateC.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
  }
}
