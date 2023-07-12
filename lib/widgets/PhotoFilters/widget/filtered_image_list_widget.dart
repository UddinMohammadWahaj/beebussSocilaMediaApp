import 'dart:typed_data';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/subfilters.dart';
import 'package:sizer/sizer.dart';

import 'filtered_image_widget.dart';

class FilteredImageListWidget extends StatelessWidget {
  final List<Filter> filters;
  final img.Image image;
  final ValueChanged<Filter> onChangedFilter;
  final Function? change;
  final String? path;

  const FilteredImageListWidget({
    Key? key,
    required this.filters,
    required this.image,
    required this.onChangedFilter,
    this.change,
    this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 20.0.h;

    return Container(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];

          return InkWell(
            onTap: () {
              onChangedFilter(filter);
            },
            child: Container(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    index == 0 ? AppLocalizations.of("Normal") : filter.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 10.0.sp),
                  ),
                  SizedBox(height: 1.0.h),
                  FilteredImageWidget(
                    setFilter: () {},
                    filter: filter,
                    image: image,
                    path: path!,
                    successBuilder: (imageBytes) => CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Container(
                          child: Image.memory(
                        imageBytes as Uint8List,
                        cacheHeight: image.height ~/ 4,
                        cacheWidth: image.width ~/ 4,
                        height: (image.height ~/ 4).toDouble(),
                        width: (image.width ~/ 4).toDouble(),
                        fit: BoxFit.cover,
                      )),
                    ),
                    errorBuilder: () => CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.report, size: 32),
                      backgroundColor: Colors.white,
                    ),
                    loadingBuilder: () => CircleAvatar(
                      radius: 50,
                      child: Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                        strokeWidth: 0.2,
                      )),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
