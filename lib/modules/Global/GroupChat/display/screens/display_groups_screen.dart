import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/display/cubit/display_groups_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/conversation/screens/group_conversation_screen.dart';
import 'package:mostaqbal_masr/shared/constants.dart';

import '../cubit/display_groups_states.dart';

class DisplayGroupsScreen extends StatefulWidget {
  const DisplayGroupsScreen({Key? key}) : super(key: key);

  @override
  State<DisplayGroupsScreen> createState() => _DisplayGroupsState();
}

class _DisplayGroupsState extends State<DisplayGroupsScreen> with SingleTickerProviderStateMixin {


  Animation<double>? animation;
  AnimationController? animationController;
  bool isForward = false;

  var searchController = TextEditingController();
  var search2Controller = TextEditingController();

  String searchText = "";

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    final curvedAnimation = CurvedAnimation(parent: animationController!, curve: Curves.fastOutSlowIn);

    animation = Tween<double>(begin: 0, end: 220).animate(curvedAnimation)..addListener(() {setState(() {});});

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DisplayGroupsCubit()..getGroups(),
      child: BlocConsumer<DisplayGroupsCubit, DisplayGroupsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = DisplayGroupsCubit.get(context);

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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, right: 12.0, left: 12.0),
                        child: Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50), bottomLeft: Radius.circular(50)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20, bottom: 5),
                                          child: TextFormField(
                                            cursorColor: Colors.teal,
                                            controller: searchController,
                                            textDirection: TextDirection.rtl,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.search,
                                            onChanged: (String value){
                                              cubit.searchGroup(value);
                                            },
                                            style: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        width: animation!.value,
                                      ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: animation!.value < 1 ? const BorderRadius.all(Radius.circular(50)) : const BorderRadius.only(topLeft: Radius.circular(0), bottomLeft: Radius.circular(0), topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(IconlyBroken.search),
                                        color: Colors.teal,
                                        onPressed: (){
                                          print("Pressed Anim Value : ${animation!.value}\n");
                                          if(!isForward){
                                            animationController!.forward();
                                            isForward = true;
                                          }else{
                                            animationController!.reverse();
                                            isForward = false;
                                          }

                                        },
                                      ),
                                    )
                                  ],
                                ),
                                height: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      BuildCondition(
                        condition: state is DisplayGroupsLoadingGroupsState,
                        builder: (context) => Center(
                          child: CircularProgressIndicator(
                            color: Colors.teal[700],
                            strokeWidth: 0.8,
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
                          itemCount: cubit.filteredGroupList.length,
                        ),
                      ),
                    ],
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
      BuildContext context, DisplayGroupsCubit cubit, state, int index) {
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
                  condition: state is DisplayGroupsLoadingGroupsState,
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
                                                      const CircularProgressIndicator(color: Colors.teal, strokeWidth: 0.8,),
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
                                          const CircularProgressIndicator(color: Colors.teal, strokeWidth: 0.8,),
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
                      placeholder: (context, url) => const CircularProgressIndicator(color: Colors.teal, strokeWidth: 0.8,),
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
