abstract class ClerkPersonalStates{}

class ClerkPersonalInitialState extends ClerkPersonalStates{}

class ClerkPersonalNavigateSuccessState extends ClerkPersonalStates{}

class ClerkPersonalChangeCityBottomSheetState extends ClerkPersonalStates{}

class ClerkPersonalChangeCityControllerState extends ClerkPersonalStates{}

class ClerkPersonalChangeRegionControllerState extends ClerkPersonalStates{}

class ClerkPersonalGetUserDataSuccessState extends ClerkPersonalStates{}

class ClerkPersonalGetCitiesSuccessState extends ClerkPersonalStates{}

class ClerkPersonalGetRegionsSuccessState extends ClerkPersonalStates{}

class ClerkPersonalChangeRegionBottomSheetState extends ClerkPersonalStates{}

class ClerkPersonalEditLoadingState extends ClerkPersonalStates{}

class ClerkPersonalEditSelectImageState extends ClerkPersonalStates{}

class ClerkPersonalEditUploadingImageState extends ClerkPersonalStates{}

class ClerkPersonalEditUploadImageSuccessState extends ClerkPersonalStates{}

class ClerkPersonalEditSuccessState extends ClerkPersonalStates{}

class ClerkPersonalEditGetCitiesErrorState extends ClerkPersonalStates{
  final String error;

  ClerkPersonalEditGetCitiesErrorState(this.error);
}
class ClerkPersonalEditGetRegionsErrorState extends ClerkPersonalStates{
  final String error;

  ClerkPersonalEditGetRegionsErrorState(this.error);
}

class ClerkPersonalEditErrorState extends ClerkPersonalStates{
  final String error;

  ClerkPersonalEditErrorState(this.error);
}
class ClerkPersonalEditUploadImageErrorState extends ClerkPersonalStates{
  final String error;

  ClerkPersonalEditUploadImageErrorState(this.error);
}

