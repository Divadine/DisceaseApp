import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/models/disease_details.dart';
import 'package:discese_dictionary/screens/video_showing_screen.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/app_utils.dart';
import 'diseasedetail_screen.dart';
import 'notes_list_screen.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  bool isLoading = true;
  int selectedIndex = 0;

  List<Map<String, dynamic>> bookmarksDisease = [];
  List<Map<String, dynamic>> notes = [];
  List<VideoModel> bookmarksVideos = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
    loadNotes();
    loadVideoBookmarks();
  }

  Future loadNotes() async {
    final result = await DbHelper.instance.getAllNotes();
    setState(() {
      notes = result;
    });
  }

  Future loadBookmarks() async {
    final result = await DbHelper.instance.getBookmarks();
    setState(() {
      bookmarksDisease = result;
    });
  }

  Future loadVideoBookmarks() async {
    final data = await DbHelper.instance.getVideoBookmarks();
    print(data);

    setState(() {
      bookmarksVideos = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Text(
            'Bookmark',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: ColorUtils.selectedColor,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Diseases'),
              Tab(text: 'Videos'),
              Tab(text: 'Notes'),
            ],

            indicatorColor: Colors.white,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 7,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            unselectedLabelColor: Colors.white,
          ),
        ),

        body: TabBarView(
          children: [
            // disease bookmark
            bookmarksDisease.isEmpty
                ? Center(
                    child: Image.asset(AssetImages.disease_bookmark_notfound),
                  )
                : ListView.builder(
                    itemCount: bookmarksDisease.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DiseaseDetailsScreen(
                                catId: 0,
                                diseaseName:
                                    bookmarksDisease[index]['disease_name'],
                                diseaseId:
                                    bookmarksDisease[index]['disease_id'],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffFFFFFF),
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 10,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      bookmarksDisease[index]['disease_name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

            //video Bookmark
            bookmarksVideos.isEmpty
                ? Center(
                    child: Image.asset(AssetImages.video_bookmark_notfound),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: bookmarksVideos.length,
                    itemBuilder: (context, index) {
                      final vid = bookmarksVideos[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VideoShowingScreen(
                                name: 'Bookmark Videos',
                                videos: bookmarksVideos,
                                selectedIndex: index,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //thumbnail image
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                      child: Image.network(
                                        vid.thumbnail_image,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
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
                                    vid.name,
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
                    },
                  ),

            //Notes Bookmark Tab
            notes.isEmpty
                ? Center(
                    child: Image.asset(AssetImages.notes_bookmark_notfound),
                  )
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            notes[index]['image'] ?? "",
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            notes[index]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            notes[index]['content'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    NotesListScreen(diseaseId: 0, image: ''),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

            //NotesListScreen(diseaseId: , image: '',),
          ],
        ),
      ),
    );
  }
}
