import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:photofilters/filters/filters.dart';

import '../filter_utils.dart';

class FilteredImageWidget extends StatelessWidget {
  final Filter filter;
  final img.Image image;
  final Widget Function(List<int> imageBytes) successBuilder;
  final Widget Function() errorBuilder;
  final Widget Function() loadingBuilder;
  final Function? setFilter;
  final String? path;

  const FilteredImageWidget({
    Key? key,
    required this.filter,
    required this.image,
    required this.successBuilder,
    required this.errorBuilder,
    required this.loadingBuilder,
    this.setFilter,
    this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cachedImageBytes = FilterUtils.getCachedFilter(filter, path!);

    if (cachedImageBytes == null) {
      return buildFilterFuture(filter, image);
    } else {
      return buildFilter(cachedImageBytes);
    }
  }

  Widget buildFilterFuture(Filter filter, img.Image image) {
    return FutureBuilder<List<int>>(
      future: FilterUtils.applyFilter(image, filter),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return loadingBuilder();
          default:
            if (snapshot.hasError) {
              return buildError();
            } else {
              FilterUtils.saveCachedFilter(filter, snapshot.data!, path!);
              /* //this.setFilter(snapshot.data);
              img.Image image = img.decodeImage(snapshot.data);
              print(snapshot.data.toString());*/

              return buildFilter(snapshot.data!);
            }
        }
      },
    );
  }

  Widget buildFilter(List<int> imageBytes) => successBuilder(imageBytes);

  Widget buildError() => errorBuilder();
}
