import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_settings_cubit.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_settings_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';

class CustomerSettingsScreen extends StatefulWidget {
  @override
  State<CustomerSettingsScreen> createState() => _CustomerSettingsScreenState();
}

class _CustomerSettingsScreenState extends State<CustomerSettingsScreen> {
  //final timerController = TimerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerSettingsCubit(),
      child: BlocConsumer<CustomerSettingsCubit, CustomerSettingsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CustomerSettingsCubit.get(context);

          return Scaffold(
            backgroundColor: secondaryColor,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: const Center(
                              child: Text(
                            "تسجيل",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                        ),
                        onLongPressStart: (_) {
                          cubit.recordAudio();
                        },
                        onLongPressUp: () {
                          cubit.stopRecord();
                        },
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      defaultButton(
                        function: () {
                          cubit.stopRecord();
                        },
                        text: "انهاء",
                        background: Colors.teal,
                        textColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      GestureDetector(
                        onLongPressStart: (_) async {
                          await cubit.recordAudio();
                        },
                        onLongPressUp: () async {
                          await cubit.stopRecord();
                        },
                        child: AvatarGlow(
                          endRadius: 50,
                          animate: cubit.isRecording,
                          duration: const Duration(milliseconds: 0),
                          repeat: true,
                          showTwoGlows: true,
                          repeatPauseDuration:
                              const Duration(milliseconds: 0),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor:
                                  Colors.indigo.shade900.withBlue(70),
                              child: const Icon(
                                Icons.mic,
                                size: 24,
                              ),
                            ),
                          ),
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
}

/*class TimerController extends ValueNotifier<bool>{
  TimerController({bool isPlaying = false}) : super(isPlaying);

  void startTimer() => value = true;
  void stopTimer() => value = false;
}*/

/*class TimerWidget extends StatefulWidget {
  final TimerController controller;
  const TimerWidget({Key? key, required this.controller}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {

  Duration duration = const Duration();

  Timer? timer;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {

      if(widget.controller.value){
        startTimer();
      }else{
        stopTimer();
      }

    });
  }

  void reset() => setState(() {
    duration = const Duration();
  });

  void addTime(){

    const addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      if(seconds < 0){
        timer?.cancel();
      }else{
        duration = Duration(seconds: seconds);
      }

    });

  }

  void startTimer({bool resets = true}){

    if(!mounted) return;

    if(resets){
      reset();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}){

    if(!mounted) return;
    if(resets){
      reset();
    }
    setState(() {
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      duration.inSeconds.toString(),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}*/

/*                    SfRadialGauge(
                      enableLoadingAnimation: true,
                        animationDuration: 4500,
                        axes: <RadialAxis>[
                      RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 0,
                            endValue: 30,
                            color: Colors.red,
                            startWidth: 5,
                            endWidth: 10,
                        ),
                        GaugeRange(
                            startValue: 30,
                            endValue: 70,
                            color: Colors.white,
                            endWidth: 15,
                            startWidth: 10,
                        ),
                        GaugeRange(
                            startValue: 70,
                            endValue: 100,
                            color: Colors.black,
                            startWidth: 15,
                            endWidth: 20,
                        )
                      ], pointers: <GaugePointer>[
                        NeedlePointer(
                          value: cubit.downloadSpeed,
                          needleColor: Colors.white,
                          enableAnimation: true,
                          enableDragging: true,
                        )
                      ], annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Text(cubit.downloadSpeed.toString(),
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            angle: 90,
                            positionFactor: 0.5)
                      ],
                        canScaleToFit: true,
                        useRangeColorForAxis: true,
                      ),
                    ])*/
