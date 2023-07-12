import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'menu_bottom_sheet.dart';

class UserHeaderCard extends GetView<ProperbuzFeedController> {
  final int? index;
  final int? val;
  final bool? showMenu;
  final Function? setNavbar;
  final Function? changeColor;
  final Function? isChannelOpen;
  const UserHeaderCard(
      {Key? key,
      this.index,
      this.val,
      this.showMenu,
      this.setNavbar,
      this.changeColor,
      this.isChannelOpen})
      : super(key: key);

  Widget _userImageCard() {
    return CircleAvatar(
      radius: 22,
      foregroundColor: featuredColor,
      backgroundColor: featuredColor,
      backgroundImage: CachedNetworkImageProvider(
          controller.getFeedsList(val!)[index!].memberProfile!),
    );
  }

  Widget _userNameCard() {
    return Text(

      controller.getFeedsList(val!)[index!].memberName!,

      // AppLocalizations.of(controller.getFeedsList(val)[index].memberName),

      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
    );
  }

  Widget _userDescriptionCard() {
    return Text(
      "",
      // AppLocalizations.of(
      //     controller.getFeedsList(val)[index].memberDesignation
      //     ),
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade600),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _timeStampCard() {
    return Text(

      controller.getFeedsList(val!)[index!].createdAt!,

      // AppLocalizations.of(controller.getFeedsList(val)[index].createdAt),

      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade600),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _moreCard() {
    return IconButton(
      splashRadius: 20,
      constraints: BoxConstraints(),
      padding: EdgeInsets.symmetric(horizontal: 10),
      onPressed: () {
        Get.bottomSheet(
          MenuBottomSheet(
            goBack: false,
            index: index!,
            val: val!,
          ),
          isScrollControlled: true,
          backgroundColor: Colors.white,
        );
      },
      icon: Icon(Icons.more_vert_outlined),
      color: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Container(
        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                OtherUser().otherUser.memberID = controller
                    .getFeedsList(val!)[index!]
                    .memberId
                    .toString()
                    .replaceAll("@", "");
                OtherUser().otherUser.shortcode = controller
                    .getFeedsList(val!)[index!]
                    .shortcode
                    .toString()
                    .replaceAll("@", "");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePageMain(
                              from: "tags",
                              setNavBar: setNavbar!,
                              isChannelOpen: isChannelOpen!,
                              changeColor: changeColor!,
                              otherMemberID: controller
                                  .getFeedsList(val!)[index!]
                                  .memberId
                                  .toString()
                                  .replaceAll("@", ""),
                            )));
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    _userImageCard(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _userNameCard(),
                          // _userDescriptionCard(),
                          _timeStampCard()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            showMenu! ? _moreCard() : Container()
          ],
        ));
  }
}
