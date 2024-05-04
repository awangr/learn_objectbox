import '../entitas/product.dart';
import '../objectbox.g.dart';

class ProductRepository {
  static void addProduct({
    required String nameProduct,
    required String image,
    required String price,
    required Box<Product> boxProduct,
  }) {
    Product product =
        Product(productName: nameProduct, price: price, image: image);
    boxProduct.put(product);
  }

  // List<Product> getAllProducts() {
  //   return _productBox!.getAll();
  // }

  static Future<void> updateProduct({
    required int id,
    required String nameProduct,
    required String image,
    required String price,
    required Box<Product> boxProduct,
  }) async {
    Product product =
        Product(id: id, productName: nameProduct, price: price, image: image);
    await boxProduct.put(product);
  }
}
