abstract class GroupSelectedImagesStates{}

class GroupSelectedImagesInitialState extends GroupSelectedImagesStates{}

class GroupSelectedImagesUploadingState extends GroupSelectedImagesStates{}

class GroupSelectedImagesUploadSuccessState extends GroupSelectedImagesStates{}

class GroupSelectedImagesUploadErrorState extends GroupSelectedImagesStates{

  final String error;

  GroupSelectedImagesUploadErrorState(this.error);

}