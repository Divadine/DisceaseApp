import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../api/apiservice.dart';
import '../models/disease_details.dart';
import '../utils/app_utils.dart';
import 'notes_screen.dart';

class DiseaseDetailsScreen extends StatefulWidget {
  final int catId;
  final int diseaseId;
  final String diseaseName;

  const DiseaseDetailsScreen({
    super.key,
    required this.catId,
    required this.diseaseName, required this.diseaseId,
  });

  @override
  State<DiseaseDetailsScreen> createState() =>
      _DiseaseDetailsScreenState();
}

class _DiseaseDetailsScreenState  extends State<DiseaseDetailsScreen> {

  bool isLoading = true;
  bool isBookMarked = false;
  int? expandedIndex;
  int noteCount = 1;




  List<InfoModel> infoList = [];
  List<PhotoModel> photos = [];
  List<VideoModel> videos = [];

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try{
      setState(() {
        isLoading = true;
      });

      //api call
      final response = await ApiService().getAllDiseaseDetails(widget.diseaseId);

      //save in db
      await DbHelper.instance.insertDiseaseDetails(response.resultData.disease_info);
      await DbHelper.instance.insertDiseaseInformation(widget.diseaseId, response.resultData.disease_info.info);
      await DbHelper.instance.insertPhotos(response.resultData.photos);


      //save video
      await DbHelper.instance.insertVideos(response.resultData.videos,widget.catId);

      List<InfoModel> dbInfo =  await DbHelper.instance.getInformationFromDbClient(widget.diseaseId);
      List<PhotoModel> dbPhotos= await DbHelper.instance.getPhotosFromDbClient(widget.diseaseId);
      List<VideoModel> dbVideos = await DbHelper.instance.getVideosFromDbClient(widget.catId);


      print("Video API Response:");
      print("DB Videos Count: ${dbVideos.length}");

      setState(() {
        infoList = dbInfo;
        photos = dbPhotos;
        videos = dbVideos;
        isLoading = false;
      });

    }catch(e){
      print('Error ------> ${e}');
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          //title: Text(widget.diseaseName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          //centerTitle: true,
          backgroundColor: ColorUtils.selectedColor,
          actions: [
            //speaker
            IconButton(onPressed: (){}, icon: SvgPicture.asset(AssetImages.speaker_icon), ),
            //bookmark
            IconButton(onPressed: () async {
              if(isBookMarked){

                await DbHelper.instance.deleteBookmarks(widget.diseaseId);

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(" Bookmark is removed"),
                  duration:  Duration(seconds: 1),
                ));
              }else{
                await DbHelper.instance.insertBookmarks(diseaseId: widget.diseaseId, diseaseName: widget.diseaseName);

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Bookmark saved successfully'),
                  duration: Duration(seconds: 1),
                ));
              }

              final result = await DbHelper.instance.checkBookmarksExists(widget.diseaseId);
              setState(() {
                isBookMarked=result;
              });
              setState(() {

              });
            },
                icon: isBookMarked ? SvgPicture.asset(AssetImages.note_icon_shaded,):SvgPicture.asset(AssetImages.bookmark_outline_bottom),
            ),
            //menu -- threedots
            PopupMenuButton(
              icon: SvgPicture.asset(AssetImages.threedots_icon),
                itemBuilder:(context) => [
                  const PopupMenuItem(

                    value: "share",
                    child: Text("Share"),
                  ),
                  const PopupMenuItem(
                    value: "report",
                    child: Text("Report"),
                  ),
                ] ),


          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 7,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),


            tabs: [
              Tab(text: "All"),
              Tab(text: "Photos"),
              Tab(text: "Videos"),
            ],
          ),
        ),


        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : TabBarView(
          children: [

            /// ALL TAB
            ListView(
              children: [

                /// Disease Name
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      widget.diseaseName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                /// Disease Image
                if (photos.isNotEmpty)
                  Image.network(
                    photos.first.image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                const SizedBox(height: 10),

                /// Expandable Sections
                ...infoList.asMap().entries.map((entry) {
                  int index = entry.key;
                  InfoModel info = entry.value;

                  bool isExpanded = expandedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: Colors.white,


                        /// track expanded tile
                        onExpansionChanged: (value) {
                          setState(() {
                            expandedIndex = value ? index : null;
                          });
                        },

                        /// arrow icon
                        trailing: Icon(

                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),

                        /// only title background color changes
                        title: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isExpanded
                                ? const Color(0xffEFE6FD)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            info.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: const EdgeInsets.all(12),
                            child: Html(
                              data: info.content,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),

            /// PHOTOS TAB
            GridView.builder(
              itemCount: photos.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Card(
                  child: Image.network(
                    photos[index].image,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),

            /// VIDEOS TAB
            ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      videos[index].thumbnail_image,width: 80,fit: BoxFit.cover,
                    ),
                    title: Text(videos[index].name),
                    subtitle: Text(
                      videos[index].description,
                    ),

                  ),
                );
              },
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorUtils.selectedColor,
            onPressed: (){

              Navigator.push(context, MaterialPageRoute(builder: (_) => NotesScreen(diseaseId: widget.diseaseId, image: photos.isNotEmpty ? photos.first.image : "",)));
            },
            child: SvgPicture.asset(AssetImages.note_icon,color: Colors.white,),



            ),

      ),
    );
  }
}