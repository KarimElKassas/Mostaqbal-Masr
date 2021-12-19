abstract class SocialSettingStates{}

class SocialSettingInitialState extends SocialSettingStates{}

class SocialSettingLoadingState extends SocialSettingStates{}

class SocialSettingSuccessState extends SocialSettingStates{}

class SocialSettingWrongPasswordState extends SocialSettingStates{}

class SocialSettingErrorState extends SocialSettingStates{

  final String error;

  SocialSettingErrorState(this.error);

}