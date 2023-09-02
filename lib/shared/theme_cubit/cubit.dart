import "package:flutter_bloc/flutter_bloc.dart";
import "../../network/local/cache_helper.dart";
import "states.dart";
class ThemeCubit extends Cubit<ThemeStates>{
  bool nightMode = CacheHelper.prefs.getBool("night")??false;
  ThemeCubit():super(ThemeInitialState());
  void changeTheme(){
    CacheHelper.prefs.setBool("night",nightMode=!nightMode);
    emit(ThemeChangeState());
  }
}