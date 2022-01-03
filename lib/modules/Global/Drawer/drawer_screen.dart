import 'package:flutter/material.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/drawer/drawer_items.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/drawer/drawer_model.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/drawer/drawer_widget.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  DrawerModel item = DrawerItems.addPost;
  double xOffSet = 0;
  double yOffSet = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: primaryGreen,
        padding: const EdgeInsets.only(top: 50, bottom: 70),
        child: DrawerWidget(
          onSelectedItem: (item){
              setState(() {
                  this.item = item;
              });
              closeDrawer();
          },
        ),
      ),
    );
  }
  void closeDrawer() {
    setState(() {
      xOffSet = 0;
      yOffSet = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }
}
