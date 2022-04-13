import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mostaqbal_masr/shared/components.dart';

// ignore: must_be_immutable
class GroupMediaScreen extends StatelessWidget {
  GroupMediaScreen({
    Key? key,
    required this.images,
    required this.groupname
  }) : super(key: key);

   List images ;
   String groupname;

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: darkColor,
        appBar:
        AppBar(
          title: Text(groupname),
            bottom: const TabBar(
              tabs: [
            Tab(child: Text('Media'),),
            Tab(child: Text('Audio'),),
            Tab(child: Text('Files'),)
          ],)),

        body: TabBarView(
                children: [
                  Center(child: mediaScreen(context),),
                  const Center(child: Text('Audio'),),
                  const Center(child: Text('Files'),)
            ]),
        )
      );



  }


   Widget mediaScreen(context){
     return Container(
       padding: EdgeInsets.all(5),
       child: GridView(
         gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
             maxCrossAxisExtent: 150,
             childAspectRatio:1,
             crossAxisSpacing: 2),

         children:images.map((element) {
           return InkWell(
             onTap: (){
               Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (_) {
                     return InteractiveViewer(
                       child: Scaffold(
                         backgroundColor: Colors.black,
                         appBar: AppBar(
                           systemOverlayStyle: const SystemUiOverlayStyle(
                             statusBarColor: Colors.black,
                             statusBarIconBrightness: Brightness.light,
                             // For Android (dark icons)
                             statusBarBrightness:
                             Brightness.dark, // For iOS (dark icons)
                           ),
                           backgroundColor: Colors.black,
                           elevation: 0.0,
                           toolbarHeight: 0,
                         ),
                         body: Center(
                           child: CachedNetworkImage(
                             imageUrl: element,
                             imageBuilder: (context, imageProvider) => ClipRRect(
                               borderRadius: BorderRadius.circular(0.0),
                               child: FadeInImage(
                                 fit: BoxFit.cover,
                                 image: imageProvider,
                                 placeholder: const AssetImage(
                                     "assets/images/placeholder.jpg"),
                                 imageErrorBuilder: (context, error, stackTrace) {
                                   return Image.asset(
                                     'assets/images/error.png',
                                     fit: BoxFit.cover,
                                   );
                                 },
                               ),
                             ),
                             placeholder: (context, url) => const Center(
                                 child: CircularProgressIndicator(
                                   color: Colors.teal,
                                   strokeWidth: 0.8,
                                 )),
                             errorWidget: (context, url, error) =>
                             const FadeInImage(
                               fit: BoxFit.cover,
                               image: AssetImage("assets/images/error.png"),
                               placeholder:
                               AssetImage("assets/images/placeholder.jpg"),
                             ),
                           ),
                         ),
                       ),
                       maxScale: 3.5,
                       panEnabled: true,
                       scaleEnabled: true,
                     );
                   },
                 ),
               );
             },
             child: CachedNetworkImage(
               imageUrl: element,
               imageBuilder: (context, imageProvider) => ClipRRect(
                 borderRadius: BorderRadius.circular(8.0),
                 child: FadeInImage(
                   fit: BoxFit.cover,
                   image: imageProvider,
                   placeholder: const AssetImage(
                       "assets/images/placeholder.jpg"),
                   imageErrorBuilder: (context, error, stackTrace) {
                     return Image.asset(
                       'assets/images/error.png',
                       fit: BoxFit.cover,
                     );
                   },
                 ),
               ),
               placeholder: (context, url) => const Center(
                   child: CircularProgressIndicator(
                     color: Colors.teal,
                     strokeWidth: 0.8,
                   )),
               errorWidget: (context, url, error) =>
               const FadeInImage(
                 fit: BoxFit.cover,
                 image: AssetImage("assets/images/error.png"),
                 placeholder:
                 AssetImage("assets/images/placeholder.jpg"),
               ),
             ),
           ) ;
         }).toList() ,),
     ) ;
   }

}
