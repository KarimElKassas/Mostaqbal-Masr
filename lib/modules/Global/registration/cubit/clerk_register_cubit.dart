import 'dart:collection';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mostaqbal_masr/models/clerk_model.dart';
import 'package:mostaqbal_masr/models/firebase_clerk_model.dart';
import 'package:mostaqbal_masr/modules/Global/registration/cubit/clerk_register_states.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../Departments/Monitor/complaints/screens/complaint_screen.dart';
import '../../../Departments/SocialMedia/home/layout/social_home_layout.dart';

class ClerkRegisterCubit extends Cubit<ClerkRegisterStates> {
  ClerkRegisterCubit() : super(ClerkRegisterInitialState());

  static ClerkRegisterCubit get(context) => BlocProvider.of(context);

  var cityBottomSheetController;
  var regionBottomSheetController;
  bool isCityBottomSheetShown = false;
  bool isRegionBottomSheetShown = false;
  bool isUserExist = false;

  String selectedCityName = "";
  double? selectedCityID;
  String selectedRegionName = "";
  double? selectedRegionID;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isPassword = true;
  bool isConfirmPassword = true;
  bool emptyImage = true;
  bool completeRegistration = false;
  String imageUrl = "";

  IconData suffix = Icons.visibility_rounded;

  ClerkModel? clerkModel;
  List<ClerkModel> clerkList = [];

  ClerkFirebaseModel? clerkFirebaseModel;
  List<ClerkFirebaseModel> clerkFirebaseList = [];

  double? personID, classificationPersonID, personPhoneID,personDataID;
  String? personPhone,personDocumentValue;
  bool isCivil = false;

  void changePasswordVisibility() {
    isPassword = !isPassword;

    suffix =
        isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded;

    emit(ClerkRegisterChangePasswordVisibilityState());
  }
  void changeConfirmPasswordVisibility() {
    isConfirmPassword = !isConfirmPassword;

    suffix =
    isConfirmPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded;

    emit(ClerkRegisterChangePasswordVisibilityState());
  }

