import 'package:discese_dictionary/sharedwidgtes/categorycard_viewall.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';

import '../models/triviamodel.dart';

class ViewallcategoryScreen extends StatelessWidget {
  final List<CategoryModel> categoryList;

  const ViewallcategoryScreen({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: Text(
          "Categories",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorUtils.selectedColor,
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: categoryList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 40,
            mainAxisSpacing: 50,
          ),
          itemBuilder: (context, index) {
            return CategorycardViewall(categorynames: categoryList[index]);
          },
        ),
      ),
    );
  }
}
