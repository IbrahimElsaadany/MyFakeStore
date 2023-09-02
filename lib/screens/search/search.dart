import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "cubit/cubit.dart";
import "cubit/states.dart";
import "../shop/cubit/cubit.dart";
import "../../shared/components.dart";
class Search extends StatelessWidget{
  final ShopCubit shopCubit;
  const Search(this.shopCubit, {super.key});
  @override
  Scaffold build(final BuildContext context)
  =>Scaffold(
    appBar:AppBar(),
    body:BlocProvider<SearchCubit>(
      create:(final BuildContext context)=>SearchCubit(),
      child: BlocBuilder<SearchCubit,SearchStates>(
        builder: (final BuildContext context,final SearchStates state){
          final SearchCubit cubit = BlocProvider.of<SearchCubit>(context);
          return ListView(
            padding:const EdgeInsets.all(15.0),
            children:[
              TextField(
                decoration:InputDecoration(
                  suffixIcon:const Icon(Icons.search_outlined),
                  labelText:"Search",
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(40.0)
                  )
                ),
                onSubmitted:(final String value)=>cubit.search(value),
              ),
              const SizedBox(height:10.0),
              if(state is SearchLoadingState)
                const LinearProgressIndicator()
              else if(cubit.productsModel!=null)
                ...rowProducts(
                  context,
                  products:cubit.productsModel!.products,
                  cubit:shopCubit
                )
              else Padding(
                padding:const EdgeInsets.only(top:150.0),
                child:Column(
                  children:<Widget>[
                    Icon(Icons.search,size:100.0,color:Theme.of(context).primaryColorLight),
                    Text(
                      "Type something to search for!",
                      textAlign:TextAlign.center,
                      style:TextStyle(
                        color:Theme.of(context).primaryColorLight
                      )
                    )
                  ]
                )
              )
            ]
          );
        }
      ),
    )
  );
}