import 'package:discese_dictionary/databasehelper/app_preference.dart';
import 'package:discese_dictionary/screens/themes_color.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  void loadTheme() {
    isDarkTheme = AppPreference.getTheme();
    setState(() {});
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
                    onTap: () {},
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
