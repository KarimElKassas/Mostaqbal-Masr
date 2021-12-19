abstract class SocialPostDetailsStates{}

class SocialPostDetailsInitialState extends SocialPostDetailsStates{}

class SocialPostDetailsLoadingImagesState extends SocialPostDetailsStates{}

class SocialPostDetailsSuccessLoadImagesState extends SocialPostDetailsStates{}

class SocialPostDetailsCloseBottomSheetState extends SocialPostDetailsStates{}

class SocialPostDetailsOpenBottomSheetState extends SocialPostDetailsStates{}

class SocialPostDetailsLoadingBackDataState extends SocialPostDetailsStates{}

class SocialPostDetailsSuccessBackDataState extends SocialPostDetailsStates{}

class SocialPostDetailsLoadingDeletePostState extends SocialPostDetailsStates{}

class SocialPostDetailsSuccessDeletePostState extends SocialPostDetailsStates{}

class SocialPostDetailsErrorDeletePostState extends SocialPostDetailsStates{

  final String error;

  SocialPostDetailsErrorDeletePostState(this.error);

}

class SocialPostDetailsErrorBackDataState extends SocialPostDetailsStates{

  final String error;

  SocialPostDetailsErrorBackDataState(this.error);

}

class SocialPostDetailsErrorLoadImagesState extends SocialPostDetailsStates{

  final String error;

  SocialPostDetailsErrorLoadImagesState(this.error);

}