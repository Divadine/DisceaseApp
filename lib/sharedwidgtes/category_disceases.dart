import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/triviamodel.dart';
import '../screens/diseasedetail_screen.dart';

class CategoryDisceases  extends StatefulWidget {

  final String name;
  final int catgoryId;
  const CategoryDisceases({super.key,required this.name,  required this.catgoryId});

  @override
  State<CategoryDisceases> createState() => _CategoryDisceasesState();
}

class _CategoryDisceasesState extends State<CategoryDisceases> {

  List<DisceaseList> diseaseList = [];
  bool isLoading = true;
  //bool isBookmarked = false;

  /// store bookmark state separately
  Map<int, bool> bookmarkedDiseases = {};


  @override
  void initState(){
    super.initState();
    loadDisease();
  }

  void loadDisease() async{
    final data = await DbHelper.instance.getDiseaseById(widget.catgoryId);

    Map<int,bool> tempBookmarks = {};
    for(var disease in data){
      bool result = await DbHelper.instance.checkBookmarksExists(disease.id);
      tempBookmarks[disease.id] = result;
    }
    setState(() {
      diseaseList = data;
      bookmarkedDiseases = tempBookmarks;
      isLoading = false;
    });

  }
  @override
  Widget build(BuildContext context){
    return DefaultTabController(

      length: 2,
      child: Scaffold(

        appBar: AppBar(
          title: Text(widget.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: ColorUtils.selectedColor,

          bottom : TabBar(
            indicatorColor: Colors.white,indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            tabs: const  [Tab(text:'Disease',),Tab(text:'Videos',)],

        ),
      ),

        body: TabBarView(
            children: [
              //diseasetab
              isLoading ? const Center(child: CircularProgressIndicator(),) :
                  ListView.builder(
                    itemCount: diseaseList.length,
                      itemBuilder: (context , index){
                      final disease = diseaseList[index];
                      bool isBookmarked = bookmarkedDiseases[disease.id] ?? false;
                      return Card(
                        //margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(disease.disceaseName ?? ""),
                          trailing:
                          IconButton(
                              onPressed: ()  async {
                                if(isBookmarked){
                                  await DbHelper.instance.deleteBookmarks(disease.id);
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content:Text('Bookmark Removed'),duration: Duration(seconds: 1), ),
                                  );
                                }else {

                                  await DbHelper.instance.insertBookmarks(diseaseId: disease.id, diseaseName: disease.disceaseName ?? "");

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content:Text('Bookmark Saved Successfully'),duration: Duration(seconds: 1), ),
                                  );
                                }

                                bool updatedResult = await DbHelper.instance.checkBookmarksExists(disease.id);
                                setState(() {
                                  bookmarkedDiseases[disease.id] = updatedResult;
                                });
                              },
                            icon: SvgPicture.asset(isBookmarked ? AssetImages.note_icon_shaded : AssetImages.bookmark_outline_bottom, color: isBookmarked ? null : Colors.black, ),
                          ),
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => DiseaseDetailsScreen( catId:widget.catgoryId , diseaseName:disease.disceaseName ??"", diseaseId: disease.id,  )));

                            // //refresh
                            // bool updatedResult = await DbHelper.instance.checkBookmarksExists(disease.id);
                            // setState(() {
                            //   bookmarkedDiseases[disease.id] = updatedResult;
                            // });
                          },
                        ),
                      );
                      }
                  ),

              //video tab
              GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,crossAxisSpacing: 10,mainAxisSpacing: 20,childAspectRatio: 0.2,
                ),
              itemCount: 4,
              itemBuilder: (context,index) {
                return Card(
                  child: Column(
                    children: [
                      Expanded(child: Image.network("https://via.placeholder.com/150",fit: BoxFit.cover,),),
                      Padding(padding: const EdgeInsets.all(10),child: Text('Category videos'),)
                    ],
                  ),
                );

          }),

            ]
        ),
      ),
    );
  }
}