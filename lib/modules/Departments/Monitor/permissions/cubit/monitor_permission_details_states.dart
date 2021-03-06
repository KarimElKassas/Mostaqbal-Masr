abstract class MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsInitialState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsGetUserDataState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsLoadingGetPermissionsState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsLoadingAddPermissionsToClerkState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsChangeAddPermissionsToDoneState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsAddPermissionsToClerkSuccessState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsAddPermissionsToClerkErrorState extends MonitorPermissionDetailsStates{
  final String error;

  MonitorPermissionDetailsAddPermissionsToClerkErrorState(this.error);
}

class MonitorPermissionDetailsGetClerksForPermissionsState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsGetPermissionsState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsDeletePermissionsState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsGetManagementUsersState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsFilterUsersState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsLoadingUnGrantedPermissionsState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsGetUnGrantedPermissionsState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsChangePermissionsSelectState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsFilterClerksState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsAddPermissionsToSelectState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsRemovePermissionsFromSelectState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsSuccessNavigateState extends MonitorPermissionDetailsStates{}

class MonitorPermissionDetailsLogOutUserState extends MonitorPermissionDetailsStates{}