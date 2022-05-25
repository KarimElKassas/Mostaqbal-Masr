abstract class MonitorManagementPermissionStates{}

class MonitorManagementPermissionInitialState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionGetUserDataState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionLoadingGetPermissionsState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionLoadingAddPermissionsState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionAddPermissionsSuccessState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionAddPermissionsErrorState extends MonitorManagementPermissionStates{
  final String error;

  MonitorManagementPermissionAddPermissionsErrorState(this.error);
}

class MonitorManagementPermissionGetClerksForPermissionsState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionGetPermissionsState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionDeletePermissionsState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionGetManagementUsersState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionFilterUsersState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionLoadingUnGrantedPermissionsState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionGetUnGrantedPermissionsState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionChangePermissionsSelectState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionAddPermissionsToSelectState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionRemovePermissionsFromSelectState extends MonitorManagementPermissionStates{}

class MonitorManagementPermissionLogOutUserState extends MonitorManagementPermissionStates{}