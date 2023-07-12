import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/widgets/FeedPosts/edit_multiple_files.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/models/discover_posts_model.dart';
import 'package:bizbultest/view/discover_feeds_page.dart';
import 'package:flutter/cupertino.dart';
import '../discover_video_player.dart';
import 'grid_image_card.dart';

class DiscoverImageCard extends StatelessWidget {
  final NewsFeedModel? post;
  int? index = 0;
  final String? logo;
  final String? memberID;
  final String? country;
  final String? currentMemberImage;
  final String? stringOfPostID;
  final bool? width;
  final VoidCallback? hideNavbar;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;

  DiscoverImageCard(
      {Key? key,
      this.post,
      this.logo,
      this.memberID,
      this.index,
      this.country,
      this.currentMemberImage,
      this.stringOfPostID,
      this.width,
      this.hideNavbar,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (index == 3) {
      print("important= ${post!.video} index=${index! - 1}");
    }
    return Stack(
      children: [
        post!.shortVideo != 1
            ? Stack(
                children: [
                  GestureDetector(
                      onTap: () {
                        print("Pressed on the video test");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiscoverFeedsPage(
                                      setNavBar: setNavBar!,
                                      isChannelOpen: isChannelOpen!,
                                      changeColor: changeColor!,
                                      currentMemberImage: currentMemberImage!,
                                      listOfPostID: stringOfPostID!,
                                      postID: post!.postId!,
                                      logo: logo!,
                                      country: country!,
                                      memberID: memberID!,
                                      posts: post!,
                                    )));
                      },
                      child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: Image(
                                image: CachedNetworkImageProvider(
                                    post?.postMultiImage == 1
                                        ? post!.postsmlImgData!.split("~~")[0]
                                        : post!.postsmlImgData!),
                                fit: BoxFit.cover),
                          ))),
                  // Text(post.postDomainName,style: TextStyle(color: Colors.green,fontSize: 15,fontWeight: FontWeight.bold),)
                ],
              )
            : Stack(
                children: [
                  post!.postType == "Image" || post!.postType == "blog"
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DiscoverFeedsPage(
                                          setNavBar: setNavBar!,
                                          isChannelOpen: isChannelOpen!,
                                          changeColor: changeColor!,
                                          currentMemberImage:
                                              currentMemberImage!,
                                          listOfPostID: stringOfPostID!,
                                          postID: post!.postId,
                                          logo: logo!,
                                          country: country!,
                                          memberID: memberID!,
                                          posts: post!,
                                        )));
                          },
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              color: Colors.grey.withOpacity(0.2),
                              child: Image(
                                  image: CachedNetworkImageProvider(
                                      post!.postMultiImage == 1
                                          ? post!.postsmlImgData!.split("~~")[0]
                                          : post!.postsmlImgData!),
                                  fit: BoxFit.cover),
                            ),
                          ))
                      : GestureDetector(
                          onTap: hideNavbar ?? () {},
                          child: Container(
                            child: DiscoverVideoPlayer(
                              image: post!.postsmlImgData,
                              url: post!.video,
                            ),
                          ),
                        ),

                  //Text(widget.index.toString(),style: TextStyle(color: Colors.red,fontSize: 30,fontWeight: FontWeight.bold),)

                  //  Text(widget.post.postId,style: TextStyle(color: Colors.black,fontSize: 25),)
                ],
              ),
        post!.postMultiImage == 1
            ? Positioned.fill(
                child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 3.0, right: 3),
                      child: Image.asset(
                        "assets/images/multiple.png",
                        height: 1.0.h,
                      ),
                    )),
              )
            : Container(),
      ],
    );
  }
}
