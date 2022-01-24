import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: Colors.teal.withOpacity(0.08),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(onPressed:(){},icon: Icon(IconlyBroken.send,color: Colors.teal[700]),iconSize: 25,constraints: const BoxConstraints(maxWidth: 25),),
          const SizedBox(width: 25),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                left: 4,
                right: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.05),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  IconButton(onPressed:(){},icon: Icon(IconlyBroken.paperUpload,color: Colors.teal[700]),iconSize: 25,constraints: const BoxConstraints(maxWidth: 25),),
                  const SizedBox(width: 5),
                  IconButton(onPressed:(){},icon: Icon(IconlyBroken.camera,color: Colors.teal[700]),iconSize: 25,constraints: const BoxConstraints(maxWidth: 25),),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      textDirection: TextDirection.rtl,
                      maxLines: 3,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: "رسالتك ... ",
                        hintTextDirection: TextDirection.rtl,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
