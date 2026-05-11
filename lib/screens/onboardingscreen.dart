import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../sharedwidgtes/homeslider.dart';
import 'disclamierscreen.dart';



class DisceseApp extends StatefulWidget {
  const DisceseApp({super.key});

  @override
  State<DisceseApp> createState() => _DisceaseStateApp();
}

class _DisceaseStateApp extends State<DisceseApp>{

  int presentIndex = 0;

  PageController pageController = PageController();

  List<Map<String,dynamic>> image_and_contents=[
    {
      'image':AssetImages.welcomeImage,
      'title':'Welcome to Diseases Dictionary',
      'content':'Discover reliable health information at your fingertips with the Diseases Dictionary app.',
    },
    {
      'image':AssetImages.welcomesecondImage,
      'title':'Explore by Category',
      'content':"Explore diseases by category to easily find what you're looking for quickly and clearly.",
    },
    {
      'image':AssetImages.welcomethirdImage,
      'title':'Watch & Learn',
      'content':"Watch expert-backed videos to understand diseases, symptoms, and prevention visually."
    }
  ];


  @override
  Widget build(BuildContext context){
    return Scaffold(
     body: Column(
       children: [
         Container(
             height: 800,
             child: PageView.builder(
               controller: pageController,
                 itemCount: image_and_contents.length,
                 onPageChanged: (value){
                 setState(() {
                     presentIndex = value;
                   });
                 },
                 itemBuilder: (context,index){
                    return homepageSlider(
                        context: context,
                        image: image_and_contents[index]['image']!,
                        index: presentIndex,
                        totalSlides: image_and_contents.length,
                        content: image_and_contents[index]['content']!,
                        title: image_and_contents[index]['title']!,
                        pageController: pageController,

                    );
                 },
             ),
         ),


         //dots
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: List.generate(image_and_contents.length, (dots) =>Container(
             margin: EdgeInsets.symmetric(horizontal: 5),
             height: 8,
             width:presentIndex == dots ? 10 : 10,
             decoration: BoxDecoration(
               color: presentIndex == dots ? ColorUtils.selectedColor:Colors.grey,
               borderRadius: BorderRadius.circular(20),
             ),
           )),
         ),

         SizedBox(height: 15,),
         //nextButton
         ElevatedButton(
           style: ElevatedButton.styleFrom(
             minimumSize: Size(300, 50),
             backgroundColor: ColorUtils.selectedColor,
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
           ),
           onPressed: (){
             if(presentIndex < image_and_contents.length -1){
               pageController.animateToPage(presentIndex + 1, duration: Duration(milliseconds: 2), curve: Curves.easeOut);
             }else{
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Disclamierscreen() ),);
             }
           },

           child: Text(presentIndex == image_and_contents.length -1 ? 'Get Started' : 'Next',style: TextStyle(fontSize:22,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
         ),
       ],
     ),
    );
  }
}