abstract class DisplayGroupsStates{}

class DisplayGroupsInitialState extends DisplayGroupsStates{}

class DisplayGroupsLoadingGroupsState extends DisplayGroupsStates{}

class DisplayGroupsGetGroupsSuccessState extends DisplayGroupsStates{}

class DisplayGroupsFilterGroupState extends DisplayGroupsStates{}

class DisplayGroupsGetGroupsErrorState extends DisplayGroupsStates{

  final String error;

  DisplayGroupsGetGroupsErrorState(this.error);

}