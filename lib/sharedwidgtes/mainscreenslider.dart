import 'dart:async';

import 'package:discese_dictionary/models/triviamodel.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';


class Mainscreenslider extends StatefulWidget {

  //final String img;
  final List<Triviamodel> triviaList;
  //final int PresentIndex ;
  //final int totalDots;
  //final String triviaText;
  const Mainscreenslider({super.key,required this.triviaList});

  @override
  State<Mainscreenslider> createState() => _MainscreensliderState();
}

class _MainscreensliderState extends State<Mainscreenslider> {
  PageController _pageController = PageController();
  int currentIndex =0;
  Timer? timer;
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
                  //title
                  Align(
                    alignment: Alignment.topCenter,
                      child: Text('Did you Know ?', textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)
                  ),

                  SizedBox(height: 20,),
                  //content text
                  //Text(widget.triviaText,style: TextStyle(fontSize: 18,color: Colors.white),),
                  SizedBox(
                    height: 50,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.triviaList.length > 3 ? 3 : widget.triviaList.length,
                        itemBuilder: (context,index){
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                            child:Center(
                              child: Text(widget.triviaList[index].trivia,textAlign: TextAlign.center, style: TextStyle(fontSize: 18,color: Colors.white),),
                            ) ,

                          );
                        }
                    )
                  ),
                  SizedBox(height: 40,),
                  //dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.triviaList.length > 3 ? 3 : widget.triviaList.length, (dots) =>Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 8,
                      width:currentIndex == dots ? 15 : 10,
                      decoration: BoxDecoration(
                        color:  Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}