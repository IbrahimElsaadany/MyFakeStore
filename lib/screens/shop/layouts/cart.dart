import "package:flutter/material.dart";
import "../../../models/products_model.dart" show ProductModel;
import "../cubit/cubit.dart";
import "../../../shared/components.dart";
List<Widget> buildCart({
  required final BuildContext context,
  required final List<ProductModel> products,
  required final ShopCubit cubit,
}){
  if(products.isEmpty)
    return <Widget>[
      Padding(
        padding: const EdgeInsets.only(top:225.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_shopping_cart,size:100.0,color:Theme.of(context).primaryColorLight),
            Text(
              "Cart is Empty.\n Why not add some!",
              textAlign:TextAlign.center,
              style:TextStyle(
                color:Theme.of(context).primaryColorLight
              )
            ),
          ],
        ),
      )
    ];
  return rowProducts(
    context,
    products:products,
    cubit:cubit
  );
}