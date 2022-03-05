import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatelessWidget {
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
    return Scaffold(
      backgroundColor: Color(lightcolor),
      body: SafeArea(
        child: SingleChildScrollView(
          // physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                color: Color(darkcolor),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(5)),
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('assets/images/logo.jpg'),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      group_title!,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    Text('${member.length} Participants',
                        style: TextStyle(color: Colors.grey, fontSize: 15)),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: audio_call_function,
                          child: Column(
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.greenAccent,
                                size: 25,
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text('Audio',
                                  style: TextStyle(
                                      color: Colors.greenAccent, fontSize: 15))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: video_call_function,
                          child: Column(
                            children: [
                              Icon(
                                Icons.video_call,
                                color: Colors.greenAccent,
                                size: 25,
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text('Video',
                                  style: TextStyle(
                                      color: Colors.greenAccent, fontSize: 15))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: add_function,
                          child: Column(
                            children: [
                              Icon(
                                Icons.group_add,
                                color: Colors.greenAccent,
                                size: 25,
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text('Audio',
                                  style: TextStyle(
                                      color: Colors.greenAccent, fontSize: 15))
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                color: Color(darkcolor),
                child: Center(
                    child: Text(description!,
                        style: TextStyle(color: Colors.grey, fontSize: 15))),
              ),
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
                          const EdgeInsets.only(left: 7, right: 5, bottom: 3),
                      child: InkWell(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Media , Links , and Docs',
                              style: TextStyle(color: Colors.grey, fontSize: 15)),
                          Text('>',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))
                        ],
                      )),
                    ),
                    Container(
                      height: 100,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: media_path!.length,
                          itemBuilder: (ctx, index) {
                            return Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              width: 100,
                              height: 70,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    media_path![index],
                                    fit: BoxFit.cover,
                                  )),
                            );
                          }),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Color(darkcolor),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${member.length} Participants',
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.search,color: Colors.grey,))
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        child: Icon(Icons.group_add,color: Color(darkcolor),),
                        backgroundColor: Colors.greenAccent,
                      ),
                      title: Text('Add Participants',style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        child: Icon(Icons.link,color: Color(darkcolor),),
                        backgroundColor: Colors.greenAccent,
                      ),
                      title: Text('Invite Via Link',style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 245,
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          itemBuilder: (ctx, index) {
                            return Container(
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          AssetImage(member[index]['photo']!),
                                    ),
                                    title: Text(member[index]['name']!,style: TextStyle(color: Colors.grey,fontSize: 17),),

                                  ),
                                  SizedBox(height: 7,)
                                ],
                              ),
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
                            child: Text('View all (${member.length - 4} more)',style: TextStyle(color: Colors.greenAccent,fontSize: 17),)),
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
                      title: Text('Exit Group',style: TextStyle(color: Colors.redAccent, fontSize: 15)),
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
                      title: Text('Report Group',style: TextStyle(color: Colors.redAccent, fontSize: 15)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
