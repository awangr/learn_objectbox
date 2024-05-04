import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  int id;
  String username;
  String password;

  User({
    this.id = 0,
    required this.username,
    required this.password,
  });
}
