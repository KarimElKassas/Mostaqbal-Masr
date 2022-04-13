abstract class SocialSettingStates{}

class SocialSettingInitialState extends SocialSettingStates{}

class SocialSettingLoadingState extends SocialSettingStates{}

class SocialSettingSuccessState extends SocialSettingStates{}

class SocialSettingGetUserDataSuccessState extends SocialSettingStates{}

class SocialSettingLogOutSuccessState extends SocialSettingStates{}

class SocialSettingWrongPasswordState extends SocialSettingStates{}

class SocialSettingNoInternetState extends SocialSettingStates{}

class SocialSettingErrorState extends SocialSettingStates{

  final String error;

  SocialSettingErrorState(this.error);

}
class SocialSettingLogOutErrorState extends SocialSettingStates{

  final String error;

  SocialSettingLogOutErrorState(this.error);

}
class SocialSettingGetUserDataErrorState extends SocialSettingStates{

  final String error;

  SocialSettingGetUserDataErrorState(this.error);

}