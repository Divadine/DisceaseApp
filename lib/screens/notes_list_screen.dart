import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'edit_note_screen.dart';
import 'notes_screen.dart';



class NotesListScreen extends StatefulWidget {

  final int diseaseId;
  final String image;



  const NotesListScreen({super.key, required this.diseaseId,  required this.image});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();

}

class _NotesListScreenState extends State<NotesListScreen> {


  List<Map<String, dynamic>> notes = [];

  @override
  void initState(){
    super.initState();
    loadNotes();
  }

  void loadNotes() async {

    final result = await DbHelper.instance.getNotes(widget.diseaseId);

    setState(() {
      notes = result;
    });

  }



  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        title: Text("Notes" , style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        backgroundColor: ColorUtils.selectedColor,

      ),


      body: notes.isEmpty ? Center(child: Text(" No Notes"),) : ListView.builder(
        itemCount: notes.length,
          itemBuilder: (context, index){
          return Card(
            child: ListTile(
              leading:
              Image.network(notes[index]['image'] ?? "",width: 60,fit: BoxFit.cover,),
              title: Text(notes[index]['title'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
              subtitle: Text(notes[index]['content'],maxLines: 2,overflow: TextOverflow.ellipsis,),

              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => EditNoteScreen(noteData : notes[index]))).then((_) {loadNotes();});
              },

            ),
          );
          }
      ),

      //add notes button

      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(ColorUtils.selectedColor)),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => NotesScreen(diseaseId: widget.diseaseId, image:widget.image,))).then((_) {
            loadNotes();
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            SvgPicture.asset(AssetImages.add_notes,color: Colors.white,),
            Text('Add Notes', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18),)
          ],
        )
      ),
        
        
        
    );
  }
}