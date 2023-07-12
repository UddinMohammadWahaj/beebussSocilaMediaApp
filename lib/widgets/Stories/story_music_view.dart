import 'dart:async';

import 'package:bizbultest/services/Story/music_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:playify/playify.dart';
import 'package:sizer/sizer.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/Story/musicdetail.dart';
import '../../services/Story/StoryMusicController.dart';

class StoryMusicView extends StatefulWidget {
  Function activitySelect;
  StoryMusicView({Key? key, required this.activitySelect}) : super(key: key);

  @override
  State<StoryMusicView> createState() => _StoryMusicViewState();
}

class _StoryMusicViewState extends State<StoryMusicView>
    with TickerProviderStateMixin {
  var controller = Get.put(StoryMusicController());
  var player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    var tabcontroller = TabController(length: 2, vsync: this);
    Future<List<SongDatum>> getData() async {
      var res =
          await StoryMusicApi.getMusicDetail(term: 'romantic', limit: '12');
      print("music res=$res");
      return res;
    }

    Widget musicCover(String url) {
      url = url.replaceFirst('{w}', '200');
      url = url.replaceFirst('{h}', '200');
      print("music url=$url");
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Container(
          height: 30.0.h,
          width: 15.0.w,
          color: Colors.black,
          child: Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(),
            child: CachedNetworkImage(imageUrl: url, fit: BoxFit.contain),
          ),
        ),
      );
    }

    Widget searchBar() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {},
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: TextFormField(
                  onChanged: (v) async {
                    controller.search.value = v;
                    Timer(Duration(seconds: 1), () async {
                      controller.searchSongs(controller.search.value);
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Search Music',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      )),
                )

                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Icon(Icons.search),
                //     SizedBox(
                //       width: 20,
                //     ),
                //   ],
                // ),
                ),
          ),
        ),
      );
    }

    Widget musicTile(onTap, onLeadingTap,
        {title: "", subtitle: "", image: '', index: 0, id: ''}) {
      print(
          "current song id=${id}  controller song=${controller.currentSongId.value}");
      return ListTile(
          onTap: onLeadingTap ?? () {},
          trailing: GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.black,
                child: Obx(() => Icon(
                    int.parse(controller.currentPlayingIndex.value) == index &&
                            controller.currentSongId.value == id
                        ? Icons.pause
                        : Icons.play_arrow_rounded,
                    color: Colors.white)),
              ),
            ),
          ),
          subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
          leading: musicCover(image),
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ));
    }

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: searchBar(),
          automaticallyImplyLeading: false,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.black,
            tabs: <Tab>[
              Tab(
                child: Text(
                  "For You",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  "Browse",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            controller: tabcontroller,
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            await player.dispose();
            Get.delete<StoryMusicController>();
            return true;
          },
          child: Obx(
            () => controller.search.value != ''
                ? Container(
                    height: 100.0.h,
                    width: 100.0.w,
                    child: ListView.builder(
                      itemCount: controller.searchedSongs.length,
                      itemBuilder: (context, index) => musicTile(
                        () async {
                          print("present tap");
                          player.stop();
                          controller.searchedSongs[index].isPlaying!.value =
                              !controller.searchedSongs[index].isPlaying!.value;

                          print(
                              "present bool ${controller.searchedSongs[index].isPlaying!.value}");
                          if (controller
                              .searchedSongs[index].isPlaying!.value) {
                            {
                              controller.currentPlayingIndex.value =
                                  index.toString();
                              controller.currentSongId.value =
                                  controller.searchedSongs[index].id!;
                            }
                            print(
                                "present playing index=${controller.searchedSongs[index].currentPlayingIndex!.value}");
                          }

                          if (controller
                              .searchedSongs[index].isPlaying!.value) {
                            await player.setUrl(// Load a URL
                                controller.searchedSongs[index].attributes!
                                    .previews![0].url!);
                            print("duration=${player.duration}");
                            await player.setLoopMode(LoopMode.all);
                            await player.play();
                          } else {
                            //  controller.currentPlayingIndex.value =
                            //     'index.toString()';
                            // controller.currentSongId.value =
                            //     '';
                            await player.stop();
                          }
                        },
                        () {
                          Navigator.of(context).pop();
                          widget.activitySelect("music",
                              song_image_url: controller.searchedSongs[index]
                                  .attributes!.artwork!.url,
                              song_artist: controller
                                  .searchedSongs[index].attributes!.artistName,
                              song_url: controller.searchedSongs[index]
                                  .attributes!.previews![0].url,
                              song_title: controller
                                  .searchedSongs[index].attributes!.name,
                              song_id: controller.searchedSongs[index].id);
                        },
                        id: controller.searchedSongs[index].id,
                        index: index,
                        image: controller
                            .searchedSongs[index].attributes!.artwork!.url,
                        subtitle: controller
                            .searchedSongs[index].attributes!.artistName,
                        title: controller.searchedSongs[index].attributes!.name,
                      ),
                    ),
                  )
                : TabBarView(controller: tabcontroller, children: [
                    Container(
                        height: 100.0.h,
                        width: 100.0.w,
                        child: Obx(() => controller.songs.value.length > 0
                            ? ListView.builder(
                                itemCount: controller.songs.length,
                                itemBuilder: (context, index) => ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      player.dispose();
                                      widget.activitySelect("music",
                                          song_image_url: controller
                                              .songs[index]
                                              .attributes!
                                              .artwork!
                                              .url,
                                          song_artist: controller.songs[index]
                                              .attributes!.artistName,
                                          song_url: controller.songs[index]
                                              .attributes!.previews![0].url,
                                          song_title: controller
                                              .songs[index].attributes!.name,
                                          song_id: controller.songs[index].id);
                                    },
                                    trailing: GestureDetector(
                                      onTap: () async {
                                        //Reset the previous playing to paused

                                        controller
                                                .songs[index].isPlaying!.value =
                                            !controller
                                                .songs[index].isPlaying!.value;
                                        if (controller
                                            .songs[index].isPlaying!.value) {
                                          controller.currentSongId.value =
                                              controller.songs[index].id!;
                                          controller.currentPlayingIndex.value =
                                              index.toString();
                                          print(
                                              "present playing index=${controller.songs[index].currentPlayingIndex!.value}");
                                        }
                                        if (controller
                                            .songs[index].isPlaying!.value) {
                                          await player.setUrl(// Load a URL
                                              controller
                                                  .songs[index]
                                                  .attributes!
                                                  .previews![0]
                                                  .url!);
                                          print("duration=${player.duration}");
                                          await player
                                              .setLoopMode(LoopMode.all);
                                          await player.play();
                                        } else {
                                          controller.currentSongId.value = '';
                                          controller.currentPlayingIndex.value =
                                              '-1';
                                          await player.stop();
                                        }

                                        // Create a player
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 25,
                                        child: CircleAvatar(
                                          radius: 24,
                                          backgroundColor: Colors.black,
                                          child: Obx(() => Icon(
                                              controller.songs[index].isPlaying!
                                                          .value &&
                                                      controller.songs[index]
                                                              .id ==
                                                          controller
                                                              .currentSongId
                                                              .value
                                                  // controller
                                                  //         .currentPlayingIndex
                                                  //         .value ==
                                                  //     index.toString()
                                                  ? Icons.pause
                                                  : Icons.play_arrow_rounded,
                                              color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(
                                        controller.songs[index].attributes!
                                            .artistName!,
                                        style: TextStyle(color: Colors.grey)),
                                    leading: musicCover(controller.songs[index]
                                        .attributes!.artwork!.url!),
                                    title: Text(
                                      controller.songs[index].attributes!.name!,
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              )))),
                    Container(
                      height: 150.0.h,
                      width: 100.0.w,
                      child: FutureBuilder(
                          future: controller.browseSongs(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData)
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Romantic',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: controller.romantic.length,
                                        itemBuilder: (context, index) =>
                                            musicTile(() async {
                                              controller.romantic[index]
                                                      .isPlaying!.value =
                                                  !controller.romantic[index]
                                                      .isPlaying!.value;
                                              if (controller.romantic[index]
                                                  .isPlaying!.value) {
                                                controller.currentSongId.value =
                                                    controller
                                                        .romantic[index].id!;
                                                controller.currentPlayingIndex
                                                    .value = index.toString();
                                                print(
                                                    "present playing index=${controller.songs[index].currentPlayingIndex!.value}");
                                              }
                                              if (controller.romantic[index]
                                                  .isPlaying!.value) {
                                                await player.setUrl(
                                                    // Load a URL
                                                    controller
                                                        .romantic[index]
                                                        .attributes!
                                                        .previews![0]
                                                        .url!);
                                                print(
                                                    "duration=${player.duration}");
                                                await player
                                                    .setLoopMode(LoopMode.all);
                                                await player.play();
                                              } else {
                                                controller.currentSongId.value =
                                                    '';
                                                controller.currentPlayingIndex
                                                    .value = '-1';
                                                await player.stop();
                                              }
                                            }, () {
                                              Navigator.of(context).pop();
                                              player.dispose();
                                              widget.activitySelect("music",
                                                  song_image_url: controller
                                                      .romantic[index]
                                                      .attributes!
                                                      .artwork!
                                                      .url!,
                                                  song_artist: controller
                                                      .romantic[index]
                                                      .attributes!
                                                      .artistName,
                                                  song_url: controller
                                                      .romantic[index]
                                                      .attributes!
                                                      .previews![0]
                                                      .url,
                                                  song_title: controller
                                                      .romantic[index]
                                                      .attributes!
                                                      .name,
                                                  song_id: controller
                                                      .romantic[index].id);
                                            },
                                                id: controller
                                                    .romantic[index].id,
                                                index: index,
                                                title: controller
                                                    .romantic[index]
                                                    .attributes!
                                                    .name,
                                                subtitle: controller
                                                    .romantic[index]
                                                    .attributes!
                                                    .artistName,
                                                image: controller
                                                    .romantic[index]
                                                    .attributes!
                                                    .artwork!
                                                    .url)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Rock',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: controller.rock.length,
                                        itemBuilder: (context, index) =>
                                            musicTile(() async {
                                              controller.rock[index].isPlaying!
                                                      .value =
                                                  !controller.rock[index]
                                                      .isPlaying!.value;
                                              if (controller.rock[index]
                                                  .isPlaying!.value) {
                                                controller.currentSongId.value =
                                                    controller.rock[index].id!;
                                                controller.currentPlayingIndex
                                                    .value = index.toString();
                                                print(
                                                    "tapped rock playing id=${controller.rock[index].id} current id=${controller.currentSongId}");
                                              }
                                              if (controller.rock[index]
                                                  .isPlaying!.value) {
                                                await player.setUrl(
                                                    // Load a URL
                                                    controller
                                                        .rock[index]
                                                        .attributes!
                                                        .previews![0]
                                                        .url!);
                                                print(
                                                    "duration=${player.duration}");
                                                await player
                                                    .setLoopMode(LoopMode.all);
                                                await player.play();
                                              } else {
                                                controller.currentSongId.value =
                                                    '';
                                                controller.currentPlayingIndex
                                                    .value = '-1';
                                                await player.stop();
                                              }
                                            }, () {
                                              Navigator.of(context).pop();
                                              player.dispose();
                                              widget.activitySelect("music",
                                                  song_image_url: controller
                                                      .rock[index]
                                                      .attributes!
                                                      .artwork!
                                                      .url,
                                                  song_artist: controller
                                                      .rock[index]
                                                      .attributes!
                                                      .artistName,
                                                  song_url: controller
                                                      .rock[index]
                                                      .attributes!
                                                      .previews![0]
                                                      .url,
                                                  song_title: controller
                                                      .rock[index]
                                                      .attributes!
                                                      .name,
                                                  song_id: controller
                                                      .rock[index].id);
                                            },
                                                index: index,
                                                id: controller.rock[index].id,
                                                title: controller.rock[index]
                                                    .attributes!.name,
                                                subtitle: controller.rock[index]
                                                    .attributes!.artistName,
                                                image: controller.rock[index]
                                                    .attributes!.artwork!.url)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Dance',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: controller.dance.length,
                                        itemBuilder: (context, index) =>
                                            musicTile(() async {
                                              controller.dance[index].isPlaying!
                                                      .value =
                                                  !controller.dance[index]
                                                      .isPlaying!.value;
                                              if (controller.dance[index]
                                                  .isPlaying!.value) {
                                                controller.currentSongId.value =
                                                    controller.dance[index].id!;
                                                controller.currentPlayingIndex
                                                    .value = index.toString();
                                                print(
                                                    "present playing index=${controller.songs[index].currentPlayingIndex!.value}");
                                              }
                                              if (controller.dance[index]
                                                  .isPlaying!.value) {
                                                await player.setUrl(
                                                    // Load a URL
                                                    controller
                                                        .dance[index]
                                                        .attributes!
                                                        .previews![0]
                                                        .url!);
                                                print(
                                                    "duration=${player.duration}");
                                                await player
                                                    .setLoopMode(LoopMode.all);
                                                await player.play();
                                              } else {
                                                controller.currentSongId.value =
                                                    '';
                                                controller.currentPlayingIndex
                                                    .value = '-1';
                                                await player.stop();
                                              }
                                            }, () {
                                              Navigator.of(context).pop();
                                              player.dispose();
                                              widget.activitySelect("music",
                                                  song_image_url: controller
                                                      .dance[index]
                                                      .attributes!
                                                      .artwork!
                                                      .url,
                                                  song_artist: controller
                                                      .dance[index]
                                                      .attributes!
                                                      .artistName,
                                                  song_url: controller
                                                      .dance[index]
                                                      .attributes!
                                                      .previews![0]
                                                      .url,
                                                  song_title: controller
                                                      .dance[index]
                                                      .attributes!
                                                      .name,
                                                  song_id: controller
                                                      .dance[index].id);
                                            },
                                                id: controller.dance[index].id,
                                                title: controller.dance[index]
                                                    .attributes!.name,
                                                subtitle: controller
                                                    .dance[index]
                                                    .attributes!
                                                    .artistName,
                                                index: index,
                                                image: controller.dance[index]
                                                    .attributes!.artwork!.url)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Blues',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: controller.blues.length,
                                        itemBuilder: (context, index) =>
                                            musicTile(() async {
                                              controller.blues[index].isPlaying!
                                                      .value =
                                                  !controller.blues[index]
                                                      .isPlaying!.value;
                                              if (controller.blues[index]
                                                  .isPlaying!.value) {
                                                controller.currentSongId.value =
                                                    controller.blues[index].id!;
                                                controller.currentPlayingIndex
                                                    .value = index.toString();
                                                print(
                                                    "present playing index=${controller.songs[index].currentPlayingIndex!.value}");
                                              }
                                              if (controller.blues[index]
                                                  .isPlaying!.value) {
                                                await player.setUrl(
                                                    // Load a URL
                                                    controller
                                                        .blues[index]
                                                        .attributes!
                                                        .previews![0]
                                                        .url!);
                                                print(
                                                    "duration=${player.duration}");
                                                await player
                                                    .setLoopMode(LoopMode.all);
                                                await player.play();
                                              } else {
                                                controller.currentSongId.value =
                                                    '';
                                                controller.currentPlayingIndex
                                                    .value = '-1';
                                                await player.stop();
                                              }
                                            }, () {
                                              Navigator.of(context).pop();
                                              player.dispose();
                                              widget.activitySelect("music",
                                                  song_image_url: controller
                                                      .blues[index]
                                                      .attributes!
                                                      .artwork!
                                                      .url,
                                                  song_artist: controller
                                                      .blues[index]
                                                      .attributes!
                                                      .artistName,
                                                  song_url: controller
                                                      .blues[index]
                                                      .attributes!
                                                      .previews![0]
                                                      .url,
                                                  song_title: controller
                                                      .blues[index]
                                                      .attributes!
                                                      .name,
                                                  song_id: controller
                                                      .blues[index].id);
                                            },
                                                title: controller.blues[index]
                                                    .attributes!.name,
                                                subtitle: controller
                                                    .blues[index]
                                                    .attributes!
                                                    .artistName,
                                                id: controller.blues[index].id,
                                                index: index,
                                                image: controller.blues[index]
                                                    .attributes!.artwork!.url))
                                  ],
                                ),
                              );
                            else
                              return Center(
                                  child: CircularProgressIndicator(
                                color: Colors.white,
                              ));
                          }),
                    )
                  ]),
          ),
        ));
  }
}
