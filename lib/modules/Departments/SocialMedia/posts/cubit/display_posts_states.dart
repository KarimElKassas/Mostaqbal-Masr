abstract class SocialDisplayPostsStates{}

class SocialDisplayPostsInitialState extends SocialDisplayPostsStates{}

class SocialDisplayPostsInitializeVideoLoadingState extends SocialDisplayPostsStates{}

class SocialDisplayPostsInitializeVideoSuccessState extends SocialDisplayPostsStates{}

class SocialDisplayPostsSuccessState extends SocialDisplayPostsStates{}

class SocialDisplayPostsLoadingState extends SocialDisplayPostsStates{}

class SocialDisplayPostsInitializeVideoErrorState extends SocialDisplayPostsStates{

  final String error;

  SocialDisplayPostsInitializeVideoErrorState(this.error);
}
class SocialDisplayPostsErrorState extends SocialDisplayPostsStates{

  final String error;

  SocialDisplayPostsErrorState(this.error);
}
