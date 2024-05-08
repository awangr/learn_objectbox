// ignore_for_file: unused_element
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:object_box/entitas/hutang.dart';
import 'package:object_box/entitas/user.dart';
import 'package:object_box/objectbox.g.dart';
import 'package:object_box/repository/user_repository.dart';
import 'package:object_box/screen/detail/views/detail_screen.dart';
import 'package:object_box/screen/home/controllers/home_controller.dart';
import 'package:object_box/screen/product/views/product_screen.dart';
import 'package:object_box/screen/sigin/views/sigin_screen.dart';
import '../../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final User user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Hutang> lists = [];
  final controller = Get.put(HomeController());
  Box<Hutang> hutangBox = store.box<Hutang>();
  late DateTime date;
  DateTime now = DateTime.now();

  @override
  void initState() {
    lists = hutangBox.getAll();
    super.initState();
  }

  void fetchData(User user) {
    final query = hutangBox.query(Hutang_.user.equals(user.id)).build();
    lists = query.find();
    setState(() {});
    query.close();
  }

  @override
  Widget build(BuildContext context) {
    final listsHutang = hutangBox.getAll();
    final geAllProducts = lists = listsHutang;

//TAMBAH DATA
    Future<void> addProduct() async {
      setState(() {
        UserRepository.addHutang(
            name: controller.nameC.text,
            detail: controller.detailC.text,
            amount: controller.amountC.text,
            user: widget.user,
            date: now,
            hutangBox: hutangBox);
        controller.nameC.text = '';
        controller.detailC.text = '';
        controller.amountC.text = '';
        controller.dateC.text = '';
      });
    }

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
            await hutangBox.remove(hutang.id);
            fetchData(widget.user);
            Get.back();
          },
          child: Text(
            'Konfirmasi',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  fetchData(widget.user);
                },
                icon: Icon(Icons.refresh)),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      Get.to(ProductScreen(), arguments: widget.user);
                    },
                    icon: Icon(Icons.shopping_cart)),
              )
            ],
            automaticallyImplyLeading: false,
            title: Text('Data Orang Hutang'),
            centerTitle: true),
        body: _body(geAllProducts, deleteProduct),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            speedLogout(),
            speedAdd(addProduct, context),
          ],
        ));
  }

  ListView _body(
      List<Hutang> geAllProducts, Future<void> deleteProduct(Hutang hutang)) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      itemCount: geAllProducts.length,
      itemBuilder: (context, index) {
        var data = geAllProducts[index];
        if (data.user.target!.id == widget.user.id) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Get.to(DetailScreen(), arguments: data);
              },
              child: Ink(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: data.belumLunas == true
                                  ? Colors.pink.shade200
                                  : Colors.teal,
                              borderRadius: BorderRadius.circular(5)),
                          width: 10,
                          height: 65,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data.name}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.start,
                            ),
                            Text('Rp. ${data.amount}'),
                            SizedBox(height: 8),
                            Text(data.belumLunas == true
                                ? 'Belum lunas'
                                : 'Lunas')
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        data.belumLunas == true
                            ? SizedBox()
                            : IconButton(
                                onPressed: () {
                                  deleteProduct(data);
                                },
                                icon: Icon(Icons.delete, color: Colors.pink)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${data.date!.hour}:${data.date!.minute}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${data.date!.day}/${data.date!.month}/${data.date!.year}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  SpeedDialChild speedAdd(Future<void> addProduct(), BuildContext context) {
    return SpeedDialChild(
        onTap: () {
          Get.defaultDialog(
            confirm: ElevatedButton(
                onPressed: () {
                  if (controller.key.currentState!.validate()) {
                    setState(() {
                      addProduct();
                    });

                    Get.back();
                  }
                },
                child: Text('ADD')),
            cancel: OutlinedButton(
                onPressed: () {
                  Get.back();
                  controller.amountC.clear();
                  controller.nameC.clear();
                  controller.dateC.clear();
                  controller.detailC.clear();
                },
                child: Text('Back')),
            title: 'Data Hutang',
            content: Form(
              key: controller.key,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                    controller: controller.nameC,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Date is required';
                      }
                      return null;
                    },
                    onTap: () async {
                      DateTime? pickedData = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: now,
                          lastDate: now);
                      if (pickedData != null) {
                        String formattedDate =
                            DateFormat('dd/MMM/yyyy').format(pickedData);
                        print(formattedDate);
                        setState(() {
                          controller.dateC.text = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    controller: controller.dateC,
                    decoration: InputDecoration(
                        labelText: 'Tanggal',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_month)),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    maxLines: 2,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'detail is required';
                      }
                      return null;
                    },
                    controller: controller.detailC,
                    decoration: InputDecoration(
                        labelText: 'Detail', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'total is required';
                      }
                      return null;
                    },
                    controller: controller.amountC,
                    decoration: InputDecoration(
                        labelText: 'Total', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)));
  }

  SpeedDialChild speedLogout() {
    return SpeedDialChild(
        child: Icon(Icons.logout),
        onTap: () {
          Get.defaultDialog(
              title: 'Peringatan!',
              content: Text('Apakah anda yakin ingin keluar?'),
              cancel: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Batal',
                    style: TextStyle(color: Colors.pink),
                  )),
              confirm: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    Get.to(SiginScreen());
                  },
                  child: Text(
                    'Konfirmasi',
                    style: TextStyle(color: Colors.white),
                  )));
        });
  }
}
