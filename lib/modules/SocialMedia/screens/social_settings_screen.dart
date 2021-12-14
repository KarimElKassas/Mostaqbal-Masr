import 'package:flutter/material.dart';

class SocialSettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0500A0),
          title: const Text("الاعدادات"),
        ),
      ),
    );
  }
}
