abstract class RegisterStates{}
class RegisterInitialState extends RegisterStates{}
class RegisterChangeVisibilityState extends RegisterStates{}
class RegisterLoadingState extends RegisterStates{}
class RegisterSuccessState extends RegisterStates{
  final String message;
  final bool status;
  final String? token;
  RegisterSuccessState({required this.token,required this.status,required this.message});
}
class RegisterErrorState extends RegisterStates{}