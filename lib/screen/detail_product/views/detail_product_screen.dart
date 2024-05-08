import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:object_box/entitas/product.dart';
import 'package:object_box/screen/detail_product/controllers/detail_product_controller.dart';

import '../../../main.dart';
import '../../../utils/constans/app_style.dart';
import '../../../utils/utils.dart';
import '../../../widget/custom_elevated.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({super.key});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  Product product = Get.arguments;
  final productBox = store.box<Product>();

  @override
  Widget build(BuildContext context) {
    final controller = DetailProductController();

    controller.productNameC.text = product.productName;
    controller.priceC.text = product.price;
    void editProduct() {
      setState(() {
        productBox.put(Product(
            id: product.id,
            productName: controller.productNameC.text,
            price: controller.priceC.text,
            image: product.image));
      });
    }

    deletePro() {
      setState(() {
        productBox.remove(product.id);
      });
      Get.back();
    }

    Future<void> deleteProduct(Product product) async {
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
          onPressed: () {},
          child: Text(
            'Konfirmasi',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: controller.key,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          children: [
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nama produk tidak boleh kosong';
                } else {
                  return null;
                }
              },
              controller: controller.productNameC,
              decoration: InputDecoration(
                  hintText: 'Nama produk',
                  labelText: 'Nama produk',
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'total tidak boleh kosong';
                } else {
                  return null;
                }
              },
              controller: controller.priceC,
              decoration: InputDecoration(
                  hintText: 'Total',
                  labelText: 'Total',
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            SizedBox(
                width: Get.width / 2,
                // height: 200,
                child: product.image.isEmpty
                    ? Image.asset('assets/images/noimage.png')
                    : Utils.imageFromBase64String(product.image)),
            SizedBox(height: 10),
            CustomElevated(
              text: Text(
                'Edit Data',
                style: TextStyle(color: white),
              ),
              onPress: () {
                if (controller.key.currentState!.validate()) {
                  setState(() {
                    editProduct();
                    // Get.back(result: editData());
                  });
                  Get.back();
                }
              },
            ),
            SizedBox(height: 8),
            OutlinedButton(
                onPressed: () {
                  deletePro();
                },
                child: Text(
                  'Hapus Produk',
                  style: TextStyle(color: Colors.pink),
                ))
          ],
        ),
      ),
    );
  }
}
