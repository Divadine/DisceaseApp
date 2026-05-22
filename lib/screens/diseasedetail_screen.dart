import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/screens/video_showing_screen.dart';
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
    required this.diseaseName,
    required this.diseaseId,
  });

  @override
  State<DiseaseDetailsScreen> createState() => _DiseaseDetailsScreenState();
}

class _DiseaseDetailsScreenState extends State<DiseaseDetailsScreen> {
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
    checkBookmark();
    fetchDetails();
  }

  Future<void> checkBookmark() async {
    final result = await DbHelper.instance.checkBookmarksExists(
      widget.diseaseId,
    );
    setState(() {
      isBookMarked = result;
    });
  }

  Future<void> fetchDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      //api call
      final response = await ApiService().getAllDiseaseDetails(
        widget.diseaseId,
      );
      final apiVideos = await response.resultData.videos;
      final apiPhotos = await response.resultData.photos;
      final apiContent = await response.resultData.disease_info.info;

      // //save in db
      // await DbHelper.instance.insertDiseaseDetails(response.resultData.disease_info);
      // await DbHelper.instance.insertDiseaseInformation(widget.diseaseId, response.resultData.disease_info.info);
      // await DbHelper.instance.insertPhotos(response.resultData.photos);
      //
      //
      // //save video
      // await DbHelper.instance.insertVideos(response.resultData.videos,);
      //
      // List<InfoModel> dbInfo =  await DbHelper.instance.getInformationFromDbClient(widget.diseaseId);
      // List<PhotoModel> dbPhotos= await DbHelper.instance.getPhotosFromDbClient(widget.diseaseId);
      // List<VideoModel> dbVideos = await DbHelper.instance.getVideosFromDbClient(widget.catId);
      //
      //
      // print("Video API Response:");
      // print("DB Videos Count: ${dbVideos.length}");

      print(apiVideos.length);

      setState(() {
        infoList = apiContent;
        photos = apiPhotos;
        videos = apiVideos;
        isLoading = false;
      });
    } catch (e) {
      print('Error ------> ${e}');
      setState(() {
        isLoading = false;
      });
    }

    print(videos);
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
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(AssetImages.speaker_icon),
            ),
            //bookmark
            IconButton(
              onPressed: () async {
                if (isBookMarked) {
                  await DbHelper.instance.deleteBookmarks(widget.diseaseId);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(" Bookmark is removed"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  await DbHelper.instance.insertBookmarks(
                    diseaseId: widget.diseaseId,
                    diseaseName: widget.diseaseName,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bookmark saved successfully'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }

                final result = await DbHelper.instance.checkBookmarksExists(
                  widget.diseaseId,
                );
                setState(() {
                  isBookMarked = result;
                });
                setState(() {});
              },
              icon: isBookMarked
                  ? SvgPicture.asset(AssetImages.bookmark_shaded_bottom)
                  : SvgPicture.asset(AssetImages.bookmark_outline_bottom),
            ),
            //menu -- threedots
            PopupMenuButton(
              icon: SvgPicture.asset(AssetImages.threedots_icon),
              itemBuilder: (context) => [
                const PopupMenuItem(value: "share", child: Text("Share")),
                const PopupMenuItem(value: "report", child: Text("Report")),
              ],
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 7,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

            tabs: [
              Tab(text: "All"),
              Tab(text: "Photos"),
              Tab(text: "Videos"),
            ],
          ),
        ),

        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  //1 st widget
                  // ALL TAB
                  ListView(
                    children: [
                      //Disease Name
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

                      // Disease Image
                      if (photos.isNotEmpty)
                        Image.network(
                          photos.first.image,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),

                      const SizedBox(height: 10),

                      //all contents
                      for (int index = 0; index < infoList.length; index++)
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child:
                              //ExpansionTile(
                              //     title: Container(
                              //       decoration: BoxDecoration(
                              //         color: const Color(0xffEFE6FD) ,
                              //         borderRadius: BorderRadius.circular(30),
                              //       ),
                              //       child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //         children: [
                              //           Text(infoList[index].title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
                              //           Icon(expandedIndex == index  ? Ic),
                              //
                              //         ],
                              //       ),
                              //     )
                              // ),
                              ExpansionTile(
                                // backgroundColor:const Color(0xffEFE6FD) ,
                                title: Text(infoList[index].title),

                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Html(data: infoList[index].content),
                                  ),
                                ],
                              ),
                        ),
                    ],
                  ),

                  /// PHOTOS TAB
                  GridView.builder(
                    itemCount: photos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
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
                  videos.isEmpty
                      ? Image.asset(AssetImages.no_search_found)
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),

                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            //final video = videos[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VideoShowingScreen(
                                      name: widget.diseaseName,
                                      videos: videos,
                                      // diseaseId: widget.diseaseId,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //thumbnail image
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(30),
                                                ),
                                            child: Image.network(
                                              videos[index].thumbnail_image,
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Container(
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.5,
                                              ),
                                              shape: BoxShape.circle,
                                            ),

                                            child: Center(
                                              child: SvgPicture.asset(
                                                AssetImages.video_pause_icon,
                                                height: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //title
                                      Padding(
                                        padding: EdgeInsets.all(30),
                                        child: Text(
                                          videos[index].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            // Card(
                            //   child: ListTile(
                            //     leading: Image.network(
                            //       videos[index].thumbnail_image,width: 80,fit: BoxFit.cover,
                            //     ),
                            //     title: Text(videos[index].name),
                            //     subtitle: Text(
                            //       videos[index].description,
                            //     ),
                            //
                            //   ),
                            // );
                          },
                        ),
                ],
              ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorUtils.selectedColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotesScreen(
                  diseaseId: widget.diseaseId,
                  image: photos.isNotEmpty ? photos.first.image : "",
                ),
              ),
            );
          },
          child: SvgPicture.asset(AssetImages.note_icon, color: Colors.white),
        ),
      ),
    );
  }
}
