import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart' as j;
import 'package:mostaqbal_masr/models/chat_model.dart';
import 'package:mostaqbal_masr/modules/Customer/screens/customer_selected_images_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Chat/cubit/conversation_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';
import 'package:mostaqbal_masr/shared/gallery_item_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationCubit extends Cubit<ConversationStates> {
  ConversationCubit() : super(ConversationInitialState());

  static ConversationCubit get(context) => BlocProvider.of(context);

  String userID = "";
  String receiverID = "Future Of Egypt";
  String userName = "";
  String userPhone = "";
  String userPassword = "";
  String userDocType = "";
  String userDocNumber = "";
  String userCity = "";
  String userRegion = "";
  String userImageUrl = "";
  String userToken = "";
  String imageUrl = "";
  String fileUrl = "";
  String downloadingFileName = "";
  String totalDuration = '0:00';
  String loadingTime = '0:00';
  String audioPath = "";
  String pathToAudio = "";
  bool isImageOnly = false;
  bool isRecording = false;
  bool isPaused = false;
  bool emptyImage = true;
  int recordDuration = 0;
  int lastAudioPlayingIndex = 0;
  double audioPlayingSpeed = 1.0;
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
  ChatModel? chatModel;
  List<ChatModel> chatList = [];
  List<ChatModel> chatListReversed = [];
  List<XFile>? imageFileList = [];
  List<XFile?> emptyList = [];

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getString("CustomerID")!;
    userName = prefs.getString("CustomerName")!;
    userPhone = prefs.getString("CustomerPhone")!;
    userPassword = prefs.getString("CustomerPassword")!;
    userDocType = prefs.getString("CustomerDocType")!;
    userDocNumber = prefs.getString("CustomerDocNumber")!;
    userCity = prefs.getString("CustomerCity")!;
    userRegion = prefs.getString("CustomerRegion")!;
    userImageUrl = prefs.getString("CustomerImage")!;
    userToken = prefs.getString("CustomerToken")!;

    documentStream = FirebaseFirestore.instance
        .collection('Messages')
        .snapshots(includeMetadataChanges: true);
  }

  void changeUserState(String state) async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    database
        .reference()
        .child("Users")
        .child(userID)
        .child("UserState")
        .set(state)
        .then((value) {
      emit(ConversationChangeUserTypeState());
    });
  }

  void sendFireStoreMessage(String message, String type, bool isSeen) {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);

    FirebaseFirestore database = FirebaseFirestore.instance;
    FirebaseDatabase realTimeDB = FirebaseDatabase.instance;

    var messagesRef = database.collection("Messages").doc();

    Map<String, Object> dataMap = HashMap();

    dataMap['SenderID'] = userID;
    dataMap['ReceiverID'] = receiverID;
    dataMap['Message'] = message;
    dataMap['type'] = type;
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;

    messagesRef.set(dataMap).then((value) {
      realTimeDB
          .reference()
          .child("Users")
          .child(userID)
          .child("UserLastMessage")
          .set(message)
          .then((value) {
        realTimeDB
            .reference()
            .child("Users")
            .child(userID)
            .child("UserLastMessageTime")
            .set(currentTime)
            .then((value) {
          realTimeDB
              .reference()
              .child("Users")
              .child(userID)
              .child("UserState")
              .set("متصل الان")
              .then((value) {
            emit(ConversationSendMessageState());
          });
        });
      });
    }).catchError((error) {
      emit(ConversationSendMessageErrorState(error.toString()));
    });
  }
  void sendNotification(String message,String notificationID,String receiverToken)async {

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

  void sendMessage(String message, String type, bool isSeen, String receiverToken) {
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
          .child("Users")
          .child(userID)
          .child("UserLastMessage")
          .set(message)
          .then((value) {
        database
            .reference()
            .child("Users")
            .child(userID)
            .child("UserLastMessageTime")
            .set(currentTime)
            .then((value) {
          database
              .reference()
              .child("Users")
              .child(userID)
              .child("UserState")
              .set("متصل الان")
              .then((value) {
                sendNotification(message, currentFullTime, receiverToken);
            emit(ConversationSendMessageState());
          });
        });
      });
    }).catchError((error) {
      emit(ConversationSendMessageErrorState(error.toString()));
    });
  }
  void selectImages(BuildContext context) async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages!.isNotEmpty) {
      imageFileList = [];
      imageFileList!.addAll(selectedImages);
      messageImagesStaticList = imageFileList!;

      navigateTo(context, CustomerSelectedImagesScreen(chatImages: imageFileList));

      print("Image List length : " + imageFileList!.length.toString());
      print("Image 0 path : " + imageFileList![0].path.toString());

      emit(ConversationSelectImagesState());
    }
  }

  void selectFile() async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);

      if (result != null) {
        sendFileMessage("file", false, result);
      } else {
        // User canceled the picker
      }

      emit(ConversationSelectFilesState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(ConversationPermissionDeniedState());
    }
  }

  Future<void> sendFileMessage(String type, bool isSeen, FilePickerResult file) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef = database.reference().child("Messages");
    var storageRef = FirebaseStorage.instance
        .ref("Messages")
        .child(userID)
        .child(receiverID)
        .child(file.files.first.name);

    Map<String, Object> dataMap = HashMap();
    dataMap['SenderID'] = userID;
    dataMap['ReceiverID'] = receiverID;
    dataMap['type'] = type;
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = "emptyList";
    dataMap["hasImages"] = false;
    dataMap["fileName"] = file.files.first.name;

    File docFile = File(file.files.first.path!);

    var uploadTask = storageRef.putFile(docFile);
    await uploadTask.then((p0) {
      p0.ref.getDownloadURL().then((value) {
        dataMap["Message"] = value.toString();

        messagesRef.child(currentFullTime).set(dataMap).then((realtimeDbValue) async {
          database
              .reference()
              .child("Users")
              .child(userID)
              .child("UserLastMessage")
              .set(file.files.first.name)
              .then((value) {
            database
                .reference()
                .child("Users")
                .child(userID)
                .child("UserLastMessageTime")
                .set(currentTime)
                .then((value) {
              database
                  .reference()
                  .child("Users")
                  .child(userID)
                  .child("UserState")
                  .set("متصل الان")
                  .then((value) {
                emit(ConversationSendMessageState());
              });
            });
          });
        }).catchError((error) {
          emit(ConversationSendMessageErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(ConversationSendMessageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(ConversationSendMessageErrorState(error.toString()));
    });
  }

  Future<void> sendAudioMessage(String type, bool isSeen, File file) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    var str = file.path.toString();
    var parts = str.split('we-');
    String fileName = parts[1].trim();

    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef = database.reference().child("Messages");
    var storageRef = FirebaseStorage.instance
        .ref("Messages")
        .child(userID)
        .child(receiverID)
        .child(fileName);

    Map<String, Object> dataMap = HashMap();
    dataMap['SenderID'] = userID;
    dataMap['ReceiverID'] = receiverID;
    dataMap['type'] = type;
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = "emptyList";
    dataMap["fileName"] = fileName;
    dataMap["hasImages"] = false;

    File audioFile = File(file.path.toString());

    var uploadTask = storageRef.putFile(audioFile);
    await uploadTask.then((p0) {
      p0.ref.getDownloadURL().then((value) {
        dataMap["Message"] = value.toString();

        messagesRef.child(currentFullTime).set(dataMap).then((realtimeDbValue) async {
          database
              .reference()
              .child("Users")
              .child(userID)
              .child("UserLastMessage")
              .set("رسالة صوتية")
              .then((value) {
            database
                .reference()
                .child("Users")
                .child(userID)
                .child("UserLastMessageTime")
                .set(currentTime)
                .then((value) {
              database
                  .reference()
                  .child("Users")
                  .child(userID)
                  .child("UserState")
                  .set("متصل الان")
                  .then((value) {
                emit(ConversationSendMessageState());
              });
            });
          });
        }).catchError((error) {
          emit(ConversationSendMessageErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(ConversationSendMessageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(ConversationSendMessageErrorState(error.toString()));
    });
  }

  Future<void> sendFireStoreImageMessage(String type, bool isSeen) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    FirebaseDatabase realTimeDB = FirebaseDatabase.instance;
    FirebaseFirestore database = FirebaseFirestore.instance;

    var messagesRef = database.collection("Messages").doc();
    var storageRef = FirebaseStorage.instance
        .ref("Messages")
        .child(userID)
        .child(receiverID)
        .child(currentFullTime);

    Map<String, Object> dataMap = HashMap();
    dataMap['SenderID'] = userID;
    dataMap['ReceiverID'] = receiverID;
    dataMap['type'] = type;
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;

    String fileName = imageUrl;

    File imageFile = File(fileName);

    var uploadTask = storageRef.putFile(imageFile);
    await uploadTask.then((p0) {
      p0.ref.getDownloadURL().then((value) {
        dataMap["Message"] = value.toString();

        messagesRef.set(dataMap).then((realtimeDbValue) async {
          realTimeDB
              .reference()
              .child("Users")
              .child(userID)
              .child("UserLastMessage")
              .set("صورة")
              .then((value) {
            realTimeDB
                .reference()
                .child("Users")
                .child(userID)
                .child("UserLastMessageTime")
                .set(currentTime)
                .then((value) {
              realTimeDB
                  .reference()
                  .child("Users")
                  .child(userID)
                  .child("UserState")
                  .set("متصل الان")
                  .then((value) {
                emit(ConversationSendMessageState());
              });
            });
          });
        }).catchError((error) {
          emit(ConversationSendMessageErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(ConversationSendMessageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(ConversationSendMessageErrorState(error.toString()));
    });
  }
  List<XFile?>? messageImages = [];
  List<File?>? messageImagesFilesList = [];
  List<String>? messageImagesStringList = [];
  GalleryModel? galleryItemModel;

  void getMessages() async {
    emit(ConversationLoadingMessageState());

    FirebaseDatabase.instance
        .reference()
        .child('Messages')
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

      emit(ConversationGetMessageSuccessState());
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
      emit(ConversationGetMessageErrorState(error.toString()));
    });

    await FirebaseDatabase.instance
        .reference()
        .child("ChatList")
        .child("Future Of Egypt")
        .child(userID)
        .child("ReceiverID")
        .set(userID);
  }
  List<GalleryModel> galleryItems = <GalleryModel>[];

  /*buildItemsList(List<String> items) {
    galleryItems = [];
    for (var item in items) {
      galleryItemModel = GalleryModel(id: item, imageUrl: item);
      galleryItems.add(
        galleryItemModel!
      );
    }
  }*/

  void getFireStoreMessages() async {
    emit(ConversationLoadingMessageState());

    SharedPreferences preferences = await SharedPreferences.getInstance();
    userID = preferences.getString("CustomerID")!;

    FirebaseFirestore.instance
        .collection("Messages")
        .where("SenderID", isEqualTo: userID)
        .get()
        .asStream()
        .listen((event) {
      chatList.clear();
      chatListReversed.clear();
      chatModel = null;
      Map data = event.docs.asMap();
      if (data.isNotEmpty) {
        data.forEach((key, val) {
          print('Message Data : ${val["Message"]}');

          chatModel = ChatModel(
              val["SenderID"],
              val["ReceiverID"],
              val["Message"],
              val["messageTime"],
              val["messageFullTime"],
              val["messageImages"],
              val["type"],
              val["isSeen"],
              val["fileName"],
              val["fileName"],
              val["sss"],);

          if (((chatModel!.senderID.toString() == userID) &&
                  (chatModel!.receiverID.toString() == receiverID)) ||
              (chatModel!.receiverID.toString() == userID) &&
                  (chatModel!.senderID.toString() == receiverID)) {
            chatList.add(chatModel!);
            chatListReversed = chatList.reversed.toList();
          }
        });
      }

      emit(ConversationGetMessageSuccessState());
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
      emit(ConversationGetMessageErrorState(error.toString()));
    });

    await FirebaseDatabase.instance
        .reference()
        .child("ChatList")
        .child("Future Of Egypt")
        .child(userID)
        .child("ReceiverID")
        .set(userID);
  }

  Future<void> downloadDocumentFile(
      String fileName, String senderID, String receiverID) async {
    emit(ConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile = File('$path/Future Of Egypt Media/Documents/$fileName');

      try {
        await FirebaseStorage.instance
            .ref('Messages/$senderID/$receiverID/$fileName')
            .writeToFile(downloadToFile);
        downloadingFileName = "";
        emit(ConversationDownloadFileSuccessState());
      } on FirebaseException catch (e) {
        downloadingFileName = "";
        emit(ConversationDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingFileName = "";
      emit(ConversationPermissionDeniedState());
    }
  }

  Future<void> downloadAudioFile(
      String fileName, String senderID, String receiverID, int index) async {
    emit(ConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {

      File downloadToFile = File('/storage/emulated/0/Download/Future Of Egypt Media/Records/$userName/we-$fileName');

      try {
        await FirebaseStorage.instance
            .ref('Messages/$senderID/$receiverID/$fileName')
            .writeToFile(downloadToFile);
        downloadingFileName = "";
        emit(ConversationDownloadFileSuccessState());

        chatMicrophoneOnTapAction(index, fileName);
      } on FirebaseException catch (e) {
        downloadingFileName = "";
        emit(ConversationDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingFileName = "";
      emit(ConversationPermissionDeniedState());
    }
  }

  Future<void> downloadImageFile(
      String fileName, String senderID, String receiverID) async {
    emit(ConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
          File('$path/Future Of Egypt Media/Images/$fileName');
      try {
        await FirebaseStorage.instance
            .ref('Messages/$senderID/$receiverID/$fileName')
            .writeToFile(downloadToFile);
        downloadingFileName = "";
        emit(ConversationDownloadFileSuccessState());
      } on FirebaseException catch (e) {
        downloadingFileName = "";
        emit(ConversationDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingFileName = "";
      emit(ConversationPermissionDeniedState());
    }
  }

  bool checkForDocumentFile(String fileName) {
    bool isFileExist = File(
            "/storage/emulated/0/Download/Future Of Egypt Media/Documents/$userName/$fileName")
        .existsSync();
    return isFileExist;
  }

  bool checkForAudioFile(String fileName) {
    bool isFileExist = File('/storage/emulated/0/Download/Future Of Egypt Media/Records/$userName/we-$fileName').existsSync();
    return isFileExist;
  }

  bool checkForImageFile(String fileName) {
    bool isFileExist = File(
            "/storage/emulated/0/Download/Future Of Egypt Media/Images/$userName/$fileName")
        .existsSync();
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

        emit(ConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await recordingsDirectory.create(recursive: true);

        emit(ConversationCreateDirectoryState());
      }
    } else {
      emit(ConversationPermissionDeniedState());
    }
  }

  Future<void> createUserRecordingsDirectory() async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory recordingsDirectory =
          Directory('$externalDoc/Future Of Egypt Media/Records/$userName/');

      if (await recordingsDirectory.exists()) {
        //if folder already exists return path

        emit(ConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await recordingsDirectory.create(recursive: true);

        emit(ConversationCreateDirectoryState());
      }
    } else {
      emit(ConversationPermissionDeniedState());
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

        emit(ConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await imagesDirectory.create(recursive: true);

        emit(ConversationCreateDirectoryState());
      }
    } else {
      emit(ConversationPermissionDeniedState());
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
          "/storage/emulated/0/Download/Future Of Egypt Media/Records/$userName/we-${currentFullTime.trim().toString()}-audio$extension";
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
      emit(ConversationStartRecordSuccessState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(ConversationPermissionDeniedState());
    }
  }

  void startTimer() {
    timer?.cancel();
    ampTimer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      recordDuration++;
      emit(ConversationIncreaseTimerSuccessState());
    });

    ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      amplitude = await audioRecorder.getAmplitude();
      emit(ConversationAmpTimerSuccessState());
    });
  }

  Future stopRecord() async {
    timer?.cancel();
    ampTimer?.cancel();
    isRecording = false;
    startedRecordValue.value = false;
    await audioRecorder.stop();
    await sendAudioMessage("Audio", false, File(audioPath));
    audioPath = "";
    emit(ConversationStopRecordSuccessState());
  }
  void changeRecordingState() async {
    isRecording = false;
    startedRecordValue.value = false;
    emit(ConversationChangeRecordingState());
  }

  Future cancelRecord() async {
    timer?.cancel();
    ampTimer?.cancel();
    isRecording = false;
    startedRecordValue.value = false;
    await audioRecorder.stop();
    File(audioPath).deleteSync();
    audioPath = "";
    emit(ConversationCancelRecordSuccessState());
  }

  Future toggleRecording() async {
    if (!isRecording) {
      await recordAudio();
    } else {
      await stopRecord();
    }
    emit(ConversationToggleRecordSuccessState());
  }

  void initRecorder() async {
    isRecording = false;
    emit(ConversationInitializeRecordSuccessState());
  }

  Future<bool> saveAudioFile(String fileName, String senderID, int index) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Future Of Egypt";
          directory = Directory(newPath);
          appDirectory = directory;
        } else {
          return false;
        }
      }
      if (!await directory!.exists()) {
        await directory.create(recursive: true);
        downloadAudioFile(fileName, senderID, "Future Of Egypt", index);
      }
      if (await directory.exists()) {
        downloadAudioFile(fileName, senderID, "Future Of Egypt", index);
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
  void chatMicrophoneOnTapAction(int index, String fileName) async {
    try {
      justAudioPlayer.positionStream.listen((event) {

        currAudioPlayingTime = event.inMicroseconds.ceilToDouble();
        loadingTime = '${event.inMinutes} : ${event.inSeconds > 59 ? event.inSeconds % 60 : event.inSeconds}';
        emit(ConversationChangeRecordPositionState());
      });

      justAudioPlayer.playerStateStream.listen((event) {
        if (event.processingState == j.ProcessingState.completed) {
          justAudioPlayer.stop();
              loadingTime = '0:00';
              iconData = Icons.play_arrow_rounded;
        }
      });

      if (lastAudioPlayingIndex != index) {
        await justAudioPlayer
            .setFilePath('/storage/emulated/0/Download/Future Of Egypt Media/Records/$userName/we-$fileName');

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
          await justAudioPlayer
              .setFilePath('/storage/emulated/0/Download/Future Of Egypt Media/Records/$userName/we-$fileName');

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
      emit(ConversationPlayRecordSuccessState());

    } catch (e) {
      print('Audio Playing Error');
      showToast(message : 'May be Audio File Not Found', length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
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
    emit(ConversationStopRecordSuccessState());
  }
}
