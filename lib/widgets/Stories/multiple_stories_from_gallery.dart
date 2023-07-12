import 'dart:io';
import 'package:bizbultest/widgets/FeedPosts/edit_multiple_files.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/view/create_story_page.dart';
import 'package:flutter/cupertino.dart';

class MultipleStoriesFromGallery extends StatefulWidget {
  final List<AssetCustom>? fileList;
  MultipleStoriesFromGallery({Key? key, this.fileList}) : super(key: key);
  @override
  _MultipleStoriesFromGalleryState createState() =>
      _MultipleStoriesFromGalleryState();
}

class _MultipleStoriesFromGalleryState
    extends State<MultipleStoriesFromGallery> {
  List<File> files = [];

  void loadFiles() async {
    for (int i = 0; i < widget.fileList!.length; i++) {
      var file = await widget.fileList![i].asset!.file;
      setState(() {
        files.add(file!);
      });
    }
  }

  @override
  void initState() {
    loadFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
        ),
      ),
      body: files.length > 0
          ? Stack(
              children: [
                Container(
                  height: 85.0.h,
                  child: PageView.builder(
                      itemCount: widget.fileList!.length,
                      itemBuilder: (context, index) {
                        return Container(
                            child: widget.fileList![index].asset!.type
                                        .toString() ==
                                    "AssetType.video"
                                ? FittedVideoPlayer(
                                    video: files[index],
                                  )
                                : Image.file(
                                    files[index],
                                    fit: BoxFit.cover,
                                  ));
                      }),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black,
                    height: 15.0.h,
                  ),
                )
              ],
            )
          : Container(
              color: Colors.black,
            ),
    );
  }
}
