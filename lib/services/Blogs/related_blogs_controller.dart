import 'package:bizbultest/models/related_blog_model.dart';
import 'package:get/get.dart';

import 'blog_api_calls.dart';

class RelatedBlogsController extends GetxController {
  var relatedBlogs = <RelatedBlogModel>[].obs;

  @override
  void onInit() {
    print("related");
    super.onInit();
  }

  @override
  void onClose() {
    print("closing");
    super.onClose();
  }

  void getRelatedBlogs (String keyword) async {
    relatedBlogs.clear();
    var blogs = await BlogApiCalls.getRelatedBlogs(keyword);
    if(blogs != null) {
      relatedBlogs.assignAll(blogs);
      print(relatedBlogs.length.toString() + " related length");
    }
  }
}
