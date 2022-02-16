import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:galleryimage/gallery_Item_model.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/cubit/conversation/it_group_conversation_cubit.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/cubit/conversation/it_group_conversation_states.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/screens/it_input_field_widget.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/gallery_item_thumbnail.dart';
import 'package:mostaqbal_masr/shared/gallery_item_wrapper_view.dart';
import 'package:open_file/open_file.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class ITGroupConversationScreen extends StatefulWidget {
  final String groupID;
  final String groupName;
  final String groupImage;

  const ITGroupConversationScreen(
      {Key? key,
      required this.groupID,
      required this.groupName,
      required this.groupImage})
      : super(key: key);

  @override
  State<ITGroupConversationScreen> createState() => _ITGroupConversationScreenState();
}

class _ITGroupConversationScreenState extends State<ITGroupConversationScreen> {
  List<GalleryItemModel> galleryItems = <GalleryItemModel>[];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ITGroupConversationCubit(),
      child: BlocConsumer<ITGroupConversationCubit, ITGroupConversationStates>(
        listener: (context, state) {
          if (state is ITGroupConversationSendMessageErrorState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if (state is ITGroupConversationDownloadFileErrorState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
        },
        builder: (context, state) {
          var cubit = ITGroupConversationCubit.get(context);

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
                            imageUrl: widget.groupImage,
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
                                  widget.groupName,
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
                            onPressed: () {},
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
                          condition: state is ITGroupConversationLoadingMessageState,
                          fallback: (context) => ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: cubit.chatListReversed.length,
                              itemBuilder: (context, index) =>
                                  chatView(context, cubit, index, state)),
                          builder: (context) => const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.teal,
                                ),
                              )),
                    ),
                  ),
                  ITGroupInputFieldWidget(userID: widget.groupID),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget chatView(BuildContext context, ITGroupConversationCubit cubit, int index,
      ITGroupConversationStates state) {
    return cubit.chatListReversed[index].type == "Text"
        ? Container(
            padding:
                const EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 10),
            child: Align(
              alignment:
                  (cubit.chatListReversed[index].receiverID == "Future Of Egypt"
                      ? Alignment.topRight
                      : Alignment.topLeft),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (cubit.chatListReversed[index].receiverID ==
                          "Future Of Egypt"
                      ? Colors.teal
                      : Colors.grey.shade200),
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
                            ? Colors.white
                            : Colors.black,
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
                            ? Colors.white
                            : Colors.black,
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
        : galleryImageMessageView(context, cubit, index, state);
}

  Widget imageMessageView(BuildContext context, ITGroupConversationCubit cubit,
      int index, ITGroupConversationStates state) {
    return cubit.chatListReversed[index].type == "Image"
        ? Align(
            alignment: cubit.chatListReversed[index].receiverID == cubit.userID
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
                            imageUrl: cubit.chatListReversed[index].messageImages![0]
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", ""),
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
                            NetworkImage(cubit.chatListReversed[index].messageImages![0]
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "")),
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

  Widget multipleImageMessageView(BuildContext context, ITGroupConversationCubit cubit,
      int index, ITGroupConversationStates state) {
    if (cubit.chatListReversed[index].type == "Image") {
      return Align(
      alignment: cubit.chatListReversed[index].receiverID == cubit.userID
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
                      imageUrl: cubit.chatListReversed[index].messageImages![0]
                          .toString()
                          .replaceAll("[", "")
                          .replaceAll("]", ""),
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
                0.65, // 45% of total width
            height: 300,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.teal
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0)),
                  child: FadeInImage(
                    height: 140,
                    width: MediaQuery.of(context).size.width *
                        0.60 * 0.5,
                    fit: BoxFit.fill,
                    image:
                    NetworkImage(cubit.chatListReversed[index].messageImages![0]
                        .toString()
                        .replaceAll("[", "")
                        .replaceAll("]", "")),
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
      ),
    );
    } else {
      return fileMessageView(cubit, index);
    }
  }

  Widget galleryImageMessageView(BuildContext context, ITGroupConversationCubit cubit,
      int index, ITGroupConversationStates state) {
    if (cubit.chatListReversed[index].type == "Image") {
      return Align(
        alignment: cubit.chatListReversed[index].receiverID == cubit.userID
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.65, // 45% of total width
            height: 300,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.teal
            ),
            child: Padding(
                padding: const EdgeInsets.all(4),
                child: cubit.chatListReversed[index].messageImages!.isEmpty
                    ? getEmptyWidget()
                    : GridView.builder(
                    primary: false,
                    itemCount: cubit.chatListReversed[index].messageImages!.length > 3 ? 3 : cubit.chatListReversed[index].messageImages!.length,
                    padding: const EdgeInsets.all(0),
                    semanticChildCount: 1,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 3),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          // if have less than 4 image we build GalleryItemThumbnail
                          // if have mor than 4 build image number 3 with number for other images
                          child: cubit.chatListReversed[index].messageImages!.length > 3 && index == 2
                              ? buildImageNumbers(index,cubit)
                              : GalleryThumbnail(
                            galleryItem: cubit.chatListReversed[index].messageImages![index]!,
                            onTap: () {
                              openImageFullScreen(index, cubit);
                            },
                          ));
                    })),
          ),
        ),
      );
    } else {
      return fileMessageView(cubit, index);
    }
  }

  Widget fileMessageView(ITGroupConversationCubit cubit, int index) {
    return cubit.chatListReversed[index].type == "file"
        ? Align(
            alignment:
                cubit.chatListReversed[index].receiverID == "Future Of Egypt"
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.65, // 45% of total width
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: cubit.chatListReversed[index].receiverID ==
                          "Future Of Egypt"
                      ? Colors.teal
                      : Colors.grey.shade200,
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
                                      cubit.chatListReversed[index].fileName)) {
                                    OpenFile.open(
                                        "/storage/emulated/0/Download/Future Of Egypt Media/Documents/${cubit.userName}/${cubit.chatListReversed[index].fileName}");
                                  } else {
                                    cubit
                                        .downloadDocumentFile(
                                            cubit.chatListReversed[index]
                                                .fileName,
                                            cubit.userID,
                                            "Future Of Egypt")
                                        .then((value) {
                                      OpenFile.open(
                                          "/storage/emulated/0/Download/Future Of Egypt Media/Documents/${cubit.userName}/${cubit.chatListReversed[index].fileName}");
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BuildCondition(
                                        condition: cubit.downloadingFileName ==
                                            cubit.chatListReversed[index]
                                                .fileName,
                                        fallback: (context) => Icon(
                                          IconlyBroken.document,
                                          color: cubit.chatListReversed[index]
                                                      .receiverID ==
                                                  "Future Of Egypt"
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        builder: (context) =>
                                            CircularProgressIndicator(
                                          color: cubit.chatListReversed[index]
                                                      .receiverID ==
                                                  "Future Of Egypt"
                                              ? Colors.white
                                              : Colors.black,
                                          strokeWidth: 0.8,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          cubit
                                              .chatListReversed[index].fileName,
                                          style: TextStyle(
                                            color: cubit.chatListReversed[index]
                                                        .receiverID ==
                                                    "Future Of Egypt"
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  if (cubit.checkForDocumentFile(
                                      cubit.chatListReversed[index].fileName)) {
                                    OpenFile.open(
                                        "/storage/emulated/0/Download/Future Of Egypt Media/Documents/${cubit.userName}/${cubit.chatListReversed[index].fileName}");
                                  } else {
                                    cubit
                                        .downloadDocumentFile(
                                            cubit.chatListReversed[index]
                                                .fileName,
                                            "Future Of Egypt",
                                            cubit.userID)
                                        .then((value) {
                                      OpenFile.open(
                                          "/storage/emulated/0/Download/Future Of Egypt Media/${cubit.userName}/${cubit.chatListReversed[index].fileName}");
                                    });
                                  }
                                },
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BuildCondition(
                                          condition:
                                              cubit.downloadingFileName ==
                                                  cubit.chatListReversed[index]
                                                      .fileName,
                                          fallback: (context) => Icon(
                                            IconlyBroken.document,
                                            color: cubit.chatListReversed[index]
                                                        .receiverID ==
                                                    "Future Of Egypt"
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          builder: (context) =>
                                              CircularProgressIndicator(
                                            color: cubit.chatListReversed[index]
                                                        .receiverID ==
                                                    "Future Of Egypt"
                                                ? Colors.white
                                                : Colors.black,
                                            strokeWidth: 0.8,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            cubit.chatListReversed[index]
                                                .fileName,
                                            style: TextStyle(
                                              color:
                                                  cubit.chatListReversed[index]
                                                              .receiverID ==
                                                          "Future Of Egypt"
                                                      ? Colors.white
                                                      : Colors.black,
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
          )
        : audioConversationManagement(context, index, cubit);
  }

  Widget audioConversationManagement(
      BuildContext itemBuilderContext, int index, ITGroupConversationCubit cubit) {
    return Padding(
      padding: const EdgeInsets.only(top : 4, right: 2, left: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onLongPress: () async {},
            child: Container(
              margin:
                  cubit.chatListReversed[index].receiverID == "Future Of Egypt"
                      ? EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 8,
                          right: 5.0,
                          top: 5.0,
                        )
                      : EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 8,
                          left: 5.0,
                          top: 5.0,
                        ),
              alignment:
                  cubit.chatListReversed[index].receiverID == "Future Of Egypt"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
              child: Container(
                height: 70.0,
                width: 250.0,
                decoration: BoxDecoration(
                  color: cubit.chatListReversed[index].receiverID ==
                          "Future Of Egypt"
                      ? Colors.teal
                      : Colors.grey.shade200,
                  borderRadius: cubit.chatListReversed[index].receiverID ==
                          "Future Of Egypt"
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(30.0),
                        )
                      : const BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                ),
                child: cubit.chatListReversed[index].receiverID ==
                        "Future Of Egypt"
                    ? Row(
                        children: [
                          const SizedBox(
                            width: 8.0,
                          ),
                          GestureDetector(
                            onLongPress: () =>
                                cubit.chatMicrophoneOnLongPressAction(),
                            onTap: () {
                              if (cubit.chatListReversed[index].receiverID ==
                                  "Future Of Egypt") {
                                if (cubit.checkForAudioFile(
                                    cubit.chatListReversed[index].fileName)) {
                                  cubit.chatMicrophoneOnTapAction(index,
                                      cubit.chatListReversed[index].fileName);
                                } else {
                                  cubit.downloadAudioFile(
                                      cubit.chatListReversed[index].fileName,
                                      cubit.userID,
                                      "Future Of Egypt",
                                      index);
                                }
                              } else {
                                if (cubit.checkForAudioFile(
                                    cubit.chatListReversed[index].fileName)) {
                                  cubit.chatMicrophoneOnTapAction(index,
                                      cubit.chatListReversed[index].fileName);
                                } else {
                                  cubit.downloadAudioFile(
                                      cubit.chatListReversed[index].fileName,
                                      "Future Of Egypt",
                                      cubit.userID,
                                      index);
                                }
                              }
                            },
                            child: BuildCondition(
                              condition: cubit.downloadingFileName ==
                                  cubit.chatListReversed[index].fileName,
                              builder: (context) => CircularProgressIndicator(
                                color: cubit.chatListReversed[index].receiverID ==
                                        "Future Of Egypt"
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.teal,
                                strokeWidth: 0.8,
                              ),
                              fallback: (context) => Icon(
                                index == cubit.lastAudioPlayingIndex
                                    ? cubit.iconData
                                    : Icons.play_arrow_rounded,
                                color: cubit.chatListReversed[index].receiverID ==
                                        "Future Of Egypt"
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.teal,
                                size: 40.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 26.0,
                                    ),
                                    child: LinearPercentIndicator(
                                      percent: cubit.justAudioPlayer.duration ==
                                              null
                                          ? 0.0
                                          : cubit.lastAudioPlayingIndex == index
                                              ? cubit.currAudioPlayingTime /
                                                          cubit
                                                              .justAudioPlayer
                                                              .duration!
                                                              .inMicroseconds
                                                              .ceilToDouble() <=
                                                      1.0
                                                  ? cubit.currAudioPlayingTime /
                                                      cubit
                                                          .justAudioPlayer
                                                          .duration!
                                                          .inMicroseconds
                                                          .ceilToDouble()
                                                  : 0.0
                                              : 0,
                                      barRadius: const Radius.circular(8.0),
                                      lineHeight: 3.5,
                                      backgroundColor: cubit
                                                  .chatListReversed[index]
                                                  .receiverID ==
                                              "Future Of Egypt"
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.teal,
                                      progressColor: cubit.chatListReversed[index]
                                                  .receiverID ==
                                              "Future Of Egypt"
                                          ? Colors.blue
                                          : Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 7.0, right: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              cubit.lastAudioPlayingIndex == index
                                                  ? cubit.loadingTime
                                                  : '0:00',
                                              style: TextStyle(
                                                color:
                                                    cubit.chatListReversed[index]
                                                                .receiverID ==
                                                            "Future Of Egypt"
                                                        ? Colors.white
                                                            .withOpacity(0.8)
                                                        : Colors.teal,
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
                                                color:
                                                    cubit.chatListReversed[index]
                                                                .receiverID ==
                                                            "Future Of Egypt"
                                                        ? Colors.white
                                                            .withOpacity(0.8)
                                                        : Colors.teal,
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
                            padding: const EdgeInsets.only(right: 8.0),
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
                                imageUrl:
                                    cubit.chatListReversed[index].receiverID ==
                                            "Future Of Egypt"
                                        ? cubit.userImageUrl
                                        : widget.groupImage,
                                imageBuilder: (context, imageProvider) =>
                                    ClipOval(
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
                                placeholder: (context, url) => Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.teal,
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
                      )
                    : Row(
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
                                imageUrl:
                                    cubit.chatListReversed[index].receiverID ==
                                            "Future Of Egypt"
                                        ? cubit.userImageUrl
                                        : widget.groupImage,
                                imageBuilder: (context, imageProvider) =>
                                    ClipOval(
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
                                placeholder: (context, url) => Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey.shade200,
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
                            onLongPress: () =>
                                cubit.chatMicrophoneOnLongPressAction(),
                            onTap: () {
                              if (cubit.chatListReversed[index].receiverID ==
                                  "Future Of Egypt") {
                                if (cubit.checkForAudioFile(
                                    cubit.chatListReversed[index].fileName)) {
                                  cubit.chatMicrophoneOnTapAction(index,
                                      cubit.chatListReversed[index].fileName);
                                } else {
                                  cubit.downloadAudioFile(
                                      cubit.chatListReversed[index].fileName,
                                      widget.groupID,
                                      "Future Of Egypt",
                                      index);
                                }
                              } else {
                                if (cubit.checkForAudioFile(
                                    cubit.chatListReversed[index].fileName)) {
                                  cubit.chatMicrophoneOnTapAction(index,
                                      cubit.chatListReversed[index].fileName);
                                } else {
                                  cubit.downloadAudioFile(
                                      cubit.chatListReversed[index].fileName,
                                      "Future Of Egypt",
                                      widget.groupID,
                                      index);
                                }
                              }
                            },
                            child: BuildCondition(
                              condition: cubit.downloadingFileName ==
                                  cubit.chatListReversed[index].fileName,
                              builder: (context) => CircularProgressIndicator(
                                color: cubit.chatListReversed[index].receiverID ==
                                        "Future Of Egypt"
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.teal,
                                strokeWidth: 0.8,
                              ),
                              fallback: (context) => Icon(
                                index == cubit.lastAudioPlayingIndex
                                    ? cubit.iconData
                                    : Icons.play_arrow_rounded,
                                color: cubit.chatListReversed[index].receiverID ==
                                        "Future Of Egypt"
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.teal,
                                size: 40.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 26.0,
                                    ),
                                    child: LinearPercentIndicator(
                                      percent: cubit.justAudioPlayer.duration ==
                                              null
                                          ? 0.0
                                          : cubit.lastAudioPlayingIndex == index
                                              ? cubit.currAudioPlayingTime /
                                                          cubit
                                                              .justAudioPlayer
                                                              .duration!
                                                              .inMicroseconds
                                                              .ceilToDouble() <=
                                                      1.0
                                                  ? cubit.currAudioPlayingTime /
                                                      cubit
                                                          .justAudioPlayer
                                                          .duration!
                                                          .inMicroseconds
                                                          .ceilToDouble()
                                                  : 0.0
                                              : 0,
                                      barRadius: const Radius.circular(8.0),
                                      lineHeight: 3.5,
                                      backgroundColor: cubit
                                                  .chatListReversed[index]
                                                  .receiverID ==
                                              "Future Of Egypt"
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.teal,
                                      progressColor: cubit.chatListReversed[index]
                                                  .receiverID ==
                                              "Future Of Egypt"
                                          ? Colors.blue
                                          : Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, left: 7.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              cubit.lastAudioPlayingIndex == index
                                                  ? cubit.loadingTime
                                                  : '0:00',
                                              style: TextStyle(
                                                color:
                                                    cubit.chatListReversed[index]
                                                                .receiverID ==
                                                            "Future Of Egypt"
                                                        ? Colors.white
                                                            .withOpacity(0.8)
                                                        : Colors.teal,
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
                                                color:
                                                    cubit.chatListReversed[index]
                                                                .receiverID ==
                                                            "Future Of Egypt"
                                                        ? Colors.white
                                                            .withOpacity(0.8)
                                                        : Colors.teal,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        )
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
      ),
    );
  }

  Widget buildImageNumbers(int index, ITGroupConversationCubit cubit) {
    return GestureDetector(
      onTap: () {
        openImageFullScreen(index, cubit);
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          GalleryThumbnail(
            galleryItem: cubit.chatListReversed[index].messageImages![index]!,
          ),
          Container(
            color: Colors.black.withOpacity(.7),
            child: Center(
              child: Text(
                "+ ${cubit.chatListReversed[index].messageImages!.length - index}",
                style: const TextStyle(color: Colors.white, fontSize: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openImageFullScreen(final int indexOfImage, ITGroupConversationCubit cubit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageWrapper(
          titleGallery: "",
          galleryItems: cubit.chatListReversed[indexOfImage].messageImages!,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: 0,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
