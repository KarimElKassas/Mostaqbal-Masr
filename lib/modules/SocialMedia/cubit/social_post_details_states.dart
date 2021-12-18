abstract class SocialPostDetailsStates{}

class SocialPostDetailsInitialState extends SocialPostDetailsStates{}

class SocialPostDetailsLoadingImagesState extends SocialPostDetailsStates{}

class SocialPostDetailsSuccessLoadImagesState extends SocialPostDetailsStates{}

class SocialPostDetailsErrorLoadImagesState extends SocialPostDetailsStates{

  final String error;

  SocialPostDetailsErrorLoadImagesState(this.error);

}