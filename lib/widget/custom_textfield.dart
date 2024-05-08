import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  CustomTextfield(
      {super.key,
      required this.controller,
      required this.decor,
      this.validator,
      this.obscureText = false,
      this.keyboardType});
  final TextEditingController controller;
  final InputDecoration decor;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: obscureText,
        validator: validator,
        controller: controller,
        decoration: decor,
        keyboardType: keyboardType);
  }
}
