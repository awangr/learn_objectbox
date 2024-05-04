import 'package:object_box/entitas/user.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Hutang {
  int id;
  String name;
  String detail;
  String amount;
  DateTime? date;
  String? category;

  ToOne<User> user = ToOne<User>();

  Hutang(
      {this.id = 0,
      required this.name,
      required this.detail,
      required this.amount,
      this.date,
      this.category = ''});
}
