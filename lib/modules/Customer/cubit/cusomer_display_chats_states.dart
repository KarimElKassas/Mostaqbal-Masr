abstract class CustomerDisplayChatsStates{}

class CustomerDisplayChatsInitialState extends CustomerDisplayChatsStates{}

class CustomerDisplayChatsLoadingChatsState extends CustomerDisplayChatsStates{}

class CustomerDisplayChatsGetUserTypeState extends CustomerDisplayChatsStates{}

class CustomerDisplayChatsGetChatsState extends CustomerDisplayChatsStates{}

class CustomerDisplayChatsGetChatsErrorState extends CustomerDisplayChatsStates{

  final String error;

  CustomerDisplayChatsGetChatsErrorState(this.error);

}