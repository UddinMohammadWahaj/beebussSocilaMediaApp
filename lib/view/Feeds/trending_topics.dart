import 'package:bizbultest/providers/feeds/trending_topics_provider.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/widgets/Newsfeeds/trending_topics_list.dart';
import 'package:bizbultest/widgets/Newsfeeds/trending_topics_searchbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Language/appLocalization.dart';
import '../discover_people_from_tags.dart';

class TrendingTopics extends StatelessWidget {
  Function? profileOpen;
  Function? setNavBar;
  Function? isChannelOpen;
  Function? changeColor;
  TrendingTopics(
      {Key? key,
      this.profileOpen,
      this.setNavBar,
      this.isChannelOpen,
      this.changeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TrendingTopicsProvider>(
      builder: (BuildContext context, topicsProvider, Widget? child) {
        return Column(
          children: [
            TrendingTopicsHeader(),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 40,
                child: FutureBuilder(
                    future: topicsProvider.trendingTopicsFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        print("trending toics null");
                        return hashtagPlaceholder();
                      } else {
                        print("trending toics not null ${snapshot.data}");
                        return ListView.builder(
                            addAutomaticKeepAlives: false,
                            scrollDirection: Axis.horizontal,
                            itemCount: topicsProvider.topics.length,
                            itemBuilder: (context, index) {
                              return TrendingTopicList(
                                color: topicsProvider.topics[index].color,
                                hashtag: AppLocalizations.of(
                                    topicsProvider.topics[index].hashtag!),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DiscoverFromTagsView(
                                          tag: topicsProvider
                                              .topics[index].hashtag,
                                          changeColor: this.changeColor!,
                                          isChannelOpen: this.isChannelOpen!,
                                          profileOpen: this.profileOpen!,
                                          setNavBar: this.setNavBar!,
                                        ),
                                      ));
                                },
                              );
                            });
                      }
                    }),
              ),
            )
          ],
        );
      },
    );
  }
}
