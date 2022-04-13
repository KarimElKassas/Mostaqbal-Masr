import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/conversation/cubit/group_conversation_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/conversation/cubit/group_conversation_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';

class GroupInputFieldWidget extends StatefulWidget {
  final String groupID;
  final String groupName;
  final String senderName;

  const GroupInputFieldWidget(
      {Key? key, required this.groupID, required this.groupName, required this.senderName})
      : super(key: key);

  @override
  State<GroupInputFieldWidget> createState() => _GroupInputFieldWidgetState();
}

class _GroupInputFieldWidgetState extends State<GroupInputFieldWidget> {
  var messageController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupConversationCubit, GroupConversationStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GroupConversationCubit.get(context);

        return Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/dark_chat_background.jpg'),
                  fit: BoxFit.fitWidth,
                ),
                color: Colors.white),
            child: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: messageControllerValue,
                  builder: (context, value, state) {
                    if (value.toString().trim().isNotEmpty) {
                      return Listener(
                        onPointerMove: (_){cubit.cancelRecord();},
                        child: LongPressDraggable(
                          axis: Axis.horizontal,
                          feedback: ClipOval(
                            child: Material(
                              color: Colors.teal, // Button color
                              child: InkWell(
                                onTap: ()async{
                                  if (cubit.isImageOnly) {
                                  } else {
                                    if (messageController.text
                                        .toString()
                                        .trim()
                                        .isEmpty ||
                                        messageController.text.toString().trim() ==
                                            "") {
                                      showToast(
                                          message: "لا يمكن ارسال رسالة فارغة",
                                          length: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 3);
                                      return;
                                    }
                                    /*cubit.sendMessage(
                                      messageController.text.toString(),
                                      "Text",
                                      false);*/
                                    messageController.text = "";
                                  }
                                },
                                child: const SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor:
                                    Colors.teal,
                                    child: Icon(
                                      IconlyBold.send,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child: ClipOval(
                            child: Material(
                              color: Colors.teal, // Button color
                              child: InkWell(
                                onTap: ()async{
                                  if (cubit.isImageOnly) {
                                  } else {
                                    if (messageController.text
                                        .toString()
                                        .trim()
                                        .isEmpty ||
                                        messageController.text.toString().trim() ==
                                            "") {
                                      showToast(
                                          message: "لا يمكن ارسال رسالة فارغة",
                                          length: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 3);
                                      return;
                                    }
                                    /*cubit.sendMessage(
                                      messageController.text.toString(),
                                      "Text",
                                      false);*/
                                    messageController.text = "";
                                  }
                                },
                                child: const SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor:
                                    Colors.teal,
                                    child: Icon(
                                      IconlyBold.send,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: getEmptyWidget(),
                        ),
                      );
                    } else {
                      return ValueListenableBuilder(
                        valueListenable: startedRecordValue,
                        builder: (context, value, state) {
                          if (value == true) {
                            return InkWell(
                              onTap: () async {
                                cubit.changeRecordingState();
                                await cubit.stopRecord(widget.groupID);
                              },
                              child: const SizedBox(
                                height: 45,
                                width: 45,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.teal,
                                  child: Icon(
                                    IconlyBold.send,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return InkWell(
                              onTap: () async {
                                await cubit.recordAudio(widget.groupName, widget.senderName);
                              },
                              child: const SizedBox(
                                height: 45,
                                width: 45,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.teal,
                                  child: Icon(
                                    Icons.mic,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: !cubit.isRecording
                      ? Container(
                          padding: const EdgeInsets.only(
                            left: 4,
                            right: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  cubit.selectFile(widget.groupID);
                                },
                                icon: const Icon(IconlyBroken.paperUpload,
                                    color: Colors.white),
                                iconSize: 25,
                                constraints: const BoxConstraints(maxWidth: 25),
                              ),
                              const SizedBox(width: 5),
                              IconButton(
                                onPressed: () {
                                  cubit.selectImages(context,widget.groupID);
                                },
                                icon: const Icon(IconlyBroken.camera,
                                    color: Colors.white),
                                iconSize: 25,
                                constraints: const BoxConstraints(maxWidth: 25),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: TextFormField(
                                  controller: messageController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  maxLines: 3,
                                  minLines: 1,
                                  decoration: const InputDecoration(
                                    hintText: "رسالتك ... ",
                                    hintStyle: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    hintTextDirection: TextDirection.rtl,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (String value) {
                                    messageControllerValue.value =
                                        value.toString();

                                    if (value.isEmpty ||
                                        value.characters.isEmpty) {
                                      //cubit.changeUserState("متصل الان");
                                    }
                                    //cubit.changeUserState("يكتب ...");
                                  },
                                  onEditingComplete: () {
                                    //cubit.changeUserState("متصل الان");
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(child: buildRecordingHolder(cubit)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildRecordingHolder(GroupConversationCubit cubit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 6, right: 6),
      child: InkWell(
        onTap: () async {
          if (cubit.isRecording) {
            await cubit.cancelRecord();
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [0.1, 0.5, 0.7, 0.9],
              colors: [
                Colors.teal[400]!,
                Colors.teal[600]!,
                Colors.teal[700]!,
                Colors.teal[800]!,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  width: 12,
                ),
                const Flexible(
                  child: Text(
                    "جارى التسجيل اضغط للإلغاء",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                _buildText(cubit),
                const SizedBox(
                  width: 6.0,
                ),
                const Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(
                  width: 8.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText(GroupConversationCubit cubit) {
    if (cubit.isRecording || cubit.isPaused) {
      return _buildTimer(cubit);
    }
    return const Text("");
  }

  Widget _buildTimer(GroupConversationCubit cubit) {
    final String minutes = _formatNumber(cubit.recordDuration ~/ 60);
    final String seconds = _formatNumber(cubit.recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14.0,
      ),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }
}
