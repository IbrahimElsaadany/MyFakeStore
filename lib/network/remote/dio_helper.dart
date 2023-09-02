import "package:dio/dio.dart";
abstract class DioHelper{
  static late final Dio dio;
  static void init()
  =>dio=Dio(BaseOptions(
    baseUrl:"https://student.valuxapps.com/api/",
    sendTimeout:const Duration(seconds:20),
    receiveTimeout:const Duration(seconds:20),
    connectTimeout:const Duration(seconds:20),
    receiveDataWhenStatusError:true,
    headers:<String,String>{
      "lang":"en",
      "Content-Type":"application/json"
    }
  ));
}