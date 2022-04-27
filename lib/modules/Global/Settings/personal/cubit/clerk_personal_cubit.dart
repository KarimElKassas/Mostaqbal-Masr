import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';
import '../../../../../models/city_model.dart';
import '../../../../../models/region_model.dart';
import '../../../../../network/remote/dio_helper.dart';
import 'clerk_personal_states.dart';

class ClerkPersonalCubit extends Cubit<ClerkPersonalStates> {
  ClerkPersonalCubit() : super(ClerkPersonalInitialState());

  static ClerkPersonalCubit get(context) => BlocProvider.of(context);

  String userID = "";
  String userName = "";
  String userPhone = "";
  String userNumber = "";
  String userPassword = "";
  String userManagementID = "";
  String userManagementName = "";
  String userCategoryName = "";
  String userRankName = "";
  String userTypeName = "";
  String userCoreStrengthName = "";
  String userPresenceName = "";
  String userJobName = "";
  String userToken = "";
  String userImage = "";
  String imageUrl = "";
  bool oldImage = true;
  bool oldCity = true;
  bool oldRegion = true;

  var cityBottomSheetController;
  var regionBottomSheetController;
  bool isCityBottomSheetShown = false;
  bool isRegionBottomSheetShown = false;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  String selectedCityName = "";
  double? selectedCityID;
  String selectedRegionName = "";
  double? selectedRegionID;

  CityModel? cityModel;
  List<CityModel> cityList = [];

  RegionModel? regionModel;
  List<RegionModel> regionList = [];

  final ImagePicker imagePicker = ImagePicker();

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getString("ClerkID")!;
    userName = prefs.getString("ClerkName")!;
    userPhone = prefs.getString("ClerkPhone")!;
    userNumber = prefs.getString("ClerkNumber")!;
    userPassword = prefs.getString("ClerkPassword")!;
    userManagementID = prefs.getString("ClerkManagementID")!;
    userManagementName = prefs.getString("ClerkManagementName")!;
    userTypeName = prefs.getString("ClerkTypeName")!;
    userRankName = prefs.getString("ClerkRankName")!;
    userCategoryName = prefs.getString("ClerkCategoryName")!;
    userCoreStrengthName = prefs.getString("ClerkCoreStrengthName")!;
    userPresenceName = prefs.getString("ClerkPresenceName")!;
    userJobName = prefs.getString("ClerkJobName")!;
    userToken = prefs.getString("ClerkToken")!;
    userImage = prefs.getString("ClerkImage")!;

