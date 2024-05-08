import 'package:flutter/material.dart';

class CustomTabbar extends StatelessWidget {
  const CustomTabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(icon: Icon(Icons.abc)),
      BottomNavigationBarItem(icon: Icon(Icons.abc))
    ]);
  }
}
