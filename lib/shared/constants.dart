import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

List<Map> tasks = [];

class DateUtil{

  static String formatDate(DateTime date){

    initializeDateFormatting('ar');
    Intl.defaultLocale = 'ar';
    final DateFormat formatter = DateFormat().add_yMMMd();
    final String formatted = formatter.format(date);

    return formatted;
  }

}

class BlurryDialog extends StatelessWidget {

  String title;
  String content;
  VoidCallback continueCallBack;

  BlurryDialog(this.title, this.content, this.continueCallBack);
  TextStyle textStyle = const TextStyle (color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child:  AlertDialog(
            title: Text(title,style: textStyle,),
            content: Text(content, style: textStyle,),
            actions: <Widget>[
               TextButton(
                child: const Text("نعم"),
                onPressed: () {
                  continueCallBack();
                },
              ),
              TextButton(
                child: const Text("الغاء"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )),
    );
  }
}