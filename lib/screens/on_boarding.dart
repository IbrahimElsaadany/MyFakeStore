import "package:flutter/material.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";
import 'login/login.dart';
import '../network/local/cache_helper.dart';
const List<List<String>> _onBoardingText = <List<String>>[
  ["Welcome to My Fake Store!","The biggest shop to get fake products!"],
  ["We sell illusion here for free!","Proceed to get some!"],
  ["Get any number of products!","They are all free for you!"]

];
class OnBoarding extends StatelessWidget{
  final PageController _pageController = PageController();
  OnBoarding({super.key});
  @override
  Scaffold build(final BuildContext context)
  =>Scaffold(
    appBar:AppBar(
      backgroundColor:Colors.white,
      elevation:0,
      actions:<TextButton>[
        TextButton(
          child:const Text("SKIP"),
          onPressed:()=>_destructOnBoarding(context)
        )
      ]    
    ),
    body:Center(
      child:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children:[
          Expanded(
            child: PageView.builder(
              controller:_pageController,
              physics:const BouncingScrollPhysics(),
              itemBuilder:(final BuildContext context,final int i)
              =>_onBoardingItem(i,context),
              itemCount:3,
            ),
          ),
          SmoothPageIndicator(
            controller:_pageController,
            count:3,
            effect:const SwapEffect(
              activeDotColor:Colors.deepPurple,
              type:SwapType.yRotation
            )
          )
        ]
      )
    ),
    floatingActionButton:FloatingActionButton(
      child:const Icon(Icons.arrow_forward_ios),
      onPressed:()=>_pageController.page!<2?_pageController.nextPage(
        duration:const Duration(milliseconds:350),
        curve:Curves.easeInOutExpo
      ):_destructOnBoarding(context)
    )
  );
  Column _onBoardingItem(final int i,final BuildContext context)
  => Column(
    crossAxisAlignment:CrossAxisAlignment.start,
    mainAxisAlignment:MainAxisAlignment.center,
    children: [
      Image.asset(
        "assets/on_boarding$i.png"
      ),
      const SizedBox(height:10.0),
      Padding(
        padding:const EdgeInsets.only(left:20.0),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Text(
              _onBoardingText[i][0],
              style:Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              _onBoardingText[i][1],
              style:Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      )
    ],
  );
  void _destructOnBoarding(final BuildContext context){
    CacheHelper.prefs.setBool("isOnBoarding",true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:(final BuildContext context)=>Login()
      )
    );
  }
}