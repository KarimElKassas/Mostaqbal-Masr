import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/create/cubit/new_group_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/create/cubit/new_group_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';

class SelectGroupUsersScreen extends StatefulWidget {
  const SelectGroupUsersScreen({Key? key}) : super(key: key);

  @override
  State<SelectGroupUsersScreen> createState() =>
      _SelectGroupUsersScreenState();
}

class _SelectGroupUsersScreenState extends State<SelectGroupUsersScreen> {
  var searchController = TextEditingController();

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewGroupCubit()..getUsers(),
      child: BlocConsumer<NewGroupCubit, NewGroupStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = NewGroupCubit.get(context);

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
            floatingActionButton: FadeInUp(
              duration: const Duration(seconds: 1),
              child: FloatingActionButton(
                onPressed: () async {
                  if (cubit.selectedClerksList.isNotEmpty) {
                    cubit.navigateToCreateClerksGroup(context);
                  } else {
                    showToast(
                        message: "يجب اختيار شخص واحد على الاقل",
                        length: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3);
                  }
                },
                child: const Icon(
                  IconlyBroken.arrowLeft,
                  color: Colors.white,
                ),
                backgroundColor: Colors.teal[700],
                elevation: 15.0,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
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
                              cubit.searchUser(value);
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: greyBorderColor, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: greyBorderColor, width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      BuildCondition(
                        condition: state is NewGroupLoadingUsersState,
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
                          itemCount: cubit.filteredClerkList.length,
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

  Widget listItem(BuildContext context, NewGroupCubit cubit, state, int index) {
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
            if (cubit.selectedClerksList
                .contains(cubit.filteredClerkList[index])) {
              print("Yeeeees\n");
              cubit.removeUserFromSelect(cubit.filteredClerkList[index]);
            } else {
              print("Nooooooo\n");
              cubit.addClerkToSelect(cubit.filteredClerkList[index]);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                BuildCondition(
                  condition: state is NewGroupLoadingUsersState,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                      strokeWidth: 0.8,
                    ),
                  ),
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
                                                  fit: BoxFit.fill,
                                                  imageUrl: cubit
                                                      .filteredClerkList[index]
                                                      .clerkImage!,
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                    color: Colors.teal,
                                                    strokeWidth: 0.8,
                                                  )),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: cubit
                                                .filteredClerkList[index]
                                                .clerkImage!,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.55,
                                            width: double.infinity,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                              color: Colors.teal,
                                              strokeWidth: 0.8,
                                            )),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
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
                    child: ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: cubit.filteredClerkList[index].clerkImage!,
                        height: 50,
                        width: 50,
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                          color: Colors.teal,
                          strokeWidth: 0.8,
                        )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      cubit.filteredClerkList[index].clerkName??"",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: cubit.selectedClerksList
                            .contains(cubit.filteredClerkList[index])
                        ? FadeIn(
                            duration: const Duration(milliseconds: 500),
                            child: const CircleAvatar(
                              child: Icon(
                                Icons.done_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              backgroundColor: Colors.teal,
                              maxRadius: 16,
                            ),
                          )
                        : getEmptyWidget(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
