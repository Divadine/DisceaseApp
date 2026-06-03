// import 'package:discese_dictionary/databasehelper/app_preference.dart';
// import 'package:discese_dictionary/databasehelper/font_helper.dart';
// import 'package:discese_dictionary/utils/app_utils.dart';
// import 'package:flutter/material.dart';
//
// import '../models/disease_details.dart';
//
// class ImageViewer extends StatefulWidget {
//   //final String diseaseName;
//   final List<PhotoModel> photos;
//
//   const ImageViewer({super.key, required this.photos});
//
//   @override
//   State<ImageViewer> createState() => _ImageViewerState();
// }
//
// class _ImageViewerState extends State<ImageViewer> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppPreference.getTheme()
//             ? Theme.of(context).scaffoldBackgroundColor
//             : ColorUtils.selectedColor,
//         title: AppText(
//           text: photos.name,
//           style: appTextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//             color: Theme.of(context).textTheme.bodyLarge?.color,
//           ),
//         ),
//       ),
//
//       body: Container(),
//     );
//   }
// }
