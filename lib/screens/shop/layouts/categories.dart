import "package:flutter/material.dart";
import "../../../models/categories_model.dart" show CategoryModel;
List<Widget> buildCategories(final BuildContext context,final List<CategoryModel> categories)
=>List<Widget>.generate(
  categories.length,
  (final int i)
  => Column(
    children: [
      InkWell(
        onTap:(){},
        child: Row(
          children: [
            Card(
              child:FadeInImage.assetNetwork(
                fadeInDuration:const Duration(milliseconds:100),
                fadeOutDuration:const Duration(milliseconds:100),
                placeholder:"assets/placeholder.gif",
                placeholderFit:BoxFit.cover,
                imageErrorBuilder:(final BuildContext context,final Object x,final StackTrace? y)
                =>Image.asset(
                  "assets/placeholder.gif",
                  height: 100.0,width:100.0,
                ),
                image:categories[i].image,
                height: 100.0,
                width:100.0,
              ),
            ),
            Text(
              categories[i].name,
              style:Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize:20.0,
                overflow:TextOverflow.ellipsis
              )
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_right_outlined,size:50.0)
          ],
        ),
      ),
      if(i<categories.length-1) const Divider(height:8.0)
    ],
  )
);