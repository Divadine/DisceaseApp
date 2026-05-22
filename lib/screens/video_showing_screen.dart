import 'package:discese_dictionary/api/apiservice.dart';
import 'package:discese_dictionary/models/disease_details.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class VideoShowingScreen extends StatefulWidget {
  // final int diseaseId;
  final String name;
  final List<VideoModel> videos;

  const VideoShowingScreen({
    super.key,
    required this.name,
    required this.videos,
    // required this.diseaseId,
  });

  @override
  State<VideoShowingScreen> createState() => _VideoShowingScreenState();
}

class _VideoShowingScreenState extends State<VideoShowingScreen> {
  VideoPlayerController? videoController;
  bool isExpanded = false;

  List<VideoModel> videos = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initialFunction();
  }

  Future<void> initialFunction() async {
    if (widget.videos.isNotEmpty) {
      videos = widget.videos;
    } else {
      await getVideosFromApi();
    }
    if (videos.isEmpty) return;
    initializeVideo(videos.first);
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
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.selectedColor,
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
                                  : '${video.description.substring(0, video.description.length > 250 ? 250 : (video.description.length - 3))}...',
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
                                onPressed: () {},
                                icon: Icon(
                                  Icons.save_alt_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              Text(
                                'Save',
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
                                onPressed: () {},
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
