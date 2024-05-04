import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:object_box/entitas/user.dart';
import 'package:object_box/main.dart';
import 'package:object_box/objectbox.g.dart';
import 'package:object_box/screen/home/views/home_screen.dart';
import 'package:object_box/screen/sigin/controllers/sing_controller.dart';
import 'package:object_box/screen/sigup/views/sigup_screen.dart';
import 'package:object_box/utils/constans/app_style.dart';
import 'package:object_box/widget/custom_elevated.dart';
import 'package:object_box/widget/custom_textfield.dart';

class SiginScreen extends StatefulWidget {
  const SiginScreen({super.key});

  @override
  State<SiginScreen> createState() => _SiginScreenState();
}

class _SiginScreenState extends State<SiginScreen> {
  final controller = SiginController();
  final usernameC = TextEditingController();
  final passC = TextEditingController();
  final users = store.box<User>();
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Warung Wa Nana'),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            SizedBox(
                height: 200,
                width: 200,
                child: LottieBuilder.asset('assets/lotties/login.json')),
            SizedBox(height: 100),
            CustomTextfield(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'username is required';
                  }
                  return null;
                },
                controller: usernameC,
                decor: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)))),
            SizedBox(height: 10),
            Obx(() => CustomTextfield(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'password is required';
                  }
                  return null;
                },
                obscureText: controller.isVisible.value,
                controller: passC,
                decor: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.isVisible.toggle();
                        },
                        icon: Obx(() => controller.isVisible.value
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility))),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))))),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Belum punya akun?'),
                TextButton(
                    onPressed: () {
                      Get.to(SigupScreen());
                    },
                    child: Text(
                      'Daftar',
                      style: TextStyle(color: Color(0xff4A6CD1)),
                    ))
              ],
            ),
            SizedBox(height: 20),
            CustomElevated(
              text: Text(
                'Masuk',
                style: TextStyle(color: white),
              ),
              onPress: () {
                if (key.currentState!.validate()) {
                  setState(() {
                    sigin();
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void sigin() {
    String username = usernameC.text;
    String pass = passC.text;
    Query<User> query = users
        .query(User_.username.equals(username) & User_.password.equals(pass))
        .build();
    var user = query
        .find()
        .firstWhereOrNull((e) => e.username == username && e.password == pass);
    query.close();
    if (user != null) {
      Get.to(HomeScreen(user: user));

      log('login id : ${user.id.toString()}');
      usernameC.text = '';
      passC.text = '';
    } else if (username != user?.username && pass != user?.password) {
      Get.snackbar('Gagal', 'username/password salah');
    } else {
      log('Gagal');
    }
  }

  void dispose() {
    usernameC.dispose();
    passC.dispose();
    super.dispose();
  }
}
