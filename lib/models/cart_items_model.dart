import 'products_model.dart' show ProductModel ;
class CartItemsModel{
  late final List<ProductModel> cartItems;
  CartItemsModel(Map<String,dynamic> json){
    cartItems=json["data"]["cart_items"].map<ProductModel>((e)
    =>ProductModel(
        name:e["product"]["name"],
        image:e["product"]["image"],
        price:e["product"]["price"],
        oldPrice:e["product"]["old_price"],
        id:e["product"]["id"],
        inCart:true,
        description:e["product"]["description"]
      )
    ).toList();
  }
}