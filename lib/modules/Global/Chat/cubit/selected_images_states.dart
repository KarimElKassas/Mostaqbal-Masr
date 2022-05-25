abstract class SocialSelectedImagesStates{}

class SocialSelectedImagesInitialState extends SocialSelectedImagesStates{}

class SocialSelectedImagesUploadingState extends SocialSelectedImagesStates{}

class SocialSelectedImagesUploadSuccessState extends SocialSelectedImagesStates{}

class SocialSelectedImagesUploadErrorState extends SocialSelectedImagesStates{

  final String error;

  SocialSelectedImagesUploadErrorState(this.error);

}