abstract class MechanHomeStates{}

class MechanHomeInitialState extends MechanHomeStates{}

class MechanHomeLogOutSuccessState extends MechanHomeStates{}

class MechanHomeLogOutErrorState extends MechanHomeStates{

  final String error;

  MechanHomeLogOutErrorState(this.error);

}