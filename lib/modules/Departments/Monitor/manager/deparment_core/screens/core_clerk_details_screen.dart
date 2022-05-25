import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/deparment_core/cubit/core_clerk_details_cubit.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/deparment_core/cubit/core_clerk_details_states.dart';
import 'package:mostaqbal_masr/modules/Global/Chat/screens/social_conversation_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';



class CoreClerkDetailsScreen extends StatefulWidget {
  const CoreClerkDetailsScreen({Key? key , required this.userID, required this.userName, required this.userPhone, required this.userImageUrl, required this.userDocNumber, required this.userJob, required this.onFirebase, required this.userToken}) : super(key: key);

  final String userID, userName, userPhone,  userImageUrl, userDocNumber, userJob, onFirebase, userToken;
  @override
  State<CoreClerkDetailsScreen> createState() => _CoreClerkDetailsScreenState();
}

class _CoreClerkDetailsScreenState extends State<CoreClerkDetailsScreen> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var docNumberController = TextEditingController();
  var passwordController = TextEditingController();
  var jobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userName;
    phoneController.text = widget.userPhone;
    docNumberController.text = widget.userDocNumber;
    jobController.text = widget.userJob;
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CoreClerkDetailsCubit(),
        child: BlocConsumer<CoreClerkDetailsCubit, CoreClerkDetailsStates>(
          listener: (context, state){},
          builder: (context, state){

            var cubit = CoreClerkDetailsCubit.get(context);

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  title: Text("الملف الشخصى", style: TextStyle(color: Colors.teal[700], fontSize: 12),),
                  backgroundColor: Colors.white,
                  actionsIconTheme: IconThemeData(color: Colors.teal[700]),
                  iconTheme: IconThemeData(color: Colors.teal[700]),
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark,
                    // For Android (dark icons)
                    statusBarBrightness:
                    Brightness.light, // For iOS (dark icons)
                  ),
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: (){
                              //cubit.selectImage();
                            },
                            child: SizedBox(
                              width: 160,
                              height: 160,
                              child: CircleAvatar(
                                radius: 160,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: BuildCondition(
                                    condition: widget.userImageUrl == "NULL",
                                    builder: (context) => CircleAvatar(
                                      child: const Icon(
                                        Icons.add_photo_alternate,
                                        color: Colors.white,
                                        size: 76,
                                      ),
                                      backgroundColor: Colors.teal.shade700,
                                      maxRadius: 160,
                                    ),
                                    fallback: (context) => SizedBox(
                                      width: 160,
                                      height: 160,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.userImageUrl,
                                        imageBuilder: (context, imageProvider) =>
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(14.0),
                                              child: FadeInImage(
                                                fit: BoxFit.scaleDown,
                                                image: imageProvider,
                                                placeholder: const AssetImage(
                                                    "assets/images/placeholder.jpg"),
                                                imageErrorBuilder:
                                                    (context, error, stackTrace) {
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
                                          image:
                                          AssetImage("assets/images/error.png"),
                                          placeholder: AssetImage(
                                              "assets/images/placeholder.jpg"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.grey.shade50,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 36,),
                        TextFormField(
                          textDirection: TextDirection.rtl,
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'يجب ادخال اسم المستخدم !';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            floatingLabelStyle:
                            TextStyle(color: Colors.teal[700], fontSize: 12),
                            labelText: 'اسم المستخدم',
                            labelStyle: TextStyle(color: Colors.teal[700], fontSize: 12),

                            alignLabelWithHint: true,
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: Icon(
                              IconlyBroken.profile,
                              color: Colors.teal[700],
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0)),
                              borderSide: BorderSide(
                                  color: Colors.teal, width: 1.0),),
                          ),
                          style: TextStyle(color: Colors.teal[700], fontSize: 12),
                          enabled: false,
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          textDirection: TextDirection.rtl,
                          controller: phoneController,
                          keyboardType: TextInputType.text,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'يجب ادخال رقم الهاتف !';
                            }
                            if (value.length != 11) {
                              return 'رقم الهاتف يجب ان يكون 11 رقم فقط';
                            }
                            if (!value.startsWith('011') &&
                                !value.startsWith('012') &&
                                !value.startsWith('010') &&
                                !value.startsWith('015')) {
                              return 'رقم الهاتف يجب ان يكون تابع لاحدى شركات المحمول المصرية';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            floatingLabelStyle:
                            TextStyle(color: Colors.teal[700], fontSize: 12),
                            labelText: 'رقم الهاتف',
                            labelStyle: TextStyle(color: Colors.teal[700], fontSize: 12),
                            alignLabelWithHint: true,
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: Icon(
                              IconlyBroken.call,
                              color: Colors.teal[700],
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: Colors.teal, width: 1.0),),
                          ),
                          style: TextStyle(color: Colors.teal[700], fontSize: 12, letterSpacing: 2.5),
                          enabled: false,
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          textDirection: TextDirection.rtl,
                          controller: docNumberController,
                          keyboardType: TextInputType.number,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'يجب ادخال الرقم القومى !';
                            }
                            if (value.length != 14) {
                              return 'الرقم القومى يجب ان يكون 14 رقم فقط';
                            }
                            if (value.startsWith('0')) {
                              return 'الرقم القومى غير صالح';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            floatingLabelStyle:
                            TextStyle(color: Colors.teal[700], fontSize: 12),
                            labelText: 'رقم البطاقة الشخصية',
                            labelStyle: TextStyle(color: Colors.teal[700], fontSize: 12),
                            alignLabelWithHint: true,
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: Icon(
                              IconlyBroken.lock,
                              color: Colors.teal[700],
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0)),
                              borderSide: BorderSide(
                                  color: Colors.teal, width: 1.0),),
                          ),
                          style: TextStyle(color: Colors.teal[700], fontSize: 12, letterSpacing: 2.5),
                          enabled: false,
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          textDirection: TextDirection.rtl,
                          controller: jobController,
                          keyboardType: TextInputType.text,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'يجب ادخال الوظيفة';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            floatingLabelStyle:
                            TextStyle(color: Colors.teal[700], fontSize: 12),
                            labelText: 'الوظيفة',
                            labelStyle: TextStyle(color: Colors.teal[700], fontSize: 12),

                            alignLabelWithHint: true,
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: Icon(
                              IconlyBroken.work,
                              color: Colors.teal[700],
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0)),
                              borderSide: BorderSide(
                                  color: Colors.teal, width: 1.0),),
                          ),
                          style: TextStyle(color: Colors.teal[700], fontSize: 12),
                          enabled: false,
                        ),
                        const SizedBox(height: 16,),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  cubit.callPerson(widget.userPhone);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.teal.shade700,
                                        spreadRadius: 0.48,
                                        blurRadius: 0,
                                        offset: const Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.white,
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: 45,
                                  child: Center(
                                      child: Text(
                                        "اتصال",
                                        style: TextStyle(
                                            color: Colors.teal.shade500,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      )),
                                ),
                              ),
                            ),
                            widget.onFirebase == "true" ? const SizedBox(width: 16,) : getEmptyWidget(),
                            if (widget.onFirebase == "true") Expanded(
                              child: InkWell(
                                onTap: ()async {
                                  await cubit.createChatList(context, widget.userID);
                                  print("CLICK ID : ${cubit.chatID}\n");
                                  cubit.navigate(context, SocialConversationScreen(userID: widget.userID, chatID: cubit.chatID, userName: widget.userName, userImage: widget.userImageUrl, userToken: widget.userToken), cubit.chatID);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.teal.shade700,
                                        spreadRadius: 0.16,
                                        blurRadius: 0,
                                        offset: const Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.teal.shade500,
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: 45,
                                  child: const Center(
                                      child: Text(
                                        "محادثة",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      )),
                                ),
                              ),
                            ) else getEmptyWidget()
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}
