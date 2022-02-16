abstract class CustomerSettingsStates{}

class CustomerSettingsInitialState extends CustomerSettingsStates{}

class CustomerSettingsLogOutSuccessState extends CustomerSettingsStates{}

class CustomerSettingsStartRecordSuccessState extends CustomerSettingsStates{}

class CustomerSettingsInitializeRecordSuccessState extends CustomerSettingsStates{}

class CustomerSettingsDisposeRecordSuccessState extends CustomerSettingsStates{}

class CustomerSettingsPermissionDeniedState extends CustomerSettingsStates{}

class CustomerSettingsStopRecordSuccessState extends CustomerSettingsStates{}

class CustomerSettingsToggleRecordSuccessState extends CustomerSettingsStates{}

class CustomerSettingsChangeSpeedState extends CustomerSettingsStates{}

class CustomerSettingsEndSpeedState extends CustomerSettingsStates{}

class CustomerSettingsLogOutErrorState extends CustomerSettingsStates{

  final String error;

  CustomerSettingsLogOutErrorState(this.error);

}
class CustomerSettingsEndSpeedErrorState extends CustomerSettingsStates{

  final String error;

  CustomerSettingsEndSpeedErrorState(this.error);

}

