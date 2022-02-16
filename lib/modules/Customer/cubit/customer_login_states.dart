abstract class CustomerLoginStates{}

class CustomerLoginInitialState extends CustomerLoginStates{}

class CustomerLoginChangePassVisibility extends CustomerLoginStates{}

class CustomerLoginLoadingState extends CustomerLoginStates{}

class CustomerLoginSuccessState extends CustomerLoginStates{}

class CustomerLoginGetDataSuccessState extends CustomerLoginStates{}

class CustomerLoginErrorState extends CustomerLoginStates{

  final String error;

  CustomerLoginErrorState(this.error);

}
class CustomerLoginGetDataErrorState extends CustomerLoginStates{

  final String error;

  CustomerLoginGetDataErrorState(this.error);

}
