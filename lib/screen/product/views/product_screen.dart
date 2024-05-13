import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:object_box/repository/product_repository.dart';
import 'package:object_box/screen/home/views/home_screen.dart';
import 'package:object_box/screen/product/controllers/product_controller.dart';
import 'package:object_box/utils/utils.dart';
import 'package:object_box/widget/custom_textfield.dart';
import '../../../entitas/product.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../detail_product/views/detail_product_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final controller = ProductController();
  List<Product>? lists = [];
  Box<Product> products = store.box<Product>();
  late TextEditingController searchC = TextEditingController();
  @override
  void initState() {
    controller.photoString = '';
    refreshData();
    searchC = TextEditingController();
    super.initState();
  }

  void pickImage() async {
    Uint8List? img = await pickImages(ImageSource.gallery);
    if (img != null) {
      setState(() {
        controller.photoString = Utils.base64String(img);
      });
    } else {
      controller.photoString = '';
    }
  }

  Future<void> refreshData() async {
    final poto = products.getAll();
    setState(() {
      lists = poto;
    });
  }

  addPro() {
    ProductRepository.addProduct(
        nameProduct: controller.productNameC.text,
        image: controller.photoString ?? '',
        price: controller.priceC.text,
        boxProduct: products);
  }

  void searchList(String val) {
    String query = val.trim().toLowerCase();
    if (query.isNotEmpty) {
      setState(() {
        lists = products
            .getAll()
            .where((e) => e.productName.toLowerCase().contains(query))
            .toList();
      });
    } else {
      setState(() {
        lists = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final listProduct = products.getAll();
    final geAllProducts = lists = listProduct;
    final user = Get.arguments;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Daftar harga produk'),
        leading: IconButton(
            onPressed: () {
              Get.to(HomeScreen(user: user));
            },
            icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  refreshData();
                });
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          // TextField(
          //   onChanged: (value) {
          //     searchList(value);
          //   },
          //   controller: searchC,
          //   decoration: InputDecoration(
          //       border: OutlineInputBorder(), labelText: 'Search..'),
          // ),
          SizedBox(height: 15.h),
          GridView.builder(
            shrinkWrap: true,
            itemCount: lists!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 8,
                crossAxisSpacing: 9,
                childAspectRatio: 2.w / 2.6.h,
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              String? photo = 'assets/images/noimage.png';
              var product = lists![index];
              return InkWell(
                hoverColor: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Get.to(DetailProductScreen(), arguments: product);
                },
                child: Ink(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      product.image.isEmpty
                          ? SizedBox(height: 80.h, child: Image.asset(photo))
                          : SizedBox(
                              width: width,
                              child: Utils.imageFromBase64String(product.image),
                            ),
                      SizedBox(height: 5.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product.productName}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text('Rp. ${product.price}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
          // FutureBuilder(
          //   future: controller.getProducts(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     } else if (snapshot.hasData) {
          //       return geAllProducts.isEmpty
          //           ? LottieBuilder.asset('assets/lotties/empty.json')
          //           : GridView.builder(
          //               shrinkWrap: true,
          //               itemCount: geAllProducts.length,
          //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //                   mainAxisSpacing: 8,
          //                   crossAxisSpacing: 9,
          //                   childAspectRatio: 2.w / 2.6.h,
          //                   crossAxisCount: 2),
          //               itemBuilder: (context, index) {
          //                 String? photo = 'assets/images/noimage.png';
          //                 var product = geAllProducts[index];

          //                 return InkWell(
          //                   hoverColor: Colors.grey.shade300,
          //                   borderRadius: BorderRadius.circular(10),
          //                   onTap: () {
          //                     Get.to(DetailProductScreen(), arguments: product);
          //                   },
          //                   child: Ink(
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         product.image.isEmpty
          //                             ? SizedBox(
          //                                 height: 80.h,
          //                                 child: Image.asset(photo))
          //                             : SizedBox(
          //                                 width: width,
          //                                 child: Utils.imageFromBase64String(
          //                                     product.image),
          //                               ),
          //                         SizedBox(height: 15.h),
          //                         Padding(
          //                           padding: const EdgeInsets.symmetric(
          //                               horizontal: 10),
          //                           child: Column(
          //                             crossAxisAlignment:
          //                                 CrossAxisAlignment.start,
          //                             children: [
          //                               Text(
          //                                 '${product.productName}',
          //                                 style: TextStyle(
          //                                     fontSize: 18,
          //                                     fontWeight: FontWeight.bold),
          //                               ),
          //                               Text('Rp. ${product.price}'),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 );
          //                 // return ListTile(
          //                 //   tileColor: Colors.amber.withOpacity(0.4),
          //                 //   shape: RoundedRectangleBorder(
          //                 //       borderRadius: BorderRadius.circular(10)),
          //                 //   onTap: () {
          //                 //     Get.to(DetailProductScreen(), arguments: product);
          //                 //   },
          //                 //   subtitle: Text('${product.price}'),
          //                 //   leading: Container(
          //                 //       height: 115,
          //                 //       child: (product.image.isEmpty)
          //                 //           ? Image.asset(photo)
          //                 //           : Utils.imageFromBase64String(
          //                 //               product.image)),
          //                 //   title: Container(
          //                 //       width: 60,
          //                 //       child: Text('${product.productName}',
          //                 //           overflow: TextOverflow.ellipsis)),
          //                 // );
          //               },
          //             );
          //     } else {
          //       return Text('Tidak ada data');
          //     }
          //   },
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(
          child: Icon(Icons.camera_enhance_rounded),
        ),
        onPressed: () {
          Get.defaultDialog(
              title: 'Tambah Produk',
              cancel: OutlinedButton(
                  onPressed: () {
                    Get.back();
                    controller.productNameC.text = '';
                    controller.priceC.text = '';
                  },
                  child: Text('Cancel')),
              confirm: ElevatedButton(
                  onPressed: () {
                    if (controller.key.currentState!.validate()) {
                      setState(() {
                        addPro();
                      });
                      refreshData();
                      Get.back();
                    }
                    controller.productNameC.clear();
                    controller.priceC.clear();
                  },
                  child: Text('ADD')),
              content: Form(
                key: controller.key,
                child: Column(
                  children: [
                    CustomTextfield(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'nama produk kosong';
                          } else {
                            return null;
                          }
                        },
                        controller: controller.productNameC,
                        decor: InputDecoration(labelText: 'Nama produk')),
                    CustomTextfield(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'harga produk kosong';
                          } else {
                            return null;
                          }
                        },
                        controller: controller.priceC,
                        decor: InputDecoration(labelText: 'Harga barang')),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            height: 80,
                            child: (controller.photoString == null ||
                                    controller.photoString!.isEmpty)
                                ? Image.asset('assets/images/noimage.png')
                                : Image.asset('assets/images/man.png')),
                        OutlinedButton(
                            onPressed: () {
                              setState(() {
                                pickImage();
                              });
                            },
                            child: Text(
                              'Tambah poto',
                              style: TextStyle(fontSize: 6),
                            ))
                      ],
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }
}
