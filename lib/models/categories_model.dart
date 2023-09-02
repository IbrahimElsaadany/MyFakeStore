class CategoriesModel{
  late final List<CategoryModel> categories;
  CategoriesModel(Map<String,dynamic> json){
    categories = json["data"]["data"].map<CategoryModel>((e)=>CategoryModel(e["name"],e["image"])).toList();
  }
}
class CategoryModel{
  final String name,image;
  CategoryModel(this.name,this.image);
}