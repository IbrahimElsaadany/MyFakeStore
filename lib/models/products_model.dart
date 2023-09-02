class ProductsModel{
  late final List<ProductModel> products;
  ProductsModel(Map<String,dynamic> json){
    products = json["data"]["data"].map<ProductModel>((e)
    =>ProductModel(
      name:e["name"],
      image:e["image"],
      price:e["price"],
      oldPrice:e["old_price"]??0,
      id:e["id"],
      inCart:e["in_cart"],
      description:e["description"]
    )).toList();
  }
}
class ProductModel{
  final String name,image,description;
  final num price,oldPrice;
  final int id;
  final bool inCart;
  ProductModel({
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.id,
    required this.inCart,
    required this.description
  });
}