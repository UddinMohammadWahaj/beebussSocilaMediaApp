import 'dart:io';
import 'dart:typed_data';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';

class SelectCoverFromGallery extends StatefulWidget {
  final Function? coverFromGallery;

  SelectCoverFromGallery({Key? key, this.coverFromGallery}) : super(key: key);

  @override
  _SelectCoverFromGalleryState createState() => _SelectCoverFromGalleryState();
}

class _SelectCoverFromGalleryState extends State<SelectCoverFromGallery> {
  List<AssetEntity> assets = [];

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.image);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );
    var file = await recentAssets[0].file;
    setState(() {
      currentFile = file!;
    });

    // Update the state and notify UI
    setState(() => assets = recentAssets);
  }

  File? currentFile;
  int? currentIndex = 0;

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.keyboard_backspace_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(
                      "Gallery",
                    ),
                    style: blackBold.copyWith(fontSize: 14.0.sp),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    widget.coverFromGallery!(currentFile);
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 45.0.h,
            width: 100.0.w,
            child: currentFile != null
                ? Image.file(
                    currentFile!,
                    fit: BoxFit.cover,
                  )
                : Container(),
          ),
          Expanded(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 6,
              itemCount: assets.length,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              itemBuilder: (context, index) {
                return ImageThumbnails(
                  index: index,
                  currentIndex: currentIndex!,
                  onTap: () async {
                    var file = await assets[index].file;
                    setState(() {
                      currentFile = file;
                      currentIndex = index;
                    });
                  },
                  asset: assets[index],
                );
              },
              staggeredTileBuilder: (index) {
                return StaggeredTile.count(2, 2);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ImageThumbnails extends StatefulWidget {
  final VoidCallback? onTap;
  final int? index;
  final int? currentIndex;

  const ImageThumbnails({
    Key? key,
    required this.asset,
    this.onTap,
    this.index,
    this.currentIndex,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  _ImageThumbnailsState createState() => _ImageThumbnailsState();
}

class _ImageThumbnailsState extends State<ImageThumbnails> {
  Future<Uint8List>? future;

  @override
  void initState() {
    future = widget.asset.thumbnailData as Future<Uint8List>?;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List>(
      future: future!,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null)
          return Container(
              color: Colors.black,
              child: Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 0.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))));
        // If there's data, display it as an image
        return InkWell(
          onTap: widget.onTap ?? () async {},
          child: Opacity(
              opacity: widget.index == widget.currentIndex ? 0.4 : 1,
              child: Container(child: Image.memory(bytes, fit: BoxFit.cover))),
        );
      },
    );
  }
}
