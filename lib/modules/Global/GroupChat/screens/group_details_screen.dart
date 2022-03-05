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
import 'package:mostaqbal_masr/modules/Global/GroupChat/screens/transition_app_bar.dart';
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
  String? group_title = 'مستقبل مصر';
  int? group_number = 50;
  String? description = "^_^ مستقبل مصر للزراعه المستدامه إدارة النظم ^_^";
  List<String>? media_path = [
    'assets/images/2.jpg',
    'assets/images/3.jpg',
    'assets/images/4.jpg',
    'assets/images/5.jpg',
    'assets/images/6.jpg'
  ];
  List<Map<String, String>> member = [
    {'name': 'Kareem', 'photo': 'assets/images/me.jpg', 'type': 'admin'},
    {'name': 'mazen', 'photo': 'assets/images/me.jpg', 'type': 'user'},
    {'name': 'mazen', 'photo': 'assets/images/me.jpg', 'type': 'user'},
    {'name': 'mazen', 'photo': 'assets/images/me.jpg', 'type': 'user'},
    {'name': 'mazen', 'photo': 'assets/images/me.jpg', 'type': 'user'},
    {'name': 'mazen', 'photo': 'assets/images/me.jpg', 'type': 'user'},
  ];

  int darkcolor = 0xff141c27;
  int lightcolor = 0xff232c38;
  void audio_call_function() {}
  void video_call_function() {}
  void add_function() {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      GroupDetailsCubit()..getClerkInfo(widget.membersList)..getGroupMedia(widget.groupID),
      child: BlocConsumer<GroupDetailsCubit, GroupDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = GroupDetailsCubit.get(context);


          return Scaffold(
            backgroundColor: Color(lightcolor),
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
                              height:150,
                              width: 150,
                              fit: BoxFit.fill,
                              image: imageProvider,
                              placeholder:
                              const AssetImage("assets/images/placeholder.jpg"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/error.png',
                                  fit: BoxFit.fill,
                                  height:150,
                                  width: 150,
                                );
                              },
                            ),
                          ),
                          placeholder: (context, url) => const CircularProgressIndicator(color: Colors.teal, strokeWidth: 0.8,),
                          errorWidget: (context, url, error) => const FadeInImage(
                            height: 150,
                            width: 150,
                            fit: BoxFit.fill,
                            image: AssetImage("assets/images/error.png"),
                            placeholder:
                            AssetImage("assets/images/placeholder.jpg"),
                          ),
                        ),
                        title: group_title!,
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate(
                            [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                height: 50,
                                color: Color(darkcolor),
                                child: Center(
                                    child:  Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(description!,
                                            style: TextStyle(
                                                color: Colors.grey, fontSize: 15)),
                                    ),
                                    ),),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                color: Color(darkcolor),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          left: 7, right: 5, bottom: 3),
                                      child: InkWell(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text('الصور , التسجيلات الصوتيه , الملفات',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15)),
                                              Text('>',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight
                                                          .bold))
                                            ],
                                          )),
                                    ),
                                    Container(
                                      height: 100,
                                      child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: cubit.messagesHasImages.length,
                                          itemBuilder: (ctx, index) {
                                            return Container(
                                              margin: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                              width: 100,
                                              height: 70,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .circular(10),
                                                  child: Image.network(
                                                   cubit.messagesHasImages[index],
                                                    fit: BoxFit.cover,
                                                  )),
                                            );
                                          }),
                                    )],
                                ),),
                              SizedBox(height: 10,),
                              Container(
                                color: Color(darkcolor),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 7,right: 7),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${member.length} عضو ',
                                              style: TextStyle(color: Colors.grey,
                                                  fontSize: 15)),
                                          IconButton(onPressed: () {},
                                              icon: Icon(Icons.search,
                                                color: Colors.grey,))
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        child: Icon(Icons.group_add,
                                          color: Color(darkcolor),),
                                        backgroundColor: Colors.greenAccent,
                                      ),
                                      title: Text('إضافة أعضاء',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15)),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        child: Icon(
                                          Icons.link, color: Color(darkcolor),),
                                        backgroundColor: Colors.greenAccent,
                                      ),
                                      title: const Text('إضافه من خلال الرابط',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15)),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    SizedBox(
                                      height: 245,
                                      child:  state is GroupDetailsLoadingMembersInfoState ? const CircularProgressIndicator(color: Colors.teal,strokeWidth: 0.8,) :ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: cubit.membersinfolist.length,
                                          itemBuilder: (ctx, index) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                  leading: CachedNetworkImage(
                                                    imageUrl: cubit.membersinfolist[index].clerkImage!,
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
                                                  title: Text(
                                                    cubit.membersinfolist[index].clerkName!,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14),),

                                                ),
                                                SizedBox(height: 7,)
                                              ],
                                            );
                                          }),
                                    ),
                                    SizedBox(height: 15,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: 51
                                        ),
                                        TextButton(

                                            onPressed: () {},
                                            child: Text(
                                              'إظهار المزيد (${member.length -
                                                  4} أخرين)', style: TextStyle(
                                                color: Colors.greenAccent,
                                                fontSize: 17),)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                color: Color(darkcolor),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        child: Icon(
                                          Icons.exit_to_app,
                                          color: Colors.redAccent,
                                          size: 30,
                                        ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      title: Text('Exit Group', style: TextStyle(
                                          color: Colors.redAccent, fontSize: 15)),
                                    ),
                                    ListTile(

                                      leading: CircleAvatar(
                                        radius: 25,
                                        child: Icon(
                                          Icons.report,
                                          color: Colors.redAccent,
                                          size: 30,
                                        ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      title: Text('Report Group',
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 15)),
                                    ),
                                  ],
                                ),
                              )
                            ]
                        ))

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