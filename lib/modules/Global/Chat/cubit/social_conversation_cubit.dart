import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
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
import 'package:just_audio/just_audio.dart';
import 'package:mostaqbal_masr/models/chat_model.dart';
import 'package:mostaqbal_masr/modules/Global/Chat/cubit/social_conversation_states.dart';
import 'package:mostaqbal_masr/modules/Global/Chat/screens/selected_images_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';
import 'package:mostaqbal_masr/shared/gallery_item_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialConversationCubit extends Cubit<SocialConversationStates> {
  SocialConversationCubit() : super(SocialConversationInitialState());

  static SocialConversationCubit get(context) => BlocProvider.of(context);

  String userID = "";
  String userName = "";
  String userPhone = "";
  String userPassword = "";
  String userDocType = "";
  String userDocNumber = "";
  String userCity = "";
  String userRegion = "";
  String userImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/mostaqbal-masr.appspot.com/o/Users%2Flogo.jpg?alt=media";
  String userToken = "";
  bool isImageOnly = false;
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
  String pathToAudio = "";
  String audioPathStore = "";
  bool isRecording = false;
  bool isPaused = false;
  bool emptyImage = true;
  int recordDuration = 0;
  int lastAudioPlayingIndex = 0;
  double audioPlayingSpeed = 1.0;
  late double currAudioPlayingTime;
  final AudioPlayer justAudioPlayer = AudioPlayer();
  final Record record = Record();
  IconData iconData = Icons.play_arrow_rounded;
  Timer? timer;
  Timer? ampTimer;
  Amplitude? amplitude;
  Stream<QuerySnapshot>? documentStream;
  var audioRecorder = Record();
  final ImagePicker imagePicker = ImagePicker();
  ChatModel? chatModel;
  ChatImagesModel? chatImagesModel;
  List<ChatImagesModel> chatImagesList = [];
  List<ChatModel> chatList = [];
  List<ChatModel> chatListReversed = [];
  List<XFile?>? messageImages = [];
  List<File?>? messageImagesFilesList = [];
  List<dynamic> messageImagesStringList = ["emptyList"];
  GalleryModel? galleryItemModel;
  List<GalleryModel> galleryItemModelList = [];
  List<dynamic>? imageFileList = [];
  String chatID = "";

  void navigate(BuildContext context, route) {
    navigateTo(context, route);
  }

  void sendNotification(
      String message, String notificationID, String receiverToken) async {
    var serverKey =
        'AAAAnuydfc0:APA91bF3jkS5-JWRVnTk3mEBnj2WI70EYJ1zC7Q7TAI6GWlCPTd37SiEkhuRZMa8Uhu9HTZQi1oiCEQ2iKQgxljSyLtWTAxN4HoB3pyfTuyNQLjXtf58s99nAEivs2L6NzEL0laSykTK';

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
            'title': 'لديك رسالة جديدة'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': Random().nextInt(100),
            'status': 'done'
          },
          'to': receiverToken,
        },
      ),
    );
  }

  void sendFireStoreMessage(String receiverID, String chatID, String message,
      String type, bool isSeen, String userToken) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    Map<String, dynamic> dataMap = HashMap();
    dataMap['SenderID'] = prefs.getString('ClerkID');
    dataMap['ReceiverID'] = receiverID;
    dataMap['Message'] = message;
    dataMap['type'] = type;
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = ["emptyList"];
    dataMap["fileName"] = "";
    dataMap["hasImages"] = false;
    dataMap["createdAt"] = Timestamp.now();
    dataMap["imagesCount"] = 0;
    dataMap["recordDuration"] = 0;
    dataMap["fileSize"] = "0 KB";

    Map<String, dynamic> chatListMap = HashMap();
    chatListMap['ReceiverID'] = receiverID;
    chatListMap['LastMessage'] = message;
    chatListMap['LastMessageType'] = type;
    chatListMap['LastMessageTime'] = currentTime;
    chatListMap['LastMessageSender'] = prefs.getString('ClerkID');

    FirebaseFirestore.instance
        .collection("Chats")
        .doc(chatID)
        .collection("Messages")
        .doc(currentFullTime)
        .set(dataMap)
        .then((value) async {
      Map<String, dynamic> imageMap = HashMap();
      imageMap["messageImages"] = ["emptyList"];

      FirebaseFirestore.instance
          .collection("Chats")
          .doc(chatID)
          .collection("Messages")
          .doc(currentFullTime)
          .collection("Images")
          .doc(currentFullTime)
          .set(imageMap);

      sendNotification(message, currentTime, userToken);
      emit(SocialConversationSendMessageState());
      await FirebaseFirestore.instance
          .collection("ChatList")
          .doc(userID)
          .collection('Chats')
          .doc(receiverID)
          .get()
          .then((value) async {
        if (value.exists) {
          Map data = value.data()!;
          print("Chat Exist with ID ${data["ChatID"]}\n");
          chatID = data["ChatID"];
          chatListMap['ChatID'] = chatID;
          await FirebaseFirestore.instance
              .collection("ChatList")
              .doc(userID)
              .collection('Chats')
              .doc(receiverID)
              .update(chatListMap);
          await FirebaseFirestore.instance
              .collection("ChatList")
              .doc(receiverID)
              .collection('Chats')
              .doc(userID)
              .update(chatListMap);
        }
      });
    });
  }

  Future<void> sendFireStoreFileMessage(String receiverID,
      bool isSeen, FilePickerResult file, String chatID) async {
    emit(SocialConversationUploadingFileState(file.files.first.name));

    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    var storageRef = FirebaseStorage.instance.ref("Chats").child(chatID).child(currentFullTime);
    var ref = FirebaseFirestore.instance.collection("Chats").doc(chatID).collection("Messages");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    Map<String, dynamic> dataMap = HashMap();
    dataMap['SenderID'] = prefs.getString('ClerkID');
    dataMap['ReceiverID'] = receiverID;
    dataMap['Message'] = "";
    dataMap['type'] = "file";
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = ["emptyList"];
    dataMap["fileName"] = file.files.first.name;
    dataMap["hasImages"] = false;
    dataMap["createdAt"] = Timestamp.now();
    dataMap["imagesCount"] = 0;
    dataMap["recordDuration"] = 0;

    if(file.files.first.size > 1000000){
      dataMap["fileSize"] = "${(file.files.first.size * 0.000001).toStringAsFixed(2)} MB";
    }else {
      dataMap["fileSize"] = "${(file.files.first.size * 0.001).toStringAsFixed(2)} KB";
    }

    Map<String, dynamic> chatListMap = HashMap();
    chatListMap['ReceiverID'] = receiverID;
    chatListMap['LastMessage'] = file.files.last;
    chatListMap['LastMessageType'] = "file";
    chatListMap['LastMessageTime'] = currentTime;
    chatListMap['LastMessageSender'] = prefs.getString('ClerkID');


      ref.doc(currentFullTime).set(dataMap).then((value) async {
        uploadingFileName = currentFullTime;
        String fileName = file.files.first.path.toString();

        File imageFile = File(fileName);

        var uploadTask = storageRef.child(fileName).putFile(imageFile);
        await uploadTask.then((p0) {
          p0.ref.getDownloadURL().then((value) {

            dataMap['Message'] = value.toString();

            ref.doc(currentFullTime).update(dataMap).then((value){
              uploadingFileName = "";
              emit(SocialConversationSendFilesSuccessState());
            }).catchError((error){
              print("UPLOAD ERROR : $error\n");
              uploadingFileName = "";
              emit(SocialConversationSendFilesErrorState(error.toString()));
            });
          }).catchError((error) {
            print("UPLOAD ERROR : $error\n");
            uploadingFileName = "";
            emit(SocialConversationSendFilesErrorState(error.toString()));
          });
        }).catchError((error) {
          print("UPLOAD ERROR : $error\n");
          uploadingFileName = "";
          emit(SocialConversationSendFilesErrorState(error.toString()));
        });
      }).catchError((error) {
        print("UPLOAD ERROR : $error\n");
        uploadingFileName = "";
        emit(SocialConversationSendFilesErrorState(error.toString()));
      });
  }

  Future<void> uploadMultipleImagesFireStore(BuildContext context, String receiverID, String chatID) async{
    emit(SocialConversationUploadingImagesState());
    DateTime now = DateTime.now();
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
    String currentTime = DateFormat("hh:mm a").format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    var storageRef = FirebaseStorage.instance.ref("Chats").child(chatID).child(currentFullTime);
    var ref = FirebaseFirestore.instance.collection("Chats").doc(chatID).collection("Messages").doc(currentFullTime);
    var chatListRef = FirebaseFirestore.instance.collection("ChatList").doc(userID).collection("Chats").doc(receiverID);
    var chatListTwoRef = FirebaseFirestore.instance.collection("ChatList").doc(receiverID).collection("Chats").doc(userID);

    List<String> urlsList = [];

    Map<String, Object> dataMap = HashMap();

    dataMap['Message'] = "صورة";
    dataMap['ReceiverID'] = receiverID;
    dataMap['SenderID'] = userID;
    dataMap['fileName'] = "";
    dataMap["isSeen"] = false;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = ["emptyList"];
    dataMap["type"] = "Image";
    dataMap["hasImages"] = true;
    dataMap["createdAt"] = Timestamp.now();
    dataMap["imagesCount"] = messageImagesStaticList!.length;
    dataMap["recordDuration"] = 0;
    dataMap["fileSize"] = "0 KB";

    for (int i = 0; i < messageImagesStaticList!.length; i++) {
      ref.set(dataMap).then((value) async {
        uploadingImageName = currentFullTime;
        String fileName = messageImagesStaticList![i].toString();
        uploadingImagesMessageID = currentFullTime;
        imagesUploaded = false;

        File imageFile = File(fileName);

        var uploadTask = storageRef.child(fileName).putFile(imageFile);
        await uploadTask.then((p0) {
          p0.ref.getDownloadURL().then((value) {
            urlsList.add(value.toString());

            dataMap["messageImages"] = urlsList;
            dataMap['fileName'] = urlsList[0].toString();

            ref.update(dataMap).then((value){
              messageImagesStaticList = [];
              uploadingImageName = "";

              Map<String, dynamic> chatListMap = HashMap();
              chatListMap['ReceiverID'] = receiverID;
              chatListMap['LastMessage'] = "صورة";
              chatListMap['LastMessageType'] = "Image";
              chatListMap['LastMessageTime'] = currentTime;
              chatListMap['LastMessageSender'] = prefs.getString('ClerkID');

              chatListRef.update(chatListMap);
              chatListTwoRef.update(chatListMap);


              emit(SocialConversationSendImagesSuccessState());
            }).catchError((error){
              print("UPLOAD ERROR : $error\n");
              uploadingImageName = "";
              emit(SocialConversationSendImagesErrorState(error.toString()));
            });
          }).catchError((error) {
            print("UPLOAD ERROR : $error\n");
            uploadingImageName = "";
            emit(SocialConversationSendImagesErrorState(error.toString()));
          });
        }).catchError((error) {
          print("UPLOAD ERROR : $error\n");
          uploadingImageName = "";
          emit(SocialConversationSendImagesErrorState(error.toString()));
        });
      }).catchError((error) {
        print("UPLOAD ERROR : $error\n");
        uploadingImageName = "";
        emit(SocialConversationSendImagesErrorState(error.toString()));
      });
    }
  }

  Future<void> sendFileMessage(String type, String receiverID, bool isSeen,
      FilePickerResult file) async {
    emit(SocialConversationUploadingFileState(file.files.first.name));

    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef = database.reference().child("Messages");
    var storageRef = FirebaseStorage.instance
        .ref("Messages")
        .child(receiverID)
        .child("Future Of Egypt")
        .child(file.files.first.name);

    Map<String, Object> dataMap = HashMap();
    dataMap['SenderID'] = userID;
    dataMap['ReceiverID'] = receiverID;
    dataMap['type'] = type;
    dataMap['Message'] = "";
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = "emptyList";
    dataMap["hasImages"] = false;
    dataMap["fileName"] = file.files.first.name;
    dataMap["imagesCount"] = 0;

    messagesRef.child(currentFullTime).set(dataMap).then((value) async {
      File docFile = File(file.files.first.path!);
      var uploadTask = storageRef.putFile(docFile);

      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          dataMap["Message"] = value.toString();
          messagesRef.child(currentFullTime).update(dataMap);
        }).catchError((error) {
          emit(SocialConversationSendMessageErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(SocialConversationSendMessageErrorState(error.toString()));
      });

      database
          .reference()
          .child("Clients")
          .child(userID)
          .child("ClientLastMessage")
          .set(file.files.first.name)
          .then((value) {
        database
            .reference()
            .child("Clients")
            .child(userID)
            .child("ClientLastMessageTime")
            .set(currentTime)
            .then((value) {
          database
              .reference()
              .child("Clients")
              .child(userID)
              .child("ClientState")
              .set("متصل الان")
              .then((value) {
            emit(SocialConversationSendMessageState());
          });
        });
      });
    });
  }

  void getFireStoreMessage(String receiverID, String chatID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    FirebaseFirestore.instance
        .collection("Chats")
        .doc(chatID)
        .collection("Messages")
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((event) async {
      chatList.clear();
      chatImagesList.clear();
      chatListReversed.clear();
      messageImages!.clear();
      messageImagesStringList.clear();
      chatModel = null;
      chatImagesModel = null;
      galleryItemModel = null;

        for (var element in event.docs) {
          Map data = element.data();

          chatImagesModel = ChatImagesModel(data["messageFullTime"], (data["messageImages"] as List));
          chatImagesList.add(chatImagesModel!);

          chatModel = ChatModel.full(
              data["SenderID"],
              data["ReceiverID"],
              data["Message"],
              data["messageTime"],
              data["messageFullTime"],
              data["createdAt"],
              data["type"],
              data["imagesCount"],
              data["fileSize"],
              data["recordDuration"],
              data["isSeen"],
              data["fileName"],
              data["hasImages"],
              messageImagesStringList,
              chatImagesModel
          );
          chatList.add(chatModel!);
          chatListReversed = chatList.reversed.toList();
          emit(SocialConversationGetMessageSuccessState());
        }
    });
  }

  void changeUserState(String currentState, String receiverID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> dataMap = HashMap();
    dataMap["PartnerState"] = currentState;
    FirebaseFirestore.instance
        .collection("ChatList")
        .doc(prefs.getString("ClerkID"))
        .collection("Chats")
        .doc(receiverID)
        .update(dataMap);
    emit(SocialConversationChangeUserState());
  }

  void sendMessage(String receiverID, String message, String type, bool isSeen,
      String userToken) {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef = database.reference().child("Messages");

    Map<String, Object> dataMap = HashMap();

    dataMap['SenderID'] = userID;
    dataMap['ReceiverID'] = receiverID;
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
          .child("Clients")
          .child(receiverID)
          .child("ClientLastMessage")
          .set(message)
          .then((value) {
        database
            .reference()
            .child("Clients")
            .child(receiverID)
            .child("ClientLastMessageTime")
            .set(currentTime)
            .then((value) {
          sendNotification(message, currentTime, userToken);
          emit(SocialConversationSendMessageState());
        });
      });
    }).catchError((error) {
      emit(SocialConversationSendMessageErrorState(error.toString()));
    });
  }

  void selectImages(
      BuildContext context, String receiverID, String chatID) async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    imageFileList = [];

    if (selectedImages!.isNotEmpty) {
      for (var element in selectedImages) {
        imageFileList!.add(element.path);
      }
      messageImagesStaticList = imageFileList!;
      navigateTo(
          context,
          SocialSelectedImagesScreen(
            chatImages: imageFileList,
            receiverID: receiverID,
            chatID: chatID,
          ));
      emit(SocialConversationSelectImagesState());
    }
  }

  void selectFile(String receiverID, String chatID) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);

      if (result != null) {
        sendFireStoreFileMessage(receiverID, false, result, chatID);
      } else {
        // User canceled the picker
      }

      emit(SocialConversationSelectFilesState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(SocialConversationPermissionDeniedState());
    }
  }

  Future<void> sendAudioMessage(
      String receiverID, String type, bool isSeen, File file) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    String fileName = audioPathStore;

    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef = database.reference().child("Messages");

    var storageRef = FirebaseStorage.instance
        .ref("Messages")
        .child(receiverID)
        .child("Future Of Egypt")
        .child(fileName);

    Map<String, Object> dataMap = HashMap();
    dataMap['SenderID'] = userID;
    dataMap['ReceiverID'] = receiverID;
    dataMap['type'] = type;
    dataMap['Message'] = "";
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = "emptyList";
    dataMap["hasImages"] = false;
    dataMap["fileName"] = fileName;

    messagesRef.child(currentFullTime).set(dataMap).then((value) async {
      emit(SocialConversationUploadingRecordState(fileName));
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
            uploadingRecordName = "";
            emit(SocialConversationSendMessageState());
          }).catchError((error) {
            uploadingRecordName = "";
            emit(SocialConversationSendMessageErrorState(error.toString()));
          });
        }).catchError((error) {
          uploadingRecordName = "";
          emit(SocialConversationSendMessageErrorState(error.toString()));
        });
      }).catchError((error) {
        uploadingRecordName = "";
        emit(SocialConversationSendMessageErrorState(error.toString()));
      });
    });
  }

