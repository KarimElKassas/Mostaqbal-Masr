abstract class SocialDisplayChatsStates{}

class SocialDisplayChatsInitialState extends SocialDisplayChatsStates{}

class SocialDisplayChatsFilterChatsState extends SocialDisplayChatsStates{}

class SocialDisplayChatsLoadingChatsState extends SocialDisplayChatsStates{}

class SocialDisplayChatsGetMessagesSuccessState extends SocialDisplayChatsStates{}

class SocialDisplayChatsGetChatsState extends SocialDisplayChatsStates{}

class SocialDisplayChatsGetChatsErrorState extends SocialDisplayChatsStates{

  final String error;

  SocialDisplayChatsGetChatsErrorState(this.error);

}