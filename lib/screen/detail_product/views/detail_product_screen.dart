import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:object_box/entitas/product.dart';
import 'package:object_box/screen/detail_product/controllers/detail_product_controller.dart';
import '../../../utils/constans/app_style.dart';
import '../../../utils/utils.dart';
import '../../../widget/custom_elevated.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({super.key});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = DetailProductController();
    Product product = Get.arguments;
    controller.productNameC.text = product.productName;
    controller.priceC.text = product.price;
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
            // TextFormField(
            //   validator: (value) {
            //     if (value!.isEmpty) {
            //       return 'deskripsi tidak boleh kosong';
            //     } else {
            //       return null;
            //     }
            //   },
            //   controller: controller.detailC,
            //   maxLines: 4,
            //   decoration: InputDecoration(
            //       labelText: 'Deskripsi',
            //       hintText: 'Deskripsi',
            //       focusedBorder: OutlineInputBorder(),
            //       border: OutlineInputBorder()),
            // ),
            // SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                    // width: 200,
                    height: 200,
                    child: product.image.isEmpty
                        ? Image.asset('assets/images/noimage.png')
                        : Utils.imageFromBase64String(product.image)),
              ],
            ),
            SizedBox(height: 10),
            CustomElevated(
              text: Text(
                'Edit Data',
                style: TextStyle(color: white),
              ),
              onPress: () {
                if (controller.key.currentState!.validate()) {
                  if (product.id > 0) {
                    setState(() {
                      // Get.back(result: editData());
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
