import 'package:flutter/material.dart';

class MyNavBarButtonData {
  final dynamic id;
  final IconData icon;
  final String title;
  final bool isLeading;

  MyNavBarButtonData({
    this.id,
    this.icon = Icons.home,
    this.title = '',
    required this.isLeading,
  });
}
