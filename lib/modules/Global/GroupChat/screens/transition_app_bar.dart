import 'package:flutter/material.dart';


class TransitionAppBar extends StatelessWidget {
  final Widget? avatar;
  final String? title;
  final double extent;

  TransitionAppBar({this.avatar, this.title, this.extent = 250, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: true,

      pinned: true,
      delegate: _TransitionAppBarDelegate(
          avatar: avatar!, title: title!, extent: extent > 200 ? extent : 200),
    );
  }
}

class _TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  final _avatarMarginTween = EdgeInsetsTween(
    begin: EdgeInsets.only(top: 15),
    end: EdgeInsets.only(left: 20.0,top: 5),
  );

  final _titleMarginTween = EdgeInsetsTween(
    begin: EdgeInsets.only(bottom: 18),
    end: EdgeInsets.only( left: 75,top: 5),
  );

  final _avatarAlignTween =
  AlignmentTween(begin: Alignment.topCenter, end: Alignment.topLeft);
  final _titleAlignTween =
  AlignmentTween(begin: Alignment.bottomCenter, end: Alignment.centerLeft);

  final Widget? avatar;
  final String? title;
  final double extent;

  int darkcolor = 0xff141c27;
  int lightcolor = 0xff232c38;

  _TransitionAppBarDelegate({this.avatar, this.title, this.extent = 250})
      : assert(avatar != null),
        assert(extent == null || extent >= 200),
        assert(title != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double tempVal = 72 * maxExtent / 100;
    final progress = shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;
    final avatarMargin = _avatarMarginTween.lerp(progress);
    final titleMargin = _titleMarginTween.lerp(progress);

    final avatarAlign = _avatarAlignTween.lerp(progress);
    final titleAlign = _titleAlignTween.lerp(progress);

    final avatarSize = (1 - progress) * 100 + 40;
//    print(progress);

    return Stack(
      children: <Widget>[
        progress==1?
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: 50,
          constraints: BoxConstraints(maxHeight: minExtent),
          color: Color(darkcolor),
        ):SizedBox(),
        Container(
          color: Color(darkcolor),

          padding: avatarMargin,
          child: Align(
            alignment: avatarAlign,
            child: SizedBox(
              height: avatarSize,
              width: avatarSize,
              child: avatar,
            ),
          ),
        ),
        Container(
          padding: titleMargin,
          child: Align(

            alignment: titleAlign,
            child:Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('مستقبل مصر',style: TextStyle(color: Colors.white,fontSize: 25),),
                  Text('6 عضو ',style: TextStyle(color: Colors.grey,fontSize: 15),),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => 55;

  @override
  bool shouldRebuild(_TransitionAppBarDelegate oldDelegate) {
    return avatar != oldDelegate.avatar || title != oldDelegate.title;
  }
}