import 'package:get/get.dart';

import '../../../entitas/product.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';

class ProductController extends GetxController {
  Box<Product> productBox = store.box<Product>();
  Future<List<Product>> getProducts() async {
    return productBox.getAll();
  }
}
