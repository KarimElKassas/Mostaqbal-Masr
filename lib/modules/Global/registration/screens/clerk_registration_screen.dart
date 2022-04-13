import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Global/Login/clerk_login_screen.dart';
import 'package:mostaqbal_masr/modules/Global/registration/cubit/clerk_register_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/registration/cubit/clerk_register_states.dart';
import 'package:mostaqbal_masr/modules/Global/registration/screens/clerk_confirm_registration_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class ClerkRegistrationScreen extends StatefulWidget {
  const ClerkRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<ClerkRegistrationScreen> createState() =>
      _ClerkRegistrationScreenState();
}

class _ClerkRegistrationScreenState extends State<ClerkRegistrationScreen> {
  var clerkNumberController = TextEditingController();
  String searchText = "";

  TextEditingController searchQueryController = TextEditingController();
  bool isSearching = false;
  String searchQuery = "Search query";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClerkRegisterCubit(),
      child: BlocConsumer<ClerkRegisterCubit, ClerkRegisterStates>(
        listener: (context, state) {
          if (state is ClerkRegisterGetClerksErrorState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if (state is ClerkRegisterNoClerkFoundState) {
            showToast(
                message:
                    "لا يوجد موظف مسجل بهذا الرقم\n برجاء التوجه الى شئون العاملين اولاً",
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if (state is ClerkRegisterSuccessState) {
            navigateAndFinish(context, ClerkLoginScreen());
          }
        },
        builder: (context, state) {
          var cubit = ClerkRegisterCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.teal.shade700,
                leading: BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: buildSearchField(cubit),
                actions: buildActions(cubit),
              ),
              body: SafeArea(
                child: cubit.clerkList.isNotEmpty
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 12.0,
                              ),
                              state is ClerkRegisterLoadingClerksState
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.teal,
                                        strokeWidth: 0.8,
                                      ),
                                    )
                                  : getEmptyWidget(),
                              state is ClerkRegisterGetClerksSuccessState
                                  ? clerkView(cubit)
                                  : getEmptyWidget(),
                            ],
                          ),
                        ),
                      )
                    : state is! ClerkRegisterLoadingClerksState ? FadeIn(
                        duration: const Duration(milliseconds: 1500),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/search.jpg'),
                              const SizedBox(
                                height: 24,
                              ),
                              const Text(
                                'ابحث عن الحساب الخاص بيك \n بالرقم القومى / العسكرى',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.teal),
                              ),
                            ],
                          ),
                        ),
                      ) : Center(child: CircularProgressIndicator(color: Colors.teal.shade500, strokeWidth: 0.8,),),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget clerkView(ClerkRegisterCubit cubit) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "اسم الموظف :",
                style: TextStyle(
                    color: Colors.teal[700],
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.text,
              cursorColor: Colors.teal,
              readOnly: true,
              style: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: cubit.clerkModel!.clerkName,
                hintStyle: TextStyle(
                    color: Colors.teal[700],
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
                hintTextDirection: TextDirection.rtl,
                prefixIcon: Icon(
                  IconlyBold.profile,
                  color: Colors.teal[700],
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 18.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "رقم الهاتف :",
                style: TextStyle(
                    color: Colors.teal[700],
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.text,
              cursorColor: Colors.teal,
              readOnly: true,
              style: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 14.0,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: cubit.clerkModel!.personPhone,
                hintStyle: TextStyle(
                    color: Colors.teal[700],
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
                hintTextDirection: TextDirection.rtl,
                prefixIcon: Icon(
                  IconlyBold.call,
                  color: Colors.teal[700],
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 18.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "الإدارة التابع لها :",
                style: TextStyle(
                    color: Colors.teal[700],
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.text,
              cursorColor: Colors.teal,
              readOnly: true,
              style: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: cubit.clerkModel!.managementName,
                hintStyle: TextStyle(
                    color: Colors.teal[700],
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
                hintTextDirection: TextDirection.rtl,
                prefixIcon: Icon(
                  IconlyBold.work,
                  color: Colors.teal[700],
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 18.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "الدرجة :",
                style: TextStyle(
                    color: Colors.teal[700],
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.text,
              cursorColor: Colors.teal,
              readOnly: true,
              style: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: cubit.clerkModel!.personTypeName,
                hintStyle: TextStyle(
                    color: Colors.teal[700],
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
                hintTextDirection: TextDirection.rtl,
                prefixIcon: Icon(
                  IconlyBold.document,
                  color: Colors.teal[700],
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            cubit.isCivil
                ? getEmptyWidget()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 18.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "الرتبة :",
                          style: TextStyle(
                              color: Colors.teal[700],
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.teal,
                        readOnly: true,
                        style: TextStyle(
                            color: Colors.teal[700],
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: cubit.clerkModel!.rankName,
                          hintStyle: TextStyle(
                              color: Colors.teal[700],
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                          hintTextDirection: TextDirection.rtl,
                          prefixIcon: Icon(
                            Icons.local_police_rounded,
                            color: Colors.teal[700],
                          ),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 18.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "الوظيفة :",
                    style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  textDirection: TextDirection.rtl,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.teal,
                  readOnly: true,
                  style: TextStyle(
                      color: Colors.teal[700],
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: cubit.clerkModel!.jobName,
                    hintStyle: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                    hintTextDirection: TextDirection.rtl,
                    prefixIcon: Icon(
                      IconlyBold.work,
                      color: Colors.teal[700],
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 18.0,
            ),
            defaultButton(
                function: () {
                  if (cubit.clerkList.isNotEmpty) {
                    if (cubit.isUserExist) {
                      showToast(
                          message: "هذا الموظف مسجل من قبل",
                          length: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3);
                    } else {
                      navigateTo(
                          context,
                          ClerkConfirmRegistrationScreen(
                            clerkModel: cubit.clerkModel!,
                          ));
                    }
                  } else {
                    showToast(
                        message: "يجب تحديد الموظف اولاً",
                        length: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3);
                  }
                },
                text: "انشاء حساب",
                background: Colors.teal),
            const SizedBox(
              height: 8.0,
            )
          ],
        ),
      ),
    );
  }

  Widget buildSearchField(ClerkRegisterCubit cubit) {
    return TextFormField(
      controller: searchQueryController,
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (String value) {
        cubit.getClerks(value);
      },
      decoration: InputDecoration(
        hintText: "بحث بالرقم القومى / العسكرى",
        border: InputBorder.none,
        hintStyle:
            TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12.0),
      ),
      style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14.0,
          letterSpacing: 1.5),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> buildActions(ClerkRegisterCubit cubit) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (searchQueryController.text.isEmpty) {
            setState(() {
              cubit.clerkList.clear();
            });
            return;
          }
          clearSearchQuery();
        },
      ),
    ];
  }

  void startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));

    setState(() {
      isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void stopSearching() {
    clearSearchQuery();
    setState(() {
      isSearching = false;
    });
  }

  void clearSearchQuery() {
    setState(() {
      searchQueryController.clear();
      updateSearchQuery("");
    });
  }
}
