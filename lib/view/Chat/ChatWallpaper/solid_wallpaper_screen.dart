import 'package:bizbultest/shared/shared.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SolidWallpaperScreen extends StatefulWidget {
  const SolidWallpaperScreen({Key? key}) : super(key: key);

  @override
  _SolidWallpaperScreenState createState() => _SolidWallpaperScreenState();
}

class _SolidWallpaperScreenState extends State<SolidWallpaperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solid Colours'),
        flexibleSpace: gradientContainer(null),
      ),
      body: GridView.count(
        padding: EdgeInsets.all(3),
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        children: [
          wallpaperView(
              'https://properbuz.com/wallpapers/solid/solid_w(0).png'),
          wallpaperView(
              'https://properbuz.com/wallpapers/solid/solid_w(1).png'),
          wallpaperView(
              'https://properbuz.com/wallpapers/solid/solid_w(2).png'),
          wallpaperView(
              'https://properbuz.com/wallpapers/solid/solid_w(3).png'),
          wallpaperView(
              'https://properbuz.com/wallpapers/solid/solid_w(4).png'),

          // wallpaperView('assets/Solid_Wallpapers/solid_w (0).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (1).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (2).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (3).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (4).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (5).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (6).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (7).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (8).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (9).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (10).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (11).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (12).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (13).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (14).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (15).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (16).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (17).png'),
          // wallpaperView('assets/Solid_Wallpapers/solid_w (18).png'),
        ],
      ),
    );
  }

  Widget wallpaperView(String img) {
    return InkWell(
      onTap: () {
        MySharedPreferences().setBGImage(img);

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        ///Route path => SelectWallpaper
      },
      child: Image(
        image: CachedNetworkImageProvider(img),
        height: 30,
        fit: BoxFit.cover,
      ),
    );
  }
}
