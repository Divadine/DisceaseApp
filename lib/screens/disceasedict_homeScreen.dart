import 'dart:async';

import 'package:discese_dictionary/databasehelper/app_preference.dart';
import 'package:discese_dictionary/databasehelper/font_helper.dart';
import 'package:discese_dictionary/screens/settings_screen.dart';
import 'package:discese_dictionary/screens/viewallcategory_screen.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';

import '../api/apiservice.dart';
import '../databasehelper/db_helper.dart';
import '../models/triviamodel.dart';
import '../sharedwidgtes/alphabet_diseae_list.dart';
import '../sharedwidgtes/discease_categories.dart';
import '../sharedwidgtes/mainscreenslider.dart';

class DisceaseDictionary extends StatefulWidget {
  const DisceaseDictionary({super.key});

  @override
  State<DisceaseDictionary> createState() => _DisceaseDictionaryState();
}

class _DisceaseDictionaryState extends State<DisceaseDictionary> {
  int currentBatchIndex = 0;
  int selectedIndex = 0;
  bool isLoading = true;
  List<Triviamodel> triviaList = [];
  List<CategoryModel> categoryList = [];
  List<DisceaseList> disceaseList = [];
  int currentTriviaIndex = 0;
  Timer? triviaTimer;

  @override
  void initState() {
    super.initState();

    fetchSaveAndLoadData();
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
    } catch (e) {
      print("Error: $e");

      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  void dispose() {
    triviaTimer?.cancel();
    super.dispose();
  }

  List<Color> bgColor = [
    Color(0xff8CC6FF),
    Color(0xffFDFF8C),
    Color(0xff8CE4FF),
    Color(0xffFFC98C),
    Color(0xffFF8C8C),
  ];

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).scaffoldBackgroundColor;

    //disease sorting for A,B,C headers
    disceaseList.sort(
      (a, b) => (a.disceaseName ?? '').compareTo(b.disceaseName ?? ''),
    );

    List<Triviamodel> currentThreeTrivia = [];
    if (triviaList.isNotEmpty) {
      currentThreeTrivia = List.generate(
        1,
        (index) => triviaList[(currentBatchIndex + index) % triviaList.length],
      );
    }

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            drawer: SettingsScreen(),
            appBar: AppBar(
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },

                    icon: Icon(Icons.menu, color: Colors.white),
                  );
                },
              ),

              backgroundColor: AppPreference.getTheme()
                  ? themeColor
                  : ColorUtils.selectedColor,
              centerTitle: true,
              title: Text(
                "Disease Dictionary",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Stack(
              children: [
                /// BACKGROUND CONTENT
                Column(
                  children: [
                    // slider
                    triviaList.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : Mainscreenslider(
                            triviaList: triviaList.take(3).toList(),
                          ),

                    SizedBox(height: 10),

                    // categories title
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // AppText(
                          //   text: 'Categories',
                          //   style: appTextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 20,
                          //   ),
                          // ),
                          Text(
                            "Categories",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewallcategoryScreen(
                                    categoryList: categoryList,
                                  ),
                                ),
                              );
                            },
                            child: Text("view all"),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // categories list
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          categoryList.length > 10 ? 10 : categoryList.length,
                          (index) => Padding(
                            padding: EdgeInsets.all(10),
                            child: DisceaseCategories(
                              category: categoryList[index],
                              bgColor: bgColor[index % bgColor.length],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                /// DRAGGABLE SHEET
                DraggableScrollableSheet(
                  initialChildSize: 0.45,
                  minChildSize: 0.45,
                  maxChildSize: 1.0,
                  snap: true,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),

                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child:
                                  // AppText(
                                  //   text: 'Diseases A-Z',
                                  //   style: appTextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  Text(
                                    "Diseases A-Z",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                            ),
                          ),

                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: disceaseList.length,
                              itemBuilder: (context, index) {
                                String currentLetter =
                                    (disceaseList[index].disceaseName ?? '')
                                        .substring(0, 1)
                                        .toUpperCase();

                                bool showHeader = true;

                                if (index > 0) {
                                  String previousLetter =
                                      (disceaseList[index - 1].disceaseName ??
                                              '')
                                          .substring(0, 1)
                                          .toUpperCase();

                                  showHeader = currentLetter != previousLetter;
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (showHeader)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15,
                                          left: 20,
                                          bottom: 5,
                                          right: 25,
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,

                                          decoration: BoxDecoration(
                                            color: Color(0xffEFE6FD),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                              right: 10,
                                              top: 15,
                                            ),
                                            child: AppText(
                                              text: currentLetter,
                                              style: appTextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    AlphabetOrderDiseaseList(
                                      diseaseNameAlphabet:
                                          disceaseList[index].disceaseName ??
                                          "",
                                      diseaseId: disceaseList[index].id,
                                      catId: disceaseList[index].cat_id,
                                    ),
                                  ],
                                );

                                // return
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }
}
