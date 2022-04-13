import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart' as j;
import 'package:mostaqbal_masr/models/group_chat_model.dart';
import 'package:mostaqbal_masr/models/group_model.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/details/screens/group_details_screen.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/conversation/screens/group_selected_images_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';
import 'package:mostaqbal_masr/shared/gallery_item_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'group_conversation_states.dart';

class GroupConversationCubit extends Cubit<GroupConversationStates> {
  GroupConversationCubit() : super(GroupConversationInitialState());

  static GroupConversationCubit get(context) => BlocProvider.of(context);

  String userID = "";
  String receiverID = "Future Of Egypt";
  String userName = "";
  String userPhone = "";
  String userNumber = "";
  String userPassword = "";
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
  String fileUrl = "";
  String downloadingFileName = "";
  String downloadingRecordName = "";
  String uploadingFileName = "";
  String uploadingRecordName = "";
  String uploadingImageName = "";
  String totalDuration = '0:00';
  String loadingTime = '0:00';
  String audioPath = "";
  String audioPathStore = "";
  String pathToAudio = "";
  bool isImageOnly = false;
  bool isRecording = false;
  bool isPaused = false;
  bool emptyImage = true;
  int recordDuration = 0;
  int lastAudioPlayingIndex = 0;
  double audioPlayingSpeed = 1.0;
  bool gotMembers = false;
  late double currAudioPlayingTime;
  final j.AudioPlayer justAudioPlayer = j.AudioPlayer();
  final Record record = Record();
  IconData iconData = Icons.play_arrow_rounded;
  Timer? timer;
  Timer? ampTimer;
  Amplitude? amplitude;
  Stream<QuerySnapshot>? documentStream;
  var audioRecorder = Record();
  final ImagePicker imagePicker = ImagePicker();
  GroupModel? groupModel;
  GroupChatModel? chatModel;
  List<GroupModel> groupList = [];
  List<GroupChatModel> chatList = [];
  List<GroupChatModel> chatListReversed = [];
  List<GroupChatModel> chatListTempReversed = [];
  List<Object?> groupMembersList = [];
  List<Object?> groupMembersNameList = [];
  List<Object?> groupAdminsList = [];
  List<Object?> groupAdminsNameList = [];
  List<XFile>? imageFileList = [];
  List<XFile?> emptyList = [];
  List<XFile?>? messageImages = [];
  List<File?>? messageImagesFilesList = [];
  List<String>? messageImagesStringList = [];
  GalleryModel? galleryItemModel;
  List<GalleryModel> galleryItems = <GalleryModel>[];