/*
  void getMessages(String receiverID) async {
    emit(SocialConversationLoadingMessageState());

    FirebaseDatabase.instance
        .reference()
        .child('Messages')
        .onValue
        .listen((event) {
      chatList.clear();
      chatListReversed.clear();
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
              val["messageImages"].forEach((image){
                print("Test Image $image\n");
                if(!messageImages!.contains(image)){
                  messageImages!.add(XFile(image));
                }

                print("Test Image List  ${messageImages!.length}\n");
              });
              messageImagesStringList = messageImages!.map<String>((file) => file!.path).toList();
              print("Test String Length ${messageImagesStringList!.length}\n");
              print("Test String Length ${messageImagesStringList![0].toString()}\n");

            }

            chatModel = ChatModel(
              val["SenderID"],
              val["ReceiverID"],
              val["Message"],
              val["messageTime"],
              val["messageFullTime"],
              val["createdAt"],
              messageImages,
              val["type"],
              val["isSeen"],
              val["fileName"],
              val["hasImages"],
              messageImagesStringList,
            );

            if (((chatModel!.senderID.toString() == userID) &&
                (chatModel!.receiverID.toString() == receiverID)) ||
                (chatModel!.receiverID.toString() == userID) &&
                    (chatModel!.senderID.toString() == receiverID)) {
              //buildItemsList(messageImagesStringList!);
              chatList.add(chatModel!);
              chatListReversed = chatList.reversed.toList();
            }
          });
        }
      }

      emit(SocialConversationGetMessageSuccessState());
    });
    print("User ID : $userID\n");
    await FirebaseDatabase.instance
        .reference()
        .child("ChatList")
        .child(userID)
        .child("Future Of Egypt")
        .once()
        .then((value) {
      if (!value.exists) {
        FirebaseDatabase.instance
            .reference()
            .child("ChatList")
            .child(userID)
            .child("Future Of Egypt")
            .child("ReceiverID")
            .set("Future Of Egypt");
      }
    }).catchError((error) {
      emit(SocialConversationGetMessageErrorState(error.toString()));
    });

    await FirebaseDatabase.instance
        .reference()
        .child("ChatList")
        .child("Future Of Egypt")
        .child(userID)
        .child("ReceiverID")
        .set(userID);
  }
*/

  Future<void> downloadDocumentFile(String receiverID, String fileName) async {
    emit(SocialConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
          File('$path/Future Of Egypt Media/Documents/$fileName');

      //try {
      await FirebaseStorage.instance
          .ref('Messages')
          .child(receiverID)
          .child("Future Of Egypt")
          .child(fileName)
          .writeToFile(downloadToFile)
          .then((p0) {
        downloadingFileName = "";
        emit(SocialConversationDownloadFileSuccessState());
      }).catchError((error) {
        downloadingFileName = "";
        emit(SocialConversationDownloadFileErrorState(error.toString()));
      });
      // } on FirebaseException catch (e) {
      // downloadingFileName = "";
      // emit(ConversationDownloadFileErrorState(e.message.toString()));
      // }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingFileName = "";
      emit(SocialConversationPermissionDeniedState());
    }
  }

  Future<void> downloadAudioFile(String fileName, int index) async {
    emit(SocialConversationLoadingDownloadFileState(fileName));
    downloadingRecordName = fileName;

    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      File downloadToFile = File(
          '/storage/emulated/0/Download/Future Of Egypt Media/Records/$fileName');

      try {
        await FirebaseStorage.instance
            .ref('Messages/$userID/Future Of Egypt/$fileName')
            .writeToFile(downloadToFile);
        downloadingRecordName = "";
        emit(SocialConversationDownloadFileSuccessState());

        chatMicrophoneOnTapAction(index, fileName);
      } on FirebaseException catch (e) {
        downloadingRecordName = "";
        emit(SocialConversationDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingRecordName = "";
      emit(SocialConversationPermissionDeniedState());
    }
  }

  Future<void> downloadImageFile(String fileName) async {
    emit(SocialConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
          File('$path/Future Of Egypt Media/Images/$fileName');
      try {
        await FirebaseStorage.instance
            .ref('Messages/$userID/Future Of Egypt/$fileName')
            .writeToFile(downloadToFile);
        downloadingFileName = "";
        emit(SocialConversationDownloadFileSuccessState());
      } on FirebaseException catch (e) {
        downloadingFileName = "";
        emit(SocialConversationDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingFileName = "";
      emit(SocialConversationPermissionDeniedState());
    }
  }

  bool checkForDocumentFile(String fileName) {
    bool isFileExist = File(
            "/storage/emulated/0/Download/Future Of Egypt Media/Documents/$fileName")
        .existsSync();
    return isFileExist;
  }

  bool checkForAudioFile(String fileName) {
    bool isFileExist = File(
            "/storage/emulated/0/Download/Future Of Egypt Media/Records/$fileName")
        .existsSync();
    return isFileExist;
  }

  bool checkForImageFile(String fileName) {
    bool isFileExist = File(
            "/storage/emulated/0/Download/Future Of Egypt Media/Images/$fileName")
        .existsSync();

    if (!isFileExist) {
      downloadImageFile(fileName);
    }

    return isFileExist;
  }

  Future<void> createUserDocumentsDirectory() async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory recordingsDirectory =
          Directory('$externalDoc/Future Of Egypt Media/Documents/');

      if (await recordingsDirectory.exists()) {
        //if folder already exists return path

        emit(SocialConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await recordingsDirectory.create(recursive: true);

        emit(SocialConversationCreateDirectoryState());
      }
    } else {
      emit(SocialConversationPermissionDeniedState());
    }
  }

  Future<void> createUserRecordingsDirectory() async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory recordingsDirectory =
          Directory('$externalDoc/Future Of Egypt Media/Records/');

      if (await recordingsDirectory.exists()) {
        //if folder already exists return path

        emit(SocialConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await recordingsDirectory.create(recursive: true);

        emit(SocialConversationCreateDirectoryState());
      }
    } else {
      emit(SocialConversationPermissionDeniedState());
    }
  }

  Future<void> createUserImagesDirectory() async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory imagesDirectory =
          Directory('$externalDoc/Future Of Egypt Media/Images/');

      if (await imagesDirectory.exists()) {
        //if folder already exists return path

        emit(SocialConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await imagesDirectory.create(recursive: true);

        emit(SocialConversationCreateDirectoryState());
      }
    } else {
      emit(SocialConversationPermissionDeniedState());
    }
  }

  Future recordAudio() async {
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      audioRecorder = Record();
      String currentFullTime =
          DateFormat("yyyy-MM-dd-HH-mm-ss").format(DateTime.now());
      String extension = ".m4a";
      await createUserRecordingsDirectory();
      audioPath =
          "/storage/emulated/0/Download/Future Of Egypt Media/Records/${currentFullTime.trim().toString()}-audio$extension";
      audioPathStore = "${currentFullTime.trim().toString()}-audio$extension";
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
      emit(SocialConversationStartRecordSuccessState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(SocialConversationPermissionDeniedState());
    }
  }

  Future stopRecord(String receiverID) async {
    timer?.cancel();
    ampTimer?.cancel();
    isRecording = false;
    startedRecordValue.value = false;
    await audioRecorder.stop();
    await sendAudioMessage(receiverID, "Audio", false, File(audioPath));
    audioPath = "";
    audioPathStore = "";
    emit(SocialConversationStopRecordSuccessState());
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
    emit(SocialConversationCancelRecordSuccessState());
  }

  Future toggleRecording(String receiverID) async {
    if (!isRecording) {
      await recordAudio();
    } else {
      await stopRecord(receiverID);
    }
    emit(SocialConversationToggleRecordSuccessState());
  }

  void changeRecordingState() async {
    isRecording = false;
    startedRecordValue.value = false;
    emit(SocialConversationChangeRecordingState());
  }

  void startTimer() {
    timer?.cancel();
    ampTimer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      recordDuration++;
      emit(SocialConversationIncreaseTimerSuccessState());
    });

    ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      amplitude = await audioRecorder.getAmplitude();
      emit(SocialConversationAmpTimerSuccessState());
    });
  }

  void initRecorder() async {
    isRecording = false;
    emit(SocialConversationInitializeRecordSuccessState());
  }

  void chatMicrophoneOnTapAction(int index, String fileName) async {
    try {
      justAudioPlayer.positionStream.listen((event) {
        currAudioPlayingTime = event.inMicroseconds.ceilToDouble();
        loadingTime =
            '${event.inMinutes} : ${event.inSeconds > 59 ? event.inSeconds % 60 : event.inSeconds}';
        emit(SocialConversationChangeRecordPositionState());
      });

      justAudioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          justAudioPlayer.stop();
          loadingTime = '0:00';
          iconData = Icons.play_arrow_rounded;
        }
      });

      if (lastAudioPlayingIndex != index) {
        await justAudioPlayer.setFilePath(
            '/storage/emulated/0/Download/Future Of Egypt Media/Records/$fileName');

        lastAudioPlayingIndex = index;
        totalDuration =
            '${justAudioPlayer.duration!.inMinutes} : ${justAudioPlayer.duration!.inSeconds > 59 ? justAudioPlayer.duration!.inSeconds % 60 : justAudioPlayer.duration!.inSeconds}';
        iconData = Icons.pause_rounded;
        audioPlayingSpeed = 1.0;
        justAudioPlayer.setSpeed(audioPlayingSpeed);

        await justAudioPlayer.play();
      } else {
        print(justAudioPlayer.processingState);
        if (justAudioPlayer.processingState == ProcessingState.idle) {
          await justAudioPlayer.setFilePath(
              '/storage/emulated/0/Download/Future Of Egypt Media/Records/$fileName');

          lastAudioPlayingIndex = index;
          totalDuration =
              '${justAudioPlayer.duration!.inMinutes} : ${justAudioPlayer.duration!.inSeconds}';
          iconData = Icons.pause_rounded;

          await justAudioPlayer.play();
        } else if (justAudioPlayer.playing) {
          iconData = Icons.play_arrow_rounded;

          await justAudioPlayer.pause();
        } else if (justAudioPlayer.processingState == ProcessingState.ready) {
          iconData = Icons.pause;

          await justAudioPlayer.play();
        } else if (justAudioPlayer.processingState ==
            ProcessingState.completed) {}
      }
      emit(SocialConversationPlayRecordSuccessState());
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
    emit(SocialConversationStopRecordSuccessState());
  }
}
