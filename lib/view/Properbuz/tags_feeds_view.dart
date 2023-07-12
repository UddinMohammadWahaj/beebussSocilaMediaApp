import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/feed_post_card.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/tags_settings/content_bottom_sheet.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/tags_settings/filter_bottom_sheet.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/tags_settings/search_bottom_sheet.dart';
import 'package:bizbultest/widgets/Properbuz/utils/header_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

class TagsFeedsView extends StatefulWidget {
  final String? tag;
  final bool keep;

  const TagsFeedsView({Key? key, this.tag, this.keep = false})
      : super(key: key);

  @override
  State<TagsFeedsView> createState() => _TagsFeedsViewState();
}

class _TagsFeedsViewState extends State<TagsFeedsView> {
  ProperbuzFeedController controller = Get.put(ProperbuzFeedController());

  Widget _separator() {
    return Container(
      width: 100.0.w,
      height: 10,
      color: HexColor("#e9e6df"),
    );
  }

  Widget _settingsCard(String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          color: Colors.transparent,
          width: (100.0.w - 2) / 3,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    icon,
                    size: 25,
                    color: hotPropertiesThemeColor,
                  )),
              Text(
                value,
                style: TextStyle(
                    fontSize: 11.0.sp,
                    color: hotPropertiesThemeColor,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )),
    );
  }

  Widget _settingsRow() {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey.shade100,
        // border: Border(
        //   top: BorderSide(color: controller.settingsColor, width: 1),
        //   bottom: BorderSide(color: controller.settingsColor, width: 1),
        // ),
      ),
      child: Row(
        children: [
          _settingsCard(
              AppLocalizations.of(
                "Content",
              ),
              CustomIcons.writer, () {
            Get.bottomSheet(ContentBottomSheet(),
                backgroundColor: Colors.white);
          }),
          Container(
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border(
                  left: BorderSide(color: hotPropertiesThemeColor, width: 1),
                  right: BorderSide(color: hotPropertiesThemeColor, width: 1),
                ),
              ),
              child: _settingsCard(
                  AppLocalizations.of(
                    "Search",
                  ),
                  CustomIcons.search__1_, () {
                Get.bottomSheet(SearchBottomSheet(),
                    backgroundColor: Colors.white);
              })),
          _settingsCard(
              AppLocalizations.of(
                "Filter",
              ),
              CustomIcons.filter, () {
            Get.bottomSheet(FilterBottomSheet(), backgroundColor: Colors.white);
          }),
        ],
      ),
    );
  }

  Widget _noPostCard() {
    return Center(
      child: Container(
        child: Text(
          "No posts found",
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12.0.sp),
        ),
      ),
    );
  }

  @override
  void initState() {
    controller.selectedTag.value = widget.tag!;
    controller.getTagFeeds(widget.tag!);
    super.initState();
  }

  @override
  void dispose() {
    controller.selectedSort.value = "";
    controller.keywordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              toolbarHeight: 50,
              titleSpacing: 10,
              pinned: true,
              floating: true,
              elevation: 0,
              brightness: Brightness.dark,
              backgroundColor: Colors.white,
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
              title: Text(
                widget.tag!,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(55), child: _settingsRow()),
              automaticallyImplyLeading: false,
            )
          ];
        },
        body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Obx(
            () => controller.isLoading.value
                ? Container()
                : Container(
                    child: controller.tagFeeds.length == 0
                        ? _noPostCard()
                        : SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: customHeader(),
                            footer: customFooter(),
                            controller: controller.refreshControllerTags,
                            onRefresh: () =>
                                controller.refreshDataTags(widget.tag!),
                            onLoading: () =>
                                controller.loadMoreDataTags(widget.tag!),
                            child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    _separator(),
                                itemCount: controller.tagFeeds.length,
                                itemBuilder: (context, index1) {
                                  return ProperbuzFeedPostCard(
                                    navigate: true,
                                    showMenu: true,
                                    maxLines: 3,
                                    index: index1,
                                    val: 2,
                                  );
                                }),
                          ),
                  ),
          ),
        ),
      ),
    );
  }
}
