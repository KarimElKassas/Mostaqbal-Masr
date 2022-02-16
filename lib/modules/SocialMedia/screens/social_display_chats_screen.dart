import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_display_chats_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_display_chats_states.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/screens/social_conversation_screen.dart';
import 'package:mostaqbal_masr/shared/constants.dart';

class SocialDisplayChats extends StatefulWidget {
  const SocialDisplayChats({Key? key}) : super(key: key);

  @override
  State<SocialDisplayChats> createState() => _SocialDisplayChatsState();
}

class _SocialDisplayChatsState extends State<SocialDisplayChats> {
  var searchController = TextEditingController();

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialDisplayChatsCubit()..getChats(),
      child: BlocConsumer<SocialDisplayChatsCubit, SocialDisplayChatsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SocialDisplayChatsCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 0.0,
              toolbarHeight: 0.0,
              backgroundColor: Colors.transparent,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, right: 12.0, left: 12.0),
                      child: SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          textAlignVertical: TextAlignVertical.center,
                          textDirection: TextDirection.rtl,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          autofocus: false,
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                            });

                            cubit.searchChat(value);
                          },
                          style: TextStyle(
                              color: greyThreeColor,
                              fontFamily: "Open Sans",
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: greyFiveColor,
                            hintText: 'بحث ..',
                            hintStyle: TextStyle(
                                color: greyThreeColor,
                                fontFamily: "Open Sans",
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            alignLabelWithHint: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: greyBorderColor, width: 1.0),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12.0))),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: greyBorderColor, width: 1.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: greyBorderColor, width: 1.0),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12.0))),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    BuildCondition(
                      condition: state is SocialDisplayChatsLoadingChatsState,
                      builder: (context) => Center(
                        child: CircularProgressIndicator(
                          color: Colors.teal[700],
                        ),
                      ),
                      fallback: (context) => ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) =>
                            listItem(context, cubit, state, index),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10.0),
                        itemCount: cubit.filteredUserList.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listItem(
      BuildContext context, SocialDisplayChatsCubit cubit, state, int index) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        shadowColor: Colors.black,
        child: InkWell(
          onTap: () {
            cubit.goToConversation(
                context,
                SocialConversationScreen(
                    userID: cubit.filteredUserList[index].userID,
                    userName: cubit.filteredUserList[index].userName,
                    userImage: cubit.filteredUserList[index].userImage));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                BuildCondition(
                  condition: state is SocialDisplayChatsLoadingChatsState,
                  builder: (context) => const Center(
                      child: CircularProgressIndicator(
                    color: Colors.teal,
                  )),
                  fallback: (context) => InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return SlideInUp(
                                duration: const Duration(milliseconds: 500),
                                child: Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) {
                                                return CachedNetworkImage(
                                                  imageUrl: cubit
                                                      .filteredUserList[index]
                                                      .userImage,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    child: FadeInImage(
                                                      height: double.infinity,
                                                      width: double.infinity,
                                                      fit: BoxFit.fill,
                                                      image: imageProvider,
                                                      placeholder: const AssetImage(
                                                          "assets/images/placeholder.jpg"),
                                                      imageErrorBuilder:
                                                          (context, error,
                                                              stackTrace) {
                                                        return Image.asset(
                                                          'assets/images/error.png',
                                                          fit: BoxFit.fill,
                                                          height:
                                                              double.infinity,
                                                          width:
                                                              double.infinity,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      const FadeInImage(
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        "assets/images/placeholder.jpg"),
                                                    placeholder: AssetImage(
                                                        "assets/images/placeholder.jpg"),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const FadeInImage(
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        "assets/images/error.png"),
                                                    placeholder: AssetImage(
                                                        "assets/images/placeholder.jpg"),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: cubit
                                              .filteredUserList[index]
                                              .userImage,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: FadeInImage(
                                              height: 400,
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
                                                  height: 50,
                                                  width: 50,
                                                );
                                              },
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const FadeInImage(
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "assets/images/placeholder.jpg"),
                                            placeholder: AssetImage(
                                                "assets/images/placeholder.jpg"),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const FadeInImage(
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "assets/images/error.png"),
                                            placeholder: AssetImage(
                                                "assets/images/placeholder.jpg"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: cubit.filteredUserList[index].userImage,
                      imageBuilder: (context, imageProvider) => ClipOval(
                        child: FadeInImage(
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                          image: imageProvider,
                          placeholder:
                              const AssetImage("assets/images/placeholder.jpg"),
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
                      errorWidget: (context, url, error) => const FadeInImage(
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
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        cubit.filteredUserList[index].userName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        cubit.filteredUserList[index].userState == "يكتب ..."
                            ? "يكتب ..."
                            : cubit.filteredUserList[index].userLastMessage,
                        style: TextStyle(
                          color: cubit.filteredUserList[index].userState ==
                                  "يكتب ..."
                              ? Colors.teal
                              : Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w200,
                          overflow: TextOverflow.ellipsis,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  flex: 1,
                  child: ValueListenableBuilder(
                      valueListenable: lastMessageTimeValue,
                      builder: (context, value, widget) {
                        return Text(
                          cubit.filteredUserList[index].userState == "يكتب ..."
                              ? ""
                              : cubit
                                  .filteredUserList[index].userLastMessageTime,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w200,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textDirection: TextDirection.ltr,
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
