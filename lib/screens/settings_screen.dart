import 'package:discese_dictionary/databasehelper/app_preference.dart';
import 'package:discese_dictionary/databasehelper/font_helper.dart';
import 'package:discese_dictionary/screens/themes_color.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../main.dart';
import '../sharedwidgtes/disclamier_contents.dart';
import 'font_style_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkTheme = false;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  void loadTheme() {
    isDarkTheme = AppPreference.getTheme();
    setState(() {});
  }

  SvgPicture? getEmoji(int ratingsEmoji) {
    switch (ratingsEmoji) {
      case 1:
        return SvgPicture.asset(AssetImages.one_star);
      case 2:
        return SvgPicture.asset(AssetImages.two_star);
      case 3:
        return SvgPicture.asset(AssetImages.three_star);
      case 4:
        return SvgPicture.asset(AssetImages.four_star);
      case 5:
        return SvgPicture.asset(AssetImages.five_star);
      default:
        return SvgPicture.asset(AssetImages.three_star);
    }
  }

  void showRateDialog() {
    int rating = 0;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.yellow.shade200,
                          child: getEmoji(rating),
                        ),

                        SizedBox(height: 15),

                        AppText(
                          text: 'Thanks!',
                          style: appTextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 15),

                        AppText(
                          text:
                              'we will work harder to make you more satisfied',
                          style: appTextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    //stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (stars) => IconButton(
                          onPressed: () {
                            setDialogState(() {
                              rating = stars + 1;
                            });
                          },
                          icon: Icon(
                            Icons.star,
                            color: stars < rating ? Colors.amber : Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPressed
                            ? ColorUtils.selectedColor
                            : Theme.of(context).scaffoldBackgroundColor,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          isPressed = true;
                        });
                        Navigator.pop(context);
                      },
                      child: AppText(
                        text: rating >= 2 ? "Feedback" : "Rate Us",
                        style: appTextStyle(
                          color: isPressed
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: AppText(
                        text: 'No , Thanks!',
                        style: appTextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            //title
            Container(
              padding: EdgeInsets.only(top: 60, left: 10),
              height: 120,
              width: double.infinity,
              color: ColorUtils.selectedColor,
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            //Lists of settings
            Expanded(
              child: ListView(
                children: [
                  //1st widget
                  ListTile(
                    leading: Icon(Icons.coffee_outlined),
                    title: Text('Themes Color'),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ThemesColor()),
                      );

                      setState(() {});
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),

                  ///2nd Widget
                  ListTile(
                    leading: Icon(Icons.dark_mode),
                    title: Text("Dark mode"),

                    //onTap: () {},
                    trailing: Switch(
                      value: isDarkTheme,
                      onChanged: (value) async {
                        setState(() {
                          isDarkTheme = value;
                        });

                        await AppPreference.setTheme(value);

                        themeCtrl.sink.add(value);
                      },
                    ),
                  ),

                  //3rd widget
                  ListTile(
                    leading: Icon(Icons.font_download_off_rounded),
                    title: Text('FontStyle'),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FontStyleScreen()),
                      );
                      setState(() {});
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),

                  //4th widget
                  ListTile(
                    leading: Icon(Icons.lock_reset),
                    title: Text('Reset'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(),
                                AppText(
                                  text: 'Reset',
                                  style: appTextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                                    // AppPreference.getTheme()
                                    //     ? Colors.white
                                    //     : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ],
                            ),

                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppText(
                                  text:
                                      'Are you sure you want to rest all your settings?',
                                  style: appTextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppPreference.getTheme()
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),

                                SizedBox(height: 20),

                                Row(
                                  //mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(color: Colors.black),
                                        color: Color(0xffF5F5F5),
                                      ),
                                      child: SvgPicture.asset(
                                        AssetImages.fontstyle_reset,
                                        color: Colors.black,
                                        height: 5,
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(color: Colors.black),
                                        color: Color(0xffF5F5F5),
                                      ),
                                      child: SvgPicture.asset(
                                        AssetImages.theme_reset,
                                        color: Colors.black,
                                        height: 5,
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(color: Colors.black),
                                        color: Color(0xffF5F5F5),
                                      ),
                                      child: SvgPicture.asset(
                                        AssetImages.darkmode_reset,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).scaffoldBackgroundColor,
                                    // AppPreference.getTheme()
                                    //     ? Colors.black
                                    //     : ColorUtils.selectedColor,
                                  ),
                                  onPressed: () async {
                                    if (AppPreference.getTheme()) {
                                      await AppPreference.setTheme(false);
                                      themeCtrl.sink.add(false);
                                    }

                                    setState(() {
                                      isDarkTheme = false;
                                    });
                                    Navigator.pop(context, isDarkTheme);
                                  },
                                  child: AppText(
                                    text: 'Reset Settings',
                                    style: appTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),

                  //5th widget
                  ListTile(
                    leading: Icon(Icons.access_alarm),
                    title: Text('About us'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DisclamierscreenContents(),
                        ),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),

                  //6th widget
                  ListTile(
                    leading: Icon(Icons.privacy_tip_sharp),
                    title: Text('Privacy & Policy'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DisclamierscreenContents(),
                        ),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),

                  //7th widget
                  ListTile(
                    leading: Icon(Icons.dangerous_outlined),
                    title: Text('Disclaimer'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DisclamierscreenContents(),
                        ),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),

                  //8th widget
                  ListTile(
                    leading: Icon(Icons.rate_review_outlined),
                    title: Text('Rate Us'),
                    onTap: () {
                      showRateDialog();
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
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
