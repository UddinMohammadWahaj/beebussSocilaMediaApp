import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import '../../../Language/appLocalization.dart';
import '../../../services/Properbuz/add_tradesman_controller.dart';

class AddImageAlbumView extends StatefulWidget {
  List image = [];
  String albumId;
  String pageForm;
  String title;
  AddImageAlbumView(this.image, this.albumId, this.pageForm, this.title,
      {Key? key})
      : super(key: key);

  @override
  State<AddImageAlbumView> createState() => _AddImageAlbumViewState();
}

class _AddImageAlbumViewState extends State<AddImageAlbumView> {
  AddTradesmenController ctr = Get.put(AddTradesmenController());

  Widget ImageListView(StateSetter setsate) {
    return ListView.builder(
        itemCount: widget.image.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext ctx, index) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.image[index],
                fit: BoxFit.fill,
                height: 150,
                width: 150,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
          );
        });
  }

  Widget _headerCard(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          header,
          style: TextStyle(
              fontSize: 14, color: settingsColor, fontWeight: FontWeight.w500),
        ));
  }

  Widget _selectionCard(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: 100,
          width: 100.0.w - 20,
          decoration: new BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: settingsColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
          )),
    );
  }

  _photosLengthCard(text) {
    return Positioned.fill(
      left: 20,
      bottom: 10,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: text,
        ),
      ),
    );
  }

  Widget fileImage(File file) {
    return Image.file(
      file,
      fit: BoxFit.cover,
      height: 250,
      width: 100.0.w,
    );
  }

  Widget _photoCard(int index, VoidCallback onTap, Widget view, show) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: view,
            ),
          ),
          show == "yes"
              ? Positioned.fill(
                  right: 10,
                  top: 10,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          splashRadius: 15,
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.all(5),
                          onPressed: onTap,
                          icon: Icon(
                            CupertinoIcons.delete_solid,
                            color: settingsColor,
                            size: 20,
                          ),
                        )),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _photosBuilder() {
    return Obx(
      () => Container(
          child: ctr.photos.isEmpty
              ? _selectionCard(
                  AppLocalizations.of("Select photos from gallery"),
                  () => ctr.pickPhotosFiles(),
                )
              : Container(
                  height: 250,
                  child: Stack(
                    children: [
                      PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ctr.photos.length,
                          itemBuilder: (context, index) {
                            return _photoCard(
                                index,
                                () => ctr.deleteFile(index),
                                fileImage(ctr.photos[index]),
                                "yes");
                          }),
                      _photosLengthCard(
                        Obx(
                          () => Text(
                            // text,
                            "${ctr.photos.length} ${ctr.photosString()}",
                            style: TextStyle(
                                color: settingsColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  Widget netwrokImage(String file) {
    return CachedNetworkImage(
      imageUrl: file,
      fit: BoxFit.cover,
      height: 250,
      width: 100.0.w,
    );
  }

  Widget _photosList() {
    return Container(
        child: widget.image.isEmpty
            ? widget.pageForm == "galleryTab"
                ? Center(
                    child: Text(AppLocalizations.of("No Image Added Yet..!")))
                : Container()
            : Container(
                height: 250,
                child: Stack(
                  children: [
                    PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.image.length,
                        itemBuilder: (context, index) {
                          return _photoCard(index, () => null,
                              netwrokImage(widget.image[index]), "");
                        }),
                    _photosLengthCard(
                      Text(
                        "${widget.image.length} ${widget.image.length == 1 ? AppLocalizations.of("Photo") : AppLocalizations.of("Photos")}",
                        style: TextStyle(
                            color: settingsColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
                    )
                  ],
                ),
              ));
  }

  Future showSuccess(context, msg) async {
    await Get.showSnackbar(GetBar(
      messageText: Text(
        AppLocalizations.of(msg),
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      icon: Icon(
        Icons.done_all_rounded,
        color: Colors.green,
      ),
      duration: Duration(seconds: 3),
    ));
    ctr.photos.value = [];
  }

  void errorView(msg) {
    Get.showSnackbar(GetBar(
      messageText: Text(AppLocalizations.of(msg),
          style: TextStyle(color: Colors.white, fontSize: 20)),
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.error,
        color: Colors.red,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                color: settingsColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                AppLocalizations.of(widget.title),
                style: TextStyle(
                    color: settingsColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Colors.white,
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.keyboard_backspace,
              size: 25,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
              ctr.photos.value = [];
            },
          ),
        ),
        body: StatefulBuilder(
            builder: (context, setState) => Column(
                  mainAxisAlignment:
                      widget.pageForm == "galleryTab" && widget.image.isEmpty
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _photosList(),
                    widget.pageForm == "galleryTab"
                        ? Container()
                        : _headerCard(AppLocalizations.of("Upload Photos")),
                    widget.pageForm == "galleryTab"
                        ? Container()
                        : _photosBuilder(),
                    widget.pageForm == "galleryTab"
                        ? Container()
                        : Obx(
                            () => Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: ctr.photos.isNotEmpty
                                    ? SizedBox(
                                        width: 150,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            String mssg =
                                                await ctr.AddImagesAlbumData(
                                                    widget.albumId, ctr.photos);
                                            print("object.. msg = $mssg");
                                            if (mssg == "false") {
                                              return errorView(AppLocalizations.of(
                                                  "There is Some Issue please try again!"));
                                            } else {
                                              setState(
                                                () async {
                                                  Navigator.pop(context, true);

                                                  showSuccess(context, mssg);
                                                  return setState(
                                                    () {},
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: settingsColor,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.save_alt_outlined),
                                              Text(AppLocalizations.of(
                                                  "Save Images")),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                  ],
                )));
  }
}
