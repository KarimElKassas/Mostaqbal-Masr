


import 'package:flutter/material.dart';

_buildCourseImage(BuildContext context, String imgUrl) {
  return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero),
      child: FadeInImage(
        height: 150,
        width: MediaQuery
            .of(context)
            .size
            .width,
        fit: BoxFit.fill,
        image: NetworkImage(imgUrl),
        placeholder: AssetImage("images/wait.jpg"),
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset('images/error.png', fit: BoxFit.fill);
        },
      )

    /*Image.network(
        course.imgUrl!,
        height: 150,
        width: MediaQuery
            .of(context)
            .size
            .width,
        fit: BoxFit.fill,

      ),*/
  );
}