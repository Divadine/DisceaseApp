import 'dart:async';

import 'package:discese_dictionary/screens/viewallcategory_screen.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';
import '../api/apiservice.dart';
import '../models/triviamodel.dart';
import '../sharedwidgtes/bottom_naviagtion_bar.dart';
import '../sharedwidgtes/discease_categories.dart';
import '../sharedwidgtes/mainscreenslider.dart';


class DisceaseDictionary extends StatefulWidget{

  const DisceaseDictionary({super.key});

  @override
  State<DisceaseDictionary> createState() => _DisceaseDictionaryState();
}



class _DisceaseDictionaryState extends State<DisceaseDictionary>{

  int currentBatchIndex = 0;
  int selectedIndex =0;
  bool isLoading = true;
  List<Triviamodel> triviaList = [];
  List<CategoryModel> categoryList = [];
  int currentTriviaIndex = 0;
  Timer? triviaTimer;




  @override
  void initState()   {
    super.initState();
    getTrivias();
    GetCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isLoading = true;
      await Future.delayed(Duration(seconds: 2));
      isLoading = false;
      setState(() {});
    });

  }

  @override
  void dispose() {
    triviaTimer?.cancel();
    super.dispose();
  }

  void getTrivias() async{
    //final discease1 = await ApiService().post('home', {'last_cat_id': 0, 'last_disease_id': 0, 'last_trivia_id': 0});
    //print(discease1[0].trivia);
    try{
      final disease = await ApiService().fetchTrivias();
      setState(() {
        triviaList = disease;
        isLoading=false;
      });
      TriviaTimingForSlider();
      //print(disease);
    }
   catch(e){
      print(e);

      setState(() {
        isLoading = false;
      });
   }
  }

  void GetCategories() async {
    try{
      final disceaseCategories = await ApiService().getCategories();
      setState(() {
        categoryList = disceaseCategories ;
        isLoading=false;
      });
    }catch(e){
      print(e);
      setState(() {
        isLoading=false;
      });
    }
  }

  void TriviaTimingForSlider(){
    triviaTimer = Timer.periodic(Duration(hours: 24), (timer){
      setState(() {
        currentBatchIndex + 3;
        if(currentBatchIndex > triviaList.length){
          currentBatchIndex = 0;
        }
      });
    });
  }




  @override
  Widget build(BuildContext context){
    List<Triviamodel> currentThreeTrivia =
    triviaList.skip(currentBatchIndex).take(3).toList();


    return Scaffold(

      appBar: AppBar(
       leading: IconButton(
           onPressed: (){

           },
           icon: Icon(Icons.menu,color: Colors.white,)),
        backgroundColor: ColorUtils.selectedColor,
        centerTitle: true,
        title: Text("Discease Dictionary",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),




      body: isLoading ? Center(child:CircularProgressIndicator() ,) : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          //slider
          Column(
            children: currentThreeTrivia.map((trivia) {
              return Mainscreenslider(triviaList: triviaList);
            }).toList()
          ),
          //Mainscreenslider(PresentIndex:currentTriviaIndex, totalDots: 3, triviaText: triviaList[currentTriviaIndex].trivia,),

          SizedBox(height: 10,),
          
          //categories and viewAll text
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20),
            child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text( "Categories", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ViewallcategoryScreen(categoryList: [],)));
                  },
                  child: Text("view all", style: TextStyle(fontSize: 15),),
                ),
              ],
            ),
          ),

          SizedBox(height: 20,),

          //category Lists Ui
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(categoryList.length, (index) => Padding(padding: EdgeInsets.all(10),child: DisceaseCategories(category: categoryList[index]),), ),
            ),
          ),

        ],
      ),


      //bottom
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavigationBar(
          currentIndex: selectedIndex,
            onTap:(index){
            setState(() {
              selectedIndex = index;
            });
            }

        ),
      ),

    );
  }
}

