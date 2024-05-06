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
  final Box<Hutang> products = store.box<Hutang>();
  List<Hutang> lists = [];
  final controller = Get.put(HomeController());
  Box<Hutang> hutangBox = store.box<Hutang>();
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

  @override
  Widget build(BuildContext context) {
    final listsHutang = products.getAll();
    final geAllProducts = lists = listsHutang;

    DateTime now = DateTime.now();

//TAMBAH DATA
    Future<void> addProduct() async {
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
    }

// //DELETE DATA
//     Future<void> deleteProduct(Hutang hutang) async {
//       Get.defaultDialog(
//         title: 'Peringatan!',
//         content: Text('Anda yakin mau menghapusnya?'),
//         cancel: OutlinedButton(
//             onPressed: () {
//               Get.back();
//             },
//             child: Text(
//               'Batal',
//               style: TextStyle(color: Colors.amber),
//             )),
//         confirm: ElevatedButton(
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
//           onPressed: () async {
//             await products.remove(hutang.id);
//             fetchData(widget.user);
//             Get.back();
//           },
//           child: Text(
//             'Konfirmasi',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       );
//     }

    return Scaffold(
      appBar: _appbar(),
      body: _body(geAllProducts, controller),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.shopping_bag_sharp),
              onPressed: () {
                Get.to(ProductScreen());
              },
            ),
          ],
        ),
        color: Colors.grey.shade200,
      ),
      // floatingActionButton: _floatingActionButton(
      //     controller.key, addProduct, controller, context, now)
    );
  }

/////////////////////////////////////////////////////////////////////////////////////////
  AppBar _appbar() {
    return AppBar(
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.teal),
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
    );
  }

  SafeArea _body(List<Hutang> geAllProducts, HomeController controller) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: geAllProducts.isEmpty
            ? Center(child: LottieBuilder.asset('assets/lotties/empty.json'))
            : ListView(
                shrinkWrap: true,
                children: [
                  ListView.builder(
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
                                          SizedBox(height: 8),
                                          Container(
                                            width: Get.width / 1.95,
                                            child: Text(
                                              '${product.detail}',
                                              style: TextStyle(fontSize: 12),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            controller.deleteProduct(product);
                                          },
                                          icon: Icon(Icons.delete,
                                              color: Colors.pink)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          '${product.date!.hour}:${product.date!.minute}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          '${product.date!.day}/${product.date!.month}/${product.date!.year}',
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
                  )
                ],
              ),
      ),
    );
  }

  FloatingActionButton _floatingActionButton(
      GlobalKey<FormState> key,
      Future<void> addProduct(),
      HomeController controller,
      BuildContext context,
      DateTime now) {
    return FloatingActionButton(
      shape: CircleBorder(),
      backgroundColor: Colors.blue,
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
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
