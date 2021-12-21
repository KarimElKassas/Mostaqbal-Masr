import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Global/Posts/cubit/global_post_details_states.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GlobalPostDetailsCubit extends Cubit<GlobalPostDetailsStates> {
  GlobalPostDetailsCubit() : super(GlobalPostDetailsInitialState());

  static GlobalPostDetailsCubit get(context) => BlocProvider.of(context);

  YoutubePlayerController? controller;

  Future initializeVideo(String videoID) async {
    controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: const YoutubePlayerFlags(
          autoPlay: false, mute: false, hideControls: false),
    );
  }
}
