import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class FilterUtils {
  static final Map<String, List<int>> _cacheFilter = {};

  static void clearCache() => _cacheFilter.clear();

  static void saveCachedFilter(
      Filter filter, List<int> imageBytes, String path) {
    if (filter == null) return;

    _cacheFilter[filter.name + ":" + path] = imageBytes;
  }

  static List<int>? getCachedFilter(Filter filter, String path) {
    if (filter == null) return null;

    return _cacheFilter[filter.name + ":" + path];
  }

  static Future<List<int>> applyFilter(img.Image image, Filter filter) {
    if (filter == null) throw Exception('Filter not set');

    return compute(
      _applyFilterInternal,
      <String, dynamic>{
        'filter': filter,
        'image': image,
        'width': image.width,
        'height': image.height,
      },
    );
  }

  static Future<List<int>> _applyFilterInternal(
      Map<String, dynamic> params) async {
    Filter filter = params["filter"];
    img.Image image = params["image"];
    int width = params["width"] ?? image.width;
    int height = params["height"];
    final bytes = image.getBytes();
    filter.apply(bytes, width, height);
    final newImage = img.Image.fromBytes(width, height, bytes);
    return img.encodePng(newImage, level: 1);
  }
}
