abstract class ConversationStates{}

class ConversationInitialState extends ConversationStates{}

class ConversationChangeUserTypeState extends ConversationStates{}

class ConversationUploadingImagesState extends ConversationStates{}

class ConversationUploadImagesState extends ConversationStates{}

class ConversationSendMessageState extends ConversationStates{}

class ConversationPermissionDeniedState extends ConversationStates{}

class ConversationSelectImagesState extends ConversationStates{}

class ConversationIncreaseTimerSuccessState extends ConversationStates{}

class ConversationCreateDirectoryState extends ConversationStates{}

class ConversationAmpTimerSuccessState extends ConversationStates{}

class ConversationStartRecordSuccessState extends ConversationStates{}

class ConversationStopRecordSuccessState extends ConversationStates{}

class ConversationChangeRecordingState extends ConversationStates{}

class ConversationPlayStreamState extends ConversationStates{}

class ConversationListenStreamState extends ConversationStates{}

class ConversationCancelRecordSuccessState extends ConversationStates{}

class ConversationChangePlayerStateSuccessState extends ConversationStates{}

class ConversationChangeRecordPositionState extends ConversationStates{}

class ConversationToggleRecordSuccessState extends ConversationStates{}

class ConversationInitializeRecordSuccessState extends ConversationStates{}

class ConversationPlayRecordSuccessState extends ConversationStates{}

class ConversationEndRecordSuccessState extends ConversationStates{}

class ConversationSelectFilesState extends ConversationStates{}

class ConversationLoadingMessageState extends ConversationStates{}

class ConversationGetMessageSuccessState extends ConversationStates{}

class ConversationDownloadFileSuccessState extends ConversationStates{}

class ConversationLoadingDownloadFileState extends ConversationStates{

  final String fileName;

  ConversationLoadingDownloadFileState(this.fileName);
}

class ConversationSendMessageErrorState extends ConversationStates{

  final String error;

  ConversationSendMessageErrorState(this.error);

}
class ConversationGetMessageErrorState extends ConversationStates{

  final String error;

  ConversationGetMessageErrorState(this.error);

}
class ConversationDownloadFileErrorState extends ConversationStates{

  final String error;

  ConversationDownloadFileErrorState(this.error);

}