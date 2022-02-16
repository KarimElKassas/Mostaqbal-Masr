import 'dart:collection';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mostaqbal_masr/models/city_model.dart';
import 'package:mostaqbal_masr/models/region_model.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_register_states.dart';
import 'package:mostaqbal_masr/modules/Customer/dropdown/drop_list_model.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerRegisterCubit extends Cubit<CustomerRegisterStates> {
  CustomerRegisterCubit() : super(CustomerRegisterInitialState());

  static CustomerRegisterCubit get(context) => BlocProvider.of(context);

  var cityBottomSheetController;
  var regionBottomSheetController;
  bool isCityBottomSheetShown = false;
  bool isRegionBottomSheetShown = false;

  String selectedCityName = "";
  double? selectedCityID;
  String selectedRegionName = "";
  double? selectedRegionID;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isPassword = true;
  bool emptyImage = true;
  String imageUrl = "";

  IconData suffix = Icons.visibility_rounded;

  DropListModel idDropListModel = DropListModel([
    OptionItem(id: 1, title: "بطاقة شخصية"),
    OptionItem(id: 2, title: "جواز سفر"),
    OptionItem(id: 3, title: "سجل تجارى")
  ]);
  OptionItem idOptionItemSelected = OptionItem(id: 0, title: "نوع الوثيقة");

  CityModel? cityModel;
  List<CityModel> cityList = [];

  RegionModel? regionModel;
  List<RegionModel> regionList = [];

  double? personID, classificationPersonID, personPhoneID,personDataID;
  String? personPhone,personDocumentValue;

  void changePasswordVisibility() {
    isPassword = !isPassword;

    suffix =
        isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded;

    emit(CustomerRegisterChangePasswordVisibilityState());
  }

  void changePaperIndex(OptionItem optionItem) {
    idOptionItemSelected = optionItem;
    emit(CustomerRegisterChangePaperState());
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
      emit(CustomerRegisterGetCitiesSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        emit(CustomerRegisterGetCitiesErrorState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(CustomerRegisterGetCitiesErrorState(error.toString()));
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
      emit(CustomerRegisterGetRegionsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        emit(CustomerRegisterGetRegionsErrorState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(CustomerRegisterGetRegionsErrorState(error.toString()));
      }
    });
  }

  Future<void> insertPersonName(String personName,String personPhone, String userPassword, String userDocType, String userDocNumber, String userCity, String userRegion, int personAddress, int placeID,String documentValue, int statementTypeID) async {
    await DioHelper.postData(
        url: 'person/POST',
        query: {
          'Person_Name': personName,
          'Person_Address': personAddress,
          'Place_ID': placeID
        }).then((value) {

        getPersonID(personName, personAddress).then((value){
          print("Person ID : $personID \n");
          insertClassificationPersonID().then((value){
            getClassificationPersonID().then((value){
              print("Classification Person ID : $classificationPersonID \n");

              insertPersonPhone(personPhone).then((value){
                getPersonPhone().then((value){
                  print("Person Phone ID : $personPhoneID \n");
                  print("Person Phone : $personPhone \n");

                  insertPersonDocumentID(documentValue, statementTypeID).then((value){
                    getPersonDocument().then((value){
                      print("Person Document Value : $personDocumentValue \n");
                      print("Person Data ID : $personDataID \n");

                        uploadUserFirebase(personName, personPhone, userPassword, userDocType, userDocNumber, userCity, userRegion);

                    });
                  });
                });
              });
            });
          });
        });

      emit(CustomerRegisterAddNameSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        emit(CustomerRegisterAddNameErrorState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(CustomerRegisterAddNameErrorState(error.toString()));
      }
    });
  }

  Future<void> getPersonID(String personName , int personAddress) async {
    await DioHelper.getData(
        url: 'person/GetWithName',
        query: {
          'Person_Name': personName,
          'Person_Address': personAddress
        }
          )
        .then((value) {
      personID = value.data[0]["Person_ID"];
    });
  }

  Future<void> insertClassificationPersonID() async {
    await DioHelper.postData(
        url: 'classificationPersons/POST',
        query: {
          'Classification_ID': 9,
          'Person_ID': personID!.round(),
        }).then((value) {

      emit(CustomerRegisterAddClassificationPersonIDSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        emit(CustomerRegisterAddClassificationPersonIDErrorState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(CustomerRegisterAddClassificationPersonIDErrorState(error.toString()));
      }
    });
  }
  Future<void> insertPersonPhone(String personPhone) async {
    await DioHelper.postData(
        url: 'personPhone/POST',
        query: {
          'Person_Phone_Number': personPhone,
          'Person_ID': personID!.round(),
        }).then((value) {

      emit(CustomerRegisterAddPhoneSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        emit(CustomerRegisterAddPhoneErrorState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(CustomerRegisterAddPhoneErrorState(error.toString()));
      }
    });
  }
  Future<void> insertPersonDocumentID(String documentValue,int statementTypeID) async {
    await DioHelper.postData(
        url: 'personData/POST',
        query: {
          'Statement_Type_ID': statementTypeID,
          'Person_Data_Value': documentValue,
          'Person_ID': personID!.round(),
        }).then((value) {

      emit(CustomerRegisterAddDocumentSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        emit(CustomerRegisterAddDocumentErrorState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(CustomerRegisterAddDocumentErrorState(error.toString()));
      }
    });
  }
  Future<void> getPersonPhone() async {
    await DioHelper.getData(
        url: 'personPhone/GetWithParameters',
        query: {
          'Person_ID': personID!.round()
        }
    )
        .then((value) {
      personPhoneID = value.data[0]["Person_Fon_ID"];
      personPhone = value.data[0]["Person_Fon_Num"];
    });
  }
  Future<void> getPersonDocument() async {
    await DioHelper.getData(
        url: 'personData/GetWithParameters',
        query: {
          'Person_ID': personID!.round()
        }
    )
        .then((value) {
      personDocumentValue = value.data[0]["Person_Data_Value"];
      personDataID = value.data[0]["Person_Data_ID"];
    });
  }
  Future<void> getClassificationPersonID() async {
    await DioHelper.getData(
        url: 'classificationPersons/GetWithPersonID',
        query: {
          'Person_ID': personID!.round(),
        }
    )
        .then((value) {
      classificationPersonID = value.data[0]["Classification_Persons_ID"];

    });
  }

  void showCityBottomSheet(context) {

    isCityBottomSheetShown = true;

    cityBottomSheetController =
        scaffoldKey.currentState!.showBottomSheet<void>((BuildContext context) {
          return GestureDetector(
            onVerticalDragDown: (_) {},
            child: Container(
              height: 250,
              decoration:  BoxDecoration(
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
              )
            ),
          );
        });
    emit(CustomerRegisterChangeCityBottomSheetState());
  }
  void showRegionBottomSheet(context) {

    isRegionBottomSheetShown = true;

    regionBottomSheetController =
        scaffoldKey.currentState!.showBottomSheet<void>((BuildContext context) {
          return GestureDetector(
            onVerticalDragDown: (_) {},
            child: Container(
                height: 250,
                decoration:  BoxDecoration(
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
                )
            ),
          );
        });
    emit(CustomerRegisterChangeRegionBottomSheetState());
  }

  void closeCityBottomSheet() {
    if (cityBottomSheetController != null) {
      cityBottomSheetController.close();
      cityBottomSheetController = null;
      isCityBottomSheetShown = false;
      emit(CustomerRegisterChangeCityBottomSheetState());
    }
  }
  void closeRegionBottomSheet() {
    if (regionBottomSheetController != null) {
      regionBottomSheetController.close();
      regionBottomSheetController = null;
      isRegionBottomSheetShown = false;
      emit(CustomerRegisterChangeRegionBottomSheetState());
    }
  }


  final ImagePicker imagePicker = ImagePicker();

  void selectImage() async {

    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

    imageUrl = image!.path;

    emptyImage = false;

    emit(CustomerRegisterChangeImageState());
  }


  void uploadUserFirebase(String userName, String userPhone, String userPassword, String userDocType, String userDocNumber, String userCity, String userRegion)async {

    try {
      emit(CustomerRegisterLoadingState());

      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "$userPhone@gmail.com",
          password: userPassword
      ).then((value) async {
        value.user!.getIdToken().then((value){
          saveUser(userName, userPhone, userPassword, userDocType, userDocNumber, userCity, userRegion, value);
        });

      }).catchError((error){

        emit(CustomerRegisterErrorState(error.toString()));

      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(CustomerRegisterErrorState("The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        emit(CustomerRegisterErrorState("The account already exists for that email."));
      }
    } catch (e) {
      emit(CustomerRegisterErrorState(e.toString()));
    }

  }

  Future saveUser(String userName, String userPhone, String userPassword, String userDocType, String userDocNumber, String userCity, String userRegion, String userToken) async {

    var storageRef = FirebaseStorage.instance.ref("Users/$userPhone");
    FirebaseDatabase database = FirebaseDatabase.instance;
    var usersRef = database.reference().child("Users");

    Map<String, Object> dataMap = HashMap();

    dataMap['UserID'] = classificationPersonID!.round().toString();
    dataMap['UserName'] = userName;
    dataMap['UserPhone'] = userPhone;
    dataMap['UserPassword'] = userPassword;
    dataMap["UserDocType"] = userDocType;
    dataMap["UserDocNumber"] = userDocNumber;
    dataMap["UserCity"] = userCity;
    dataMap["UserRegion"] = userRegion;
    dataMap["UserToken"] = userToken;
    dataMap["UserState"] = "متصل الان";
    dataMap["UserLastMessage"] = "";
    dataMap["UserLastMessageTime"] = "";

      usersRef.child(classificationPersonID!.round().toString()).set(dataMap).then((value) async {
        String fileName = imageUrl;

        File imageFile = File(fileName);

        var uploadTask = storageRef.putFile(imageFile);
        await uploadTask.then((p0) {
          p0.ref.getDownloadURL().then((value) {

            dataMap["UserImage"] = value.toString();

            usersRef.child(classificationPersonID!.round().toString()).update(dataMap).then((realtimeDbValue)async {

              SharedPreferences prefs = await SharedPreferences.getInstance();

              prefs.setString("CustomerID", classificationPersonID!.round().toString());
              prefs.setString("CustomerName", userName);
              prefs.setString("CustomerPhone", userPhone);
              prefs.setString("CustomerPassword", userPassword);
              prefs.setString("CustomerDocType", userDocType);
              prefs.setString("CustomerDocNumber", userDocNumber);
              prefs.setString("CustomerCity", userCity);
              prefs.setString("CustomerRegion", userRegion);
              prefs.setString("CustomerImageUrl", value.toString());
              prefs.setString("CustomerToken", userToken).then((value){
                showToast(
                  message: "تم التسجيل بنجاح",
                  length: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                );

                emit(CustomerRegisterSuccessState());
              }).catchError((error){
                emit(CustomerRegisterErrorState(error.toString()));
              });

            }).catchError((error) {
              emit(CustomerRegisterErrorState(error.toString()));
            });
          }).catchError((error) {
            emit(CustomerRegisterErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(CustomerRegisterErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(CustomerRegisterErrorState(error.toString()));
      });

  }

}
