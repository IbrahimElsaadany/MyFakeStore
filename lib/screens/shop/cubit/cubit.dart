import "package:flutter_bloc/flutter_bloc.dart";
import "states.dart";
import "../../../shared/components.dart";
import "../../../network/remote/dio_helper.dart";
import "../../../models/categories_model.dart";
import "../../../models/cart_items_model.dart";
import "../../../models/products_model.dart";
import "../../../models/profile_model.dart";
class ShopCubit extends Cubit<ShopStates>{
  int currentLayout=0;
  CategoriesModel? categoriesModel;
  ProductsModel? productsModel;
  CartItemsModel? cartItemsModel;
  ProfileModel? profileModel;
  bool isObscure=true;
  Map<int,bool> inCarts={};
  ShopCubit():super(ShopInitialState());
  Future<void> init(){
    DioHelper.dio.options.headers.addAll({"Authorization":token});
    emit(ShopLoadingState());
    return refresh();
  }
  Future<void> refresh()
  => Future.wait([
    DioHelper.dio.get(
      "categories"
    ).then((value)=>categoriesModel=CategoriesModel(value.data)),
    DioHelper.dio.get(
      "products"
    ).then((value){
      productsModel=ProductsModel(value.data);
      for(final ProductModel e in productsModel!.products)
        inCarts.putIfAbsent(e.id, () => e.inCart);
    }),
    getCart(),
    getProfile()
  ]).then((value) => emit(ShopGetSuccessState())
  ).catchError((error){
    showToast(message:"An error happened while loading. Refresh the page!");
    emit(ShopGetErrorState());
  });
  void toCart(int id){
    inCarts[id]=!inCarts[id]!;
    emit(ShopChangeCartState());
    DioHelper.dio.post(
      "carts",
      data:<String,int>{"product_id":id}
    ).then((value)=>getCart().then((value)=>emit(ShopChangeCartSuccessState()))
    ).catchError((error){
      inCarts[id]=!inCarts[id]!;
      emit(ShopChangeCartErrorState());
      showToast(message:"An error happened while loading. Check your connection and try again!");
    });
  }
  Future<void> getCart()
  =>DioHelper.dio.get(
      "carts"
    ).then((value) => cartItemsModel=CartItemsModel(value.data));
  void changeLayout(int i){
    currentLayout=i;
    emit(ShopChangeLayoutState());
  }
  Future<void> getProfile()
  =>DioHelper.dio.get(
    "profile"
  ).then((value)=> profileModel=ProfileModel(value.data));
  void updateProfile({
    required final String name,
    required final String email,
    required final String phone,
  }){
    emit(ShopUpdatingProfileState());
    DioHelper.dio.put(
      "update-profile",
      data:{"name":name,"phone":phone,"email":email}
    ).then((value){
      if(value.data["status"]==true) profileModel=ProfileModel(value.data);
      emit(ShopUpdateProfileSuccessState());
      showToast(
        status:value.data["status"],
        message:value.data["message"]
      );
    }).catchError((error){
      emit(ShopUpdateProfileErrorState());
      showToast(
        message:"Check your internet connection!"
      );
    });
    getProfile();
  }
  void changeVisibility(){
    isObscure=!isObscure;
    emit(ShopChangeVisibilityState());
  }
}