  Future<void> getClerks(String personNumber) async {
    emit(ClerkRegisterLoadingClerksState());
    clerkList = [];
    clerkFirebaseList = [];
    await DioHelper.getData(
        url: 'userInfo/GetUserInfo',
        query: {'PR_Person_Number': personNumber}).then((value) {
          if(value.statusCode == 200){
            value.data.forEach((clerk)async {
              FirebaseDatabase.instance.reference().child("Clerks").child(clerk['PR_Persons_MobilNum1'].toString()).get().then((value){
                if(value.exists){
                  print("USER EXISTS \n");
                  isUserExist = true;
                }else{
                  print("USER Doesn't EXIST \n");
                  isUserExist = false;
                }
              });

              clerkModel = ClerkModel(
                  clerk['PR_Persons_ID'].toString(), clerk['PR_Persons_Name'].toString(),"", personNumber, clerk['PR_Persons_Address'].toString(), clerk['PR_Persons_MobilNum1'].toString(),
                  clerk['Person_Type_ID'].toString(), clerk['Person_Type_Name'].toString(), clerk['PR_Category_ID'].toString(), clerk['PR_Category_Name'].toString(),
                  clerk['CategoryRank'].toString(), clerk['PR_Rank_ID'].toString(), clerk['PR_Rank_Name'].toString(), clerk['PR_Management_ID'].toString(),
                  clerk['PR_Management_Name'].toString(), clerk['PR_Jobs_ID'].toString(), clerk['PR_Jobs_Name'].toString(), clerk['PR_CoreStrength_ID'].toString(),
                  clerk['PR_CoreStrength_Name'].toString(), clerk['PR_Presence_ID'].toString(), clerk['PR_Presence_Name'].toString(), clerk['TrueOrFalse'].toString());

              globalClerkID = clerk['PR_Persons_ID'].toString();
              globalClerkName = clerk['PR_Persons_Name'].toString();
              globalClerkAddress = clerk['PR_Persons_Address'].toString();
              globalClerkNumber = personNumber;
              globalClerkPhone = clerk['PR_Persons_MobilNum1'].toString();

              if(clerk['Person_Type_ID'] != 4){
                isCivil = false;
              }else{
                isCivil = true;
              }
              clerkList.add(clerkModel!);
              print("Clerk Name : ${clerk['PR_Persons_Name']}\n");
              print("Clerk Type : $isCivil\n");
            });
            emit(ClerkRegisterGetClerksSuccessState());

          }

    }).catchError((error) {
      if (error is DioError) {
        if(error.response!.statusCode! == 400){
          emit(ClerkRegisterNoClerkFoundState());
        }else{
          emit(ClerkRegisterGetClerksErrorState(
              "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
        }

      } else {
        emit(ClerkRegisterGetClerksErrorState(error.toString()));
      }
    });
  }

  Future<void> insertPersonName(BuildContext context, String clerkID, String clerkName, String clerkNumber, String clerkPhone, String clerkPassword, String clerkAddress,
      String managementID, String managementName, String typeName, String rankName, String categoryName, String jobName,
      String presenceName, String coreStrengthName) async {
    emit(ClerkRegisterLoadingUploadClerksState());

    await FirebaseDatabase.instance.reference().child("Clerks").child(clerkPhone).get().then((value) {
      if (value.exists) {
        print("USER EXISTS \n");
        isUserExist = true;
      } else {
        print("USER Doesn't EXIST \n");
        isUserExist = false;
      }
    });
    if(!isUserExist){
      await DioHelper.postData(
          url: 'person/POST',
          query: {
            'Person_Name': clerkName,
            'Person_Address': "",
            'Place_ID': 1
          }).then((value) {

        getPersonID(clerkName).then((value){
          print("Person ID : $personID \n");
          insertClassificationPersonID().then((value){
            getClassificationPersonID().then((value){
              print("Classification Person ID : $classificationPersonID \n");

              insertPersonPhone(clerkPhone).then((value){
                getPersonPhone().then((value){
                  print("Person Phone ID : $personPhoneID \n");
                  print("Person Phone : $personPhone \n");
                  uploadUserFirebase(context, clerkID, clerkName, clerkNumber, clerkPhone, clerkPassword, clerkAddress, managementName, managementID,
                      managementName, typeName, rankName, categoryName, jobName,
                      presenceName, coreStrengthName);
                });
              });
            });
          });
        });
      }).catchError((error) {
        if (error is DioError) {
          emit(ClerkRegisterAddNameErrorState(
              "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
        } else {
          emit(ClerkRegisterAddNameErrorState(error.toString()));
        }
      });
    }else{
      emit(ClerkRegisterClerkExistState());
    }

  }

  Future<void> getPersonID(String personName) async {
    await DioHelper.getData(
        url: 'person/GetWithOnlyName',
        query: {
          'Person_Name': personName,
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
          'Classification_ID': 7,
          'Person_ID': personID!.round(),
        }).catchError((error) {
      if (error is DioError) {
        emit(ClerkRegisterAddClassificationPersonIDErrorState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(ClerkRegisterAddClassificationPersonIDErrorState(error.toString()));
      }
    });
  }
  Future<void> insertPersonPhone(String personPhone) async {

    await DioHelper.postData(
        url: 'personPhone/POST',
        query: {
          'Person_Phone_Number': personPhone,
          'Person_ID': personID!.round(),
        }).catchError((error) {
      if (error is DioError) {
        emit(ClerkRegisterAddPhoneErrorState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(ClerkRegisterAddPhoneErrorState(error.toString()));
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
        }).catchError((error) {
      if (error is DioError) {
        emit(ClerkRegisterAddDocumentErrorState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(ClerkRegisterAddDocumentErrorState(error.toString()));
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
  Future<void> insertLogin() async {
    await DioHelper.postData(
        url: 'classificationPersons/POST',
        query: {
          'Classification_ID': 7,
          'Person_ID': personID!.round(),
        }).then((value) {

      //emit(ClerkRegisterAddClassificationPersonIDSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        emit(ClerkRegisterAddClassificationPersonIDErrorState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(ClerkRegisterAddClassificationPersonIDErrorState(error.toString()));
      }
    });
  }
  
  final ImagePicker imagePicker = ImagePicker();

  void selectImage() async {

    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

    imageUrl = image!.path;

    emptyImage = false;

    emit(ClerkRegisterChangeImageState());
  }

  void uploadUserFirebase(BuildContext context, String clerkID, String clerkName,String clerkNumber, String clerkPhone, String clerkPassword, String clerkAddress,String clerkDepartment,
      String managementID, String managementName, String typeName, String rankName, String categoryName, String jobName,
      String presenceName, String coreStrengthName)async {

    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "$clerkPhone@clerk.com",
          password: clerkPassword
      ).then((value) async {
        FirebaseMessaging.instance.getToken().then((value){
          saveUser(context, clerkID, clerkName, clerkNumber, clerkPhone, clerkPassword, clerkAddress,
              value!,clerkDepartment, managementID, managementName, typeName, rankName, categoryName, jobName,
              presenceName, coreStrengthName);
        });

      }).catchError((error){

        emit(ClerkRegisterErrorState(error.toString()));

      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(ClerkRegisterErrorState("The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        emit(ClerkRegisterErrorState("The account already exists for that email."));
      }
    } catch (e) {
      emit(ClerkRegisterErrorState(e.toString()));
    }

  }

  Future saveUser(BuildContext context, String clerkID, String clerkName,String clerkNumber, String clerkPhone, String clerkPassword, String clerkAddress,
      String clerkToken,String clerkDepartment, String managementID, String managementName, String typeName, String rankName, String categoryName, String jobName,
      String presenceName, String coreStrengthName) async {

    var storageRef = FirebaseStorage.instance.ref("Clerks/$clerkPhone");
    FirebaseDatabase database = FirebaseDatabase.instance;
    var clerksRef = database.reference().child("Clerks");

    Map<String, Object> dataMap = HashMap();

    dataMap['ClerkID'] = clerkPhone;
    dataMap['ClerkName'] = clerkName;
    dataMap['ClerkNumber'] = clerkNumber;
    dataMap['ClerkPhone'] = clerkPhone;
    dataMap['ClerkPassword'] = clerkPassword;
    dataMap["ClerkAddress"] = clerkAddress;
    dataMap["ClerkManagementID"] = managementID;
    dataMap["ClerkManagementName"] = managementName;
    dataMap["ClerkRankName"] = rankName;
    dataMap["ClerkTypeName"] = typeName;
    dataMap["ClerkCategoryName"] = categoryName;
    dataMap["ClerkCoreStrengthName"] = coreStrengthName;
    dataMap["ClerkPresenceName"] = presenceName;
    dataMap["ClerkJobName"] = jobName;
    dataMap["ClerkState"] = "متصل الان";
    dataMap["ClerkLastMessage"] = "";
    dataMap["ClerkLastMessageTime"] = "";
    dataMap["ClerkToken"] = clerkToken;
    dataMap["ClerkSubscriptions"] = ["empty"];

      clerksRef.child(clerkPhone).set(dataMap).then((value) async {
      String fileName = imageUrl;

      File imageFile = File(fileName);

      var uploadTask = storageRef.putFile(imageFile);
      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          dataMap["ClerkImage"] = value.toString();

          clerksRef.child(clerkPhone).update(dataMap).then((
              realtimeDbValue) async {
            clerkFirebaseModel = ClerkFirebaseModel(globalClerkID, globalClerkName, value.toString(), managementID, jobName, globalClerkNumber, globalClerkAddress, globalClerkPhone, clerkPassword, "متصل الأن", clerkToken, "", "",["empty"]);

            globalClerkName = "";
            globalClerkPhone = "";
            globalClerkAddress = "";
            globalClerkNumber = "";
            globalClerkID = "";

            SharedPreferences prefs = await SharedPreferences.getInstance();

            await prefs.setString("ClerkID", clerkID.toString());
            await prefs.setString("ClerkName", clerkName);
            await prefs.setString("ClerkPhone", clerkPhone);
            await prefs.setString("ClerkNumber", clerkNumber);
            await prefs.setString("ClerkPassword", clerkPassword);
            await prefs.setString("ClerkManagementID", managementID);
            await prefs.setString("ClerkManagementName", managementName);
            await prefs.setString("ClerkTypeName", typeName);
            await prefs.setString("ClerkRankName", rankName);
            await prefs.setString("ClerkCategoryName", categoryName);
            await prefs.setString("ClerkCoreStrengthName", coreStrengthName);
            await prefs.setString("ClerkPresenceName", presenceName);
            await prefs.setString("ClerkJobName", jobName);
            await prefs.setString("ClerkToken", clerkToken);
            await prefs.setStringList("ClerkSubscriptions", ["empty"]);

            //clerkModel!.clerkImage = value.toString();

            prefs.setString("ClerkImage", value.toString()).then((value) {
              completeRegistration = true;
              showToast(
                message: "تم التسجيل بنجاح",
                length: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
              );

              emit(ClerkRegisterSuccessState());
              print("MANAGEMENT ID $managementID\n");

              switch (managementID){

              //   إدارة التسويق
                case "1054" :
                  finish(context, const SocialHomeLayout());
                  break;
              //إدارة الرقمنة
                case "1028" :
                  finish(context, const SocialHomeLayout());
                  break;
              //   إدارة الرقابة والمتابعة
                case "1022" :
                  finish(context, const OfficerComplaintScreen());
                  break;

              }

            }).catchError((error){
                emit(ClerkRegisterErrorState(error.toString()));
              });

            }).catchError((error) {
              emit(ClerkRegisterErrorState(error.toString()));
            });
          }).catchError((error) {
            emit(ClerkRegisterErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(ClerkRegisterErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(ClerkRegisterErrorState(error.toString()));
      });
  }

  void finish(BuildContext context, route){
    Navigator.pushReplacement(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
    emit(ClerkRegisterNavigateSuccessState());
  }

}
