  import 'package:bizbultest/models/related_blog_model.dart';
import 'package:bizbultest/services/Blogs/related_blogs_controller.dart';
import 'package:bizbultest/widgets/related_blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RelatedBlogsView extends GetView<RelatedBlogsController> {
  const RelatedBlogsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RelatedBlogsController(), fenix: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.keyboard_backspace,
              size: 28,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: controller.relatedBlogs
                .asMap()
                .map((i, value) => MapEntry(
                    i,
                    RelatedBlogCard(
                      index: i,
                      blog: controller.relatedBlogs[i],
                    )))
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}
