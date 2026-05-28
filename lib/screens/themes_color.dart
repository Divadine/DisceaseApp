import 'package:discese_dictionary/main.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';

class ThemesColor extends StatefulWidget {
  const ThemesColor({super.key});

  @override
  State<ThemesColor> createState() => _ThemesColorState();
}

class _ThemesColorState extends State<ThemesColor> {
  bool isSelected = false;
  int selectedIndex = -1;

  final List colorsTheme = [
    0xff6200EE,
    0xff00C6EE,
    0xff007C0F,
    0xffB00D9A,
    0xffEEB700,
    0xffEE0000,
    0xff84BE11,
    0xffFF9D00,
    0xff850016,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.selectedColor,
        title: Text(
          "Themes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: GridView.builder(
                  itemCount: colorsTheme.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.8,
                  ),
                  itemBuilder: (context, index) {
                    bool isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        print("Theme Selected iiiiii");

                        setState(() {
                          selectedIndex = index;
                        });
                        print("Theme Selected");
                        themeCtrl.sink.add(true);
                        setState(() {});
                      },
                      child: Container(
                        // height: 0,
                        // width: 80,
                        decoration: BoxDecoration(
                          color: Color(colorsTheme[index]),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: isSelected
                            ? Center(
                                child: Icon(Icons.check, color: Colors.white),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("Theme Selected kkkkkkk");

                      if (selectedIndex != -1) {
                        setState(() {
                          ColorUtils.selectedColor = Color(
                            colorsTheme[selectedIndex],
                          );
                        });

                        themeCtrl.sink.add(true);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text('apply'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
