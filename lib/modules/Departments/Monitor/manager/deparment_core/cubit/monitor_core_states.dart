abstract class MonitorCoreStates{}

class MonitorCoreInitialState extends MonitorCoreStates{}

class MonitorCoreChangeFilterState extends MonitorCoreStates{}

class MonitorCoreNavigateSuccessState extends MonitorCoreStates{}

class MonitorCoreLoadingClerksState extends MonitorCoreStates{}

class MonitorCoreGetClerksSuccessState extends MonitorCoreStates{}

class MonitorCoreGetClerksErrorState extends MonitorCoreStates{
  final String error;

  MonitorCoreGetClerksErrorState(this.error);
}