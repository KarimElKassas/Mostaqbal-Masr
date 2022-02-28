abstract class GroupConversationStates{}

class GroupConversationInitialState extends GroupConversationStates{}

class GroupConversationChangeUserTypeState extends GroupConversationStates{}

class GroupConversationUploadingImagesState extends GroupConversationStates{}

class GroupConversationUploadImagesState extends GroupConversationStates{}

class GroupConversationUploadingFileState extends GroupConversationStates{}

class GroupConversationSendMessageState extends GroupConversationStates{}

class GroupConversationPermissionDeniedState extends GroupConversationStates{}

class GroupConversationSelectImagesState extends GroupConversationStates{}

class GroupConversationIncreaseTimerSuccessState extends GroupConversationStates{}

class GroupConversationCreateDirectoryState extends GroupConversationStates{}

class GroupConversationAmpTimerSuccessState extends GroupConversationStates{}

class GroupConversationStartRecordSuccessState extends GroupConversationStates{}

class GroupConversationStopRecordSuccessState extends GroupConversationStates{}

class GroupConversationChangeRecordingState extends GroupConversationStates{}

class GroupConversationPlayStreamState extends GroupConversationStates{}

class GroupConversationListenStreamState extends GroupConversationStates{}

class GroupConversationCancelRecordSuccessState extends GroupConversationStates{}

class GroupConversationChangePlayerStateSuccessState extends GroupConversationStates{}

class GroupConversationChangeRecordPositionState extends GroupConversationStates{}

class GroupConversationToggleRecordSuccessState extends GroupConversationStates{}

class GroupConversationInitializeRecordSuccessState extends GroupConversationStates{}

class GroupConversationPlayRecordSuccessState extends GroupConversationStates{}

class GroupConversationEndRecordSuccessState extends GroupConversationStates{}

class GroupConversationSelectFilesState extends GroupConversationStates{}

class GroupConversationLoadingMessageState extends GroupConversationStates{}

class GroupConversationGetGroupMembersSuccessState extends GroupConversationStates{}

class GroupConversationGetMessageSuccessState extends GroupConversationStates{}

class GroupConversationDownloadFileSuccessState extends GroupConversationStates{}

class GroupConversationLoadingDownloadFileState extends GroupConversationStates{

  final String fileName;

  GroupConversationLoadingDownloadFileState(this.fileName);
}

class GroupConversationSendMessageErrorState extends GroupConversationStates{

  final String error;

  GroupConversationSendMessageErrorState(this.error);

}
class GroupConversationGetMessageErrorState extends GroupConversationStates{

  final String error;

  GroupConversationGetMessageErrorState(this.error);

}
class GroupConversationDownloadFileErrorState extends GroupConversationStates{

  final String error;

  GroupConversationDownloadFileErrorState(this.error);

}