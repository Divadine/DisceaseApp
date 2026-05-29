import 'dart:async';

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
        isLoading = false;
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

    List<Triviamodel> currentThreeTrivia = [];
    if (triviaList.isNotEmpty) {
      currentThreeTrivia = List.generate(
        1,
        (index) => triviaList[(currentBatchIndex + index) % triviaList.length],
      );
    }

    return Scaffold(
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

        backgroundColor: ColorUtils.primary,
        centerTitle: true,
        title: Text(
          "Disease Dictionary",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          /// BACKGROUND CONTENT
          Column(
            children: [
              // slider
              triviaList.isEmpty
                  ? Center(child: Text("No data"))
                  : Mainscreenslider(triviaList: triviaList.take(3).toList()),

              SizedBox(height: 10),

              // categories title
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                        child: Text(
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
                          return AlphabetOrderDiseaseList(
                            diseaseNameAlphabet:
                                disceaseList[index].disceaseName ?? "",
                            diseaseId: disceaseList[index].id,
                            catId: disceaseList[index].cat_id,
                          );
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

      // body: isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     : Column(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     //slider
      //     triviaList.isEmpty
      //         ? Center(child: Text("No data"))
      //         : Mainscreenslider(triviaList: triviaList.take(3).toList()),
      //
      //     // print(currentThreeTrivia);
      //     SizedBox(height: 10),
      //
      //     //categories and viewAll text
      //     Padding(
      //       padding: const EdgeInsets.only(left: 20.0, right: 20),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text(
      //             "Categories",
      //             style: TextStyle(
      //               fontWeight: FontWeight.bold,
      //               fontSize: 20,
      //             ),
      //           ),
      //
      //           //viewAll
      //           TextButton(
      //             onPressed: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (_) =>
      //                       ViewallcategoryScreen(
      //                         categoryList: categoryList,
      //                       ),
      //                 ),
      //               );
      //             },
      //             child: Text(
      //               "view all",
      //               style: TextStyle(fontSize: 15, color: Colors.black),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //
      //     SizedBox(height: 20),
      //
      //     //category Lists Ui
      //     categoryList.isEmpty
      //         ? Center(child: Text(" no data"))
      //         : SingleChildScrollView(
      //       scrollDirection: Axis.horizontal,
      //
      //       child: Row(
      //         children: List.generate(
      //           categoryList.length > 10 ? 10 : categoryList.length,
      //               (index) =>
      //               Padding(
      //                 padding: EdgeInsets.all(10),
      //                 child: DisceaseCategories(
      //                   category: categoryList[index],
      //                   bgColor: bgColor[index % bgColor.length],
      //                 ),
      //               ),
      //         ),
      //       ),
      //     ),
      //
      //     SizedBox(height: 40),
      //
      //     //Disease List alphabetically title a-z
      //     Expanded(
      //       child: DraggableScrollableSheet(
      //         initialChildSize: 0.45,
      //         minChildSize: 0.45,
      //         maxChildSize: 1.0,
      //         expand: true,
      //         builder: (context, scrollController) {
      //           return Container(
      //             decoration: const BoxDecoration(
      //               color: Colors.transparent,
      //               // borderRadius: BorderRadius.only(
      //               //   topLeft: Radius.circular(),
      //               //   topRight: Radius.circular(25),
      //               // ),
      //             ),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //
      //                 /// drag handle
      //                 // Center(
      //                 //   child: Padding(
      //                 //     padding: const EdgeInsets.only(top: 10),
      //                 //     child: Container(
      //                 //       width: 50,
      //                 //       height: 5,
      //                 //       decoration: BoxDecoration(
      //                 //         color: Colors.grey,
      //                 //         borderRadius: BorderRadius.circular(10),
      //                 //       ),
      //                 //     ),
      //                 //   ),
      //                 // ),
      //                 const SizedBox(height: 20),
      //                 Padding(
      //                   padding: EdgeInsets.only(left: 20),
      //                   child: Align(
      //                     alignment: Alignment.topLeft,
      //                     child: Text(
      //                       "Diseases A-Z",
      //                       style: TextStyle(
      //                         fontWeight: FontWeight.bold,
      //                         fontSize: 20,
      //                         color: Colors.black,
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //
      //                 //Alpahbetic diseace list
      //                 Expanded(
      //                   child: disceaseList.isEmpty
      //                       ? Center(child: CircularProgressIndicator())
      //                       : ListView.builder(
      //                     controller: scrollController,
      //                     // shrinkWrap: true,
      //                     // physics: const NeverScrollableScrollPhysics(),
      //                     itemCount: disceaseList.length,
      //                     itemBuilder: (context, index) {
      //                       return AlphabetOrderDiseaseList(
      //                         diseaseNameAlphabet:
      //                         disceaseList[index]
      //                             .disceaseName ??
      //                             "",
      //                         diseaseId: disceaseList[index].id,
      //                         catId: disceaseList[index].cat_id,
      //                       );
      //                     },
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
