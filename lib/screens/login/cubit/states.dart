abstract class LoginStates{}
class LoginInitialState extends LoginStates{}
class LoginChangeVisibilityState extends LoginStates{}
class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates{
  final String message;
  final bool status;
  final String? token;
  LoginSuccessState({required this.token,required this.status,required this.message});
}
class LoginErrorState extends LoginStates{
  final String message;
  LoginErrorState(this.message);
}