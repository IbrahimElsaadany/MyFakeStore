import "package:flutter/material.dart";
class Product extends StatelessWidget{
  final String name, description, image;
  const Product({
    required this.name,
    required this.description,
    required this.image,
    super.key
  });
  @override
  Scaffold build(final BuildContext context)
  =>Scaffold(
    appBar:AppBar(),
    body:ListView(
      padding:const EdgeInsets.all(20.0),
      children:[
        FadeInImage.assetNetwork(
          imageErrorBuilder:(final BuildContext context,final Object x,final StackTrace? y)
          =>Image.asset("assets/placeholder.gif"),
          fadeInDuration:const Duration(milliseconds:100),
          fadeOutDuration:const Duration(milliseconds:100),
          placeholder:"assets/placeholder.gif",
          placeholderFit:BoxFit.cover,
          image:image,
          height:200.0,width:200.0
        ),
        Text(
          name,
          style:Theme.of(context).textTheme.titleLarge
        ),
        const Divider(),
        Text(
          description,
        )
      ]
    )
  );
}