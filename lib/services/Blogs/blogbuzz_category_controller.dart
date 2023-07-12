import 'package:bizbultest/models/blogbuzz_list_model.dart';
import 'package:bizbultest/services/Blogs/blog_api_calls.dart';
import 'package:get/get.dart';

class BlogBuzzCategoryController extends GetxController {
  Rx<Categories> categoryList = Categories([]).obs;

  @override
  void onInit() {
    // _getCategoryListLocal();
    _getCategoryList();
    super.onInit();
  }

  void _getCategoryList() async {
    var data = await BlogApiCalls.getBlogCategoryList();
    categoryList.value.categories.assignAll(data.categories);
  }

  void _getCategoryListLocal() async {
    var data = await BlogApiCalls.getBlogCategoryListLocal();
    categoryList.value.categories.assignAll(data.categories);
  }
}
