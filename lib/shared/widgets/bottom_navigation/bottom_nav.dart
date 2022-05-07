import 'package:flutter/material.dart';
import 'package:mostaqbal_masr/shared/widgets/bottom_navigation/button.dart';
import 'package:mostaqbal_masr/shared/widgets/bottom_navigation/button_model.dart';
import 'package:mostaqbal_masr/shared/widgets/bottom_navigation/fab_btn.dart';

class MyNavBar extends StatefulWidget {

  final Color? backgroundColor;
  final Color? shadowColor;
  final List<MyNavBarButtonData> buttonData;
  final Widget? fabIcon;
  final Color? buttonColor;
  final Color? buttonSelectedColor;
  final List<Color>? fabColors;

  final Function(dynamic selectedPage) onChange;
  final VoidCallback? onFabButtonPressed;

  const MyNavBar({
    Key? key,
    required this.buttonData,
    required this.onChange,
    this.backgroundColor,
    this.shadowColor,
    this.fabIcon,
    this.fabColors,
    this.onFabButtonPressed,
    this.buttonColor,
    this.buttonSelectedColor,
  }) : super(key: key);

  @override
  _MyNavBarState createState() => _MyNavBarState();
}
class _MyNavBarState extends State<MyNavBar> {
  final double fabSize = 50;
  final bool isLeading = true;
  final Color unSelectedColor = Colors.grey;

  dynamic selectedId;

  @override
  void initState() {
    selectedId =
    widget.buttonData.isNotEmpty ? widget.buttonData.first.id : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final clipper = _PandaBarClipper(fabSize: fabSize);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          painter: _ClipShadowPainter(
            shadow: Shadow(
                color: widget.shadowColor ?? Colors.white.withOpacity(.1),
                blurRadius: 10,
                offset: const Offset(0, -3)),
            clipper: clipper,
          ),
          child: ClipPath(
            clipper: clipper,
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(18), topLeft: Radius.circular(18)),
                  gradient: LinearGradient(
                      colors: [
                        Colors.teal.shade600,
                        Colors.teal.shade400,
                        Colors.teal.shade300,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: const [0.0, 0.5, 1.0],
                      tileMode: TileMode.clamp),
                //color: widget.backgroundColor ?? Color(0xFF004152),
              ),
              child: Builder(builder: (context) {
                List<Widget> leadingChildren = [];
                List<Widget> trailingChildren = [];

                widget.buttonData.asMap().forEach((i, data) {
                  Widget btn = MyNavBarButton(
                    icon: data.icon,
                    title: data.title,
                    isSelected: data.id != null && selectedId == data.id,
                    unselectedColor: widget.buttonColor,
                    selectedColor: widget.buttonSelectedColor,
                    onTap: () {
                      setState(() {
                        selectedId = data.id;
                      });
                      this.widget.onChange(data.id);
                    },
                  );

                  if (data.isLeading) {
                    leadingChildren.add(btn);
                  } else {
                    trailingChildren.add(btn);
                  }
                });

                return Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: leadingChildren,
                      ),
                    ),
                    Container(width: fabSize),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: trailingChildren,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        MyNavBarFabButton(
          size: fabSize,
          icon: widget.fabIcon,
          onTap: widget.onFabButtonPressed,
          colors: widget.fabColors,
        ),
      ],
    );
  }
}

class _PandaBarClipper extends CustomClipper<Path> {
  final double fabSize;
  final double padding = 50;
  final double centerRadius = 20;
  final double cornerRadius = 5;

  _PandaBarClipper({this.fabSize = 120});

  @override
  Path getClip(Size size) {
    final xCenter = (size.width / 2);

    final fabSizeWithPadding = fabSize + padding;

    final path = Path();
    path.lineTo((xCenter - (fabSizeWithPadding / 2) - cornerRadius), 0);
    path.quadraticBezierTo(xCenter - (fabSizeWithPadding / 2), 0,
        (xCenter - (fabSizeWithPadding / 2)) + cornerRadius, cornerRadius);
    path.lineTo(
        xCenter - centerRadius, (fabSizeWithPadding / 2) - centerRadius);
    path.quadraticBezierTo(xCenter, (fabSizeWithPadding / 2),
        xCenter + centerRadius, (fabSizeWithPadding / 2) - centerRadius);
    path.lineTo(
        (xCenter + (fabSizeWithPadding / 2) - cornerRadius), cornerRadius);
    path.quadraticBezierTo(xCenter + (fabSizeWithPadding / 2), 0,
        (xCenter + (fabSizeWithPadding / 2) + cornerRadius), 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;

}

class _ClipShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}