import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:object_box/entitas/hutang.dart';
import 'package:object_box/repository/user_repository.dart';
import 'package:object_box/screen/detail/controllers/detail_controller.dart';
import 'package:object_box/utils/constans/app_style.dart';
import 'package:object_box/widget/custom_elevated.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Hutang hutang = Get.arguments;
  final controller = DetailController();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Box<Hutang> hutangs = store.box<Hutang>();
    controller.nameC.text = hutang.name;
    controller.amountC.text = hutang.amount;
    controller.detailC.text = hutang.detail;
    editData() {
      UserRepository.editHutang(
          id: hutang.id,
          name: controller.nameC.text,
          detail: controller.detailC.text,
          date: hutang.date,
          amount: controller.amountC.text,
          user: hutang.user.target!,
          hutangBox: hutangs);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Detail'),
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          children: [
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'nama tidak boleh kosong';
                } else {
                  return null;
                }
              },
              controller: controller.nameC,
              decoration: InputDecoration(
                  hintText: 'Nama',
                  labelText: 'Nama',
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'total tidak boleh kosong';
                } else {
                  return null;
                }
              },
              controller: controller.amountC,
              decoration: InputDecoration(
                  hintText: 'Total',
                  labelText: 'Total',
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'deskripsi tidak boleh kosong';
                } else {
                  return null;
                }
              },
              controller: controller.detailC,
              maxLines: 4,
              decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Deskripsi',
                  focusedBorder: OutlineInputBorder(),
                  border: OutlineInputBorder()),
            ),
            Text(hutang.belumLunas == true ? 'Belum Lunas' : 'Lunas'),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Tanggal  Jam',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                    '${hutang.date!.day}/${hutang.date!.month}/${hutang.date!.year}  ${hutang.date!.hour}:${hutang.date!.minute}'),
              ],
            ),
            SizedBox(height: 10),
            CustomElevated(
              text: Text(
                'Edit Data',
                style: TextStyle(color: white),
              ),
              onPress: () {
                if (key.currentState!.validate()) {
                  if (hutang.id > 0) {
                    setState(() {
                      Get.back(result: editData());
                    });
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
