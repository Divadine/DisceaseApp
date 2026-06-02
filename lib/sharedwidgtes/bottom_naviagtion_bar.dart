import 'package:discese_dictionary/databasehelper/app_preference.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppPreference.getTheme() ? Colors.black : ColorUtils.selectedColor,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => onTap(0),

            icon: currentIndex == 0
                ? SvgPicture.asset(AssetImages.home_shaded_bottom)
                : SvgPicture.asset(AssetImages.home_outline_bottom),
          ),

          IconButton(
            onPressed: () => onTap(1),

            icon: currentIndex == 1
                ? SvgPicture.asset(AssetImages.search_shaded_bottom)
                : SvgPicture.asset(AssetImages.search_outline_bottom),
          ),

          IconButton(
            onPressed: () => onTap(2),

            icon: currentIndex == 2
                ? SvgPicture.asset(AssetImages.video_shaded_bottom)
                : SvgPicture.asset(AssetImages.video_outline_bottom),
          ),

          IconButton(
            onPressed: () => onTap(3),
            icon: currentIndex == 3
                ? SvgPicture.asset(AssetImages.bookmark_shaded_bottom)
                : SvgPicture.asset(AssetImages.bookmark_outline_bottom),
          ),
        ],
      ),
    );
  }
}
