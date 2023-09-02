import "package:flutter_bloc/flutter_bloc.dart";
import "states.dart";
import "../../../network/remote/dio_helper.dart";
import "../../../models/products_model.dart";
import "../../../shared/components.dart";
class SearchCubit extends Cubit<SearchStates>{
  ProductsModel? productsModel;
  SearchCubit():super(SearchInitialState());
  void search(final String text){
    emit(SearchLoadingState());
    DioHelper.dio.post(
      "products/search",
      data:{"text":text}
    ).then((value){
      productsModel=ProductsModel(value.data);
      emit(SearchSuccessState());
    }).catchError((error){
      emit(SearchErrorState());
      showToast(
        message:"Check your internet connection!"
      );
    });
  }
}