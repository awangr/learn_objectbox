import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:object_box/entitas/user.dart';
import 'package:object_box/screen/home/views/home_screen.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:object_box/screen/main/controllers/main_controller.dart';

import '../../../entitas/hutang.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';
import '../../../repository/user_repository.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User user = Get.arguments;
  Box<Hutang> hutangBox = store.box<Hutang>();
  final controller = MainController();
  final now = DateTime.now();
  Future<void> addProduct() async {
    UserRepository.addHutang(
        name: controller.nameC.text,
        detail: controller.detailC.text,
        amount: controller.amountC.text,
        user: user,
        date: now,
        hutangBox: hutangBox);
    controller.nameC.text = '';
    controller.detailC.text = '';
    controller.amountC.text = '';
    controller.dateC.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarAppBar(
          locale: 'id',
          backButton: false,
          firstDate: DateTime.now().subtract(Duration(days: 140)),
          lastDate: now,
          onDateChanged: () {}),
      body: HomeScreen(
        user: User(username: user.username, password: user.password),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   shape: CircleBorder(),
      //   backgroundColor: Colors.blue,
      //   onPressed: () {
      //     Get.defaultDialog(
      //         confirm: ElevatedButton(
      //             onPressed: () {
      //               if (controller.key.currentState!.validate()) {
      //                 addProduct();
      //                 Get.back();
      //               }
      //             },
      //             child: Text('ADD')),
      //         cancel: OutlinedButton(
      //             onPressed: () {
      //               Get.back();
      //               controller.amountC.clear();
      //               controller.nameC.clear();
      //               controller.dateC.clear();
      //               controller.detailC.clear();
      //             },
      //             child: Text('Back')),
      //         title: 'Data Hutang',
      //         content: Form(
      //           key: controller.key,
      //           child: Column(
      //             children: [
      //               TextFormField(
      //                 validator: (value) {
      //                   if (value!.isEmpty) {
      //                     return 'Name is required';
      //                   }
      //                   return null;
      //                 },
      //                 controller: controller.nameC,
      //                 decoration: InputDecoration(
      //                     labelText: 'Nama', border: OutlineInputBorder()),
      //               ),
      //               SizedBox(height: 10),
      //               TextFormField(
      //                 readOnly: true,
      //                 validator: (value) {
      //                   if (value!.isEmpty) {
      //                     return 'Date is required';
      //                   }
      //                   return null;
      //                 },
      //                 onTap: () async {
      //                   DateTime? pickedData = await showDatePicker(
      //                       context: context,
      //                       initialDate: DateTime.now(),
      //                       firstDate: now,
      //                       lastDate: now);
      //                   if (pickedData != null) {
      //                     String formattedDate =
      //                         DateFormat('dd/MMM/yyyy').format(pickedData);
      //                     print(formattedDate);
      //                     setState(() {
      //                       controller.dateC.text = formattedDate;
      //                     });
      //                   } else {
      //                     print("Date is not selected");
      //                   }
      //                 },
      //                 controller: controller.dateC,
      //                 decoration: InputDecoration(
      //                     labelText: 'Tanggal',
      //                     border: OutlineInputBorder(),
      //                     suffixIcon: Icon(Icons.calendar_month)),
      //               ),
      //               SizedBox(height: 10),
      //               TextFormField(
      //                 maxLines: 4,
      //                 validator: (value) {
      //                   if (value!.isEmpty) {
      //                     return 'detail is required';
      //                   }
      //                   return null;
      //                 },
      //                 controller: controller.detailC,
      //                 decoration: InputDecoration(
      //                     labelText: 'Detail', border: OutlineInputBorder()),
      //               ),
      //               SizedBox(height: 10),
      //               TextFormField(
      //                 validator: (value) {
      //                   if (value!.isEmpty) {
      //                     return 'total is required';
      //                   }
      //                   return null;
      //                 },
      //                 controller: controller.amountC,
      //                 decoration: InputDecoration(
      //                     labelText: 'Total', border: OutlineInputBorder()),
      //               ),
      //             ],
      //           ),
      //         ));
      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // )
    );
  }
}
