import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HomePageSlider extends StatelessWidget {
  final String image;
  final int index;
  final int totalSlides;
  final String content;
  final String title;
  final PageController pageController;
  
  const HomePageSlider({super.key,
    required this.image, required this.index, required this.totalSlides, required this.content, required this.title, required this.pageController, required BuildContext context,
  });
  
  @override
  Widget build(BuildContext context){
    return SizedBox(
      //height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [

          //1st Widget--skip
          index == 0 ? Align(
              alignment: Alignment.topRight,
              child: Padding(padding: EdgeInsets.only(top: 40,right: 30),

                child: TextButton(
                  onPressed: (){
                    pageController.animateToPage(totalSlides-1, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                  },
                  child: Text('Skip',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                ),

              )) : SizedBox(height: 80,),

          SizedBox(height: 30,),

          //2nd Widget--image
          Image.asset(image, height: 300,),

          SizedBox(height: 20,),

          //3rd Widget--title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          ),
          SizedBox(height: 20,),

          //4th Widget--content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(content, style: TextStyle(fontSize: 18,),textAlign: TextAlign.center,),
          ),


        ],
      ),
    );
  
}

}