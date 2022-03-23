import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

List<Map> tasks = [];
bool customerLogged = false;

Color orangeColor = const Color(0xFFF69323);
Color greyColor = const Color(0xffEBEEF5);
Color greySubTitleColor = const Color(0xff454B66);
Color greyBorderColor = const Color(0xffD4DDE8);
Color greyThreeColor = const Color(0xff92A8C4);
Color greyFiveColor = const Color(0xFFEBEEF5);
Color greySixColor = const Color(0xFFF8F9FC);
Color darkBlueColor = const Color(0xff0F2644);
Color secondaryColor = const Color(0xff003D8C);
Color lightSecondaryColor = const Color(0xff197DFF);

Directory? appDirectory;

List<XFile>? messageImagesStaticList = [];


String? globalClerkID,globalClerkName,globalClerkNumber,globalClerkAddress,globalClerkPhone;

final customerState = ValueNotifier<int>(0);

final messageControllerValue = ValueNotifier<String>("");

final startedRecordValue = ValueNotifier<bool>(false);

final lastMessageValue = ValueNotifier<String>("");

final lastMessageTimeValue = ValueNotifier<String>("");

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
class BlurryProgressDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child:  AlertDialog(
            content: Center(child: CircularProgressIndicator(color: Colors.teal[500], strokeWidth: 0.8,),),
          )),
    );
  }
}

class PulsatingCircleIconButton extends StatefulWidget {
  const PulsatingCircleIconButton({
    Key? key,
    required this.onLongPressStart,
    required this.onLongPressUp,
    required this.icon,
  }) : super(key: key);

  final Function onLongPressStart;
  final Function onLongPressUp;
  final Icon icon;

  @override
  _PulsatingCircleIconButtonState createState() => _PulsatingCircleIconButtonState();
}

class _PulsatingCircleIconButtonState extends State<PulsatingCircleIconButton> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );
    _animationController!.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart : widget.onLongPressStart(),
      onLongPressUp : widget.onLongPressUp(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: AnimatedBuilder(
          animation: _animation!,
          builder: (context, _) {
            return Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  for (int i = 1; i <= 2; i++)
                    BoxShadow(
                      color: Colors.white.withOpacity(_animationController!.value / 2),
                      spreadRadius: _animation!.value * i,
                    )
                ],
              ),
              child: widget.icon,
            );
          },
        ),
      ),
    );
  }
}