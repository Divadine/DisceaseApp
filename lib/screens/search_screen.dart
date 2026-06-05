import 'package:discese_dictionary/api/apiservice.dart';
import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/databasehelper/font_helper.dart';
import 'package:discese_dictionary/databasehelper/network_helper.dart';
import 'package:discese_dictionary/models/disease_details.dart';
import 'package:discese_dictionary/screens/video_showing_screen.dart';
import 'package:discese_dictionary/sharedwidgtes/nointernet.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../databasehelper/app_preference.dart';
import '../models/triviamodel.dart';
import 'diseasedetail_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<CategoryModel> category;
  final List<DisceaseList> diseaseList;

  SearchScreen({super.key, required this.category, required this.diseaseList});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  bool isFound = false;
  bool isLoading = true;
  bool hasSearchedVideo = false;
  bool isFilterApplied = false;

  List<DisceaseList> allDiseases = [];
  List<DisceaseList> filteredDiseases = [];
  List<VideoModel> filteredVideos = [];
  bool hasInternet = true;

  List<CategoryModel> filteredCategory = [];
  List<CategoryModel> selectedCategory = [];

  List<DisceaseList> filteredDisease = [];

  @override
  void initState() {
    super.initState();
    filteredCategory = widget.category;
    getAllDiseasesList();
    getAllCategory();
  }

  void showBottomModalSheetFilters(BuildContext context) {
    //List<CategoryModel> tempCategory = selectedCategory;
    List<CategoryModel> tempCategory = List.from(selectedCategory);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const SizedBox(),
                      const Text(
                        "Filter",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },

                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: filteredCategory.map((cat) {
                      bool isSelected =
                          tempCategory.indexWhere(
                            (category) => cat.id == category.id,
                          ) >
                          -1;

                      return ChoiceChip(
                        label: Text(cat.name),
                        selected: isSelected,
                        onSelected: (value) {
                          setBottomState(() {
                            if (value) {
                              tempCategory.add(cat);
                            } else {
                              tempCategory.remove(cat);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        onPressed: () {
                          // tempCategory.clear();
                          // selectedCategory.clear();
                          // setState(() {});
                          setBottomState(() {
                            tempCategory.clear();
                            isFilterApplied = false;
                          });

                          // setState(() {
                          //   selectedCategory.clear();
                          //   filteredDiseases = allDiseases;
                          //   filteredDiseases.clear();
                          //   isFilterApplied = false;
                          // });

                          setState(() {
                            selectedCategory.clear();
                            filteredDiseases.clear();
                            searchController.clear();
                            isFilterApplied = false;
                          });
                        },
                        child: AppText(
                          text: 'Reset',
                          style: appTextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppPreference.getTheme()
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPreference.getTheme()
                              ? Colors.black
                              : ColorUtils.selectedColor,
                        ),
                        onPressed: () async {
                          selectedCategory = List.from(tempCategory);
                          isFilterApplied = selectedCategory.isNotEmpty;
                          // var filDisease = allDiseases.where((disease) {
                          //   return selectedCategory.any(
                          //     (cat) => cat.id == disease.cat_id,
                          //   );
                          // }).toList();

                          // await filterDisease(
                          //   searchController.text.trim().toLowerCase(),
                          // );
                          //if (!context.mounted) return;
                          setState(() {
                            isFilterApplied = true;
                          });

                          Navigator.pop(context);
                        },
                        child: AppText(
                          text: 'Apply',
                          style: appTextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> getAllCategory() async {
    filteredCategory = await DbHelper.instance.getCategoryFromDbclient();
    setState(() {});
  }

  Future<void> getAllDiseasesList() async {
    hasInternet = await NetworkHelper.checkConnection(context);
    if (!hasInternet) {
      setState(() {});
    }
    try {
      final data = await DbHelper.instance.getDiseaseListFromDbclient();

      setState(() {
        allDiseases = data;
        //filteredDiseases = data;
        isLoading = false;
      });
    } catch (e) {
      throw Exception(' $e no data found');
    }
  }

  Future<void> filterDisease(String value) async {
    final catIdList = selectedCategory.map((cat) => cat.id).toList();
    final results = allDiseases.where((disease) {
      final diseaseName = disease.disceaseName?.toLowerCase() ?? '';

      if (catIdList.isEmpty) {
        return diseaseName.contains(value.toLowerCase());
      } else {
        return diseaseName.contains(value.toLowerCase()) &&
            catIdList.contains(disease.cat_id);
      }
    }).toList();

    setState(() {
      //filteredCategory = results.cast<CategoryModel>();
      filteredDiseases = results;
    });
  }

  Future<void> searchVideos(String value) async {
    if (value.trim().isEmpty) {
      setState(() {
        filteredVideos = [];
      });
      return;
    }

    final videos = await ApiService().searchVideos(value);

    setState(() {
      hasSearchedVideo = true;
      filteredVideos = videos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          backgroundColor: AppPreference.getTheme()
              ? Theme.of(context).scaffoldBackgroundColor
              : ColorUtils.selectedColor,
          centerTitle: true,
          title: Text(
            'Search',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          bottom: TabBar(
            tabs: [
              Tab(text: 'Diseases'),
              Tab(text: 'Videos'),
            ],
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.white,
            indicatorWeight: 7,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),

        body: !hasInternet
            ? NoInternet(
                onTap: () {
                  getAllDiseasesList();
                },
              )
            : TabBarView(
                children: [
                  //diseases search
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: TextField(
                          onChanged: (value) {
                            filterDisease(value);
                            searchVideos(value);
                          },

                          controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 20,
                              ),
                              child: SvgPicture.asset(
                                AssetImages.search_icon_for_searchscreen,
                                height: 10,
                              ), // _myIcon is a 48px-wide widget.
                            ),

                            border: OutlineInputBorder(),

                            hintText: 'Search here...',

                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    AssetImages.microphone_in_search,
                                    height: 30,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    showBottomModalSheetFilters(context);
                                  },
                                  icon: isFilterApplied
                                      ? SvgPicture.asset(
                                          AssetImages.filter_in_search,
                                          color: ColorUtils.selectedColor,
                                          height: 30,
                                        )
                                      : SvgPicture.asset(
                                          AssetImages.filter_in_search,
                                          height: 30,
                                        ),

                                  // colorFilter: ColorFilter.mode(
                                  //   isFilterApplied
                                  //       ? Colors.deepPurple
                                  //       : Colors.grey,
                                  //   BlendMode.srcIn,
                                  // ),
                                  //height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      Expanded(
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : filteredDiseases.isEmpty
                            ? Center(
                                child: Image.asset(
                                  AssetImages.search_for_disease,
                                  height: 200,
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredDiseases.length,

                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DiseaseDetailsScreen(
                                            catId:
                                                filteredDiseases[index]
                                                    .cat_id ??
                                                0,
                                            diseaseName:
                                                filteredDiseases[index]
                                                    .disceaseName ??
                                                '',
                                            diseaseId:
                                                filteredDiseases[index].id,
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                  filteredDiseases[index]
                                                          .disceaseName ??
                                                      '',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                      ),
                    ],
                  ),

                  //videos
                  //Container(child: Image.asset(AssetImages.no_search_found)),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: TextField(
                          onChanged: (value) {
                            filterDisease(value);
                            searchVideos(value);
                          },

                          controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 20,
                              ),
                              child: SvgPicture.asset(
                                AssetImages.search_icon_for_searchscreen,
                                height: 10,
                              ), // _myIcon is a 48px-wide widget.
                            ),

                            border: OutlineInputBorder(),

                            hintText: 'Search here...',

                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    AssetImages.microphone_in_search,
                                    height: 30,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    AssetImages.filter_in_search,
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      Expanded(
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : !hasSearchedVideo
                            ? Center(
                                child: Image.asset(
                                  AssetImages.search_for_disease,
                                ),
                              )
                            : filteredVideos.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      AssetImages.no_search_found,
                                      height: 200,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  AppText(
                                    text: 'No search Found !  Please Try Again',
                                    style: appTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1,
                                    ),
                                itemCount: filteredVideos.length,

                                itemBuilder: (context, index) {
                                  final video = filteredVideos[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => VideoShowingScreen(
                                            name: video.name,
                                            videos: filteredVideos,
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.4,
                                              ),
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
                                                        topLeft:
                                                            Radius.circular(30),
                                                        topRight:
                                                            Radius.circular(30),
                                                      ),
                                                  child: Image.network(
                                                    video.thumbnail_image,
                                                    height: 200,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Container(
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    shape: BoxShape.circle,
                                                  ),

                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      AssetImages
                                                          .video_pause_icon,
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
                                                video.name,
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
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
