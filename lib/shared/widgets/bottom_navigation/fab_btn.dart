import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';

class MyNavBarFabButton extends StatefulWidget {

  final double size;
  final VoidCallback? onTap;
  final List<Color>? colors;
  final Widget? icon;

  const MyNavBarFabButton({
    Key? key,
    required this.size,
    required this.onTap,
    this.colors,
    this.icon,
  }) : super(key: key);

  @override
  _MyNavBarFabButtonState createState() => _MyNavBarFabButtonState();
}

class _MyNavBarFabButtonState extends State<MyNavBarFabButton> {
  bool _touched = false;

  @override
  Widget build(BuildContext context) {
    final _colors = widget.colors ??
        [
          Color(0xFF0286EA),
          Color(0xFF27A1FE),
        ];

    return Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: InkResponse(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: widget.onTap as void Function(),
        onHighlightChanged: (touched) {
          setState(() {
            _touched = touched;
          });
        },
        child: Transform.rotate(
          angle: 45 * math.pi / 180,
          child: Container(
            width: _touched ? widget.size - 1 : widget.size,
            height: _touched ? widget.size - 1 : widget.size,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: _touched ? _colors : _colors.reversed.toList()),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 5,
                      offset: Offset(3, 3))
                ]),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Center(
                child: Transform.rotate(
                    angle: -45 * math.pi / 180,
                    child:
                        SvgPicture.asset(
                        "assets/images/head.svg"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
