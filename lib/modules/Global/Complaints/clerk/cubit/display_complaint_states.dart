abstract class DisplayComplaintStates{}

class DisplayComplaintInitialState extends DisplayComplaintStates{}

class DisplayComplaintChangeFilterState extends DisplayComplaintStates{}

class DisplayComplaintLoadingComplaintsState extends DisplayComplaintStates{}

class DisplayComplaintLoadingUpdateComplaintState extends DisplayComplaintStates{}

class DisplayComplaintLoadingDeleteComplaintState extends DisplayComplaintStates{}

class DisplayComplaintSuccessGetComplaintsState extends DisplayComplaintStates{}

class DisplayComplaintSuccessUpdateComplaintState extends DisplayComplaintStates{}

class DisplayComplaintSuccessDeleteComplaintState extends DisplayComplaintStates{}

class DisplayComplaintErrorGetComplaintsState extends DisplayComplaintStates{

  final String error;

  DisplayComplaintErrorGetComplaintsState(this.error);

}
class DisplayComplaintErrorUpdateComplaintState extends DisplayComplaintStates{

  final String error;

  DisplayComplaintErrorUpdateComplaintState(this.error);

}
class DisplayComplaintErrorDeleteComplaintState extends DisplayComplaintStates{

  final String error;

  DisplayComplaintErrorDeleteComplaintState(this.error);

}
