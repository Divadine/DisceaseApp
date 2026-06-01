import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../databasehelper/app_preference.dart';
import '../models/triviamodel.dart';
import 'diseasedetail_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  bool isFound = false;
  bool isLoading = true;

  List<DisceaseList> allDiseases = [];
  List<DisceaseList> filteredDiseases = [];

  Future<void> getAllDiseasesList() async {
    try {
      final data = await DbHelper.instance.getDiseaseListFromDbclient();

      setState(() {
        allDiseases = data;

        isLoading = false;
      });
    } catch (e) {
      throw Exception(' $e no data found');
    }
  }

  Future<void> filterDisease(String value) async {
    // if(value.isEmpty){
    //
    //   setState(() {
    //     filteredDiseases = [];
    //   });
    //
    //   return;
    // }
    final results = allDiseases.where((disease) {
      final diseaseName = disease.disceaseName?.toLowerCase() ?? '';

      return diseaseName.contains(value.toLowerCase());
    }).toList();

    setState(() {
      filteredDiseases = results;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllDiseasesList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
          ),
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

        body: TabBarView(
          children: [
            //diseases search
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: TextField(
                    onChanged: (value) {
                      filterDisease(value);
                    },

                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20),
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
                                          filteredDiseases[index].cat_id ?? 0,
                                      diseaseName:
                                          filteredDiseases[index]
                                              .disceaseName ??
                                          '',
                                      diseaseId: filteredDiseases[index].id,
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
                                            filteredDiseases[index]
                                                    .disceaseName ??
                                                '',
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
                ),
              ],
            ),

            //videos
            Container(child: Image.asset(AssetImages.no_search_found)),
          ],
        ),

        //bottom
        // bottomNavigationBar: SafeArea(
        //   child: CustomBottomNavigationBar(
        //       currentIndex: selectedIndex,
        //       onTap:(index){
        //         setState(() {
        //           selectedIndex = index;
        //         });
        //       }
        //
        //   ),
        // ),
      ),
    );
  }
}
