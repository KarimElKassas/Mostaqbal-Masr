// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/cubit/group_details_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/cubit/group_details_states.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/screens/transition_app_bar.dart';
import 'package:mostaqbal_masr/shared/components.dart';

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
  String? description = "جروب إدارة البلح";

  int lightColor = 0xff141c27;
  int darkColor = 0xff232c38;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupDetailsCubit()
        ..getClerkInfo(widget.membersList)
        ..getGroupMedia(widget.groupID),
      child: BlocConsumer<GroupDetailsCubit, GroupDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = GroupDetailsCubit.get(context);

          return Scaffold(
            backgroundColor: Color(darkColor),
            body: SafeArea(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: CustomScrollView(
                  slivers: <Widget>[
                    TransitionAppBar(
                      extent: 240,
                      avatar: CachedNetworkImage(
                        imageUrl: widget.groupImage,
                        imageBuilder: (context, imageProvider) => ClipOval(
                          child: FadeInImage(
                            height: 150,
                            width: 150,
                            fit: BoxFit.fill,
                            image: imageProvider,
                            placeholder: const AssetImage(
                                "assets/images/placeholder.jpg"),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/error.png',
                                fit: BoxFit.fill,
                                height: 150,
                                width: 150,
                              );
                            },
                          ),
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(
                          color: Colors.teal,
                          strokeWidth: 0.8,
                        ),
                        errorWidget: (context, url, error) => const FadeInImage(
                          height: 150,
                          width: 150,
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/error.png"),
                          placeholder:
                              AssetImage("assets/images/placeholder.jpg"),
                        ),
                      ),
                      title: widget.groupName,
                      membersCount: widget.membersCount,
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      const SizedBox(
                        height: 1,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        color: Color(lightColor),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(description!,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      cubit.messagesHasImages.isNotEmpty ? Container(
                        color: Color(lightColor),
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 7, right: 5, bottom: 6,top: 6),
                              child: InkWell(
                                onTap: (){},
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: const [
                                  Text('الصور , التسجيلات الصوتيه , الملفات',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                ],
                              )),
                            ),
                            SizedBox(
                              height: 110,
                              child: state
                              is GroupDetailsLoadingMediaState
                              ? const CircularProgressIndicator(
                              color: Colors.teal,
                              strokeWidth: 0.8,
                            ) : ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: cubit.messagesHasImages.length,
                                  itemBuilder: (ctx, index) {
                                    return Container(
                                      margin: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      width: 100,
                                      //height: 50,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            cubit.messagesHasImages[index],
                                            fit: BoxFit.cover,
                                          ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ) : getEmptyWidget(),
                          cubit.messagesHasImages.isNotEmpty ? SizedBox(
                        height: 1,
                      ) : getEmptyWidget(),
                      Container(
                        color: Color(lightColor),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 12,top: 6, bottom: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${widget.membersCount} عضو ',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                      ))
                                ],
                              ),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                child: Icon(
                                  Icons.group_add,
                                  color: Color(lightColor),
                                ),
                                backgroundColor: Colors.teal[400],
                              ),
                              title: Text('إضافة أعضاء',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                child: Icon(
                                  Icons.link,
                                  color: Color(lightColor),
                                ),
                                backgroundColor: Colors.teal[400],
                              ),
                              title: const Text('إضافه من خلال الرابط',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              //height: 245,
                              child: state
                                      is GroupDetailsLoadingMembersInfoState
                                  ? const CircularProgressIndicator(
                                      color: Colors.teal,
                                      strokeWidth: 0.8,
                                    )
                                  : ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: cubit.membersinfolist.length > 5 ? 5 : cubit.membersinfolist.length,
                                      itemBuilder: (ctx, index) {
                                        return InkWell(
                                          onTap: (){
                                            print("TAPPED\n");
                                          },
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: CachedNetworkImage(
                                                  imageUrl: cubit
                                                      .membersinfolist[index]
                                                      .clerkImage!,
                                                  imageBuilder:
                                                      (context, imageProvider) =>
                                                          ClipOval(
                                                    child: FadeInImage(
                                                      height: 50,
                                                      width: 50,
                                                      fit: BoxFit.fill,
                                                      image: imageProvider,
                                                      placeholder: const AssetImage(
                                                          "assets/images/placeholder.jpg"),
                                                      imageErrorBuilder: (context,
                                                          error, stackTrace) {
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
                                                      const CircularProgressIndicator(
                                                    color: Colors.teal,
                                                    strokeWidth: 0.8,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
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
                                                title: Text(
                                                  cubit.membersinfolist[index]
                                                      .clerkName!,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 6),
                                cubit.membersinfolist.length > 5 ?
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'إظهار المزيد (${int.parse(widget.membersCount) - 5} أخرين)',
                                      style: TextStyle(
                                          color: Colors.teal[400],
                                          fontSize: 14),
                                    )) : getEmptyWidget(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Container(
                        color: Color(lightColor),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: (){},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
                                child: Row(
                                  children: const [
                                    CircleAvatar(
                                      radius: 25,
                                      child: Icon(
                                        IconlyBroken.closeSquare,
                                        color: Colors.redAccent,
                                        size: 30,
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    SizedBox(width: 16.0,),
                                    Text('مغادرة الجروب',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){},
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10, bottom: 4.0),
                                child: Row(
                                  children: const [
                                    CircleAvatar(
                                      radius: 25,
                                      child: Icon(
                                        IconlyBroken.infoCircle,
                                        color: Colors.redAccent,
                                        size: 30,
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    SizedBox(width: 16.0,),
                                    Text('الابلاغ عن الجروب',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
