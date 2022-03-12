import 'package:flutter/material.dart';


class TransitionAppBar extends StatelessWidget {
  final Widget? avatar;
  final String? title;
  final String? membersCount;
  final double extent;

  const TransitionAppBar({this.avatar, this.title, this.membersCount, this.extent = 250, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: true,

      pinned: true,
      delegate: _TransitionAppBarDelegate(
          avatar: avatar!, title: title!, membersCount: membersCount!, extent: extent > 200 ? extent : 200),
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
  final String? membersCount;
  final double extent;

  int lightcolor = 0xff141c27;
  int darkcolor = 0xff232c38;

  _TransitionAppBarDelegate({this.avatar, this.title, this.membersCount, this.extent = 250});

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
          duration: const Duration(milliseconds: 100),
          height: 50,
          constraints: BoxConstraints(maxHeight: minExtent),
          color: Color(lightcolor),
        ):const SizedBox(),
        Container(
          color: Color(lightcolor),

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
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title!,style: const TextStyle(color: Colors.white,fontSize: 20),),
                const SizedBox(height: 4,),
                Text("$membersCount  عضو",style: const TextStyle(color: Colors.grey,fontSize: 14),),
              ],
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
    return avatar != oldDelegate.avatar || title != oldDelegate.title || membersCount != oldDelegate.membersCount;
  }
}