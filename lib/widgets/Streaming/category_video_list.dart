import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:bizbultest/services/Streaming/Controllers/category_controller.dart';
import 'package:bizbultest/view/Streaming/detailed_video_info_page_movies.dart';
import 'package:bizbultest/view/Streaming/detailed_video_info_page_series.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'info_card.dart';

class CategoryVideoList extends StatefulWidget {
  final List<StreamCategoriesModel> categoryList;
  final int? videoIndex;
  const CategoryVideoList(
      {Key? key, required this.categoryList, this.videoIndex})
      : super(key: key);

  @override
  _CategoryVideoListState createState() => _CategoryVideoListState();
}

class _CategoryVideoListState extends State<CategoryVideoList> {
  CategoryController _categoryController = Get.put(CategoryController());
  Widget _categoryCard(String title, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          child: Container(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        _videoListView(index)
      ],
    );
  }

  Widget _videoListView(int i) {
    return Container(
      height: 150,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.categoryList[i].categoryData!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: InkWell(
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
                          onTap: () {
                            if (widget.categoryList[i].categoryData![index]
                                    .videoType ==
                                1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailedVideoInfoPageMovie(
                                            image: widget.categoryList[i]
                                                .categoryData![index].poster,
                                            video: widget.categoryList[i]
                                                .categoryData![index],
                                          )));
                            } else {
                              print(widget.categoryList[i].categoryData![index]
                                  .videoId);
                              print(i);
                              print(index);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailedVideoInfoPageSeries(
                                            index: i,
                                            catIndex: index,
                                            image: widget.categoryList[i]
                                                .categoryData![index].poster,
                                            video: widget.categoryList[i]
                                                .categoryData![index],
                                          )));
                            }
                          },
                          video: widget.categoryList[i].categoryData![index],
                        );
                      });
                },
                child: Container(
                  height: 140,
                  width: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image(
                        image: CachedNetworkImageProvider(widget
                            .categoryList[i].categoryData![index].poster!),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_categoryController.categoricalVideoList.length > 0) {
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.categoryList.length,
            itemBuilder: (context, index) {
              return _categoryCard(widget.categoryList[index].name!, index);
            });
      } else {
        return Container();
      }
    });
  }
}
