import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';

import '../databasehelper/app_preference.dart';
import '../databasehelper/font_helper.dart';
import 'notes_list_screen.dart';

class NotesScreen extends StatefulWidget {
  final int diseaseId;
  final String image;

  const NotesScreen({super.key, required this.diseaseId, required this.image});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool isSaved = false;
  bool isCancel = false;
  bool isFill = false;

  Future saveNotes() async {
    await DbHelper.instance.insertNotes(
      diseaseId: widget.diseaseId,
      title: titleController.text,
      content: contentController.text,
      image: widget.image ?? "",
    );

    Navigator.pop(context, true);
  }

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
          'Notes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppPreference.getTheme()
            ? Theme.of(context).scaffoldBackgroundColor
            : ColorUtils.selectedColor,
      ),

      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              maxLines: 1,
              maxLength: 30,

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: " Add title",
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: contentController,
              maxLines: 6,
              maxLength: 250,
              decoration: const InputDecoration(
                hintText: "Text here...",

                border: OutlineInputBorder(),
              ),
            ),

            //SizedBox(height: 30,),

            //buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //cancel button
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          title: AppText(
                            text: 'Remove Bookmark',
                            style: appTextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: AppText(
                            text: 'Are you sure want to unsave this Note',
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: AppText(
                                text: 'Cancel',
                                style: appTextStyle(
                                  color: ColorUtils.selectedColor,
                                ),
                              ),
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorUtils.selectedColor,
                              ),
                              onPressed: () async {
                                DbHelper.instance.deleteBookmarks(
                                  widget.diseaseId,
                                );

                                Navigator.pop(context);

                                setState(() {});
                              },
                              child: AppText(
                                text: 'Remove',
                                style: appTextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    Navigator.pop(context);
                    // setState(() {
                    //   isCancel=!isCancel;
                    // });
                  },
                  child: Text(
                    'cancel',
                    style: TextStyle(
                      color: isCancel
                          ? ColorUtils.selectedColor
                          : Color(0xff828282),
                    ),
                  ),
                ),

                //save button
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isSaved = !isSaved;
                    });
                    await saveNotes();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotesListScreen(
                          diseaseId: widget.diseaseId,
                          image: widget.image,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'save',
                    style: TextStyle(
                      color: isSaved
                          ? ColorUtils.selectedColor
                          : Color(0xff828282),
                    ),
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
