import "package:flutter/material.dart";
import "package:carousel_slider/carousel_slider.dart";
import "../../../models/products_model.dart";
import "../../product.dart";
import "../cubit/cubit.dart";
List<Widget> buildHome(final BuildContext context, final ShopCubit cubit)
=> <Widget>[
  CarouselSlider.builder(
    itemBuilder:(final BuildContext context,final int i,final int j)
    =>Image.asset(
      "assets/banner$i.png",
      width:double.infinity,
    ),
    itemCount:3,
    options:CarouselOptions(
      autoPlayInterval:const Duration(seconds:6),
      viewportFraction:1.0,
      aspectRatio:5/3,
      autoPlay:true,
      autoPlayCurve:Curves.elasticOut,
      enlargeCenterPage:true
    )
  ),
  Text(
    "  Categories",
    style:Theme.of(context).textTheme.bodyLarge
  ),
  SizedBox(
    height:105.0,
    child: ListView.builder(
      scrollDirection:Axis.horizontal,
      itemBuilder:(final BuildContext context,int i)
      =>_buildCategoryItem(
        image:cubit.categoriesModel!.categories[i].image,
        name:cubit.categoriesModel!.categories[i].name
      ),
      itemCount:cubit.categoriesModel!.categories.length
    ),
  ),
  Text(
    "  Products",
    style:Theme.of(context).textTheme.bodyLarge
  ),
  Container(
    color:Colors.grey,
    child: GridView.builder(
      shrinkWrap:true,
      physics:const NeverScrollableScrollPhysics(),
      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:2,
        childAspectRatio:1/1.4,
        mainAxisSpacing:1.0,
        crossAxisSpacing:1.0
      ),
      itemBuilder:(final BuildContext context,final int i)
      =>_buildProductItem(
        context:context,
        cubit:cubit,
        model:cubit.productsModel!.products[i],
        inCart:cubit.inCarts[cubit.productsModel!.products[i].id]!
      ),
      itemCount:cubit.productsModel!.products.length,
    ),
  )
];

Card _buildCategoryItem({required final String image,required final String name})
=> Card(
  child: Column(
    children:<Widget>[
      FadeInImage.assetNetwork(
        fadeInDuration:const Duration(milliseconds:100),
        fadeOutDuration:const Duration(milliseconds:100),
        placeholder:"assets/placeholder.gif",
        imageErrorBuilder:(final BuildContext context,final Object x,final StackTrace? y)
        =>Image.asset(
          "assets/placeholder.gif",
          height:80.0,width:80.0
        ),
        placeholderFit:BoxFit.cover,
        image:image,
        height:80.0,width:80.0
      ),
      Text(
        name,
        style:const TextStyle(
          color:Colors.black
        )
      )
    ]
  ),
);

InkWell _buildProductItem({
  required final BuildContext context,
  required final ShopCubit cubit,
  required final ProductModel model,
  required final bool inCart
})
=>InkWell(
  onTap:()=>Navigator.push(
    context,
    MaterialPageRoute(
      builder:(final BuildContext context)=>Product(
        name: model.name,
        description: model.description,
        image:model.image
      )
    )
  ),
  child:   Container(
    color:Theme.of(context).canvasColor,
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children:<Widget>[
        Stack(
          alignment:AlignmentDirectional.bottomStart,
          children: [
            FadeInImage.assetNetwork(
              imageErrorBuilder:(final BuildContext context,final Object x,final StackTrace? y)
              =>Image.asset("assets/placeholder.gif"),
              fadeInDuration:const Duration(milliseconds:100),
              fadeOutDuration:const Duration(milliseconds:100),
              placeholder:"assets/placeholder.gif",
              placeholderFit:BoxFit.cover,
              image:model.image,
              height:150.0,width:150.0
            ),
            if(model.oldPrice>model.price)
            const Text(
              " DISCOUNT ",
              style:TextStyle(
                backgroundColor:Colors.red,
                color:Colors.white
              )
            )
          ],
        ),
        Text(
          model.name,
          maxLines:2,
          overflow:TextOverflow.ellipsis,
          style:Theme.of(context).textTheme.titleSmall
        ),
        Row(
          children:<Widget>[
            Text(
              model.price.toString(),
              style:TextStyle(
                color:Theme.of(context).primaryColor,
                fontSize:14.0
              )
            ),
            if(model.oldPrice>model.price)
              Text(
              "  ${model.oldPrice}",
              style:const TextStyle(
                decoration:TextDecoration.lineThrough,
                fontSize:12.0,
              )
            ),
            const Spacer(),
            IconButton(
              icon:CircleAvatar(
                backgroundColor:inCart?Theme.of(context).primaryColor:Colors.grey,
                radius: 15.0,
                child:const Icon(Icons.shopping_cart_outlined,size:15.0,color:Colors.white)
              ),
              onPressed:()=>cubit.toCart(model.id),
            )
          ]
        )
      ]
    ),
  ),
);