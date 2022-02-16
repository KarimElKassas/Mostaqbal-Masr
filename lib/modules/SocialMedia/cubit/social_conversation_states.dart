abstract class SocialConversationStates{}

class SocialConversationInitialState extends SocialConversationStates{}

class SocialConversationSendMessageState extends SocialConversationStates{}

class SocialConversationSelectImagesState extends SocialConversationStates{}

class SocialConversationSelectFilesState extends SocialConversationStates{}

class SocialConversationLoadingMessageState extends SocialConversationStates{}

class SocialConversationGetMessageSuccessState extends SocialConversationStates{}

class SocialConversationCreateDirectoryState extends SocialConversationStates{}

class SocialConversationStartRecordSuccessState extends SocialConversationStates{}

class SocialConversationIncreaseTimerSuccessState extends SocialConversationStates{}

class SocialConversationAmpTimerSuccessState extends SocialConversationStates{}

class SocialConversationStopRecordSuccessState extends SocialConversationStates{}

class SocialConversationCancelRecordSuccessState extends SocialConversationStates{}

class SocialConversationToggleRecordSuccessState extends SocialConversationStates{}

class SocialConversationInitializeRecordSuccessState extends SocialConversationStates{}

class SocialConversationChangeRecordPositionState extends SocialConversationStates{}

class SocialConversationPlayRecordSuccessState extends SocialConversationStates{}

class SocialConversationPermissionDeniedState extends SocialConversationStates{}

class SocialConversationDownloadFileSuccessState extends SocialConversationStates{}

class SocialConversationLoadingDownloadFileState extends SocialConversationStates{

  final String fileName;

  SocialConversationLoadingDownloadFileState(this.fileName);
}
class SocialConversationSendMessageErrorState extends SocialConversationStates{

  final String error;

  SocialConversationSendMessageErrorState(this.error);

}
class SocialConversationGetMessageErrorState extends SocialConversationStates{

  final String error;

  SocialConversationGetMessageErrorState(this.error);

}
class SocialConversationDownloadFileErrorState extends SocialConversationStates{

  final String error;

  SocialConversationDownloadFileErrorState(this.error);

}