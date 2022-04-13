abstract class GroupSelectedImagesStates{}

class GroupSelectedImagesInitialState extends GroupSelectedImagesStates{}

class GroupSelectedImagesUploadingState extends GroupSelectedImagesStates{
  final String imageName;

  GroupSelectedImagesUploadingState(this.imageName);
}

class GroupSelectedImagesUploadSuccessState extends GroupSelectedImagesStates{}

class GroupSelectedImagesUploadErrorState extends GroupSelectedImagesStates{

  final String error;

  GroupSelectedImagesUploadErrorState(this.error);

}