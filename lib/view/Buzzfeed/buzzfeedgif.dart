import 'package:bizbultest/models/Buzzerfeed/buzzfeedgifmodel.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedcontroller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:skeleton_text/skeleton_text.dart';

class BuzzerfeedGif extends StatefulWidget {
  BuzzerfeedGif({Key? key, this.controller}) : super(key: key);
  BuzzerfeedController? controller;
  @override
  State<BuzzerfeedGif> createState() => _BuzzerfeedGifState();
}

class _BuzzerfeedGifState extends State<BuzzerfeedGif> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            print("clicked back");
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(
          'Gifs',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          height: Get.height,
          width: Get.width,
          child: FutureBuilder(
            future: widget.controller!.getGif(),
            builder: (context, AsyncSnapshot<List<Datum>> snapshot) {
              if (snapshot.data != null)
                return StaggeredGridView.countBuilder(
                    addAutomaticKeepAlives: false,
                    crossAxisCount: 6,
                    staggeredTileBuilder: (index) {
                      return StaggeredTile.count(3, 3);
                    },
                    itemCount: snapshot.data!.length,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    itemBuilder: (context, index) => Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: InkWell(
                                onTap: () {
                                  widget.controller!.currentGif!.value =
                                      snapshot.data![index].name!;
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  child: CachedNetworkImage(
                                    imageUrl: '${snapshot.data![index].name}',
                                    fit: BoxFit.cover,
                                    // placeholder: (context, url) =>
                                    //     SkeletonAnimation(
                                    //         child: AspectRatio(aspectRatio: 1)

                                    //         ),
                                  ),
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                            ),
                            Text(
                              '${snapshot.data![index].stickerName}',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ));
              else
                return SkeletonAnimation(
                  child: StaggeredGridView.countBuilder(
                    addAutomaticKeepAlives: false,
                    crossAxisCount: 6,
                    staggeredTileBuilder: (index) {
                      return StaggeredTile.count(3, 3);
                    },
                    itemCount: 20,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    itemBuilder: (context, index) => AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                );
            },
          )),
    );
  }
}
