import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_post_details_states.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SocialPostDetailsCubit extends Cubit<SocialPostDetailsStates>{


  SocialPostDetailsCubit() : super(SocialPostDetailsInitialState());

  static SocialPostDetailsCubit get(context) => BlocProvider.of(context);



  YoutubePlayerController? controller;

  Future initializeVideo(String videoID) async {
    controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: const YoutubePlayerFlags(
          autoPlay: false, mute: false, hideControls: false),
    );
  }


}