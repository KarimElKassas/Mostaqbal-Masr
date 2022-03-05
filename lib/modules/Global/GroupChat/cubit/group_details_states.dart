abstract class GroupDetailsStates{}

class GroupDetailsInitialState extends GroupDetailsStates{}

class GroupDetailsLoadingMembersInfoState extends GroupDetailsStates{}

class GroupDetailsMembersInfoState extends GroupDetailsStates{}

class GroupDetailsGetMediaState extends GroupDetailsStates{}

class GroupDetailsLoadingGroupsState extends GroupDetailsStates{}


class GroupDetailsGetGroupsSuccessState extends GroupDetailsStates{}

class GroupDetailsFilterGroupState extends GroupDetailsStates{}

class GroupDetailsGetGroupsErrorState extends GroupDetailsStates{

  final String error;

  GroupDetailsGetGroupsErrorState(this.error);

}