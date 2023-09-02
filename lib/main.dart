import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import 'screens/on_boarding.dart';
import "screens/login/login.dart";
import "network/local/cache_helper.dart";
import "network/remote/dio_helper.dart";
import "screens/shop/shop.dart";
import "shared/components.dart";
import "shared/theme_cubit/cubit.dart";
import "shared/theme_cubit/states.dart";
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  DioHelper.init();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(final BuildContext context)
  =>BlocProvider<ThemeCubit>(
    create:(final BuildContext context)=>ThemeCubit(),
    child: BlocBuilder<ThemeCubit,ThemeStates>(
      builder: (final BuildContext context,final ThemeStates state) {
        return MaterialApp(
          home:_whichStart(),
          theme:ThemeData(
            appBarTheme: AppBarTheme(
              systemOverlayStyle:SystemUiOverlayStyle(
                statusBarColor:Colors.deepPurple[700]
              )
            ),
            primarySwatch:Colors.deepPurple,
            canvasColor: Colors.white,
            scaffoldBackgroundColor:Colors.white,
            listTileTheme:const ListTileThemeData(
              titleTextStyle:TextStyle(
                color:Colors.black,
                fontSize:16.0,
                fontWeight:FontWeight.bold
              )
            ),
            textTheme:const TextTheme(
              bodyLarge:TextStyle(
                fontSize:24.0,
                height:2.0
              ),
              bodyMedium:TextStyle(
                color:Colors.grey,
              ),
              headlineLarge:TextStyle(
                color:Colors.black,
                fontWeight:FontWeight.w700,
                height:2
              ),
              displaySmall:TextStyle(
                fontSize:18.0,
                height:1.0
              )
            )
          ),
          darkTheme:ThemeData(
            primarySwatch:Colors.cyan,
            appBarTheme: AppBarTheme(
              systemOverlayStyle:SystemUiOverlayStyle(
                statusBarColor:Colors.cyan[700],
              )
            ),
            inputDecorationTheme:InputDecorationTheme(
              labelStyle:const TextStyle(
                color:Colors.grey
              ),
              prefixIconColor:Colors.grey,
              enabledBorder:OutlineInputBorder(
                borderSide: const BorderSide(color:Colors.grey),
                borderRadius:BorderRadius.circular(20.0)
                
              ),
            ),
            canvasColor: Colors.black,
            scaffoldBackgroundColor:Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            listTileTheme:const ListTileThemeData(
              iconColor:Colors.white,
              titleTextStyle:TextStyle(
                color:Colors.white,
                fontSize:16.0,
                fontWeight:FontWeight.bold
              )
            ),
            dividerColor:Colors.grey,
            textTheme:const TextTheme(
              titleLarge:TextStyle(color:Colors.white),
              titleMedium: TextStyle(
                color:Colors.white
              ),
              titleSmall:TextStyle(
                color:Colors.white
              ),
              bodyLarge:TextStyle(
                fontSize:24.0,
                height:2.0,
                color:Colors.white
              ),
              bodyMedium:TextStyle(
                color:Colors.grey,
              ),
              headlineLarge:TextStyle(
                color:Colors.white,
                fontWeight:FontWeight.w700,
                height:2
              ),
              displaySmall:TextStyle(
                fontSize:18.0,
                height:1.0,
                color:Colors.white
              )
            )
          ),
          themeMode:BlocProvider.of<ThemeCubit>(context).nightMode?ThemeMode.dark:ThemeMode.light,
        );
      }
    ),
  );
  StatelessWidget _whichStart(){
    if(CacheHelper.prefs.getBool("isOnBoarding")==null)
      return OnBoarding();
    else if(token==null)
      return Login();
    return const Shop();
  }
}