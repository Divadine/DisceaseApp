import 'package:dio/dio.dart';
import 'package:discese_dictionary/databasehelper/app_preference.dart';
import 'package:discese_dictionary/databasehelper/font_helper.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../models/disease_details.dart';

class ImageViewer extends StatefulWidget {
  final List<PhotoModel> photos;

  const ImageViewer({super.key, required this.photos});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  int currentImage = 0;

  final PageController _pageController = PageController();

  Future<void> downloadPhotos(String photosUrl) async {
    try {
      await Permission.manageExternalStorage.request();

      final dir = await getExternalStorageDirectory();
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';

      final savePath = '/storage/emulated/0/Download/${fileName}';

      await Dio().download(photosUrl, savePath);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image downloaded successfully')),
        );
      }
      print('Saved at: $savePath');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Download failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPreference.getTheme()
            ? Theme.of(context).scaffoldBackgroundColor
            : ColorUtils.selectedColor,
        title: AppText(
          text: widget.photos[currentImage].name,
          style: appTextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            //Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),

      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: PageView.builder(
              itemCount: widget.photos.length,
              controller: _pageController,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.photos[index].image,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () {
                    final shareParams = ShareParams(
                      title: 'Share Image',
                      text:
                          'https://diseasedictionary.skyraantech.com/server/api/',
                    );
                    SharePlus.instance.share(shareParams);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white),
                  ),
                  child: AppText(
                    text: 'share',
                    style: appTextStyle(color: Colors.white),
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPreference.getTheme()
                        ? Colors.black
                        : ColorUtils.selectedColor,
                  ),
                  onPressed: () {
                    downloadPhotos(widget.photos[currentImage].image);
                  },
                  child: AppText(
                    text: 'download',
                    style: appTextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 20,
            top: 300,

            child: IconButton(
              onPressed: () {
                setState(() {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                  currentImage--;
                });
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
            ),
          ),

          Positioned(
            right: 20,
            top: 300,

            child: IconButton(
              onPressed: () {
                setState(() {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                  currentImage++;
                });
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