  void navigateToDetails(BuildContext context,String groupID, String groupName, String groupImage, List<Object?> membersList, List<Object?> adminsList){
    navigateTo(context, GroupDetailsScreen(groupID: groupID,groupName: groupName,groupImage: groupImage, membersList: membersList, adminsList: adminsList, membersCount: ((membersList.length + adminsList.length) - 1).toString(),));
  }

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getString("ClerkID")!;
    userName = prefs.getString("ClerkName")!;
    userPhone = prefs.getString("ClerkPhone")!;
    userNumber = prefs.getString("ClerkNumber")!;
    userPassword = prefs.getString("ClerkPassword")!;
    userManagementName = prefs.getString("ClerkManagementName")!;
    userTypeName = prefs.getString("ClerkTypeName")!;
    userRankName = prefs.getString("ClerkRankName")!;
    userCategoryName = prefs.getString("ClerkCategoryName")!;
    userCoreStrengthName = prefs.getString("ClerkCoreStrengthName")!;
    userPresenceName = prefs.getString("ClerkPresenceName")!;
    userJobName = prefs.getString("ClerkJobName")!;
    userToken = prefs.getString("ClerkToken")!;
    userImage = prefs.getString("ClerkImage")!;
  }

  void changeUserState(String state) async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    database
        .reference()
        .child("Clerks")
        .child(userID)
        .child("ClerkState")
        .set(state)
        .then((value) {
      emit(GroupConversationChangeUserTypeState());
    });
  }

  void sendNotification(
      String message, String notificationID, String groupID,String senderName) async {
    var serverKey =
        'AAAAnuydfc0:APA91bF3jkS5-JWRVnTk3mEBnj2WI70EYJ1zC7Q7TAI6GWlCPTd37SiEkhuRZMa8Uhu9HTZQi1oiCEQ2iKQgxljSyLtWTAxN4HoB3pyfTuyNQLjXtf58s99nAEivs2L6NzEL0laSykTK';

    for (var element in groupMembersList){ 
      
      if(element.toString() != userID){
        
        var token = await FirebaseDatabase.instance.reference().child("Clerks").child(element.toString()).child("ClerkToken").get();
        print("Token : ${token.value.toString()}\n");
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': message,
                'title': senderName
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': Random().nextInt(100),
                'status': 'done'
              },
              'to': token.value.toString(),
            },
          ),
        );
      }
    }
  }

  void sendMessage(String groupID, String message, String type, bool isSeen) {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef =
        database.reference().child("Groups").child(groupID).child("Messages");

    Map<String, Object> dataMap = HashMap();

    dataMap['SenderID'] = userID;
    dataMap['SenderName'] = userName;
    dataMap['SenderImage'] = userImage;
    dataMap['groupID'] = groupID;
    dataMap['Message'] = message;
    dataMap['type'] = type;
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = "emptyList";
    dataMap["fileName"] = "";
    dataMap["hasImages"] = false;

    messagesRef.child(currentFullTime).set(dataMap).then((value) {
      database
          .reference()
          .child("Groups")
          .child(groupID)
          .child("Info")
          .child("GroupLastMessageSenderName")
          .set(userName);
      database
          .reference()
          .child("Groups")
          .child(groupID)
          .child("Info")
          .child("GroupLastMessage")
          .set(message);
      database
          .reference()
          .child("Groups")
          .child(groupID)
          .child("Info")
          .child("GroupLastMessageTime")
          .set(currentTime);
      sendNotification(message, currentFullTime, groupID, userName);
      emit(GroupConversationSendMessageState());
    }).catchError((error) {
      emit(GroupConversationSendMessageErrorState(error.toString()));
    });
  }

  void selectImages(BuildContext context, String groupID) async {
    final XFile? selectedImage =  await imagePicker.pickImage(source: ImageSource.gallery);

    if (selectedImage!.path.isNotEmpty) {
      imageFileList = [];
      imageFileList!.add(selectedImage);
      messageImagesStaticList = imageFileList!;

      navigateTo(
          context, GroupSelectedImagesScreen(chatImages: imageFileList, groupID: groupID));

      print("Image List length : " + imageFileList!.length.toString());
      print("Image 0 path : " + imageFileList![0].path.toString());

      emit(GroupConversationSelectImagesState());
    }
  }

  void selectFile(String groupID) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);

      if (result != null) {
        sendFileMessage(groupID,"file", false, result);
      } else {
        // User canceled the picker
      }
      emit(GroupConversationSelectFilesState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future<void> sendFileMessage(
      String groupID, String type, bool isSeen, FilePickerResult file) async {

    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef = database.reference().child("Groups").child(groupID).child("Messages");
    var storageRef = FirebaseStorage.instance
        .ref("Groups")
        .child(groupID)
        .child("Media")
        .child(file.files.first.name);

    Map<String, Object> dataMap = HashMap();
    dataMap['SenderID'] = userID;
    dataMap['SenderName'] = userName;
    dataMap['SenderImage'] = userImage;
    dataMap['groupID'] = groupID;
    dataMap['type'] = type;
    dataMap['Message'] = "";
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = "emptyList";
    dataMap["hasImages"] = false;
    dataMap["fileName"] = file.files.first.name;

    //send data then update with file url
    messagesRef.child(currentFullTime).set(dataMap).then((value)async {
      emit(GroupConversationUploadingFileState(file.files.first.name));
      uploadingFileName = file.files.first.name;
      print("FILE NAME UPLOADING : $uploadingFileName \n");
      File docFile = File(file.files.first.path!);

      var uploadTask = storageRef.putFile(docFile);
       uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          dataMap["Message"] = value.toString();

          messagesRef
              .child(currentFullTime)
              .update(dataMap)
              .then((realtimeDbValue) async {

            database
                .reference()
                .child("Groups")
                .child(groupID)
                .child("Info")
                .child("GroupLastMessageSenderName")
                .set(userName);
            database
                .reference()
                .child("Groups")
                .child(groupID)
                .child("Info")
                .child("GroupLastMessage")
                .set("ملف");
            database
                .reference()
                .child("Groups")
                .child(groupID)
                .child("Info")
                .child("GroupLastMessageTime")
                .set(currentTime);

            chatListTempReversed.removeLast();
            uploadingFileName = "";
            emit(GroupConversationSendMessageState());
          }).catchError((error) {
            uploadingFileName = "";
            emit(GroupConversationSendMessageErrorState(error.toString()));
          });
        }).catchError((error) {
          uploadingFileName = "";
          emit(GroupConversationSendMessageErrorState(error.toString()));
        });
      }).catchError((error) {
        uploadingFileName = "";
        emit(GroupConversationSendMessageErrorState(error.toString()));
      });
    });



  }

  Future<void> sendAudioMessage(String groupID, String type, bool isSeen, File file) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    String fileName = audioPathStore;

    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef = database.reference().child("Groups").child(groupID).child("Messages");
    var storageRef = FirebaseStorage.instance
        .ref("Groups")
        .child(groupID)
        .child("Media")
        .child(fileName);

    Map<String, Object> dataMap = HashMap();
    dataMap['SenderID'] = userID;
    dataMap['SenderName'] = userName;
    dataMap['SenderImage'] = userImage;
    dataMap['groupID'] = groupID;
    dataMap['type'] = type;
    dataMap['Message'] = "";
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = "emptyList";
    dataMap["hasImages"] = false;
    dataMap["fileName"] = fileName;

    messagesRef.child(currentFullTime).set(dataMap).then((value)async {
      emit(GroupConversationUploadingRecordState(fileName));
      uploadingRecordName = fileName;
      print("RECORD NAME UPLOADING : $uploadingRecordName \n");

      File audioFile = File(file.path.toString());

      var uploadTask = storageRef.putFile(audioFile);
      uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          dataMap["Message"] = value.toString();

          messagesRef
              .child(currentFullTime)
              .update(dataMap)
              .then((realtimeDbValue) async {
            database
                .reference()
                .child("Groups")
                .child(groupID)
                .child("Info")
                .child("GroupLastMessageSenderName")
                .set(userName);
            database
                .reference()
                .child("Groups")
                .child(groupID)
                .child("Info")
                .child("GroupLastMessage")
                .set("تسجيل صوتى");
            database
                .reference()
                .child("Groups")
                .child(groupID)
                .child("Info")
                .child("GroupLastMessageTime")
                .set(currentTime);
                uploadingRecordName = "";
            emit(GroupConversationSendMessageState());
          }).catchError((error) {
            uploadingRecordName = "";
            emit(GroupConversationSendMessageErrorState(error.toString()));
          });
        }).catchError((error) {
          uploadingRecordName = "";
          emit(GroupConversationSendMessageErrorState(error.toString()));
        });
      }).catchError((error) {
        uploadingRecordName = "";
        emit(GroupConversationSendMessageErrorState(error.toString()));
      });
    });
  }

  Future uploadMultipleImages(BuildContext context, String groupID) async {

    DateTime now = DateTime.now();
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
    String currentTime = DateFormat("hh:mm a").format(now);

    var storageRef = FirebaseStorage.instance.ref("Groups").child(groupID).child("Media");
    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef = database.reference().child("Groups").child(groupID).child("Messages").child(currentFullTime);
    String currentFullTime1 =
    DateFormat("yyyy-MM-dd-HH-mm-ss").format(DateTime.now());
    List<String> urlsList = [];

    Map<String, Object> dataMap = HashMap();

    dataMap['Message'] = "صورة";
    dataMap['SenderID'] = userID;
    dataMap['SenderName'] = userName;
    dataMap['SenderImage'] = userImage;
    dataMap['groupID'] = groupID;
    dataMap['fileName'] = "";
    dataMap["isSeen"] = false;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["type"] = "Image";
    dataMap["hasImages"] = true;

    //for (int i = 0; i < messageImagesStaticList!.length; i++) {
    messagesRef.set(dataMap).then((value) async {
      String fileName = messageImagesStaticList![0].path.toString();

      emit(GroupConversationUploadingImagesState(fileName));
      uploadingImageName = fileName;
      print("IMAGE NAME UPLOADING : $uploadingImageName \n");

      File imageFile = File(fileName);

      var uploadTask = storageRef.child(fileName).putFile(imageFile);
      uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          urlsList.add(value.toString());

          dataMap["fileName"] = value.toString();
          dataMap["messageImages"] = urlsList;

          messagesRef.update(dataMap).then((value) {
            if(Navigator.canPop(context)){
              Navigator.pop(context);
            }

            database
                .reference()
                .child("Groups")
                .child(groupID)
                .child("Info")
                .child("GroupLastMessageSenderName")
                .set(userName);
            database
                .reference()
                .child("Groups")
                .child(groupID)
                .child("Info")
                .child("GroupLastMessage")
                .set("صورة");
            database
                .reference()
                .child("Groups")
                .child(groupID)
                .child("Info")
                .child("GroupLastMessageTime")
                .set(currentTime);

            messageImagesStaticList = [];
            uploadingImageName = "";
            emit(GroupConversationUploadImagesSuccessState());
          }).catchError((error) {
            uploadingImageName = "";
            emit(GroupConversationUploadingImageErrorState(error.toString()));
          });
        }).catchError((error) {
          uploadingImageName = "";
          emit(GroupConversationUploadingImageErrorState(error.toString()));
        });
      }).catchError((error) {
        uploadingImageName = "";
        emit(GroupConversationUploadingImageErrorState(error.toString()));
      });
    }).catchError((error) {
      uploadingImageName = "";
      emit(GroupConversationUploadingImageErrorState(error.toString()));
    });
    //}
  }

  void getGroupMembers(String groupID) async {
    emit(GroupConversationLoadingMembersState());

    gotMembers = false;
    FirebaseDatabase.instance
        .reference()
        .child('Groups')
        .child(groupID)
        .child("Info")
        .child("Members")
        .onValue
        .listen((event) async {
      groupList.clear();
      groupMembersList = [];
      groupModel = null;

      if (event.snapshot.exists) {
        List<Object?> data = event.snapshot.value;
        if (data.isNotEmpty) {
          print('Members Data : $data\n');
          groupMembersList = data;
        }
        groupMembersNameList = [];

        for (var element in data)  {

          var clerkName = await FirebaseDatabase.instance
              .reference()
              .child('Clerks')
              .child(element.toString())
              .child("ClerkName").get();
          groupMembersNameList.add(clerkName.value.toString());
        }
      }
      gotMembers = true;
      emit(GroupConversationGetGroupMembersSuccessState());
    });
    FirebaseDatabase.instance
        .reference()
        .child('Groups')
        .child(groupID)
        .child("Info")
        .child("Admins")
        .onValue
        .listen((event)async  {
      groupList.clear();
      groupAdminsList = [];
      groupModel = null;

      if (event.snapshot.exists) {
        List<Object?> data = event.snapshot.value;
        if (data.isNotEmpty) {
          print('Admins Data : $data\n');
          groupAdminsList = data;
        }
        groupAdminsNameList = [];

        for (var element in data)  {

          var clerkName = await FirebaseDatabase.instance
              .reference()
              .child('Clerks')
              .child(element.toString())
              .child("ClerkName").get();
          groupAdminsNameList.add(clerkName.value.toString());
        }
      }
      gotMembers = true;
      emit(GroupConversationGetGroupMembersSuccessState());
    });
  }

  void getMessages(String groupID) async {
    emit(GroupConversationLoadingMessageState());

    FirebaseDatabase.instance
        .reference()
        .child('Groups')
        .child(groupID)
        .child("Messages")
        .onValue
        .listen((event) {
      chatList.clear();
      chatListReversed.clear();
      galleryItems.clear();
      messageImages!.clear();
      messageImagesStringList!.clear();
      chatModel = null;
      galleryItemModel = null;

      if (event.snapshot.exists) {
        Map data = event.snapshot.value;
        if (data.isNotEmpty) {
          data.forEach((key, val) {
            //print('Message Data : $val');
            if (val["hasImages"] == true) {
              val["messageImages"].forEach((image) {
                print("Test Image $image\n");
                if (!messageImages!.contains(image)) {
                  messageImages!.add(XFile(image));
                }

                print("Test Image List  ${messageImages!.length}\n");
              });

              messageImagesStringList = messageImages!.map<String>((file) => file!.path).toList();

              print("Test String Length ${messageImagesStringList!.length}\n");
              print(
                  "Test String Length ${messageImagesStringList![0].toString()}\n");
            }
            buildItemsList(messageImages!);

            chatModel = GroupChatModel(
              val["SenderID"],
              val["SenderName"],
              val["SenderImage"],
              val["groupID"],
              val["Message"],
              val["messageTime"],
              val["messageFullTime"],
              messageImages,
              val["type"],
              val["isSeen"],
              val["fileName"],
              val["hasImages"],
              messageImagesStringList,
              galleryItems
            );

            if (((chatModel!.senderID.toString() == userID) || (groupMembersList.contains(userPhone)) || (groupAdminsList.contains(userPhone)))) {
              chatList.add(chatModel!);
              chatListReversed = chatList.reversed.toList();
              chatListTempReversed = chatListReversed;
            }
          });
        }
      }

      emit(GroupConversationGetMessageSuccessState());
    });
  }

  buildItemsList(List<XFile?> items) {
    galleryItems = [];
    for (var item in items) {
      galleryItemModel = GalleryModel(id: item!.path.toString(), imageUrl: item);
      galleryItems.add(galleryItemModel!);
    }
    print("Build Item LIST LENGTH : ${galleryItems.length}\n");
  }

  Future<void> downloadDocumentFile(
      String fileName,String senderName, String groupName, String groupID) async {
    emit(GroupConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
      File('$path/Future Of Egypt Media/Documents/$groupName/$fileName');
      //try {
        await FirebaseStorage.instance
            .ref("Groups")
            .child(groupID)
            .child("Media")
            .child(fileName)
            .writeToFile(downloadToFile);
        downloadingFileName = "";
        emit(GroupConversationDownloadFileSuccessState());
      /*} on FirebaseException catch (e) {
        downloadingFileName = "";
        emit(GroupConversationDownloadFileErrorState(e.message.toString()));
      }*/
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingFileName = "";
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future<void> downloadAudioFile(
      String fileName,String senderName,String groupName, String groupID, int index) async {
    emit(GroupConversationLoadingDownloadFileState(fileName));
    downloadingRecordName = fileName;

    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
      File('$path/Future Of Egypt Media/Records/$groupName/$fileName');
      try {
        await FirebaseStorage.instance
            .ref('Groups/$groupID/Media/$fileName')
            .writeToFile(downloadToFile);
        downloadingRecordName = "";
        emit(GroupConversationDownloadFileSuccessState());

        chatMicrophoneOnTapAction(index, fileName, groupName,senderName);
      } on FirebaseException catch (e) {
        downloadingRecordName = "";
        emit(GroupConversationDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingRecordName = "";
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future<void> downloadImageFile(
      String fileName, String senderID,String senderName, String groupName, String groupID) async {
    emit(GroupConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
          File('$path/Future Of Egypt Media/Images/$groupName/$fileName');
      try {
        await FirebaseStorage.instance
            .ref('Groups/$groupID/Media/$fileName')
            .writeToFile(downloadToFile);
        downloadingFileName = "";
        emit(GroupConversationDownloadFileSuccessState());
      } on FirebaseException catch (e) {
        downloadingFileName = "";
        emit(GroupConversationDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingFileName = "";
      emit(GroupConversationPermissionDeniedState());
    }
  }

  bool checkForDocumentFile(String fileName, String groupName, String groupID,String senderName) {
    bool isFileExist = File(
            "/storage/emulated/0/Download/Future Of Egypt Media/Documents/$groupName/$fileName")
        .existsSync();
    return isFileExist;
  }

  bool checkForAudioFile(String fileName, String groupName, String groupID,String senderName) {
    bool isFileExist = File(
        "/storage/emulated/0/Download/Future Of Egypt Media/Records/$groupName/$fileName")
        .existsSync();
    return isFileExist;
  }

  bool checkForImageFile(String fileName, String groupName, String groupID,String senderName) {
    bool isFileExist = File(
        "/storage/emulated/0/Download/Future Of Egypt Media/Images/$groupName/$fileName")
        .existsSync();

    if(!isFileExist){
      downloadImageFile(fileName, userID, userName, groupName, groupID);
    }

    return isFileExist;
  }

  Future<void> createUserDocumentsDirectory(String groupName) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory recordingsDirectory =
          Directory('$externalDoc/Future Of Egypt Media/Documents/$groupName/');

      if (await recordingsDirectory.exists()) {
        //if folder already exists return path

        emit(GroupConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await recordingsDirectory.create(recursive: true);

        emit(GroupConversationCreateDirectoryState());
      }
    } else {
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future<void> createUserRecordingsDirectory(String groupName) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory recordingsDirectory =
          Directory('$externalDoc/Future Of Egypt Media/Records/$groupName/');

      if (await recordingsDirectory.exists()) {
        //if folder already exists return path

        emit(GroupConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await recordingsDirectory.create(recursive: true);

        emit(GroupConversationCreateDirectoryState());
      }
    } else {
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future<void> createUserImagesDirectory(String groupName) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory imagesDirectory =
          Directory('$externalDoc/Future Of Egypt Media/Images/$groupName/');

      if (await imagesDirectory.exists()) {
        //if folder already exists return path

        emit(GroupConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await imagesDirectory.create(recursive: true);

        emit(GroupConversationCreateDirectoryState());
      }
    } else {
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future recordAudio(String groupName, String senderName) async {
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      audioRecorder = Record();
      String currentFullTime =
          DateFormat("yyyy-MM-dd-HH-mm-ss").format(DateTime.now());
      String extension = ".m4a";
      await createUserRecordingsDirectory(groupName);
      audioPath =
          "/storage/emulated/0/Download/Future Of Egypt Media/Records/$groupName/${currentFullTime.trim().toString()}-audio$extension";
      audioPathStore =
      "${currentFullTime.trim().toString()}-audio$extension";
      await audioRecorder.start(
          path: audioPath,
          bitRate: 16000,
          samplingRate: 16000,
          encoder: AudioEncoder.AAC);
      bool recording = await audioRecorder.isRecording();
      isRecording = recording;
      recordDuration = 0;
      startedRecordValue.value = true;
      startTimer();
      emit(GroupConversationStartRecordSuccessState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(GroupConversationPermissionDeniedState());
    }
  }

  void startTimer() {
    timer?.cancel();
    ampTimer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      recordDuration++;
      emit(GroupConversationIncreaseTimerSuccessState());
    });

    ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      amplitude = await audioRecorder.getAmplitude();
      emit(GroupConversationAmpTimerSuccessState());
    });
  }

  Future stopRecord(String groupID) async {
    timer?.cancel();
    ampTimer?.cancel();
    isRecording = false;
    startedRecordValue.value = false;
    await audioRecorder.stop();
    await sendAudioMessage(groupID,"Audio", false, File(audioPath));
    audioPath = "";
    audioPathStore = "";
    emit(GroupConversationStopRecordSuccessState());
  }

  void changeRecordingState() async {
    isRecording = false;
    startedRecordValue.value = false;
    emit(GroupConversationChangeRecordingState());
  }

  Future cancelRecord() async {
    timer?.cancel();
    ampTimer?.cancel();
    isRecording = false;
    startedRecordValue.value = false;
    await audioRecorder.stop();
    File(audioPath).deleteSync();
    audioPath = "";
    audioPathStore = "";
    emit(GroupConversationCancelRecordSuccessState());
  }

  Future toggleRecording(String groupID, String groupName, String senderName) async {
    if (!isRecording) {
      await recordAudio(groupName, senderName);
    } else {
      await stopRecord(groupID);
    }
    emit(GroupConversationToggleRecordSuccessState());
  }

  void initRecorder() async {
    isRecording = false;
    emit(GroupConversationInitializeRecordSuccessState());
  }

  void chatMicrophoneOnTapAction(int index, String fileName, String groupName, String senderName) async {
    try {
      justAudioPlayer.positionStream.listen((event) {
        currAudioPlayingTime = event.inMicroseconds.ceilToDouble();
        loadingTime =
            '${event.inMinutes} : ${event.inSeconds > 59 ? event.inSeconds % 60 : event.inSeconds}';
        emit(GroupConversationChangeRecordPositionState());
      });

      justAudioPlayer.playerStateStream.listen((event) {
        if (event.processingState == j.ProcessingState.completed) {
          justAudioPlayer.stop();
          loadingTime = '0:00';
          iconData = Icons.play_arrow_rounded;
        }
      });

      if (lastAudioPlayingIndex != index) {
        await justAudioPlayer.setFilePath(
            '/storage/emulated/0/Download/Future Of Egypt Media/Records/$groupName/$fileName');

        lastAudioPlayingIndex = index;
        totalDuration =
            '${justAudioPlayer.duration!.inMinutes} : ${justAudioPlayer.duration!.inSeconds > 59 ? justAudioPlayer.duration!.inSeconds % 60 : justAudioPlayer.duration!.inSeconds}';
        iconData = Icons.pause_rounded;
        audioPlayingSpeed = 1.0;
        justAudioPlayer.setSpeed(audioPlayingSpeed);

        await justAudioPlayer.play();
      } else {
        print(justAudioPlayer.processingState);
        if (justAudioPlayer.processingState == j.ProcessingState.idle) {
          await justAudioPlayer.setFilePath(
              '/storage/emulated/0/Download/Future Of Egypt Media/Records/$groupName/$fileName');

          lastAudioPlayingIndex = index;
          totalDuration =
              '${justAudioPlayer.duration!.inMinutes} : ${justAudioPlayer.duration!.inSeconds}';
          iconData = Icons.pause_rounded;

          await justAudioPlayer.play();
        } else if (justAudioPlayer.playing) {
          iconData = Icons.play_arrow_rounded;

          await justAudioPlayer.pause();
        } else if (justAudioPlayer.processingState == j.ProcessingState.ready) {
          iconData = Icons.pause;

          await justAudioPlayer.play();
        } else if (justAudioPlayer.processingState ==
            j.ProcessingState.completed) {}
      }
      emit(GroupConversationPlayRecordSuccessState());
    } catch (e) {
      print('Audio Playing Error');
      showToast(
          message: 'May be Audio File Not Found',
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
    }
  }

  void chatMicrophoneOnLongPressAction() async {
    if (justAudioPlayer.playing) {
      await justAudioPlayer.stop();

      print('Audio Play Completed');
      justAudioPlayer.stop();
      loadingTime = '0:00';
      iconData = Icons.play_arrow_rounded;
      lastAudioPlayingIndex = -1;
    }
    emit(GroupConversationStopRecordSuccessState());
  }
}
