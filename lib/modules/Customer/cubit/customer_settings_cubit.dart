import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:internet_speed_test/internet_speed_test.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_settings_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CustomerSettingsCubit extends Cubit<CustomerSettingsStates> {
  CustomerSettingsCubit() : super(CustomerSettingsInitialState());

  static CustomerSettingsCubit get(context) => BlocProvider.of(context);

  //final internetSpeedTest = InternetSpeedTest();
  double downloadSpeed = 0.0;

  void logOutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove("CustomerID");
    await prefs.remove("CustomerName");
    await prefs.remove("CustomerRegion");
    await prefs.remove("CustomerCity");
    await prefs.remove("CustomerPhone");
    await prefs.remove("CustomerPassword");
    await prefs.remove("CustomerToken");
    await prefs.remove("CustomerImage");
    await prefs.remove("CustomerDocType");
    await prefs.remove("CustomerDocNumber");
    await prefs.remove("UserType");

    customerLogged = false;
    customerState.value = 0;

    showToast(message: "تم تسجيل الخروج بنجاح",
        length: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3);
    emit(CustomerSettingsLogOutSuccessState());

    /*CarrierInfo.carrierName.then((value){
      showToast(message: value!, length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
    });

    internetSpeedTest.startDownloadTesting(
      onDone: (double transferRate, SpeedUnit unit) {
        print('on done the transfer rate $transferRate\n');
        print('on done the speed unit ${unit.name.toString()}\n');
        downloadSpeed = transferRate;
        emit(CustomerSettingsEndSpeedState());
        },
      onProgress: (double percent, double transferRate, SpeedUnit unit) {
        print('on progress the transfer rate $transferRate\n');
        print('on progress the speed unit ${unit.name.toString()}\n');
        downloadSpeed = transferRate;
        emit(CustomerSettingsChangeSpeedState());

      },
      onError: (String errorMessage, String speedTestError) {
        print('on error $errorMessage\n');
        print('on error test ${speedTestError.toString()}\n');
        downloadSpeed = 0.0;
        emit(CustomerSettingsEndSpeedErrorState(errorMessage.toString()));
        },

      testServer: "http://ipv4.ikoula.testdebit.info/1M.iso"
    );*/


  }
  Record? record;
  bool isRecording =  false;

  Future recordAudio() async {
    record = Record();
    await record!.start(
      path: "/storage/emulated/0/Download/Mostaqbal Masr Media/myFile.m4a",
      bitRate: 16000,
      samplingRate: 16000,
      encoder: AudioEncoder.AAC
    );
    isRecording = true;

    //await audioRecorder!.startRecorder(toFile: "/storage/emulated/0/Download/Mostaqbal Masr Media/myFile.m4a");
    emit(CustomerSettingsStartRecordSuccessState());
  }

  Future stopRecord() async {
    await record!.start();
    isRecording = false;
    emit(CustomerSettingsStopRecordSuccessState());
  }

  Future toggleRecording() async {
    if (!isRecording) {
      await recordAudio();
    } else {
      await stopRecord();
    }
    emit(CustomerSettingsToggleRecordSuccessState());
  }

}
