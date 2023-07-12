import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Streaming/Controllers/category_controller.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/Streaming/streaming_search_page.dart';
import 'package:bizbultest/widgets/Streaming/info_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'detailed_video_info_page_movies.dart';

class MyListVideos extends StatefulWidget {
  const MyListVideos({Key? key}) : super(key: key);

  @override
  _MyListVideosState createState() => _MyListVideosState();
}

class _MyListVideosState extends State<MyListVideos> {
  CategoryController controller = Get.put(CategoryController());

  @override
  void initState() {
    controller.fetchMyListVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          AppLocalizations.of(
            "My List",
          ),
          style: whiteBold.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () {
              Get.to(() => StreamingSearchPage(
                    image: controller.myListVideos[0].categoryData![0].poster,
                  ));
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Obx(
        () => GridView.builder(
            itemCount: controller.myListVideos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 4 / 6),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  AspectRatio(
                      aspectRatio: 4 / 6,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              barrierColor: Colors.white.withOpacity(0),
                              elevation: 0,
                              backgroundColor: Colors.grey.shade900,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      topRight: const Radius.circular(10.0))),
                              //isScrollControlled:true,
                              context: context,
                              builder: (BuildContext bc) {
                                return InfoCard(
                                  video: controller
                                      .myListVideos[index].categoryData![0],
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailedVideoInfoPageMovie(
                                                  video: controller
                                                      .myListVideos[index]
                                                      .categoryData![0],
                                                  image: controller
                                                      .myListVideos[index]
                                                      .categoryData![0]
                                                      .poster,
                                                )));
                                  },
                                );
                              });
                        },
                        child: Container(
                            color: Colors.transparent,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image(
                                  image: CachedNetworkImageProvider(controller
                                      .myListVideos[index]
                                      .categoryData![0]
                                      .poster!),
                                  fit: BoxFit.cover,
                                ))),
                      )),
                ],
              );
            }),
      ),
    );
  }
}
