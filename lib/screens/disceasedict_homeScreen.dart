import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';
import '../api/apiservice.dart';
import '../models/triviamodel.dart';
import '../sharedwidgtes/bottom_naviagtion_bar.dart';
import '../sharedwidgtes/mainscreenslider.dart';


class DisceaseDictionary extends StatefulWidget{

  const DisceaseDictionary({super.key});

  @override
  State<DisceaseDictionary> createState() => _DisceaseDictionaryState();
}



class _DisceaseDictionaryState extends State<DisceaseDictionary>{

  int selectedIndex =0;
  bool isLoading = true;
  List<Triviamodel> triviaList = [];

  @override
  void initState()   {
    super.initState();
    getTrivias();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isLoading = true;
      await Future.delayed(Duration(seconds: 2));
      isLoading = false;
      setState(() {});
    });

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
      //print(disease);
    }
   catch(e){
      print(e);

      setState(() {
        isLoading = false;
      });
   }
  }



  @override
  Widget build(BuildContext context){
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


      body: isLoading ? Center(child:CircularProgressIndicator() ,) : Mainscreenslider(PresentIndex: 0, totalDots: 3,),

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