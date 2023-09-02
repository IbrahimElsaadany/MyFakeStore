class ProfileModel{
  String name,email,phone,image;
  ProfileModel(Map<String,dynamic> json):
    name=json["data"]["name"],
    email=json["data"]["email"],
    phone=json["data"]["phone"],
    image=json["data"]["image"];
}