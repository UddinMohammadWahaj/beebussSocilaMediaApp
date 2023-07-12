import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AssetCustom {
  AssetEntity? asset;
  bool selected = false;
  int selectedNumber = 0;
  int? assetIndex;
  int? indexNumber;
  bool isCropped = false;
  File? croppedFile;

  AssetCustom(asset, selected) {
    this.asset = asset;
    this.selected = selected;
  }
}

class AudioLibrary extends StatefulWidget {
  final String? name;
  final Function? sendAudioMessage;

  const AudioLibrary({Key? key, this.sendAudioMessage, this.name})
      : super(key: key);

  @override
  _AudioLibraryState createState() => _AudioLibraryState();
}

class _AudioLibraryState extends State<AudioLibrary> {
  late Future future;
  List<FileSystemEntity> songs = [];
  List<File> songFiles = [];
  List<File> allFiles = [];
  List<String> durationList = [];

  /*Future<List<FileSystemEntity>> getAudio() async {
    Directory dir = Directory('/storage/emulated/0/');
    String mp3Path = dir.toString();
    print(mp3Path);
    List<FileSystemEntity> _files;
    List<FileSystemEntity> _songs = [];
    _files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) _songs.add(entity);
      if (path.endsWith('.aac')) _songs.add(entity);
      if (path.endsWith('.m4a')) _songs.add(entity);
    }
    print(_songs);
    print(_songs.length);
    return _songs;
  }*/

  List<AssetCustom> assets = [];

  String _durationText(int minutes, int seconds) {
    String mins = minutes.toString();
    String minsPrefix = "";
    if (minutes < 10) {
      minsPrefix = "0";
    }
    String secs = (seconds % 60).toString();
    String secsPrefix = "";
    if ((seconds % 60) < 10) {
      secsPrefix = "0";
    }
    String durationText = minsPrefix + mins + ":" + secsPrefix + secs;
    return durationText;
  }

  Future<List<File>> fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.audio);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 100, // end at a very big index (to get all the assets)
    );
    List<AssetCustom> data = [];
    List<File> files = [];
    recentAssets.forEach((element) {
      data.add(AssetCustom(element, false));
    });

    assets = data;

    for (int i = 0; i < data.length; i++) {
      File? file = await data[i].asset!.file;
      files.add(file!);
    }

    return files;
  }

  @override
  void initState() {
    future = fetchAssets().then((value) {
      setState(() {
        allFiles = value;
      });
      return value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: songFiles.length > 0
          ? new FloatingActionButton(
              backgroundColor: darkColor,
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () {
                widget.sendAudioMessage!(songFiles, durationList);
                Navigator.pop(context);
              },
            )
          : null,
      appBar: AppBar(
        title: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(
                      "Send to",
                    ) +
                    " ${widget.name}",
                style: whiteBold.copyWith(fontSize: 20),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                songFiles.length == 0
                    ? AppLocalizations.of(
                        "Tap to select",
                      )
                    : "${songFiles.length.toString()} selected",
                style: whiteNormal.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
        flexibleSpace: gradientContainer(null),
        brightness: Brightness.dark,
      ),
      body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: ListView.builder(
                    itemCount: allFiles.length,
                    itemBuilder: (context, index) {
                      var file = allFiles[index];

                      return Container(
                        color: assets[index].selected
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.transparent,
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              assets[index].selected = !assets[index].selected;
                            });
                            if (assets[index].selected) {
                              setState(() {
                                songFiles.add(file);
                                durationList.add(_durationText(
                                    assets[index]
                                        .asset!
                                        .videoDuration
                                        .inMinutes,
                                    assets[index]
                                        .asset!
                                        .videoDuration
                                        .inSeconds));
                              });
                            } else {
                              setState(() {
                                songFiles.removeWhere(
                                    (element) => element.path == file.path);
                                durationList.removeWhere((element) =>
                                    element ==
                                    _durationText(
                                        assets[index]
                                            .asset!
                                            .videoDuration
                                            .inMinutes,
                                        assets[index]
                                            .asset!
                                            .videoDuration
                                            .inSeconds));
                              });
                            }
                          },
                          leading: Container(
                              decoration: new BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  shape: BoxShape.rectangle,
                                  color: darkColor),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.headset,
                                  color: Colors.white,
                                  size: 23,
                                ),
                              )),
                          title: Container(
                            width: 50.0.w,
                            child: Text(
                              assets[index].asset!.title!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Audio(
                            path: file.path,
                          ),
                          subtitle: Container(
                            child: Text(_durationText(
                                assets[index].asset!.videoDuration.inMinutes,
                                assets[index].asset!.videoDuration.inSeconds)),
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}

class AudioInfo extends StatefulWidget {
  final String? path;

  const AudioInfo({Key? key, this.path}) : super(key: key);

  @override
  _AudioInfoState createState() => _AudioInfoState();
}

class _AudioInfoState extends State<AudioInfo> {
  late Future _audioInfoFuture;
  ap.AudioPlayer player = ap.AudioPlayer();
  AudioCache audioCache = new AudioCache();
  late Future _durationFuture;
  String stringDuration = "";
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Future<String> loadFile() async {
    print(widget.path! + " received path");
    String duration = "";
    player.setUrl(widget.path!, isLocal: true);
    player.onDurationChanged.listen((Duration d) {
      print('max duration: ${d.inSeconds}');
      print(d.inMinutes.toString() + ":" + (d.inSeconds % 60).toString());
      duration = d.inMinutes.toString() + ":" + (d.inSeconds % 60).toString();
      print(duration + " beforeee");

      stringDuration = duration;
    });

    return stringDuration;
  }

  @override
  void initState() {
    _audioInfoFuture = loadFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _audioInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("hassss");
            return Container(
              child: Text(stringDuration),
            );
          } else {
            return Container(
              child: Text(""),
            );
          }
        });
  }
}

class Audio extends StatefulWidget {
  final String? path;

  const Audio({Key? key, this.path}) : super(key: key);

  @override
  _AudioState createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  late ap.AudioPlayer player;
  bool isPlaying = false;
  late StreamSubscription _completeSubscription;

  void _init() {
    _completeSubscription = player.onPlayerCompletion.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<void> play() async {
    print(widget.path! + " play path");
    await player.play(widget.path!);
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> pause() async {
    await player.pause();
    await player.release();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    print("disposeee");
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    player = ap.AudioPlayer();
    _init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
            shape: BoxShape.circle, color: Colors.grey.shade200),
        child: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(
            !isPlaying ? Icons.play_arrow : Icons.pause,
            color: Colors.grey.shade500,
            size: 30,
          ),
          onPressed: () {
            !isPlaying ? play() : pause();
          },
        ));
  }
}
