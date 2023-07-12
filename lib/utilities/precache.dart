import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class Preload {
  static Future cacheImage(BuildContext context, String url) async {
    precacheImage(Image.network(url).image, context);
  }
}

class PreloadCached {
  static Future cacheImage(BuildContext context, String url) async {
    precacheImage(CachedNetworkImageProvider(url), context);
  }
}

class PreloadUserImage {
  static Future cacheImage(BuildContext context, String url) async {
    precacheImage(NetworkImage(url), context);
  }
}
