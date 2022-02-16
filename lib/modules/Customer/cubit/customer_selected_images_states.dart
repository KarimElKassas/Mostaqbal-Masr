abstract class CustomerSelectedImagesStates{}

class CustomerSelectedImagesInitialState extends CustomerSelectedImagesStates{}

class CustomerSelectedImagesUploadingState extends CustomerSelectedImagesStates{}

class CustomerSelectedImagesUploadSuccessState extends CustomerSelectedImagesStates{}

class CustomerSelectedImagesUploadErrorState extends CustomerSelectedImagesStates{

  final String error;

  CustomerSelectedImagesUploadErrorState(this.error);

}