    emit(ClerkPersonalGetUserDataSuccessState());
  }

  void selectImage() async {
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

    imageUrl = image!.path;

    oldImage = false;

    emit(ClerkPersonalEditSelectImageState());
  }

  Future<void> updateUserData(String userID, String userName, String userPassword) async{
    emit(ClerkPersonalEditLoadingState());
    Map<String, dynamic> dataMap = HashMap();
    dataMap['ClerkName'] = userName;
    dataMap['ClerkPassword'] = userPassword;

    if(!oldImage){
      await FirebaseStorage.instance.ref("Clients/$userID").delete().then((value)async{
        await FirebaseStorage.instance
            .ref("Clients/$userID").putFile(File(imageUrl)).then((p0){
          p0.ref.getDownloadURL().then((downloadUrl){
            dataMap['ClientImage'] = downloadUrl;
            FirebaseDatabase.instance.reference().child("Clients").child(userID).update(dataMap).then((value)async {

              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString("ClerkName", userName);
              await prefs.setString("ClerkPassword", userPassword);
              await prefs.setString("ClerkImageUrl", downloadUrl);

              emit(ClerkPersonalEditSuccessState());
            }).catchError((error){
              emit(ClerkPersonalEditErrorState(error.toString()));
            });
          });
        });
      });
    }else{
      FirebaseDatabase.instance.reference().child("Clients").child(userID).update(dataMap).then((value)async {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("ClerkName", userName);
        await prefs.setString("ClerkPassword", userPassword);

        emit(ClerkPersonalEditSuccessState());
      }).catchError((error){
        emit(ClerkPersonalEditErrorState(error.toString()));
      });
    }
  }

  void navigate(BuildContext context, route){
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
    emit(ClerkPersonalNavigateSuccessState());
  }
  Future<void> getCities() async {
    cityList = [];
    await DioHelper.getData(
        url: 'address/GetWithParameters',
        query: {'Address_FK': 1}).then((value) {
      value.data.forEach((city) {
        cityModel = CityModel(city["Address_ID"], city["Address_Name"]);

        cityList.add(cityModel!);
      });
      emit(ClerkPersonalGetCitiesSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        emit(ClerkPersonalEditGetCitiesErrorState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(ClerkPersonalEditGetCitiesErrorState(error.toString()));
      }
    });
  }
  Future<void> getUserRegion(int addressFK) async {
    regionList = [];
    await DioHelper.getData(
        url: 'address/GetWithParameters',
        query: {'Address_FK': addressFK}).then((value) {
      value.data.forEach((region) {
        regionModel = RegionModel(region["Address_ID"], region["Address_Name"]);

        regionList.add(regionModel!);
      });
      emit(ClerkPersonalGetRegionsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        emit(ClerkPersonalEditGetRegionsErrorState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(ClerkPersonalEditGetRegionsErrorState(error.toString()));
      }
    });
  }
  void changeCityController(TextEditingController cityController, TextEditingController regionController){
    cityController.text = selectedCityName;
    regionController.clear();
    emit(ClerkPersonalChangeCityControllerState());
  }

  void changeRegionController(TextEditingController controller){
    controller.text = selectedRegionName;
    emit(ClerkPersonalChangeRegionControllerState());
  }

  void showCityBottomSheet(context, TextEditingController cityController, TextEditingController regionController) {
    isCityBottomSheetShown = true;

    cityBottomSheetController =
        scaffoldKey.currentState!.showBottomSheet<void>((BuildContext context) {
          return GestureDetector(
            onVerticalDragDown: (_) {},
            child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24.0), bottom: Radius.zero),
                  color: Colors.grey[200],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: cityList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: InkWell(
                        onTap: () {
                          selectedCityName = cityList[index].cityName!;
                          selectedCityID = cityList[index].cityID!;

                          selectedRegionName = "";
                          selectedRegionID = null;
                          oldCity = false;
                          changeCityController(cityController, regionController);
                          closeCityBottomSheet();
                        },
                        child: Center(
                            child: Text(
                              cityList[index].cityName!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            )),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                )),
          );
        });
    emit(ClerkPersonalChangeCityBottomSheetState());
  }

  void showRegionBottomSheet(context, TextEditingController regionController) {
    isRegionBottomSheetShown = true;

    regionBottomSheetController =
        scaffoldKey.currentState!.showBottomSheet<void>((BuildContext context) {
          return GestureDetector(
            onVerticalDragDown: (_) {},
            child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24.0), bottom: Radius.zero),
                  color: Colors.grey[200],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: regionList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: InkWell(
                        onTap: () {
                          selectedRegionName = regionList[index].regionName!;
                          selectedRegionID = regionList[index].regionID!;
                          oldRegion = false;
                          changeRegionController(regionController);
                          closeRegionBottomSheet();
                        },
                        child: Center(
                            child: Text(
                              regionList[index].regionName!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            )),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                )),
          );
        });
    emit(ClerkPersonalChangeRegionBottomSheetState());
  }

  void closeCityBottomSheet() {
    if (cityBottomSheetController != null) {
      cityBottomSheetController.close();
      cityBottomSheetController = null;
      isCityBottomSheetShown = false;
      emit(ClerkPersonalChangeCityBottomSheetState());
    }
  }

  void closeRegionBottomSheet() {
    if (regionBottomSheetController != null) {
      regionBottomSheetController.close();
      regionBottomSheetController = null;
      isRegionBottomSheetShown = false;
      emit(ClerkPersonalChangeRegionBottomSheetState());
    }
  }
}
