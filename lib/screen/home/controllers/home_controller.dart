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
  Box<Hutang> hutangs = store.box<Hutang>();
  final key = GlobalKey<FormState>();

//DELETE DATA
  Future<void> deleteProduct(Hutang hutang) async {
    Get.defaultDialog(
      title: 'Peringatan!',
      content: Text('Anda yakin mau menghapusnya?'),
      cancel: OutlinedButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            'Batal',
            style: TextStyle(color: Colors.amber),
          )),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
        onPressed: () async {
          await hutangs.remove(hutang.id);
          // fetchData(widget.user);
          Get.back();
        },
        child: Text(
          'Konfirmasi',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

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
