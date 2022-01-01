abstract class GlobalDisplayPostsStates{}

class GlobalDisplayPostsInitialState extends GlobalDisplayPostsStates{}

class GlobalDisplayPostsInitializeVideoLoadingState extends GlobalDisplayPostsStates{}

class GlobalDisplayPostsInitializeVideoSuccessState extends GlobalDisplayPostsStates{}

class GlobalDisplayPostsSuccessState extends GlobalDisplayPostsStates{}

class GlobalDisplayPostsLogOutSuccessState extends GlobalDisplayPostsStates{}

class GlobalDisplayPostsNavigateSuccessState extends GlobalDisplayPostsStates{}

class GlobalDisplayPostsLoadingState extends GlobalDisplayPostsStates{}

class GlobalDisplayPostsInitializeVideoErrorState extends GlobalDisplayPostsStates{

  final String error;

  GlobalDisplayPostsInitializeVideoErrorState(this.error);
}
class GlobalDisplayPostsErrorState extends GlobalDisplayPostsStates{

  final String error;

  GlobalDisplayPostsErrorState(this.error);
}
class GlobalDisplayPostsLogOutErrorState extends GlobalDisplayPostsStates{

  final String error;

  GlobalDisplayPostsLogOutErrorState(this.error);

}