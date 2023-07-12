import 'package:bizbultest/services/Properbuz/tradesmen_results_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Language/appLocalization.dart';
import '../../../../services/Properbuz/add_tradesman_controller.dart';
import '../../../../utilities/colors.dart';
import '../../../../view/Properbuz/add_items/add_album_image_view.dart';

class GalleryTab extends GetView<TradesmenResultsController> {
  bool? iscompany;
  GalleryTab({Key? key, this.iscompany}) : super(key: key);

  // AddTradesmenController ctr = Get.put(AddTradesmenController());

  @override
  Widget build(BuildContext context) {
    // Get.put(TradesmenResultsController());
    print("iscompany=${iscompany}");
    return Container(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: !this.iscompany! && controller.tradesmenAlbumListSolo.length > 0
            ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.tradesmenAlbumListSolo.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      shape: BoxShape.rectangle,
                      border: new Border.all(
                        color: settingsColor,
                        width: 0.5,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      onTap: () {
                        List images = controller
                            .tradesmenAlbumListSolo[index].images!
                            .split(',');
                        images = images
                            .map((e) => controller.tradesmanpicurl + e)
                            .toList();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddImageAlbumView(
                                    // ctr.lstAlubmData[index].albumImage,
                                    images,
                                    // ctr.lstAlubmData[index].albumId,
                                    controller.tradesmenAlbumListSolo[index].id
                                        .toString(),
                                    "galleryTab",
                                    controller.tradesmenAlbumListSolo[index]
                                        .albumName!)));
                      },
                      leading: Container(
                        height: 60,
                        width: 60,
                        child: CircleAvatar(
                          backgroundColor: settingsColor,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: controller.tradesmanpicurl +
                                  controller
                                      .tradesmenAlbumListSolo[index].albumPic!,
                              fit: BoxFit.fill,
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        AppLocalizations.of(controller
                            .tradesmenAlbumListSolo[index].albumName
                            .toString()),
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward_ios_rounded)),
                    ),
                  );
                })
            : this.iscompany! && controller.tradesmenAlbumListCompany.length > 0
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.tradesmenAlbumListCompany.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          shape: BoxShape.rectangle,
                          border: new Border.all(
                            color: settingsColor,
                            width: 0.5,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          onTap: () {
                            List images = controller
                                .tradesmenAlbumListCompany[index].images!
                                .split(',');
                            images = images
                                .map((e) => controller.tradesmanpicurl + e)
                                .toList();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddImageAlbumView(
                                        // ctr.lstAlubmData[index].albumImage,
                                        images,
                                        // ctr.lstAlubmData[index].albumId,
                                        controller
                                            .tradesmenAlbumListCompany[index].id
                                            .toString(),
                                        "galleryTab",
                                        controller
                                            .tradesmenAlbumListCompany[index]
                                            .albumName!)));
                          },
                          leading: Container(
                            height: 60,
                            width: 60,
                            child: CircleAvatar(
                              backgroundColor: settingsColor,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: controller.tradesmanpicurl +
                                      controller
                                          .tradesmenAlbumListCompany[index]
                                          .albumPic!,
                                  fit: BoxFit.fill,
                                  height: 60,
                                  width: 60,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            AppLocalizations.of(controller
                                .tradesmenAlbumListCompany[index].albumName
                                .toString()),
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios_rounded)),
                        ),
                      );
                    })
                : Center(
                    child: Text(AppLocalizations.of("No Album Added Yet..!"))),
      ),
    );
  }
}
