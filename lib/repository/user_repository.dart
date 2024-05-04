import 'package:object_box/entitas/hutang.dart';
import 'package:object_box/entitas/user.dart';
import 'package:object_box/objectbox.g.dart';

class UserRepository {
  static void addHutang(
      {required String name,
      required String detail,
      required String amount,
      required DateTime date,
      required User user,
      required Box<Hutang> hutangBox}) {
    Hutang hutang =
        Hutang(name: name, detail: detail, amount: amount, date: date);
    hutang.user.target = user;
    hutangBox.put(hutang);
  }

  static void editHutang(
      {required int id,
      required String name,
      required String detail,
      required String amount,
      required User user,
      DateTime? date,
      required Box<Hutang> hutangBox}) {
    Hutang hutang =
        Hutang(id: id, name: name, detail: detail, amount: amount, date: date);
    hutang.user.target = user;
    hutangBox.put(hutang);
  }
}
