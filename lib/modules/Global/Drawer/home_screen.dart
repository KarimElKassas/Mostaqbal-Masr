import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/drawer/drawer_items.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/drawer/drawer_model.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/drawer/drawer_widget.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/screens/social_add_post_screen.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/screens/social_display_posts_screen.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/screens/social_settings_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xOffSet = 0;
  double yOffSet = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;
  bool isDragging = false;
  DrawerModel item = DrawerItems.addPost;

  static const delta = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    closeDrawer();
  }

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: (){
          if(isDrawerOpen){
            closeDrawer();
          }
        },
        onHorizontalDragStart: (details) {

          if(isDrawerOpen){
            setState(() {
              isDragging = true;
            });
          }
        },
        onHorizontalDragUpdate: (details) {
          if (isDrawerOpen) {
            if (details.delta.dx < delta) {
              openDrawer();
            } else if (details.delta.dx > -delta) {
              closeDrawer();
            }
            setState(() {
              isDragging = false;
            });
          }
        },
        child: AnimatedContainer(
          transform: Matrix4.translationValues(xOffSet, yOffSet, 0)
            ..scale(scaleFactor)
            ..rotateY(isDrawerOpen ? -0.5 : 0),
          duration: const Duration(milliseconds: 750),
          decoration: BoxDecoration(
              color: Colors.grey[200],
          ),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: Column(
              children: [
                SizedBox(
                  height: 56.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isDrawerOpen
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    xOffSet = 0;
                                    yOffSet = 0;
                                    scaleFactor = 1;

                                    isDrawerOpen = false;
                                  });
                                },
                                icon: const Icon(Icons.arrow_back_ios),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    xOffSet = -60;
                                    yOffSet = 200;
                                    scaleFactor = 0.6;

                                    isDrawerOpen = true;
                                  });
                                },
                                icon: const Icon(Icons.menu),
                              ),
                        const Text("مشروع مستقبل مصر"),
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage("assets/images/logo.jpg"),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.only(
                              bottomLeft:
                              Radius.circular(isDrawerOpen ? 40.0 : 0.0),
                              bottomRight:
                              Radius.circular(isDrawerOpen ? 40.0 : 0.0))),
                    child: getDrawerPage(),
                  ),
                ),
                Container(
                    child: const SizedBox(height: 1,),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.only(
                          bottomLeft:
                          Radius.circular(isDrawerOpen ? 40.0 : 0.0),
                          bottomRight:
                          Radius.circular(isDrawerOpen ? 40.0 : 0.0))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              buildDrawer(),
              buildPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return DrawerWidget(
      onSelectedItem: (item) {
        switch (item) {
          case DrawerItems.close:
            closeDrawer();
            break;
          case DrawerItems.logOut:
            showToast(
                message: "Log Out",
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
            break;
          default:
            setState(() {
              this.item = item;
            });
            closeDrawer();
        }
      },
    );
  }

  Widget getDrawerPage() {
    switch (item) {
      case DrawerItems.addPost:
        return SocialAddPostScreen();
      case DrawerItems.showPosts:
        return SocialDisplayPostsScreen();
      case DrawerItems.settings:
        return SocialSettingsScreen();
      default:
        return SocialSettingsScreen();
    }
  }

  void closeDrawer() {
    setState(() {
      xOffSet = 0;
      yOffSet = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  void openDrawer() {
    setState(() {
      xOffSet = -60;
      yOffSet = 200;
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }
}
