import 'package:flutter/material.dart';

import '../utils/constans/app_style.dart';

class CustomElevated extends StatelessWidget {
  const CustomElevated({super.key, required this.text, required this.onPress});
  final Widget text;
  final Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      child: ElevatedButton(
        onPressed: onPress,
        child: text,
        style:
            ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(blue)),
      ),
    );
  }
}
