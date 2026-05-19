import 'dart:async';
import 'package:discese_dictionary/screens/viewallcategory_screen.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';
import '../api/apiservice.dart';
import '../databasehelper/db_helper.dart';
import '../models/triviamodel.dart';
import '../sharedwidgtes/alphabet_diseae_list.dart';
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
  List<DisceaseList> disceaseList =[];
  int currentTriviaIndex = 0;
  Timer? triviaTimer;


  @override
  void initState() {
    super.initState();

    fetchSaveAndLoadData();


  }


  Future<void> fetchDiseaseDetailsandSave(int id) async{
    try{
      setState(() {
        isLoading = true;
      });

      //Api fetch
      final data = await ApiService().getAllDiseaseDetails(id);
      //save to Db
      await DbHelper.instance.insertDiseaseDetails(data.resultData.disease_info);
      await DbHelper.instance.insertDiseaseInformation(data.resultData.disease_info.id,data.resultData.disease_info.info);
      await DbHelper.instance.insertPhotos(data.resultData.photos);
      await DbHelper.instance.insertVideos(data.resultData.videos, data.resultData.disease_info.cat_id,);

      //final videos = await DbHelper.instance.getVideosFromDbClient();
      //print(videos.length);
      //print(videos.first.name);
    }catch(e) {
      print("Disease Details Error: $e");
    }
  }


  Future<void> fetchSaveAndLoadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // API fetch
      final data = await ApiService().getAllDatas();

      // save to DB
      await DbHelper.instance.insertTrivias(data.trivias);
      await DbHelper.instance.insertCategory(data.category);
      await DbHelper.instance.insertDisease(data.disceaseList);

      // fetch from DB
      final triviaData = await DbHelper.instance.getTriviaFromDbclient();
      final categoryData = await DbHelper.instance.getCategoryFromDbclient();
      final diseaseData = await DbHelper.instance.getDiseaseListFromDbclient();

      setState(() {
        triviaList = triviaData;
        categoryList = categoryData;
        disceaseList = diseaseData;
        isLoading = false;
      });
      // print(triviaList);
      // print(categoryList);

    } catch (e) {
      print("Error: $e");

      setState(() {
        isLoading = false;
      });
    }
  }




  @override
  void dispose() {
    triviaTimer?.cancel();
    super.dispose();
  }

  List<Color> bgColor = [ Color(0xff8CC6FF),Color(0xffFDFF8C),Color(0xff8CE4FF),Color(0xffFFC98C),Color(0xffFF8C8C),];

  @override
  Widget build(BuildContext context){

    List<Triviamodel> currentThreeTrivia =[];
      if(triviaList.isNotEmpty) {
        currentThreeTrivia = List.generate(1, (index) =>
        triviaList[(currentBatchIndex + index) %
            triviaList.length]);
      }

    return Scaffold(

      appBar: AppBar(
       leading: IconButton(
           onPressed: (){

           },
           icon: Icon(Icons.menu,color: Colors.white,)),
        backgroundColor: ColorUtils.selectedColor,
        centerTitle: true,
        title: Text("Disease Dictionary",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),




      body: isLoading ? Center(child:CircularProgressIndicator() ,) : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          //slider
          triviaList.isEmpty
              ? Center(child: Text("No data"))
              : Mainscreenslider(
            triviaList: triviaList.take(3).toList(),
          ),
          // print(currentThreeTrivia);


          SizedBox(height: 10,),

          //categories and viewAll text
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20),
            child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text( "Categories", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                //viewAll
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ViewallcategoryScreen(categoryList: categoryList,)));
                  },
                  child: Text("view all", style: TextStyle(fontSize: 15,color: Colors.black),),
                ),
              ],
            ),
          ),

          SizedBox(height: 20,),

          //category Lists Ui
          categoryList.isEmpty ? Center(child: Text(" no data"),) : SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: Row(
              children: List.generate(categoryList.length > 10 ? 10 : categoryList.length , (index) => Padding(padding: EdgeInsets.all(10),child: DisceaseCategories(category: categoryList[index],bgColor: bgColor[index % bgColor.length], ),), ),
            ),
          ),
          SizedBox(height: 40,),
          //Disease List alphabetically
          Padding(
              padding: EdgeInsets.only(left:20 ),
            child: Align(
              alignment: Alignment.topLeft,
                child: Text("Diseases A-Z" , style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),)),
          ),


          //Alpahbetic diseace list
          Expanded(
              child: disceaseList.isEmpty ? Center(child: CircularProgressIndicator(),) :
                  ListView.builder(
                    itemCount: disceaseList.length,
                      itemBuilder: (context,index){
                      return AlphabetOrderDiseaseList(diseaseNameAlphabet:  disceaseList[index].disceaseName  ?? "",  diseaseId: disceaseList[index].id, catId: disceaseList[index].cat_id,);
                      }
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

