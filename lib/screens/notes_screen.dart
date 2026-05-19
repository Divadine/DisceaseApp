import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';

import 'notes_list_screen.dart';


class NotesScreen extends StatefulWidget{

  final int diseaseId;
  final String image;


  const NotesScreen({super.key, required this.diseaseId, required this.image, });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}


class _NotesScreenState extends State<NotesScreen>{

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool isSaved = false;
  bool isCancel = false;
  bool isFill = false;

  Future saveNotes() async {
    await DbHelper.instance.insertNotes(diseaseId: widget.diseaseId, title: titleController.text, content: contentController.text, image: widget.image ?? "");

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        title: Text('Notes',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold,),),
        centerTitle: true,
        backgroundColor: ColorUtils.selectedColor,
      ),

      body:Padding(
          padding: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              maxLines: 1,
              maxLength: 30,

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText:" Add title",

              ),
            ),

            SizedBox(height: 20,),

            TextField(
              controller: contentController,
              maxLines: 6,
              maxLength: 250,
              decoration: const InputDecoration(

                hintText:"Text here...",

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
                    onPressed: (){
                      Navigator.pop(context);
                      // setState(() {
                      //   isCancel=!isCancel;
                      // });
                    },
                    child: Text('cancel',style: TextStyle(color: isCancel  ? ColorUtils.selectedColor: Color(0xff828282)),)
                ),

                //save button
                ElevatedButton(

                    onPressed: () async {

                      setState(()  {
                        isSaved=!isSaved;
                      });
                      await saveNotes();

                      Navigator.push(context, MaterialPageRoute(builder: (_) => NotesListScreen(diseaseId: widget.diseaseId,image: widget.image,)));
                    },
                    child: Text('save',style: TextStyle(color: isSaved ? ColorUtils.selectedColor : Color(0xff828282) ),)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}