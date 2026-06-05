import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/databasehelper/network_helper.dart';
import 'package:discese_dictionary/sharedwidgtes/nointernet.dart';
import 'package:flutter/material.dart';

import '../databasehelper/app_preference.dart';
import '../utils/app_utils.dart';

class EditNoteScreen extends StatefulWidget {
  final Map<String, dynamic> noteData;

  const EditNoteScreen({super.key, required this.noteData});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  bool hasInternet = true;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.noteData['title']);
    contentController = TextEditingController(text: widget.noteData['content']);
  }

  Future<void> updateNote() async {
    final hasInternet = await NetworkHelper.checkConnection(context);
    if (!hasInternet) {
      setState(() {
        return;
      });
    }
    await DbHelper.instance.updateNotes(
      id: widget.noteData['id'],
      title: titleController.text,
      content: contentController.text,
    );

    Navigator.pop(context);
  }

  Future<void> deleteNote() async {
    final hasInternet = await NetworkHelper.checkConnection(context);
    if (!hasInternet) {
      setState(() {
        return;
      });
    }
    await DbHelper.instance.deleteNotes(widget.noteData['id']);
    Navigator.pop(context);
  }

  void showDeleteDialogBox() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Are you sure'),
          content: const Text(' Want to delete'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                deleteNote();
                Navigator.pop(context);
              },
              child: Text('confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext conetext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPreference.getTheme()
            ? Theme.of(context).scaffoldBackgroundColor
            : ColorUtils.selectedColor,
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
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDeleteDialogBox();
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),

      body: !hasInternet
          ? NoInternet(
              onTap: () {
                updateNote();
                deleteNote();
                titleController = TextEditingController(
                  text: widget.noteData['title'],
                );
                contentController = TextEditingController(
                  text: widget.noteData['content'],
                );
              },
            )
          : Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                children: [
                  TextField(controller: titleController),
                  const SizedBox(height: 20),
                  TextField(controller: contentController, maxLines: 2),

                  const Spacer(),

                  ElevatedButton(
                    onPressed: updateNote,
                    child: Text('Save changes'),
                  ),
                ],
              ),
            ),
    );
  }
}
