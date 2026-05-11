import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';


class Mainscreenslider extends StatelessWidget {

  //final String img;
  final int PresentIndex ;
  final int totalDots;
  const Mainscreenslider({super.key, required this.PresentIndex, required this.totalDots, });

  @override
  Widget build(BuildContext context){


    return Column(
      children: [
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 20,top: 5),
          child: Align(
            alignment: Alignment.topLeft,
              child: Text( " Medical Trivia", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
        ),

        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(

            height: 150,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              image: DecorationImage(image: AssetImage(AssetImages.mainsliderimg),fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(18),
              border:Border.all(color: Colors.black,width: 1)
            ),
            padding: EdgeInsets.only(top: 16),
            child: Container(

              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                      child: Text('Did you Know ?', textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)
                  ),

                  SizedBox(height: 20,),
                  Text("“The human brain has about 86 billion neurons!”",style: TextStyle(fontSize: 18,color: Colors.white),),

                  SizedBox(height: 40,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalDots, (dots) =>Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 8,
                      width:PresentIndex == dots ? 15 : 10,
                      decoration: BoxDecoration(
                        color:  Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )),
                  ),


                  //SizedBox(height: 50,),
                  //categories
                ],


              ),
            ),

          ),


        ),

        Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 20),
          child: Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text( "Categories", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              Text("view all",style: TextStyle(fontSize: 18),),
            ],
          ),
        ),

        SizedBox(height: 20,),




      ],
    );
  }
}