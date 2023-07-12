import 'package:bizbultest/services/Properbuz/wallpaper_Controller.dart';
import 'package:bizbultest/shared/shared.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'bright_wallpaper_screen.dart';
import 'dark_wallpaper_screen.dart';
import 'solid_wallpaper_screen.dart';

// ignore: must_be_immutable
class SelectWallpaper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text("Dark Theme Wallpaper"),
        actionsIconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => WpHelp(),
                //   ),
                // );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                height: 30,
                value: 1,
                child: Row(
                  children: <Widget>[
                    Text(
                      'Reset Wallpaper settings',
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              BrightWallpaperScreen(),
                        ),
                      );
                    },
                    child: wallpaperBox(context,
                        img: 'assets/Bright_Wallpapers/bright_w (0).jpg',
                        title: 'Bright'),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DarkWallpaperScreen(),
                        ),
                      );
                    },
                    child: wallpaperBox(context,
                        img: 'assets/Dark_Wallpapers/dark_w (0).jpg',
                        title: 'Dark'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SolidWallpaperScreen(),
                        ),
                      );
                    },
                    child: wallpaperBox(context,
                        img: 'assets/Solid_Wallpapers/solid_w (0).png',
                        title: 'Solid Coulors'),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width / 2.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ListTile(
              onTap: () {
                MySharedPreferences().setBGImage("");
                Fluttertoast.showToast(msg: "Set Default Theme");

                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              leading: Icon(Icons.wallpaper),
              title: Text('Default Wallpaper'),
            )
          ],
        ),
      ),
    );
  }

  Widget wallpaperBox(BuildContext context, {String? title, String? img}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(img!), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 10, 0, 10),
          child: Text(
            '$title',
          ),
        )
      ],
    );
  }
}
