import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/cubit/display_groups_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/cubit/display_groups_states.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/cubit/group_details_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/cubit/group_details_states.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/screens/group_conversation_screen.dart';
import 'package:mostaqbal_masr/shared/constants.dart';

class GroupDetailsScreen extends StatefulWidget {

  final String groupID, groupImage, groupName, membersCount;
  final List<Object?> membersList, adminsList;

  const GroupDetailsScreen({
    Key? key,
    required this.groupID,
    required this.groupName,
    required this.groupImage,
    required this.membersList,
    required this.adminsList,
    required this.membersCount,
  }) : super(key: key);

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetailsScreen> {
  var searchController = TextEditingController();

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupDetailsCubit()..getGroups(),
      child: BlocConsumer<GroupDetailsCubit, GroupDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = GroupDetailsCubit.get(context);

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
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    color: const Color(0xff141C27),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 48.0, ),
                            child: CachedNetworkImage(
                              imageUrl: widget.groupImage,
                              imageBuilder: (context, imageProvider) => ClipOval(
                                child: FadeInImage(
                                  height: 140,
                                  width: 140,
                                  fit: BoxFit.fill,
                                  image: imageProvider,
                                  placeholder: const AssetImage(
                                      "assets/images/placeholder.jpg"),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/error.png',
                                      fit: BoxFit.fill,
                                      height: 140,
                                      width: 140,
                                    );
                                  },
                                ),
                              ),
                              placeholder: (context, url) => const CircularProgressIndicator(color: Colors.teal, strokeWidth: 0.8,),
                              errorWidget: (context, url, error) =>
                              const FadeInImage(
                                height: 140,
                                width: 140,
                                fit: BoxFit.fill,
                                image: AssetImage("assets/images/error.png"),
                                placeholder:
                                AssetImage("assets/images/placeholder.jpg"),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.groupName,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          " اعضاء ${widget.membersCount} مجموعة ",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff939190)),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listItem(
      BuildContext context, GroupDetailsCubit cubit, state, int index) {
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
                GroupConversationScreen(
                    groupID: cubit.filteredGroupList[index].groupID,
                    groupName: cubit.filteredGroupList[index].groupName,
                    groupImage: cubit.filteredGroupList[index].groupImage,
                    adminsList: cubit.filteredGroupList[index].adminsList,
                    membersList: cubit.filteredGroupList[index].membersList,
                ));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                BuildCondition(
                  condition: state is GroupDetailsLoadingGroupsState,
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
                                                      .filteredGroupList[index]
                                                      .groupImage,
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
                                              .filteredGroupList[index]
                                              .groupImage,
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
                      imageUrl: cubit.filteredGroupList[index].groupImage,
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
                        cubit.filteredGroupList[index].groupName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "${cubit.filteredGroupList[index].groupLastMessageSenderName} : ${cubit.filteredGroupList[index].groupLastMessage}",
                        style: const TextStyle(
                          color: Colors.grey,
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
                          cubit.filteredGroupList[index].groupLastMessageTime,
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
