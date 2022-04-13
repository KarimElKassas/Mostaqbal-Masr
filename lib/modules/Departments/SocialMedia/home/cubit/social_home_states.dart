abstract class SocialHomeStates{}

class SocialHomeInitialState extends SocialHomeStates{}

class SocialHomeHandleUserTypeState extends SocialHomeStates{}

class SocialHomeChangeBottomNavState extends SocialHomeStates{}

class SocialHomeLogOutSuccessState extends SocialHomeStates{}

class SocialHomeLogOutErrorState extends SocialHomeStates{

  final String error;

  SocialHomeLogOutErrorState(this.error);

}
