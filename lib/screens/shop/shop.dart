import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "cubit/cubit.dart";
import "cubit/states.dart";
import "layouts/cart.dart";
import "layouts/categories.dart";
import "layouts/home.dart";
import "layouts/settings.dart";
import "../../shared/theme_cubit/cubit.dart";
import "../../network/local/cache_helper.dart";
import '../search/search.dart';
import "../login/login.dart";
class Shop extends StatelessWidget{
  static const titles=["Home","Categories","Cart","Settings"];
  const Shop({super.key});
  @override
  BlocProvider build(final BuildContext context)
  =>BlocProvider<ShopCubit>(
    create:(final BuildContext context)=>ShopCubit()..init(),
    child: BlocBuilder<ShopCubit,ShopStates>(
      builder:(final BuildContext context, final ShopStates state){
        final ShopCubit cubit = BlocProvider.of<ShopCubit>(context);
        return Scaffold(
          appBar:AppBar(
            title:Text(titles[cubit.currentLayout]),
            actions:<IconButton>[
              IconButton(
                icon:const Icon(Icons.search),
                onPressed:()=>Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:(final BuildContext context)
                    =>Search(cubit)
                  )
                )
              )
            ]      
          ),
          body:_whichLayout(
            cubit: cubit,
            state: state,
            context: context
          ),
          drawer:state is ShopLoadingState? null : NavigationDrawer(
            children: [
              if(cubit.profileModel!=null)
                UserAccountsDrawerHeader(
                  currentAccountPicture:CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    child: Text(
                      cubit.profileModel!.name[0],
                      style:const TextStyle(
                        color:Colors.white,
                        fontSize:28.0
                      )
                    )
                  ),
                  accountName: Text(cubit.profileModel!.name),
                  accountEmail: Text(cubit.profileModel!.email),
                ),
              ListTile(
                leading:const Icon(Icons.home_outlined),
                title:const Text("Home"),
                onTap:(){
                  cubit.changeLayout(0);
                  Navigator.pop(context);
                }
              ),
              const Divider(height:1.0),
              ListTile(
                leading:const Icon(Icons.grid_on_outlined),
                title:const Text("Categories"),
                onTap:(){
                  cubit.changeLayout(1);
                  Navigator.pop(context);
                }
              ),
              const Divider(height:1.0),
              ListTile(
                leading:const Icon(Icons.shopping_cart_outlined),
                title:const Text("Cart"),
                onTap:(){
                  cubit.changeLayout(2);
                  Navigator.pop(context);
                }
              ),
              const Divider(height:1.0),
              ListTile(
                leading:const Icon(Icons.person_outline),
                title:const Text("Profile"),
                onTap: (){
                  cubit.changeLayout(3);
                  Navigator.pop(context);
                }
              ),
              const Divider(height:1.0),
              ListTile(
                leading:const Icon(Icons.logout_outlined),
                title:const Text("Logout"),
                onTap: (){
                  CacheHelper.prefs.remove("token");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:(final BuildContext context)=>Login()
                    )
                  );
                },
              ),
              const Divider(height:1.0),
              ListTile(
                leading:const Icon(Icons.light_mode),
                title:Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Night Mode"),
                    Switch(
                      value:BlocProvider.of<ThemeCubit>(context).nightMode,
                      onChanged: (final bool _)=>BlocProvider.of<ThemeCubit>(context).changeTheme(),
                    ),
                  ],
                )
              )
            ],
          )
        );
      }
    ),
  );
  Widget _whichLayout({
    required final ShopCubit cubit,
    required final ShopStates state,
    required final BuildContext context
  }){
    if(state is ShopLoadingState)
      return const Center(child:CircularProgressIndicator());
    return RefreshIndicator(
      onRefresh:()=>cubit.refresh(), // var
      child:ListView(
        children:<Widget>[
          if([
            cubit.productsModel,
            cubit.cartItemsModel,
            cubit.categoriesModel,
            cubit.profileModel
            ].contains(null)
          )
          Padding(
            padding:const EdgeInsets.only(top:225.0),
            child:Column(
              children:[
                Icon(Icons.arrow_downward,size:100.0,color:Theme.of(context).primaryColorLight),
                Text(
                  "Disconnected. Connect and\nscroll down to refresh the page.",
                  textAlign:TextAlign.center,
                  style:TextStyle(
                    color:Theme.of(context).primaryColorLight
                  )
                )
              ]
            ),
          )
          else if(cubit.currentLayout==0) ...buildHome(context,cubit)
          else if(cubit.currentLayout==1) ...buildCategories(context,cubit.categoriesModel!.categories)
          else if(cubit.currentLayout==2) ...buildCart(
            context:context,
            products: cubit.cartItemsModel!.cartItems,
            cubit:cubit,
          )
          else ...buildSettings(
            context,
            cubit:cubit,
            state:state,
          )
        ]
      )
    );
  }
}