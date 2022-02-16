abstract class ITHomeStates{}

class ITHomeInitialState extends ITHomeStates{}

class ITHomeLoadingUsersState extends ITHomeStates{}

class ITHomeLoadingCreateGroupState extends ITHomeStates{}

class ITHomeChangeGroupImageState extends ITHomeStates{}

class ITHomeChangeUsersSelectState extends ITHomeStates{}

class ITHomeAddUsersSelectState extends ITHomeStates{}

class ITHomeRemoveUsersSelectState extends ITHomeStates{}

class ITHomeFilterUsersState extends ITHomeStates{}

class ITHomeGetUsersSuccessState extends ITHomeStates{}

class ITHomeCreateGroupSuccessState extends ITHomeStates{}

class ITHomeGetUsersErrorState extends ITHomeStates{

  final String error;

  ITHomeGetUsersErrorState(this.error);

}
class ITHomeCreateGroupErrorState extends ITHomeStates{

  final String error;

  ITHomeCreateGroupErrorState(this.error);

}