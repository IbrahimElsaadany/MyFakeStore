import "package:flutter_bloc/flutter_bloc.dart";
import "states.dart";
import "../../../network/remote/dio_helper.dart";
class RegisterCubit extends Cubit<RegisterStates>{
  bool isObscure=true;
  RegisterCubit():super(RegisterInitialState());
  void changeVisibility(){
    isObscure=!isObscure;
    emit(RegisterChangeVisibilityState());
  }
  void register({
    required String name,
    required String email,
    required String phone,
    required String password
  }){
    emit(RegisterLoadingState());
    DioHelper.dio.post(
      "register",
      data:{"name":name,"password":password,"phone":phone,"email":email}
    ).then((value)=>
      emit(RegisterSuccessState(
        status:value.data["status"],
        message:value.data["message"],
        token:value.data["data"]==null?null:value.data["data"]["token"]
      ))
    ).catchError((error)=>
      emit(RegisterErrorState())
    );
  }
}