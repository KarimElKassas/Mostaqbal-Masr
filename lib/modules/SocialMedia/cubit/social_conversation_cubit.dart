import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
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
import 'package:just_audio/just_audio.dart';
import 'package:mostaqbal_masr/models/chat_model.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_conversation_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';
import 'package:mostaqbal_masr/shared/gallery_item_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class SocialConversationCubit extends Cubit<SocialConversationStates> {
  SocialConversationCubit() : super(SocialConversationInitialState());

  static SocialConversationCubit get(context) => BlocProvider.of(context);

  String userID = "Future Of Egypt";
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
  String totalDuration = '0:00';
  String loadingTime = '0:00';
  String audioPath = "";
  String pathToAudio = "";
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
  List<ChatModel> chatList = [];
  List<ChatModel> chatListReversed = [];
  List<XFile?>? messageImages = [];
  List<File?>? messageImagesFilesList = [];
  List<String>? messageImagesStringList = [];
  GalleryModel? galleryItemModel;

  void navigate(BuildContext context, route) {
    navigateTo(context, route);
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

  void sendMessage(
      String receiverID, String message, String type, bool isSeen, String userToken) {
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
          .child(receiverID)
          .child("UserLastMessage")
          .set(message)
          .then((value) {
        database
            .reference()
            .child("Users")
            .child(receiverID)
            .child("UserLastMessageTime")
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

  void selectImage(String receiverID) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);

      imageUrl = image!.path;

      if (imageUrl.isNotEmpty) {
        emptyImage = false;

        sendImageMessage(receiverID, "Image", false);
      }

      emit(SocialConversationSelectImagesState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(SocialConversationPermissionDeniedState());
    }
  }

  void selectFile(String receiverID) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);

      if (result != null) {
        sendFileMessage(receiverID, "file", false, result);
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

  Future<void> sendImageMessage(
      String receiverID, String type, bool isSeen) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("kk:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef = database.reference().child("Messages");
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
    dataMap["fileName"] = "";

    String fileName = imageUrl;

    File imageFile = File(fileName);

    var uploadTask = storageRef.putFile(imageFile);
    await uploadTask.then((p0) {
      p0.ref.getDownloadURL().then((value) {
        dataMap["Message"] = value.toString();

        messagesRef.push().set(dataMap).then((realtimeDbValue) async {
          database
              .reference()
              .child("Users")
              .child(receiverID)
              .child("UserLastMessage")
              .set("صورة")
              .then((value) {
            database
                .reference()
                .child("Users")
                .child(receiverID)
                .child("UserLastMessageTime")
                .set(currentTime)
                .then((value) {
              emit(SocialConversationSendMessageState());
            });
          });
        }).catchError((error) {
          emit(SocialConversationSendMessageErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(SocialConversationSendMessageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialConversationSendMessageErrorState(error.toString()));
    });
  }

  Future<void> sendAudioMessage(
      String receiverID, String type, bool isSeen, File file) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);

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
    dataMap["fileName"] = fileName;

    File audioFile = File(file.path.toString());

    var uploadTask = storageRef.putFile(audioFile);
    await uploadTask.then((p0) {
      p0.ref.getDownloadURL().then((value) {
        dataMap["Message"] = value.toString();

        messagesRef.push().set(dataMap).then((realtimeDbValue) async {
          database
              .reference()
              .child("Users")
              .child(receiverID)
              .child("UserLastMessage")
              .set("رسالة صوتية")
              .then((value) {
            database
                .reference()
                .child("Users")
                .child(receiverID)
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
                emit(SocialConversationSendMessageState());
              });
            });
          });
        }).catchError((error) {
          emit(SocialConversationSendMessageErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(SocialConversationSendMessageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialConversationSendMessageErrorState(error.toString()));
    });
  }

  Future<void> sendFileMessage(String receiverID, String type, bool isSeen,
      FilePickerResult file) async {
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
    dataMap["fileName"] = file.files.first.name;

    File docFile = File(file.files.first.path!);

    var uploadTask = storageRef.putFile(docFile);
    await uploadTask.then((p0) {
      p0.ref.getDownloadURL().then((value) {
        dataMap["Message"] = value.toString();

        messagesRef.push().set(dataMap).then((realtimeDbValue) async {
          database
              .reference()
              .child("Users")
              .child(receiverID)
              .child("UserLastMessage")
              .set(file.files.first.name)
              .then((value) {
            database
                .reference()
                .child("Users")
                .child(receiverID)
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
                emit(SocialConversationSendMessageState());
              });
            });
          });
        }).catchError((error) {
          emit(SocialConversationSendMessageErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(SocialConversationSendMessageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialConversationSendMessageErrorState(error.toString()));
    });
  }

  void getMessages(String clientID) async {
    emit(SocialConversationLoadingMessageState());

    List<String>? images = [];
    galleryItemModel = null;
    messageImages!.clear();
    messageImagesStringList!.clear();
    FirebaseDatabase.instance
        .reference()
        .child('Messages')
        .onValue
        .listen((event) {
      chatList.clear();
      chatListReversed.clear();
      chatModel = null;
      if (event.snapshot.exists) {
        Map data = event.snapshot.value;
        if (data.isNotEmpty) {
          data.forEach((key, value) {
            print('Message Data : $value');

            if (value["hasImages"] == true) {
              value["messageImages"].forEach((image){
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
              value["SenderID"],
              value["ReceiverID"],
              value["Message"],
              value["messageTime"],
              value["messageFullTime"],
              messageImages,
              value["type"],
              value["isSeen"],
              value["fileName"],
              value["hasImages"],
              messageImagesStringList,
            );

            if (((chatModel!.senderID.toString() == clientID) &&
                    (chatModel!.receiverID.toString() == userID)) ||
                (chatModel!.receiverID.toString() == clientID) &&
                    (chatModel!.senderID.toString() == userID)) {
              chatList.add(chatModel!);
              chatListReversed = chatList.reversed.toList();
            }
          });
        }
      }

      emit(SocialConversationGetMessageSuccessState());
    });
    print("User ID : $userID\n");
    FirebaseDatabase.instance
        .reference()
        .child("ChatList")
        .child(userID)
        .child(clientID)
        .once()
        .then((value) {
      if (!value.exists) {
        FirebaseDatabase.instance
            .reference()
            .child("ChatList")
            .child(userID)
            .child(clientID)
            .child("ReceiverID")
            .set("Future Of Egypt");
      }
    }).catchError((error) {
      emit(SocialConversationGetMessageErrorState(error.toString()));
    });

    FirebaseDatabase.instance
        .reference()
        .child("ChatList")
        .child(clientID)
        .child(userID)
        .child("ReceiverID")
        .set(userID);
  }

  Future<void> downloadDocumentFile(String fileName, String senderID,
      String receiverID, String receiverName) async {
    emit(SocialConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
          File('$path/Future Of Egypt Media/Documents/$receiverName/$fileName');

      try {
        await FirebaseStorage.instance
            .ref('Messages/$senderID/$receiverID/$fileName')
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

  Future<void> downloadAudioFile(String fileName, String senderID,
      String receiverID, String receiverName, int index) async {
    emit(SocialConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      File downloadToFile = File(
          '/storage/emulated/0/Download/Future Of Egypt Media/Records/$receiverName/we-$fileName');

      try {
        await FirebaseStorage.instance
            .ref('Messages/$senderID/$receiverID/$fileName')
            .writeToFile(downloadToFile);
        downloadingFileName = "";
        emit(SocialConversationDownloadFileSuccessState());

        chatMicrophoneOnTapAction(index, fileName, receiverName);
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

  Future<void> downloadImageFile(String fileName, String senderID,
      String receiverID, String receiverName) async {
    emit(SocialConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
          File('$path/Future Of Egypt Media/Images/$receiverName/$fileName');
      try {
        await FirebaseStorage.instance
            .ref('Messages/$senderID/$receiverID/$fileName')
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

  bool checkForDocumentFile(String fileName, String receiverName) {
    bool isFileExist = File(
            "/storage/emulated/0/Download/Future Of Egypt Media/Documents/$receiverName/$fileName")
        .existsSync();
    return isFileExist;
  }

  bool checkForAudioFile(String fileName, String receiverName) {
    bool isFileExist = File(
            '/storage/emulated/0/Download/Future Of Egypt Media/Records/$receiverName/we-$fileName')
        .existsSync();
    return isFileExist;
  }

  bool checkForImageFile(String fileName, String receiverName) {
    bool isFileExist = File(
            "/storage/emulated/0/Download/Future Of Egypt Media/Images/$receiverName/$fileName")
        .existsSync();
    return isFileExist;
  }

  Future<void> createUserDocumentsDirectory(String receiverName) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory recordingsDirectory = Directory(
          '$externalDoc/Future Of Egypt Media/Documents/$receiverName/');

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

  Future<void> createUserRecordingsDirectory(String receiverName) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory recordingsDirectory = Directory(
          '$externalDoc/Future Of Egypt Media/Records/$receiverName/');

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

  Future<void> createUserImagesDirectory(String receiverName) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory imagesDirectory =
          Directory('$externalDoc/Future Of Egypt Media/Images/$receiverName/');

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

  Future recordAudio(String receiverName) async {
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      audioRecorder = Record();
      String currentFullTime =
          DateFormat("yyyy-MM-dd-HH-mm-ss").format(DateTime.now());
      String extension = ".m4a";
      await createUserRecordingsDirectory(receiverName);
      audioPath =
          "/storage/emulated/0/Download/Future Of Egypt Media/Records/$receiverName/we-${currentFullTime.trim().toString()}-audio$extension";
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

  Future stopRecord(String receiverID) async {
    timer?.cancel();
    ampTimer?.cancel();
    isRecording = false;
    startedRecordValue.value = false;
    await audioRecorder.stop();
    await sendAudioMessage(receiverID, "Audio", false, File(audioPath));
    audioPath = "";
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
    emit(SocialConversationCancelRecordSuccessState());
  }

  Future toggleRecording(String receiverName, String receiverID) async {
    if (!isRecording) {
      await recordAudio(receiverName);
    } else {
      await stopRecord(receiverID);
    }
    emit(SocialConversationToggleRecordSuccessState());
  }

  void initRecorder() async {
    isRecording = false;
    emit(SocialConversationInitializeRecordSuccessState());
  }

  void chatMicrophoneOnTapAction(
      int index, String fileName, String receiverName) async {
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
            '/storage/emulated/0/Download/Future Of Egypt Media/Records/$receiverName/we-$fileName');

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
              '/storage/emulated/0/Download/Future Of Egypt Media/Records/$receiverName/we-$fileName');

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
