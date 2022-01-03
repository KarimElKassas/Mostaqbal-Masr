import 'package:flutter/material.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/drawer/drawer_items.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/drawer/drawer_model.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class DrawerWidget extends StatelessWidget {

  final ValueChanged<DrawerModel> onSelectedItem;

  const DrawerWidget({
    Key? key,
    required this.onSelectedItem,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      body: SingleChildScrollView(
        child: Column(
          children: [
              buildDrawerItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Column(
      children: DrawerItems.all
          .map(
          (item) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            onTap: () => onSelectedItem(item),
            leading: Icon(item.icon,color: Colors.white,),
            title: Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14.0
              ),
            ),
          ),
      ).toList(),
    ),
  );
}
