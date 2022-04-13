abstract class SocialEditPostStates{}

class SocialEditPostInitialState extends SocialEditPostStates{}

class SocialEditPostLoadingState extends SocialEditPostStates{}

class SocialEditPostSuccessAddImageState extends SocialEditPostStates{}

class SocialEditPostSuccessDeleteImageState extends SocialEditPostStates{}

class SocialEditPostSuccessState extends SocialEditPostStates{}

class SocialEditPostErrorState extends SocialEditPostStates{

  final String error;

  SocialEditPostErrorState(this.error);

}