import 'package:discese_dictionary/api/apiservice.dart';
import 'package:discese_dictionary/databasehelper/db_helper.dart';
import 'package:discese_dictionary/models/disease_details.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../databasehelper/app_preference.dart';
import '../databasehelper/font_helper.dart';

class VideoShowingScreen extends StatefulWidget {
  final String name;
  final List<VideoModel> videos;
  final int selectedIndex;

  const VideoShowingScreen({
    super.key,
    required this.name,
    required this.videos,
    this.selectedIndex = 0,
  });

  @override
  State<VideoShowingScreen> createState() => _VideoShowingScreenState();
}

class _VideoShowingScreenState extends State<VideoShowingScreen> {
  VideoPlayerController? videoController;
  bool isExpanded = false;
  bool isBookmarked = false;

  List<VideoModel> videos = [];
  late int currentIndex;
  PageController pageController = PageController();

  @override
  void initState() {
    currentIndex = widget.selectedIndex;
    super.initState();
    initialFunction();
  }

  Future<void> checkVideoBookmarks() async {
    final result = await DbHelper.instance.checkVideoBookmarksExist(
      videos[currentIndex].id,
    );

    setState(() {
      isBookmarked = result;
    });
  }

  Future<void> initialFunction() async {
    print('index = ===============$currentIndex : ${widget.selectedIndex}');
    if (widget.videos.isNotEmpty) {
      videos = widget.videos;
    } else {
      await getVideosFromApi();
    }
    if (videos.isEmpty) return;
    await initializeVideo(videos[currentIndex]);
    await checkVideoBookmarks();
    if (currentIndex > 0) {
      pageController.jumpToPage(currentIndex);
    }
  }

  Future<void> initializeVideo(VideoModel video) async {
    try {
      videoController?.pause();
      videoController?.dispose();

      setState(() {});

      videoController = VideoPlayerController.networkUrl(
        Uri.parse(video.video),
      );

      await videoController!.initialize();
      videoController!.play();

      setState(() {});
    } catch (e) {
      print('Error  ---------> $e');
    }
  }

  Future<void> getVideosFromApi() async {
    final lastId = videos.isEmpty ? 0 : videos.last.id;
    final result = await ApiService().getVideosApi(lastId);
    if (result.isEmpty) {
      return;
    }
    videos.addAll(result);
    setState(() {});
  }

  void onPageChange(int index) async {
    currentIndex = index;
    if (index == videos.length - 1) {
      await getVideosFromApi();
    }
    await initializeVideo(videos[index]);

    await checkVideoBookmarks();
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
    pageController.dispose();
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
        backgroundColor: AppPreference.getTheme()
            ? Theme.of(context).scaffoldBackgroundColor
            : ColorUtils.selectedColor,
        title: Text(
          widget.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      body: videos.isNotEmpty
          ? PageView.builder(
              controller: pageController,
              itemCount: videos.length,
              scrollDirection: Axis.vertical,
              onPageChanged: onPageChange,
              itemBuilder: (BuildContext context, int index) {
                final video = videos[index];
                if (!((videoController?.value.isInitialized) ?? true)) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black,

                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          if (videoController != null) {
                            if (videoController!.value.isPlaying) {
                              videoController?.pause();
                            } else {
                              videoController?.play();
                            }
                            setState(() {});
                          }
                        },
                        child: AspectRatio(
                          aspectRatio: videoController!.value.aspectRatio,
                          child: VideoPlayer(videoController!),
                        ),
                      ),
                    ),

                    //description
                    Positioned(
                      bottom: 20,
                      right: 10,
                      left: 10,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),

                            Text(
                              isExpanded
                                  ? video.description
                                  : '${video.description.substring(0, video.description.length > 100 ? 100 : (video.description.length - 50))}...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            //const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Text(
                                isExpanded ? 'Show less' : 'Show more',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //pauseButton
                    if (videoController != null &&
                        !(videoController!.value.isPlaying))
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            if (videoController != null) {
                              videoController?.play();
                              setState(() {});
                            }
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AssetImages.video_pause_icon,
                                height: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                    Positioned(
                      bottom: 200,
                      right: 40,
                      //left: 50,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              //save
                              IconButton(
                                onPressed: () async {
                                  final currentVideo = videos[currentIndex];
                                  if (isBookmarked) {
                                    await DbHelper.instance
                                        .deleteVideoBookmarks(currentVideo.id);

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          title: AppText(
                                            text: 'Remove Bookmark',
                                            style: appTextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: AppText(
                                            text:
                                                'Are you sure want to unsave this Video',
                                          ),

                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: AppText(
                                                text: 'Cancel',
                                                style: appTextStyle(
                                                  color:
                                                      ColorUtils.selectedColor,
                                                ),
                                              ),
                                            ),

                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    ColorUtils.selectedColor,
                                              ),
                                              onPressed: () async {
                                                DbHelper.instance
                                                    .deleteBookmarks(
                                                      currentVideo.id,
                                                    );

                                                Navigator.pop(context);

                                                setState(() {});
                                              },
                                              child: AppText(
                                                text: 'Remove',
                                                style: appTextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    await DbHelper.instance
                                        .insertVideoBookmarks(video);

                                    setState(() {
                                      isBookmarked = true;
                                    });
                                  }

                                  await checkVideoBookmarks();
                                },
                                icon: isBookmarked
                                    ? SvgPicture.asset(
                                        AssetImages.bookmark_shaded_bottom,
                                        color: Colors.black,
                                      )
                                    : SvgPicture.asset(
                                        AssetImages.bookmark_outline_bottom,
                                        color: Colors.red,
                                      ),
                              ),
                              Text(
                                'Bookmark',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),

                          //download
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.download,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),

                              Text(
                                'Download',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),

                          //share
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  final shareParams = ShareParams(
                                    title: 'Disease Dictionary',
                                    text:
                                        'Video of the Diseases URL : ${'https://diseasedictionary.skyraantech.com/server/api/'}',
                                  );
                                  SharePlus.instance.share(shareParams);
                                },
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              Text(
                                'Share',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
