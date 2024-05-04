import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:object_box/entitas/user.dart';
import 'package:object_box/main.dart';
import 'package:object_box/screen/sigup/controllers/sigup_controller.dart';
import 'package:object_box/widget/custom_textfield.dart';

import '../../../objectbox.g.dart';
import '../../../utils/constans/app_style.dart';
import '../../../widget/custom_elevated.dart';
import '../../sigin/views/sigin_screen.dart';

class SigupScreen extends StatefulWidget {
  const SigupScreen({super.key});

  @override
  State<SigupScreen> createState() => _SigupScreenState();
}

class _SigupScreenState extends State<SigupScreen> {
  final controller = SigupController();
  //textediting
  final usernameC = TextEditingController();
  final passC = TextEditingController();
  final users = store.box<User>();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: key,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            SizedBox(
              width: 300,
              height: 250,
              child: LottieBuilder.asset('assets/lotties/sigup.json'),
            ),
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
                        borderRadius: BorderRadius.circular(10))),
                obscureText: false),
            SizedBox(height: 10),
            Obx(() => CustomTextfield(
                obscureText: controller.isVisble.value,
                controller: passC,
                decor: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.isVisble.toggle();
                      },
                      icon: controller.isVisble.value
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))))),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Sudah punya akun?'),
                TextButton(
                    onPressed: () {
                      Get.to(SiginScreen());
                    },
                    child: Text(
                      'Masuk',
                      style: TextStyle(color: blue),
                    ))
              ],
            ),
            SizedBox(height: 20),
            CustomElevated(
              onPress: () {
                if (key.currentState!.validate()) {
                  setState(() {
                    sigup(usernameC.text, passC.text);
                  });
                }
              },
              text: Text(
                'Daftar',
                style: TextStyle(color: white),
              ),
            ),
          ],
        ),
      ),
    );
  }

//mendaftarkan user
  void sigup(String username, String pass) {
    //untuk cek user sudah terdaftar apa belum
    var existingUsername =
        users.query(User_.username.equals(username)).build().find();
    if (existingUsername.isEmpty) {
      // if (adminC.text == '1') {

      // } else {
      //   users.put(User(username: username, password: pass));
      //   usernameC.text = '';
      //   passC.text = '';
      //   setState(() {});
      //   Get.to(SiginScreen());
      // }
      users.put(User(username: username, password: pass));
      setState(() {});
      Get.to(SiginScreen());
      usernameC.text = '';
      passC.text = '';
      Get.snackbar('Sukses', 'Berhasil mendaftar',
          backgroundColor: Colors.teal, colorText: Colors.white);
    } else {
      log('Username existing');
      Get.snackbar('Data already exists', 'Username sudah terdaftar',
          backgroundColor: Colors.pink, colorText: Colors.white);
    }
  }

  Future<void> deleteUser() async {
    await users.removeAll();
  }

  @override
  void dispose() {
    usernameC.dispose();
    passC.dispose();
    super.dispose();
  }
}
