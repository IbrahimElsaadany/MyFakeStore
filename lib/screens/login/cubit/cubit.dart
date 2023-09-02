import "package:flutter_bloc/flutter_bloc.dart";
import "../../../network/remote/dio_helper.dart";
import "states.dart";
class LoginCubit extends Cubit<LoginStates>{
  bool isObscure=true;
  LoginCubit():super(LoginInitialState());
  void changeVisibility(){
    isObscure=!isObscure;
    emit(LoginChangeVisibilityState());
  }
  void login({
    required String email,
    required String password
  }){
    emit(LoginLoadingState());
    DioHelper.dio.post(
      "login",
      data:{"password":password,"email":email}
    ).then((value)=>
      emit(LoginSuccessState(
        status:value.data["status"],
        message:value.data["message"],
        token:value.data["data"]==null?null:value.data["data"]["token"]
      ))
    ).catchError((error)=>
      emit(LoginErrorState("Check your internet connection!"))
    );
  }
}