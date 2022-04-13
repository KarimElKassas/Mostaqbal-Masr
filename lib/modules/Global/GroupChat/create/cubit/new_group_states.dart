abstract class NewGroupStates{}

class NewGroupInitialState extends NewGroupStates{}

class NewGroupLoadingUsersState extends NewGroupStates{}

class NewGroupLoadingCreateGroupState extends NewGroupStates{}

class NewGroupChangeGroupImageState extends NewGroupStates{}

class NewGroupChangeUsersSelectState extends NewGroupStates{}

class NewGroupLogOutUserState extends NewGroupStates{}

class NewGroupAddUsersSelectState extends NewGroupStates{}

class NewGroupRemoveUsersSelectState extends NewGroupStates{}

class NewGroupFilterUsersState extends NewGroupStates{}

class NewGroupGetUsersSuccessState extends NewGroupStates{}

class NewGroupCreateGroupSuccessState extends NewGroupStates{}

class NewGroupGetUsersErrorState extends NewGroupStates{

  final String error;

  NewGroupGetUsersErrorState(this.error);

}
class NewGroupCreateGroupErrorState extends NewGroupStates{

  final String error;

  NewGroupCreateGroupErrorState(this.error);

}
class NewGroupLogOutErrorState extends NewGroupStates{

  final String error;

  NewGroupLogOutErrorState(this.error);

}