import 'package:object_box/entitas/category.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Product {
  int id;
  String productName;
  String price;
  String image;
  ToMany<Category> categoryOne = ToMany<Category>();
  Product(
      {this.id = 0,
      required this.productName,
      required this.price,
      required this.image});
}
