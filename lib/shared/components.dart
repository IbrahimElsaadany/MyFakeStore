import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:fluttertoast/fluttertoast.dart";
import "../network/local/cache_helper.dart";
import "../models/products_model.dart" show ProductModel;
import "../screens/product.dart";
import "../screens/shop/cubit/cubit.dart";
import "../screens/shop/cubit/states.dart";
String? token=CacheHelper.prefs.getString("token");
void showToast({final bool? status,required final String message})
=> Fluttertoast.showToast(
  msg:message,
  backgroundColor:status==null?Colors.amber:status?Colors.green:Colors.red
);
List<Column> rowProducts(
  final BuildContext context,
  {
    required final List<ProductModel> products,
    required final ShopCubit cubit
  }
)
=> List<Column>.generate(
  products.length,
  (final int i)
  => Column(
    children: <Widget>[
      InkWell(
        onTap:()=>Navigator.push(
          context,
          MaterialPageRoute(
            builder:(final BuildContext context)=>Product(
              name:products[i].name,
              description:products[i].description,
              image:products[i].description
            )
          )
        ),
        child: Row(
          children: <Widget>[
            Stack(
              alignment:AlignmentDirectional.bottomStart,
              children: [
                FadeInImage.assetNetwork(
                fadeInDuration:const Duration(milliseconds:100),
                fadeOutDuration:const Duration(milliseconds:100),
                placeholder:"assets/placeholder.gif",
                placeholderFit:BoxFit.cover,
                imageErrorBuilder:(final BuildContext context,final Object x,final StackTrace? y)
                =>Image.asset(
                  "assets/placeholder.gif",
                  height:150.0,width:150.0
                ),
                image:products[i].image,
                height:150.0,
                width:150.0
                              ),
                if(products[i].oldPrice>products[i].price)
                const Text(
                  " DISCOUNT ",
                  style:TextStyle(
                    backgroundColor:Colors.red,
                    color:Colors.white
                  )
                )
              ],
            ),
            const SizedBox(width:5.0),
            Expanded(
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Text(
                    products[i].name,
                    style:Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize:16.0,
                      overflow:TextOverflow.ellipsis
                    )
                  ),
                  Text(
                    products[i].description,
                    maxLines:2,
                    overflow:TextOverflow.ellipsis,
                    style:const TextStyle(
                      fontSize:12.0
                    )
                  ),
                  Row(
                    children:<Widget>[
                      Text(
                        products[i].price.toString(),
                        style:TextStyle(
                          color:Theme.of(context).primaryColor,
                          fontSize:14.0
                        )
                      ),
                      if(products[i].oldPrice>products[i].price)
                        Text(
                        "  ${products[i].oldPrice}",
                        style:const TextStyle(
                          decoration:TextDecoration.lineThrough,
                          fontSize:12.0,
      
                        )
                      ),
                      const Spacer(),
                      BlocBuilder<ShopCubit,ShopStates>(
                        bloc:cubit,
                        builder: (final BuildContext context,final ShopStates state) {
                          return IconButton(
                            icon:CircleAvatar(
                              backgroundColor:cubit.inCarts[products[i].id]!?Theme.of(context).primaryColor:Colors.grey,
                              radius: 15.0,
                              child:const Icon(Icons.shopping_cart_outlined,size:15.0,color:Colors.white)
                            ),
                            onPressed:()=>cubit.toCart(products[i].id),
                          );
                        }
                      )
                    ]
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      if(i<products.length-1) const Divider(height:8.0)
    ],
  )
);