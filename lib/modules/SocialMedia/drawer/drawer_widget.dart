import 'package:flutter/material.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/drawer/drawer_items.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
            buildDrawerItems(context),
        ],
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Column(
      children: DrawerItems.all
          .map(
          (item) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            onTap: (){},
            leading: Icon(item.icon,color: const Color(0xFF0500A0),),
            title: Text(
              item.title,
              style: const TextStyle(
                color: Color(0xFF0500A0),
                fontWeight: FontWeight.w400,
                fontSize: 16.0
              ),
            ),
          ),
      ).toList(),
    ),
  );
}
