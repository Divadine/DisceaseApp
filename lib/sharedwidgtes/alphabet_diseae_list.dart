import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/databasehelper/font_helper.dart';
import 'package:discese_dictionary/screens/diseasedetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/notes_list_screen.dart';
import '../utils/imagesutils.dart';

class AlphabetOrderDiseaseList extends StatefulWidget {
  final String diseaseNameAlphabet;
  final int diseaseId;
  final int catId;

  const AlphabetOrderDiseaseList({
    super.key,
    required this.diseaseNameAlphabet,
    required this.diseaseId,
    required this.catId,
  });

  @override
  State<AlphabetOrderDiseaseList> createState() =>
      _AlphabetOrderDiseaseListState();
}

class _AlphabetOrderDiseaseListState extends State<AlphabetOrderDiseaseList> {
  bool hasNotes = false;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    checkNotes();
    checkBookmark();
  }

  Future checkBookmark() async {
    final result = await DbHelper.instance.checkBookmarksExists(
      widget.diseaseId,
    );
    setState(() {
      isBookmarked = result;
    });
  }

  Future checkNotes() async {
    final result = await DbHelper.instance.checkNotesExist(widget.diseaseId);
    setState(() {
      hasNotes = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiseaseDetailsScreen(
              catId: widget.catId,
              diseaseName: widget.diseaseNameAlphabet,
              diseaseId: widget.diseaseId,
            ),
          ),
        );
        await checkBookmark();
        await checkNotes();
      },
      child: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffFFFFFF),
              ),

              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child:
                          // AppText(
                          //   text: widget.diseaseNameAlphabet,
                          //   maxLines: 1,
                          //   textOverflow: TextOverflow.ellipsis,
                          //   style: appTextStyle(
                          //     color: Colors.black,
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 16,
                          //   ),
                          // ),
                          // AppFonts.getFont(
                          //   AppPreference.getFontChange() ?? 'Inter',
                          // ).copyWith(
                          //   color: Colors.black,
                          //   fontWeight: FontWeight.bold,
                          //   fontSize: 16,
                          // ),
                          Text(
                            widget.diseaseNameAlphabet,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                    ),
                    SizedBox(width: 200),

                    if (hasNotes)
                      IconButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NotesListScreen(
                                diseaseId: widget.diseaseId,
                                image: '',
                              ),
                            ),
                          );
                          await checkNotes();
                          await checkBookmark();
                        },
                        icon: SvgPicture.asset(
                          AssetImages.note_icon,
                          color: Colors.black,
                        ),
                      ),

                    // bookmark
                    IconButton(
                      onPressed: () async {
                        if (isBookmarked) {
                          await DbHelper.instance.deleteBookmarks(
                            widget.diseaseId,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: AppText(text: " Bookmark is removed"),
                              //Text(" Bookmark is removed"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          await DbHelper.instance.insertBookmarks(
                            diseaseId: widget.diseaseId,
                            diseaseName: widget.diseaseNameAlphabet,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bookmark saved successfully'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }

                        final result = await DbHelper.instance
                            .checkBookmarksExists(widget.diseaseId);
                        setState(() {
                          isBookmarked = result;
                        });
                      },
                      icon: SvgPicture.asset(
                        isBookmarked
                            ? AssetImages.note_icon_shaded
                            : AssetImages.bookmark_outline_bottom,
                        color: isBookmarked ? null : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
