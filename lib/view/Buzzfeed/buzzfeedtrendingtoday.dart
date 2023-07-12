import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedmaincontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/Buzzfeed/trendingtags.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/Properbuz/feeds/tags_country_bottom_sheet.dart';

class BuzzfeedTrendingToday extends GetView<BuzzerfeedMainController> {
  get appBarColor => null;

  @override
  Widget build(BuildContext context) {
    Widget _title() {
      return GestureDetector(
        onTap: () {
          // Get.bottomSheet(TagsCountryBottomSheet(),
          //     backgroundColor: Colors.white);
          controller.getTrendingCountry();
          Get.bottomSheet(TagsCountryBottomSheet(),
              backgroundColor: Colors.white);
        },
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            children: [
              Obx(
                () => Text(
                  AppLocalizations.of(
                        "Trending Tags in",
                      ) +
                      " ${controller.country.value} • ",
                  style: TextStyle(
                      fontSize: 2.0.h,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                AppLocalizations.of(
                  "Change",
                ),
                style: TextStyle(
                  fontSize: 13,
                  color: appBarColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget customTile(index, String hashtag, {String nooftweets: '2000'}) {
      return ListTile(
        onTap: () {
          controller.headerTag.value = hashtag;
          controller.fetchData(tag: hashtag);
          Navigator.of(context).pop();
        },
        contentPadding: EdgeInsets.all(8),
        leading: Icon(
          FontAwesomeIcons.hashtag,
          size: 3.0.h,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$index .Trending',
              style: TextStyle(
                  fontSize: 2.0.h,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            Text(
              '${hashtag}',
              style: TextStyle(
                  fontSize: 3.0.h,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text('$nooftweets Tweets'),
          ],
        ),
        isThreeLine: true,
      );
    }

    return Container(
      height: 100.0.h,
      color: Colors.white,
      width: 100.0.w,
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index == 0) return _title();
              return ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return customTile(index + 1,
                        controller.todaytrendinglist.value[index]['tagName'],
                        nooftweets: controller
                            .todaytrendinglist.value[index]['tagValue']
                            .toString());
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 0.1.h,
                    );
                  },
                  itemCount: controller.todaytrendinglist.length);
            }, childCount: 2),
          )
        ],
      ),
    );
  }
}
