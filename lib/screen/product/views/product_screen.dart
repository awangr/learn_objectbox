import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:object_box/repository/product_repository.dart';
import 'package:object_box/screen/detail_product/views/detail_product_screen.dart';
import 'package:object_box/screen/product/controllers/product_controller.dart';
import 'package:object_box/utils/utils.dart';
import 'package:object_box/widget/custom_textfield.dart';
import '../../../entitas/product.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product>? lists = [];
  final controller = ProductController();

  @override
  void initState() {
    controller.photoString = '';
    refreshData();
    super.initState();
  }

  final listProduct = products.getAll();
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

  static Box<Product> products = store.box<Product>();
  @override
  Widget build(BuildContext context) {
    final listProduct = products.getAll();
    final geAllProducts = lists = listProduct;
    void searchProduct(String productName) {
      setState(() {
        if (productName.isEmpty) {
          geAllProducts.assignAll(listProduct);
        } else {
          geAllProducts.assignAll(listProduct.where((product) => product
              .productName
              .toLowerCase()
              .contains(productName.toLowerCase())));
        }
      });
    }

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: 50,
              child: TextField(
                onChanged: (value) => searchProduct(value),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
          ),
          SizedBox(height: 10),
          FutureBuilder(
            future: controller.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return geAllProducts.isEmpty
                    ? LottieBuilder.asset('assets/lotties/empty.json')
                    : GridView.builder(
                        shrinkWrap: true,
                        itemCount: geAllProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 9,
                            childAspectRatio: 2.6,
                            crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          String? photo = 'assets/images/noimage.png';
                          var product = geAllProducts[index];
                          return ListTile(
                            tileColor: Colors.amber.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onTap: () {
                              Get.to(DetailProductScreen(), arguments: product);
                            },
                            subtitle: Text('${product.price}'),
                            leading: Container(
                                height: 130,
                                child: (product.image.isEmpty)
                                    ? Image.asset(photo)
                                    : Utils.imageFromBase64String(
                                        product.image)),
                            title: Text('${product.productName}'),
                          );
                        },
                      );
                // : ListView.builder(
                //     padding: EdgeInsets.symmetric(vertical: 10),
                //     shrinkWrap: true,
                //     itemCount: geAllProducts.length,
                //     itemBuilder: (context, index) {
                //       var product = snapshot.data?[index] ?? null;
                //       String? photo = 'assets/images/noimage.png';
                //       // productNameC.text = product!.productName;
                //       // priceC.text = product.price;

                //       return Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: ListTile(
                //           shape: RoundedRectangleBorder(
                //               side: BorderSide(width: 1),
                //               borderRadius: BorderRadius.circular(15)),
                //           splashColor: Colors.white,
                //           subtitle:
                //               Text('Rp. ${product!.price.toString()}'),
                //           leading: (product.image.isEmpty)
                //               ? Image.asset(photo)
                //               : Utils.imageFromBase64String(product.image),
                //           title: Text('${product.productName}'),
                //           onTap: () {
                //             Get.to(DetailProductScreen(),
                //                 arguments: product);
                //             // Get.defaultDialog(
                //             //     confirm: ElevatedButton(
                //             //         onPressed: () {
                //             //           if (product.id > 0)
                //             //             ProductRepository.updateProduct(
                //             //                 id: product.id,
                //             //                 nameProduct: controller.productNameC.text,
                //             //                 image: controller.imageC.text,
                //             //                 price: controller.priceC.text,
                //             //                 boxProduct: products);
                //             //         },
                //             //         child: Text('EDIT')),
                //             //     cancel: OutlinedButton(
                //             //         onPressed: () {
                //             //           Get.back();
                //             //         },
                //             //         child: Text('Cancel')),
                //             //     content: Column(
                //             //       children: [
                //             //         CustomTextfield(
                //             //           controller: controller.productNameC,
                //             //           decor: InputDecoration(labelText: 'Nama produk'),
                //             //         ),
                //             //         TextField(
                //             //             keyboardType: TextInputType.number,
                //             //             controller: controller.priceC,
                //             //             decoration:
                //             //                 InputDecoration(labelText: 'Harga')),
                //             //         SizedBox(height: 10),
                //             //         SizedBox(
                //             //             height: 200,
                //             //             child:
                //             //                 Utils.imageFromBase64String(product.image)),
                //             //       ],
                //             //     ));
                //           },
                //         ),
                //       );
                //     },
                //   );
              } else {
                return Text('Tidak ada data');
              }
            },
          ),
        ],
      ),
      // body: ListView.builder(
      //   shrinkWrap: true,
      //   itemCount: geAllProducts.length,
      //   itemBuilder: (context, index) {
      //     var product = lists?[index] ?? null;

      //     String? photo = 'assets/images/man.png';
      //     return ListTile(
      //       leading: Utils.imageFromBase64String(product!.image),
      //       title: Text('${product.productName}'),
      //       onTap: () {
      //         Get.defaultDialog(
      //             confirm: ElevatedButton(
      //                 onPressed: () {
      //                   if (product.id > 0)
      //                     ProductRepository.updateProduct(
      //                         id: product.id,
      //                         nameProduct: productNameC.text,
      //                         image: imageC.text,
      //                         price: double.parse(priceC.text),
      //                         boxProduct: products);
      //                 },
      //                 child: Text('EDIT')),
      //             cancel: OutlinedButton(
      //                 onPressed: () {
      //                   Get.back();
      //                 },
      //                 child: Text('Cancel')),
      //             content: Column(
      //               children: [
      //                 TextField(controller: productNameC),
      //                 TextField(controller: priceC),
      //                 SizedBox(height: 10),
      //                 SizedBox(
      //                     height: 100,
      //                     child: Utils.imageFromBase64String(product.image)),
      //               ],
      //             ));
      //       },
      //     );
      //   },
      // ),

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
