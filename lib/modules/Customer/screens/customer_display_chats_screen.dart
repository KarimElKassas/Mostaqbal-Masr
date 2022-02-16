import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/cusomer_display_chats_states.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_display_chats_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/Chat/conversation_screen.dart';

class CustomerDisplayChats extends StatelessWidget {
  const CustomerDisplayChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerDisplayChatsCubit()..getUserData(),
      child: BlocConsumer<CustomerDisplayChatsCubit,CustomerDisplayChatsStates>(
        listener: (context, state){

          if(state is CustomerDisplayChatsGetUserTypeState){

            CustomerDisplayChatsCubit.get(context).getChats();

          }

        },
        builder: (context, state){

          var cubit = CustomerDisplayChatsCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 0.0,
              toolbarHeight: 0.0,
              backgroundColor: Colors.transparent,
            ),
            body: BuildCondition(
              condition: state is CustomerDisplayChatsLoadingChatsState,
              builder: (context) => Center(child: CircularProgressIndicator(color: Colors.teal[700],),),
              fallback: (context) => ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => listItem(context, cubit,state, index),
                separatorBuilder: (context, index) =>
                const SizedBox(width: 10.0),
                itemCount: cubit.chatList.length,
              ),
            ),

          );
        },
      ),
    );

  }

  Widget listItem(BuildContext context, CustomerDisplayChatsCubit cubit,state, int index){

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        elevation: 2,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        shadowColor: Colors.black,
        child: InkWell(
          onTap: (){
                cubit.goToConversation(context, ConversationScreen(userID: cubit.userList[index].userID,userName: cubit.userList[index].userName,userImage: cubit.userList[index].userImage));
          },
          splashColor: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                BuildCondition(
                  condition: state is CustomerDisplayChatsLoadingChatsState,
                  builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.teal,)),
                  fallback: (context) => ClipOval(
                    child: FadeInImage(
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                      image: NetworkImage(cubit.userList[index].userImage),
                      placeholder: const AssetImage("assets/images/placeholder.jpg"),
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
                ),
                const SizedBox(width: 12.0,),
                Text(
                  cubit.userList[index].userName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

}
