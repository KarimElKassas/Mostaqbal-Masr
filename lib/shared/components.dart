import 'dart:async';
import 'dart:ffi';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void navigateTo(context, widget) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushReplacement(
    context, MaterialPageRoute(builder: (context) => widget));

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.deepPurple,
  double radius = 8.0,
  bool isUpperCase = true,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        height: 30,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 2,
              color: Colors.white),
        ),
      ),
    );

Future<bool?> showToast({
  required String message,
  required dynamic length,
  required dynamic gravity,
  required int timeInSecForIosWeb,
  Color? backgroundColor,
  Color? textColor,
  double? fontSize,
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: length,
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIosWeb,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);


int purpleColor = 0xFF0500A0;
Color primaryGreen = const Color(0xff416d6d);

Future<bool> noInternetConnection()async{
  bool noConnection = false;
  var connectivityResult = await (Connectivity().checkConnectivity());
  if(connectivityResult == ConnectivityResult.none){
    noConnection = true;
  }

  return noConnection;

}

void noInternet()async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if(connectivityResult == ConnectivityResult.none){
    showToast(
      message: 'انت لست متصل بالانترنت',
      length: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
    );
  }
}

List<Map> drawerItems=[
  {
    'icon': FontAwesomeIcons.paw,
    'title' : 'Adoption'
  },
  {
    'icon': Icons.mail,
    'title' : 'Donation'
  },
  {
    'icon': FontAwesomeIcons.plus,
    'title' : 'Add pet'
  },
  {
    'icon': Icons.favorite,
    'title' : 'Favorites'
  },
  {
    'icon': Icons.mail,
    'title' : 'Messages'
  },
  {
    'icon': FontAwesomeIcons.userAlt,
    'title' : 'Profile'
  },
];