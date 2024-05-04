// ignore_for_file: unused_element

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:object_box/entitas/hutang.dart';
import 'package:object_box/entitas/user.dart';
import 'package:object_box/objectbox.g.dart';
import 'package:object_box/repository/user_repository.dart';
import 'package:object_box/screen/detail/views/detail_screen.dart';
import 'package:object_box/screen/home/controllers/home_controller.dart';
import 'package:object_box/screen/sigin/views/sigin_screen.dart';
import '../../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final User user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Box<Hutang> products = store.box<Hutang>();
  List<Hutang> lists = [];
  @override
  void initState() {
    products.getAll();
    fetchData(widget.user);

    super.initState();
  }

  void fetchData(User user) {
    final query = hutangBox.query(Hutang_.user.equals(user.id)).build();
    lists = query.find();
    setState(() {});
    query.close();
  }

  Box<Hutang> hutangBox = store.box<Hutang>();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    final listsHutang = products.getAll();
    final geAllProducts = lists = listsHutang;
    final key = GlobalKey<FormState>();
    DateTime now = DateTime.now();

    Future<void> addProduct() async {
      UserRepository.addHutang(
          name: controller.nameC.text,
          detail: controller.detailC.text,
          amount: controller.amountC.text,
          user: widget.user,
          date: now,
          hutangBox: hutangBox);
      setState(() {});
      controller.nameC.text = '';
      controller.detailC.text = '';
      controller.amountC.text = '';
      controller.dateC.text = '';
    }

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
                await products.remove(hutang.id);
                fetchData(widget.user);
                Get.back();
              },
              child: Text(
                'Konfirmasi',
                style: TextStyle(color: Colors.white),
              )));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 7,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                child: Center(
                  child: Text('${widget.user.username[0].toUpperCase()}'),
                ),
              ),
            ),
          )
        ],
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal),
                      onPressed: () {
                        Get.to(SiginScreen());
                      },
                      child: Text(
                        'Konfirmasi',
                        style: TextStyle(color: Colors.white),
                      )));
            },
            icon: Icon(Icons.power_settings_new_sharp)),
        title: Text('Catatan Hutang'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              (geAllProducts.isEmpty)
                  ? Center(
                      child: LottieBuilder.asset('assets/lotties/empty.json'))
                  : ListView.builder(
                      padding: EdgeInsets.all(10),
                      shrinkWrap: true,
                      itemCount: geAllProducts.length,
                      itemBuilder: (context, index) {
                        final product = geAllProducts[index];
                        if (product.user.target!.id == widget.user.id) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Get.to(DetailScreen(), arguments: product);
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.teal,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          width: 10,
                                          height: 65,
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${product.name}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                              textAlign: TextAlign.start,
                                            ),
                                            Text('Rp. ${product.amount}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          deleteProduct(product);
                                        },
                                        icon: Icon(Icons.delete)),
                                  ],
                                ),
                                // child: Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 8.0, vertical: 4.0),
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: [
                                //           Text(
                                //             '${product.name}',
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.bold,
                                //                 fontSize: 16),
                                //           ),
                                //           IconButton(
                                //               onPressed: () {},
                                //               icon: Icon(Icons.delete,
                                //                   color: Colors.pink))
                                //         ],
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: [
                                //           Text('Rp. ${product.amount}'),
                                //           Column(
                                //             children: [
                                //               Text(
                                //                   '${product.date!.hour}:${product.date!.minute}'),
                                //               Text(
                                //                   '${product.date!.day}/${product.date!.month}/${product.date!.year} '),
                                //             ],
                                //           ),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ),
                            ),
                          );
                          // return ListTile(
                          //     onTap: () {
                          //       Get.to(DetailScreen(), arguments: product);
                          //     },
                          //     subtitle: Text('Rp.${product.amount}'),
                          //     leading: CircleAvatar(
                          //       child: Center(
                          //         child: Text('${number++}'),
                          //       ),
                          //     ),
                          //     title: Text(product.name),
                          //     trailing: IconButton(
                          //         color: Colors.pink,
                          //         onPressed: () {
                          //           deleteProduct(product);
                          //         },
                          //         icon: Icon(Icons.delete)));
                        } else {
                          return SizedBox();
                        }
                      },
                    )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(
          child: Icon(Icons.add),
        ),
        onPressed: () {
          Get.defaultDialog(
              confirm: ElevatedButton(
                  onPressed: () {
                    if (key.currentState!.validate()) {
                      addProduct();
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
                key: key,
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
                          labelText: 'Nama', border: OutlineInputBorder()),
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
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2030));
                        if (pickedData != null) {
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(pickedData);
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
                      maxLines: 4,
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
              ));
        },
      ),
    );
  }
}
