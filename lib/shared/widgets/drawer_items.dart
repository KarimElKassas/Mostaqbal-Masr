
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mostaqbal_masr/shared/widgets/drawer_model.dart';

class DrawerItems{

  static const close = DrawerModel(title: "اغلاق القائمة", icon: Icons.close);
  static const empty = DrawerModel(title: "", icon: null);
  static const addPost = DrawerModel(title: "اضافة خبر", icon: Icons.add_task);
  static const showPosts = DrawerModel(title: "عرض الاخبار", icon: Icons.visibility);
  static const settings = DrawerModel(title: "الاعدادات", icon: Icons.settings);
  static const empty1 = DrawerModel(title: "", icon: null);
  static const logOut = DrawerModel(title: "تسجيل الخروج", icon: Icons.logout);


  static final List<DrawerModel> all =[
    close,
    empty,
    addPost,
    showPosts,
    settings,
    empty1,
    logOut
  ];
}