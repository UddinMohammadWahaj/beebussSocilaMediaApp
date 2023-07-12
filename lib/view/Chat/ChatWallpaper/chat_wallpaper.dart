import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/view/Chat/ChatWallpaper/select_wallpaper.dart';
import 'package:flutter/material.dart';

class ChatWallpaper extends StatefulWidget {
  const ChatWallpaper({Key? key}) : super(key: key);

  @override
  _ChatWallpaperState createState() => _ChatWallpaperState();
}

class _ChatWallpaperState extends State<ChatWallpaper> {
  int _value = 15;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text("Dark Theme Wallpaper"),
      ),
      body: ListView(
        padding: EdgeInsets.only(right: 14, left: 14, bottom: 14),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                width: 240,
                height: MediaQuery.of(context).size.height / 1.7,
                decoration: BoxDecoration(
                  color: Color(0xffe8e2dd),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 0.5,
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              spreadRadius: 0.5)
                        ],
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 29,
                            child: CircleAvatar(),
                          ),
                          Text(
                            "Contact Name",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      height: 25,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 0.5,
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              spreadRadius: 0.5)
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                          height: 40,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0.5,
                                  color: Colors.black12,
                                  offset: Offset(0, 2),
                                  spreadRadius: 0.5)
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 4, 10, 10),
                          height: 40,
                          width: 180,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0.5,
                                  color: Colors.black12,
                                  offset: Offset(0, 2),
                                  spreadRadius: 0.5)
                            ],
                            color: Color(0xffe1ffc8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_emotions_rounded,
                                      size: 15,
                                      color: Colors.grey,
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.attach_file,
                                      size: 15,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.camera_alt,
                                      size: 15,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.mic_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectWallpaper(),
                ),
              );
            },
            child: Text(
              'CHANGE',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 0, 5),
            child: Row(
              children: [Text('Wallpaper Dimming')],
            ),
          ),
          Slider(
            min: 0,
            max: 100,
            activeColor: secondaryColor,
            inactiveColor: secondaryColor.withOpacity(0.5),
            value: _value.toDouble(),
            onChanged: (double newValue) {
              setState(() {
                _value = newValue.round();
              });
            },
          ),
          Text('TO change your wallpaper for light theme, turn on light'),
          Text('Theme from Settings > Chats > Theme')
        ],
      ),
    );
  }
}
