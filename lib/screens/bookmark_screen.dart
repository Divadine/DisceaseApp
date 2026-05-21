import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../sharedwidgtes/bottom_naviagtion_bar.dart';
import '../utils/app_utils.dart';
import 'diseasedetail_screen.dart';
import 'edit_note_screen.dart';
import 'notes_list_screen.dart';



class BookmarkScreen extends StatefulWidget {



  const BookmarkScreen({super.key,  });

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();

}


class _BookmarkScreenState extends State<BookmarkScreen> {

  bool isLoading = true;
  int selectedIndex =0;

  List<Map<String, dynamic>> bookmarksDisease = [];
  List<Map<String, dynamic>> notes = [];
  



  @override
  void initState(){
    super.initState();
    loadBookmarks();
   // loadNotes();
  }
  
  // Future loadNotes() async {
  //   final result = await DbHelper.instance.getNotes();
  //   setState(() {
  //     notes = result;
  //   });
  // }

  Future loadBookmarks() async {
    final  result = await DbHelper.instance.getBookmarks();
    setState(() {
      bookmarksDisease=result;
    });



    
  }


  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
          title: Text('Bookmark',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
          centerTitle: true,
          backgroundColor: ColorUtils.selectedColor,
          bottom: const TabBar(
              tabs: [
                Tab(text: 'Diseases',),
                Tab(text: 'Videos',),
                Tab(text: 'Notes',)
              ],

            indicatorColor: Colors.white,
            labelColor: Colors.white,
            indicatorSize:TabBarIndicatorSize.tab,
            indicatorWeight: 7,
            labelStyle:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
            unselectedLabelColor: Colors.white,
          ),
        ),


        body: TabBarView(
            children: [

              // disease bookmark
              bookmarksDisease.isEmpty ? Center(child: Image.asset(AssetImages.disease_bookmark_notfound)) : ListView.builder(
                        itemCount: bookmarksDisease.length,
                          itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_) => DiseaseDetailsScreen(catId: 0, diseaseName: bookmarksDisease[index]['disease_name'], diseaseId: bookmarksDisease[index]['disease_id'],)));
                            },
                            child: Column(
                                          children: [
                                            SizedBox(height: 20,),
                                            Padding(
                                                padding: const EdgeInsets.only(left: 10,right: 10),
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Color(0xffFFFFFF),
                                                ),

                                                child: Padding(
                                                  padding:  const EdgeInsets.only(left: 15,right: 10),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(bookmarksDisease[index]['disease_name'],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                            ),
                          );

                          }
                        ),
              //video Bookmark

               Center(
                child: Image.asset(AssetImages.video_bookmark_notfound),
              ),
              
              

              //Notes Bookmark Tab
               notes.isEmpty ? Center(child: Image.asset(AssetImages.notes_bookmark_notfound),) : ListView.builder(
                   itemCount: notes.length,
                   itemBuilder: (context, index){
                     return Card(
                       child: ListTile(
                         leading:
                         Image.network(notes[index]['image'] ?? "",width: 60,fit: BoxFit.cover,),
                         title: Text(notes[index]['title'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                         subtitle: Text(notes[index]['content'],maxLines: 2,overflow: TextOverflow.ellipsis,),

                         onTap: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => EditNoteScreen(noteData : notes[index]))).then((_) {loadNotes();});
                         },

                       ),
                     );
                   }
               ),


              //NotesListScreen(diseaseId: , image: '',),

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
      ),

    );
  }
}