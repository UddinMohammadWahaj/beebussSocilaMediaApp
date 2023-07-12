import 'package:bizbultest/shared/shared.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DarkWallpaperScreen extends StatefulWidget {
  const DarkWallpaperScreen({Key? key}) : super(key: key);

  @override
  _DarkWallpaperScreenState createState() => _DarkWallpaperScreenState();
}

class _DarkWallpaperScreenState extends State<DarkWallpaperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dark'),
        flexibleSpace: gradientContainer(null),
      ),
      body: GridView.count(
        padding: EdgeInsets.all(3),
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        children: [
          wallpaperView('https://properbuz.com/wallpapers/dark/dark_w(0).jpg'),
          wallpaperView('https://properbuz.com/wallpapers/dark/dark_w(1).jpg'),
          wallpaperView('https://properbuz.com/wallpapers/dark/dark_w(2).jpg'),
          wallpaperView('https://properbuz.com/wallpapers/dark/dark_w(3).jpg'),
          wallpaperView('https://properbuz.com/wallpapers/dark/dark_w(4).jpg'),
          wallpaperView('https://properbuz.com/wallpapers/dark/dark_w(5).jpg'),
          // wallpaperView('assets/Bright_Wallpapers/bright_w (0).jpg'),
          // wallpaperView('assets/Bright_Wallpapers/bright_w (1).jpg'),
          // wallpaperView('assets/Bright_Wallpapers/bright_w (2).jpg'),
          // wallpaperView('assets/Bright_Wallpapers/bright_w (3).jpg'),
          // wallpaperView('assets/Bright_Wallpapers/bright_w (4).jpg'),
          // wallpaperView('assets/Bright_Wallpapers/bright_w (5).jpg'),
        ],
      ),
    );
  }

  Widget wallpaperView(String img) {
    return InkWell(
      onTap: () {
        ///Route path => SelectWallpaper
        MySharedPreferences().setBGImage(img);

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: Image(
        image: CachedNetworkImageProvider(img),
        height: 30,
        fit: BoxFit.cover,
      ),
    );
  }
}
