abstract class AddComplaintStates{}

class AddComplaintInitialState extends AddComplaintStates{}

class AddComplaintLoadingSendComplaintState extends AddComplaintStates{}

class AddComplaintSuccessSendComplaintState extends AddComplaintStates{}

class AddComplaintErrorSendComplaintState extends AddComplaintStates{

  final String error;

  AddComplaintErrorSendComplaintState(this.error);

}

