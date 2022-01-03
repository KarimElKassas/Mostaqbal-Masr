import 'package:flutter/material.dart';
import 'package:mostaqbal_masr/modules/Global/Drawer/home_screen.dart';

class BigLayout extends StatelessWidget {
  const BigLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(),
    );
  }
}
