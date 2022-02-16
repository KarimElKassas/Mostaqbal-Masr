import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Global/Chat/cubit/conversation_states.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_conversation_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_conversation_states.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/screens/social_input_field_widget.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/screens/social_user_info_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:open_file/open_file.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialConversationScreen extends StatefulWidget {
  final String userID;
  final String userName;
  final String userImage;

  const SocialConversationScreen(
      {Key? key,
      required this.userID,
      required this.userName,
      required this.userImage})
      : super(key: key);

  @override
  State<SocialConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<SocialConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialConversationCubit()
        ..createUserImagesDirectory(widget.userName)
        ..createUserDocumentsDirectory(widget.userName)
        ..createUserRecordingsDirectory(widget.userName)
        ..initRecorder()
        ..getMessages(widget.userID),
      child: BlocConsumer<SocialConversationCubit, SocialConversationStates>(
        listener: (context, state) {
          if (state is SocialConversationDownloadFileErrorState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
        },
        builder: (context, state) {
          var cubit = SocialConversationCubit.get(context);

          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logoWhite.png'),
                  fit: BoxFit.fitWidth,
                ),
                color: Colors.white),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                  // For Android (dark icons)
                  statusBarBrightness: Brightness.light, // For iOS (dark icons)
                ),
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                flexibleSpace: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              IconlyBroken.arrowRightCircle,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          CachedNetworkImage(
                            imageUrl: widget.userImage,
                            imageBuilder: (context, imageProvider) => ClipOval(
                              child: FadeInImage(
                                height: 50,
                                width: 50,
                                fit: BoxFit.fill,
                                image: imageProvider,
                                placeholder: const AssetImage(
                                    "assets/images/placeholder.jpg"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/error.png',
                                    fit: BoxFit.fill,
                                    height: 50,
                                    width: 50,
                                  );
                                },
                              ),
                            ),
                            placeholder: (context, url) => const FadeInImage(
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                              image:
                                  AssetImage("assets/images/placeholder.jpg"),
                              placeholder:
                                  AssetImage("assets/images/placeholder.jpg"),
                            ),
                            errorWidget: (context, url, error) =>
                                const FadeInImage(
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                              image: AssetImage("assets/images/error.png"),
                              placeholder:
                                  AssetImage("assets/images/placeholder.jpg"),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  widget.userName,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              cubit.navigate(
                                  context,
                                  SocialUserInfoScreen(
                                    userID: widget.userID,
                                    userImage: widget.userImage,
                                    userName: widget.userName,
                                  ));
                            },
                            icon: const Icon(
                              IconlyBroken.infoCircle,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BuildCondition(
                          condition: state is ConversationLoadingMessageState,
                          fallback: (context) => ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: cubit.chatListReversed.length,
                              itemBuilder: (context, index) =>
                                  chatView(context, cubit, index)),
                          builder: (context) => const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.teal,
                                ),
                              )),
                    ),
                  ),
                  SocialInputFieldWidget(userID: widget.userID, userName: widget.userName),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget chatView(
      BuildContext context, SocialConversationCubit cubit, int index) {
    return cubit.chatListReversed[index].type == "Text"
        ? Container(
            padding:
                const EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 10),
            child: Align(
              alignment:
                  (cubit.chatListReversed[index].receiverID == "Future Of Egypt"
                      ? Alignment.topLeft
                      : Alignment.topRight),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (cubit.chatListReversed[index].receiverID ==
                          "Future Of Egypt"
                      ? Colors.grey.shade200
                      : Colors.teal),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Linkify(
                      onOpen: (link) async {
                        if (await canLaunch(link.url)) {
                          await launch(link.url);
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      text: cubit.chatListReversed[index].message.toString(),
                      style: TextStyle(
                        color: cubit.chatListReversed[index].receiverID ==
                                "Future Of Egypt"
                            ? Colors.black
                            : Colors.white,
                        fontSize: 14.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                      linkStyle: TextStyle(
                        color: Colors.cyanAccent.shade400,
                        fontSize: 14.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      cubit.chatListReversed[index].messageTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: cubit.chatListReversed[index].receiverID ==
                                "Future Of Egypt"
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                  ],
                ),
              ),
            ),
          )
        : imageMessageView(context, cubit, index);
  }

  Widget imageMessageView(
      BuildContext context, SocialConversationCubit cubit, int index) {
    return cubit.chatListReversed[index].type == "Image"
        ? Align(
            alignment:
                cubit.chatListReversed[index].receiverID == "Future Of Egypt"
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return InteractiveViewer(
                          child: CachedNetworkImage(
                            imageUrl: cubit.chatListReversed[index].message,
                            imageBuilder: (context, imageProvider) => ClipRRect(
                              borderRadius: BorderRadius.circular(0.0),
                              child: FadeInImage(
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.fill,
                                image: imageProvider,
                                placeholder: const AssetImage(
                                    "assets/images/placeholder.jpg"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/error.png',
                                    fit: BoxFit.fill,
                                    height: double.infinity,
                                    width: double.infinity,
                                  );
                                },
                              ),
                            ),
                            placeholder: (context, url) => const FadeInImage(
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.fill,
                              image:
                                  AssetImage("assets/images/placeholder.jpg"),
                              placeholder:
                                  AssetImage("assets/images/placeholder.jpg"),
                            ),
                            errorWidget: (context, url, error) =>
                                const FadeInImage(
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.fill,
                              image: AssetImage("assets/images/error.png"),
                              placeholder:
                                  AssetImage("assets/images/placeholder.jpg"),
                            ),
                          ),
                          maxScale: 3.5,
                          panEnabled: false,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.60, // 45% of total width
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0)),
                      child: FadeInImage(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                        image:
                            NetworkImage(cubit.chatListReversed[index].message),
                        placeholder:
                            const AssetImage("assets/images/placeholder.jpg"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/error.png',
                            fit: BoxFit.fill,
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : fileMessageView(cubit, index);
  }

  Widget fileMessageView(SocialConversationCubit cubit, int index) {
    if (cubit.chatListReversed[index].type == "file") {
      return Align(
        alignment: cubit.chatListReversed[index].receiverID == "Future Of Egypt"
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.65, // 45% of total width
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color:
                  cubit.chatListReversed[index].receiverID == "Future Of Egypt"
                      ? Colors.grey.shade200
                      : Colors.teal,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: cubit.chatListReversed[index].receiverID ==
                            "Future Of Egypt"
                        ? InkWell(
                            onTap: () {
                              if (cubit.checkForDocumentFile(
                                  cubit.chatListReversed[index].fileName,
                                  widget.userName)) {
                                OpenFile.open(
                                    "/storage/emulated/0/Download/Future Of Egypt Media/Documents/${widget.userName}/${cubit.chatListReversed[index].fileName}");
                              } else {
                                cubit
                                    .downloadDocumentFile(
                                        cubit.chatListReversed[index].fileName,
                                        widget.userID,
                                        "Future Of Egypt",
                                        widget.userName)
                                    .then((value) {
                                  OpenFile.open(
                                      "/storage/emulated/0/Download/Future Of Egypt Media/Documents/${widget.userName}/${cubit.chatListReversed[index].fileName}");
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BuildCondition(
                                      condition: cubit.downloadingFileName ==
                                          cubit
                                              .chatListReversed[index].fileName,
                                      fallback: (context) => Icon(
                                        IconlyBroken.document,
                                        color: cubit.chatListReversed[index]
                                                    .receiverID ==
                                                "Future Of Egypt"
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      builder: (context) =>
                                          CircularProgressIndicator(
                                        color: cubit.chatListReversed[index]
                                                    .receiverID ==
                                                "Future Of Egypt"
                                            ? Colors.black
                                            : Colors.white,
                                        strokeWidth: 0.8,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        cubit.chatListReversed[index].fileName,
                                        style: TextStyle(
                                          color: cubit.chatListReversed[index]
                                                      .receiverID ==
                                                  "Future Of Egypt"
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 14,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              if (cubit.checkForDocumentFile(
                                  cubit.chatListReversed[index].fileName,
                                  widget.userName)) {
                                OpenFile.open(
                                    "/storage/emulated/0/Download/Future Of Egypt Media/Documents/${widget.userName}/${cubit.chatListReversed[index].fileName}");
                              } else {
                                cubit
                                    .downloadDocumentFile(
                                        cubit.chatListReversed[index].fileName,
                                        "Future Of Egypt",
                                        widget.userID,
                                        widget.userName)
                                    .then((value) {
                                  OpenFile.open(
                                      "/storage/emulated/0/Download/Future Of Egypt Media/Documents/${widget.userName}/${cubit.chatListReversed[index].fileName}");
                                });
                              }
                            },
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BuildCondition(
                                      condition: cubit.downloadingFileName ==
                                          cubit
                                              .chatListReversed[index].fileName,
                                      fallback: (context) => Icon(
                                        IconlyBroken.document,
                                        color: cubit.chatListReversed[index]
                                                    .receiverID ==
                                                "Future Of Egypt"
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      builder: (context) =>
                                          CircularProgressIndicator(
                                        color: cubit.chatListReversed[index]
                                                    .receiverID ==
                                                "Future Of Egypt"
                                            ? Colors.black
                                            : Colors.white,
                                        strokeWidth: 0.8,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        cubit.chatListReversed[index].fileName,
                                        style: TextStyle(
                                          color: cubit.chatListReversed[index]
                                                      .receiverID ==
                                                  "Future Of Egypt"
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 14,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                )),
          ),
        ),
      );
    } else {
      return audioConversationManagement(context, index, cubit);
    }
  }

  Widget audioConversationManagement(BuildContext itemBuilderContext, int index,
      SocialConversationCubit cubit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onLongPress: () async {},
          child: Container(
            margin:
                cubit.chatListReversed[index].receiverID == "Future Of Egypt"
                    ? EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 8,
                        left: 5.0,
                        top: 5.0,
                      )
                    : EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 8,
                        right: 5.0,
                        top: 5.0,
                      ),
            alignment:
                cubit.chatListReversed[index].receiverID == "Future Of Egypt"
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
            child: Container(
              height: 70.0,
              width: 250.0,
              decoration: BoxDecoration(
                color: cubit.chatListReversed[index].receiverID ==
                        "Future Of Egypt"
                    ? Colors.grey.shade200
                    : Colors.teal,
                borderRadius: cubit.chatListReversed[index].receiverID ==
                        "Future Of Egypt"
                    ? const BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(40.0),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(30.0),
                      ),
              ),
              child: cubit.chatListReversed[index].receiverID == "Future Of Egypt" ? Row(
                children: [
                  const SizedBox(
                    width: 8.0,
                  ),
                  GestureDetector(
                    onLongPress: () => cubit.chatMicrophoneOnLongPressAction(),
                    onTap: () {
                      if (cubit.chatListReversed[index].receiverID ==
                          "Future Of Egypt") {
                        if (cubit.checkForAudioFile(
                            cubit.chatListReversed[index].fileName,
                            widget.userName)) {
                          cubit.chatMicrophoneOnTapAction(
                              index, cubit.chatListReversed[index].fileName,widget.userName);
                        } else {
                          cubit.downloadAudioFile(
                              cubit.chatListReversed[index].fileName,
                              widget.userID,
                              "Future Of Egypt",
                              cubit.userName,
                              index);
                        }
                      } else {
                        if (cubit.checkForAudioFile(
                            cubit.chatListReversed[index].fileName,
                            widget.userName)) {
                          cubit.chatMicrophoneOnTapAction(
                              index, cubit.chatListReversed[index].fileName,widget.userName);
                        } else {
                          cubit.downloadAudioFile(
                              cubit.chatListReversed[index].fileName,
                              "Future Of Egypt",
                              widget.userID,
                              cubit.userName,
                              index);
                        }
                      }
                    },
                    child: Icon(
                      index == cubit.lastAudioPlayingIndex
                          ? cubit.iconData
                          : Icons.play_arrow_rounded,
                      color: cubit.chatListReversed[index].receiverID == "Future Of Egypt" ? Colors.teal : Colors.white.withOpacity(0.8),
                      size: 40.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: 26.0,
                            ),
                            child: LinearPercentIndicator(
                              percent: cubit.justAudioPlayer.duration == null
                                  ? 0.0
                                  : cubit.lastAudioPlayingIndex == index
                                      ? cubit.currAudioPlayingTime /
                                                  cubit.justAudioPlayer
                                                      .duration!.inMicroseconds
                                                      .ceilToDouble() <=
                                              1.0
                                          ? cubit.currAudioPlayingTime /
                                              cubit.justAudioPlayer.duration!
                                                  .inMicroseconds
                                                  .ceilToDouble()
                                          : 0.0
                                      : 0,
                              barRadius: const Radius.circular(8.0),
                              lineHeight: 3.5,
                              backgroundColor:
                                  cubit.chatListReversed[index].receiverID ==
                                          "Future Of Egypt"
                                      ? Colors.teal
                                      : Colors.white.withOpacity(0.8),
                              progressColor:
                                  cubit.chatListReversed[index].receiverID ==
                                          "Future Of Egypt"
                                      ? Colors.blue
                                      : Colors.amber,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 7.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      cubit.lastAudioPlayingIndex == index
                                          ? cubit.loadingTime
                                          : '0:00',
                                      style: TextStyle(
                                        color: cubit.chatListReversed[index]
                                                    .receiverID ==
                                                "Future Of Egypt"
                                            ? Colors.teal
                                            : Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      cubit.lastAudioPlayingIndex == index
                                          ? cubit.totalDuration
                                          : '',
                                      style: TextStyle(
                                        color: cubit.chatListReversed[index]
                                                    .receiverID ==
                                                "Future Of Egypt"
                                            ? Colors.teal
                                            : Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: CircleAvatar(
                        radius: 23.0,
                        backgroundColor:
                            cubit.chatListReversed[index].receiverID ==
                                    "Future Of Egypt"
                                ? const Color.fromRGBO(60, 80, 100, 1)
                                : const Color.fromRGBO(102, 102, 255, 1),
                        backgroundImage: const ExactAssetImage(
                          "assets/images/me.jpg",
                        ),
                        child: CachedNetworkImage(
                          imageUrl: cubit.chatListReversed[index].receiverID ==
                                  "Future Of Egypt"
                              ? widget.userImage
                              : cubit.userImageUrl,
                          imageBuilder: (context, imageProvider) => ClipOval(
                            child: FadeInImage(
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                              image: imageProvider,
                              placeholder: const AssetImage(
                                  "assets/images/placeholder.jpg"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/error.png',
                                  fit: BoxFit.fill,
                                  height: 50,
                                  width: 50,
                                );
                              },
                            ),
                          ),
                          placeholder: (context, url) => const FadeInImage(
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                            image: AssetImage("assets/images/placeholder.jpg"),
                            placeholder:
                                AssetImage("assets/images/placeholder.jpg"),
                          ),
                          errorWidget: (context, url, error) =>
                              const FadeInImage(
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                            image: AssetImage("assets/images/error.png"),
                            placeholder:
                                AssetImage("assets/images/placeholder.jpg"),
                          ),
                        ),
                      ),
                  ),
                ],
              ) : Row(
                children: [
                  const SizedBox(
                    width: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: CircleAvatar(
                      radius: 23.0,
                      backgroundColor:
                      cubit.chatListReversed[index].receiverID ==
                          "Future Of Egypt"
                          ? const Color.fromRGBO(60, 80, 100, 1)
                          : const Color.fromRGBO(102, 102, 255, 1),
                      backgroundImage: const ExactAssetImage(
                        "assets/images/me.jpg",
                      ),
                      child: CachedNetworkImage(
                        imageUrl: cubit.chatListReversed[index].receiverID ==
                            "Future Of Egypt"
                            ? widget.userImage
                            : cubit.userImageUrl,
                        imageBuilder: (context, imageProvider) => ClipOval(
                          child: FadeInImage(
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                            image: imageProvider,
                            placeholder: const AssetImage(
                                "assets/images/placeholder.jpg"),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/error.png',
                                fit: BoxFit.fill,
                                height: 50,
                                width: 50,
                              );
                            },
                          ),
                        ),
                        placeholder: (context, url) => const FadeInImage(
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/placeholder.jpg"),
                          placeholder:
                          AssetImage("assets/images/placeholder.jpg"),
                        ),
                        errorWidget: (context, url, error) =>
                        const FadeInImage(
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/error.png"),
                          placeholder:
                          AssetImage("assets/images/placeholder.jpg"),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onLongPress: () => cubit.chatMicrophoneOnLongPressAction(),
                    onTap: () {
                      if (cubit.chatListReversed[index].receiverID ==
                          "Future Of Egypt") {
                        if (cubit.checkForAudioFile(cubit.chatListReversed[index].fileName,widget.userName))
                        {
                          cubit.chatMicrophoneOnTapAction(
                              index, cubit.chatListReversed[index].fileName,widget.userName);
                        } else {
                          cubit.downloadAudioFile(
                              cubit.chatListReversed[index].fileName,
                              widget.userID,
                              "Future Of Egypt",
                              cubit.userName,
                              index);
                        }
                      } else {
                        if (cubit.checkForAudioFile(
                            cubit.chatListReversed[index].fileName,
                            widget.userName)) {
                          cubit.chatMicrophoneOnTapAction(
                              index, cubit.chatListReversed[index].fileName,widget.userName);
                        } else {
                          cubit.downloadAudioFile(
                              cubit.chatListReversed[index].fileName,
                              "Future Of Egypt",
                              widget.userID,
                              widget.userName,
                              index);
                        }
                      }
                    },
                    child: Icon(
                      index == cubit.lastAudioPlayingIndex
                          ? cubit.iconData
                          : Icons.play_arrow_rounded,
                      color: cubit.chatListReversed[index].receiverID == "Future Of Egypt" ? Colors.teal : Colors.white.withOpacity(0.8),
                      size: 40.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: 26.0,
                            ),
                            child: LinearPercentIndicator(
                              percent: cubit.justAudioPlayer.duration == null
                                  ? 0.0
                                  : cubit.lastAudioPlayingIndex == index
                                  ? cubit.currAudioPlayingTime /
                                  cubit.justAudioPlayer
                                      .duration!.inMicroseconds
                                      .ceilToDouble() <=
                                  1.0
                                  ? cubit.currAudioPlayingTime /
                                  cubit.justAudioPlayer.duration!
                                      .inMicroseconds
                                      .ceilToDouble()
                                  : 0.0
                                  : 0,
                              barRadius: const Radius.circular(8.0),
                              lineHeight: 3.5,
                              backgroundColor:
                              cubit.chatListReversed[index].receiverID ==
                                  "Future Of Egypt"
                                  ? Colors.teal
                                  : Colors.white.withOpacity(0.8),
                              progressColor:
                              cubit.chatListReversed[index].receiverID ==
                                  "Future Of Egypt"
                                  ? Colors.blue
                                  : Colors.amber,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 10.0, right: 7.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      cubit.lastAudioPlayingIndex == index
                                          ? cubit.loadingTime
                                          : '0:00',
                                      style: TextStyle(
                                        color: cubit.chatListReversed[index]
                                            .receiverID ==
                                            "Future Of Egypt"
                                            ? Colors.teal
                                            : Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      cubit.lastAudioPlayingIndex == index
                                          ? cubit.totalDuration
                                          : '',
                                      style: TextStyle(
                                        color: cubit.chatListReversed[index]
                                            .receiverID ==
                                            "Future Of Egypt"
                                            ? Colors.teal
                                            : Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0,)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}