abstract class SocialAddPostStates{}

class SocialAddPostInitialState extends SocialAddPostStates{}

class SocialAddPostPickImagesSuccessState extends SocialAddPostStates{}

class SocialAddPostSuccessState extends SocialAddPostStates{}

class SocialAddPostLoadingState extends SocialAddPostStates{}

class SocialAddPostErrorState extends SocialAddPostStates{

  final String error;

  SocialAddPostErrorState(this.error);
}

class SocialAddPostDeleteImageSuccessState extends SocialAddPostStates{}

class SocialAddPostDeleteImageErrorState extends SocialAddPostStates{

  final String error;

  SocialAddPostDeleteImageErrorState(this.error);

}

class SocialAddPostPickImagesErrorState extends SocialAddPostStates{

  final String error;

  SocialAddPostPickImagesErrorState(this.error);

}