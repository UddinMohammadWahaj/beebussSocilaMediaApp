import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzerfeedexpandedcontroller.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedcontroller.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedmaincontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Buzzfeed/bezzfeedlocationpage.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedgallery.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedgif.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedview.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_property_search_view.dart';
import 'package:bizbultest/widgets/Newsfeeds/feed_body.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/custom_textfield.dart';
import 'package:bizbultest/widgets/shortbuz_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:helpers/helpers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';

import 'buzzfeedplayer.dart';

class BuzzfeedUploadPost extends StatefulWidget {
  BuzzerfeedMainController? buzzfeedmaincontroller;
  String? purpose;
  String? buzzerfeedId;
  String? from;
  String? edittext = '';
  var editfiles = [];
  var edittype = '';
  String? editbuzzerfeedid = '';
  var editIndex;
  Tweet? retweetpost;
  String? replymemberId;
  BuzzerfeedExpandedController? buzzerfeedExpandedController;
  BuzzfeedUploadPost(
      {Key? key,
      this.replymemberId,
      this.buzzerfeedExpandedController,
      this.buzzfeedmaincontroller,
      this.editIndex,
      this.from = '',
      this.retweetpost,
      this.purpose = "post_upload",
      this.buzzerfeedId = "",
      this.editfiles = const [],
      this.edittext,
      this.editbuzzerfeedid,
      this.edittype = ''})
      : super(key: key);

  @override
  State<BuzzfeedUploadPost> createState() => _BuzzfeedUploadPostState();
}

class _BuzzfeedUploadPostState extends State<BuzzfeedUploadPost> {
  @override
  void dispose() {
    Get.delete<BuzzerfeedController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(BuzzerfeedController(
        editbuzzerfeedid: widget.editbuzzerfeedid,
        editIndex: widget.editIndex,
        purpose: widget.purpose,
        editfiles: widget.editfiles,
        edittext: widget.edittext,
        edittype: widget.edittype));

    Widget retweetCard() {
      return InkWell(
        onTap: () {},
        child: Container(
            color: Colors.yellow,
            // height: 10.0.h,
            // width: 88.0.w,
            child: widget.retweetpost),
      );
    }

    Widget imageCard(index) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Obx(() => Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        // color: Colors.red,
                        width: controller.listoffiles.length == 1
                            ? 75.0.w
                            : 30.0.w,
                        height: controller.listoffiles.length == 1
                            ? 45.0.h
                            : 20.0.h,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: controller.listoffiles[index]
                                    .contains('https://')
                                ? CachedNetworkImage(
                                    imageUrl: controller.listoffiles[index],
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(controller.listoffiles[index]),
                                    fit: BoxFit.cover,
                                  )),
                      ),
                    ],
                  )

              //  Container(
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //           color: Colors.black,
              //         ),
              //         borderRadius: BorderRadius.all(Radius.circular(20))),
              //     key: Key('$index'),
              //     width: controller.listoffiles.length == 1 ? 65.0.w : 35.0.w,
              //     padding: EdgeInsets.all(9.0),
              //     height: controller.listoffiles.length == 1 ? 55.0.h : 25.0.h,
              //     child: Image.file(
              //       controller.listoffiles[index],
              //       fit: BoxFit.cover,
              //     )

              //     // Image.network(
              //     //   'https://images.unsplash.com/photo-1525134479668-1bee5c7c6845?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8cmFuZG9tJTIwcGVvcGxlfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
              //     //   fit: BoxFit.cover,
              //     // ),
              //     ),
              ),
          widget.purpose == "post_edit"
              ? Container(
                  width: 30.0.w,
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      print("clicked remove");
                      controller.showImage.value = true;
                      // controller.resetGif();
                      // controller.resetPoll();
                      // controller.resetVideo();

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FeedPostGallery(
                          buzzcontroller: controller,
                          isImage: true,
                          purpose: "post_edit",
                          index: index,
                        ),
                      ));

                      // temp = controller.listoffiles.value;
                      // if (temp.length != 0) {
                      //   temp.removeAt(index);
                      //   print("$index removed templength=${temp.length}");
                      //   controller.listoffiles.value = temp;
                      //   controller.listoffiles.refresh();
                      // }
                      // if (controller.listoffiles.length == 0)
                      //   controller.toggleShowImage();
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.7),
                        child: Icon(
                          Icons.edit,
                          size: 3.0.h,
                          color: Colors.white,
                        )),
                    // ),
                  )

                  //  IconButton(
                  //     alignment: Alignment.topRight,
                  //     onPressed: () {
                  //       var temp = [];
                  //       temp = controller.listoffiles.value;
                  //       temp.removeAt(index);
                  //       print("$index removed templength=${temp.length}");
                  //       controller.listoffiles.value = temp;
                  //       if (controller.listoffiles.length == 0)
                  //         controller.toggleShowImage();
                  //     },
                  //     icon: Icon(
                  //       Icons.close_rounded,
                  //       size: 3.0.h,
                  //       color: Colors.black,
                  //     )),
                  )
              : Container(
                  width: 30.0.w,
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      print("clicked remove");

                      var temp = [];

                      temp = controller.listoffiles.value;
                      if (temp.length != 0) {
                        temp.removeAt(index);
                        print("$index removed templength=${temp.length}");
                        controller.listoffiles.value = temp;
                        controller.listoffiles.refresh();
                      }
                      if (controller.listoffiles.length == 0)
                        controller.toggleShowImage();
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.7),
                        child: Icon(
                          Icons.close_rounded,
                          size: 3.0.h,
                          color: Colors.white,
                        )),
                    // ),
                  )

                  //  IconButton(
                  //     alignment: Alignment.topRight,
                  //     onPressed: () {
                  //       var temp = [];
                  //       temp = controller.listoffiles.value;
                  //       temp.removeAt(index);
                  //       print("$index removed templength=${temp.length}");
                  //       controller.listoffiles.value = temp;
                  //       if (controller.listoffiles.length == 0)
                  //         controller.toggleShowImage();
                  //     },
                  //     icon: Icon(
                  //       Icons.close_rounded,
                  //       size: 3.0.h,
                  //       color: Colors.black,
                  //     )),
                  ),
        ],
      );
    }

    Widget gifCard() {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Obx(() => Stack(
                    children: [
                      Container(
                        width: 75.0.w,
                        height: 25.0.h,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: OptimizedCacheImage(
                              imageUrl: controller.currentGif.value,
                              placeholder: (context, url) => Container(
                                  width: 75.0.w,
                                  height: 25.0.h,
                                  color: Colors.grey[300],
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          controller.currentGifPreview.value,
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                              fit: BoxFit.contain,
                            )),
                      ),
                    ],
                  )

              //  Container(
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //           color: Colors.black,
              //         ),
              //         borderRadius: BorderRadius.all(Radius.circular(20))),
              //     key: Key('$index'),
              //     width: controller.listoffiles.length == 1 ? 65.0.w : 35.0.w,
              //     padding: EdgeInsets.all(9.0),
              //     height: controller.listoffiles.length == 1 ? 55.0.h : 25.0.h,
              //     child: Image.file(
              //       controller.listoffiles[index],
              //       fit: BoxFit.cover,
              //     )

              //     // Image.network(
              //     //   'https://images.unsplash.com/photo-1525134479668-1bee5c7c6845?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8cmFuZG9tJTIwcGVvcGxlfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
              //     //   fit: BoxFit.cover,
              //     // ),
              //     ),
              ),
          Container(
              width: 30.0.w,
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  controller.currentGif.value = '';
                  controller.selectedGif.value = false;
                },
                child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.7),
                    child:

                        //  IconButton(
                        //     onPressed: () {

                        //       // var temp = [];
                        //       // temp = controller.listoffiles.value;
                        //       // temp.removeAt(index);
                        //       // print("$index removed templength=${temp.length}");
                        //       // controller.listoffiles.value = temp;
                        //       // if (controller.listoffiles.length == 0)
                        //       //   controller.toggleShowImage();
                        //     },
                        // icon:
                        Icon(
                      Icons.close_rounded,
                      size: 3.0.h,
                      color: Colors.white,
                    )),
                // ),
              )),
        ],
      );
    }

    Widget listofimagecard() {
      // return Container();
      return Obx(() => controller.listoffiles.length > 0
          ? Container(
              width: 80.0.w,
              height: 60.0.h,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  width: 1.0.w,
                ),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: (widget.purpose == "edit")
                    ? controller.editfiles.length
                    : controller.listoffiles.value.length,
                itemBuilder: (context, index) => imageCard(index),
              ))
          : Container());
    }

    Widget listIcons() {
      return Container(
        color: Colors.white,
        height: 10.0.h,
        width: 100.0.w,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  controller.showImage.value = true;
                  controller.resetGif();
                  controller.resetPoll();
                  controller.resetVideo();

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FeedPostGallery(
                      buzzcontroller: controller,
                      isImage: true,
                    ),
                  ));
                },
                icon: Icon(
                  Icons.photo_outlined,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  controller.showVideo.value = true;
                  controller.resetGif();
                  controller.resetPoll();
                  controller.resetImage();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FeedPostGallery(
                      buzzcontroller: controller,
                      isImage: false,
                    ),
                  ));
                },
                icon: Icon(
                  Icons.videocam,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () async {
                  // controller.selectedGif.value = !controller.selectedGif.value;
                  controller.selectedGif.value = true;
                  controller.resetImage();
                  controller.resetPoll();
                  controller.resetVideo();
                  var currentGif = await GiphyGet.getGif(
                    context: context, //Required
                    apiKey: "zONCyRNgg6IGXkmoHG7Yy1RxRgvTtPx5", //Required.
                    //Optional - Language for query.
                    // Optional - An ID/proxy for a specific user.
                    tabColor: Colors.teal,

                    // Optional- default accent color.
                  );
                  controller.currentGif.value =
                      currentGif!.images!.original!.webp!;
                  controller.currentGifPreview.value =
                      currentGif!.images!.previewWebp!.url;
                  controller.currentGif.refresh();
                  controller.currentGifPreview.refresh();
                  print("currentGif=${currentGif.images!.original!.webp}");
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => BuzzerfeedGif(
                  //     controller: controller,
                  //   ),
                  // ));
                },
                icon: Icon(
                  Icons.gif_sharp,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  controller.togglePoll();
                  controller.resetVideo();
                  controller.resetGif();
                  // controller.resetImage();
                  controller.showImage.value = false;
                  controller.listoffiles.value = [];
                  controller.listoffiles.refresh();
                },
                icon: Icon(
                  Icons.poll_outlined,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          BuzzFeedLocation(controller: controller)
                      // LocationSearchPageAdd(),
                      ));
                },
                icon: Obx(
                  () => Icon(
                    !controller.locationselected.value
                        ? Icons.location_on_outlined
                        : Icons.location_on,
                    color: Colors.black,
                  ),
                ))
          ],
        ),
      );
    }

    void showPrivacy() async {
      await showModalBottomSheet(
          context: context,
          builder: (context) => ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Center(
                  child: Container(
                    color: Colors.white,
                    width: Get.width,
                    height: Get.height / 2,
                    child: Container(
                      child: Column(
                        children: [
                          ListTile(
                            subtitle: Text(
                              AppLocalizations.of(
                                  'Pick who can reply to this Buzz. Keep in mind that anyone mentioned can always reply'),
                              maxLines: 10,
                            ),
                            title: Text(
                              AppLocalizations.of('Who can reply?'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          ListTile(
                            tileColor:
                                // (controller.currentPrivacy.value ==
                                //         "${privacy.public}")
                                //     ?
                                Colors.pink,
                            // : Colors.white,
                            onTap: () {
                              controller.currentPrivacy.value =
                                  "${privacy.public}";
                              Navigator.of(context).pop();
                            },
                            leading: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  child: Icon(
                                    Icons.public_outlined,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                                Obx(() => controller.currentPrivacy.value ==
                                        "${privacy.public}"
                                    ? Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.green,
                                      )
                                    : SizedBox(
                                        height: 0,
                                        width: 0,
                                      ))
                              ],
                            ),
                            title: Text(
                              AppLocalizations.of('Everyone'),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          ListTile(
                            tileColor: (controller.currentPrivacy.value ==
                                    "${privacy.follow}")
                                ? Colors.black
                                : Colors.white,
                            onTap: () {
                              controller.currentPrivacy.value =
                                  "${privacy.follow}";
                              Navigator.of(context).pop();
                            },
                            leading: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  child: Icon(
                                    Icons.people_outline_sharp,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                                Obx(() => controller.currentPrivacy.value ==
                                        "${privacy.follow}"
                                    ? Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.green,
                                      )
                                    : SizedBox(
                                        height: 0,
                                        width: 0,
                                      ))
                              ],
                            ),
                            title: Text(
                              AppLocalizations.of('People who you follow'),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          ListTile(
                            leading: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  child: Icon(
                                    Icons.manage_accounts_outlined,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                                Obx(() => controller.currentPrivacy.value ==
                                        "${privacy.mention}"
                                    ? Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.green,
                                      )
                                    : SizedBox(
                                        height: 0,
                                        width: 0,
                                      ))
                              ],
                            ),
                            onTap: () {
                              controller.currentPrivacy.value =
                                  "${privacy.mention}";
                              Navigator.of(context).pop();
                            },
                            title: Text(
                              AppLocalizations.of('Only People you mention'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          shape: RoundedRectangleBorder());
    }

    // Widget listofphotos() {
    //   return Container(
    //     decoration: BoxDecoration(
    //         color: Colors.grey,
    //         borderRadius: BorderRadius.all(Radius.circular(8)),
    //         border: Border()),
    //     height: 15.0.h,
    //     width: Get.width,
    //     child: ListView.builder(
    //       shrinkWrap: true,
    //       scrollDirection: Axis.horizontal,
    //       itemCount: 20,
    //       itemBuilder: (context, index) => AspectRatio(
    //         aspectRatio: 1,
    //         child: Container(
    //           color: Colors.white,
    //           child: Center(
    //             child: Icon(
    //               Icons.camera_alt_outlined,
    //               color: Colors.black,
    //             ),
    //           ),
    //           height: 9.5.h,
    //           width: 100,
    //         ),
    //       ),
    //     ),
    //   );
    // }

    Widget customTextField(
        {width: 0.0, height: 0.0, choice: 0, txtcontroller: null}) {
      return Container(
          width: width,
          child: Column(
            children: [
              TextFormField(
                onChanged: (val) {},
                maxLines: null,
                controller: txtcontroller == null
                    ? TextEditingController()
                    : txtcontroller,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: "Choice $choice",
                  //  AppLocalizations.of(
                  //   "Description",
                  // ),
                  hintStyle: TextStyle(color: Colors.black, fontSize: 10.0.sp),
                ),
              ),
              SizedBox(
                height: 2.0.h,
              ),
            ],
          ));
    }

    Widget location() {
      return Column(
        children: [
          Obx(
            () => controller.listoffiles.length != 0 &&
                    controller.showImage.value
                ? Container(
                    width: 75.0.w,
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black)))),
                        onPressed: () {},
                        child: Text(
                          AppLocalizations.of('Who\'s in the photo?'),
                          style: TextStyle(color: Colors.black),
                        )),
                  )
                : SizedBox(),
          ),
          controller.currentCity.value != ''
              ? Container(
                  width: 75.0.w,
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                        Text(
                            '${controller.currentCity},${CurrentUser().currentUser.country}')
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      );
    }

    void pickPollLength() {
      showCupertinoDialog(
        context: Get.context!,
        builder: (context) => Container(
          height: Get.bottomBarHeight * 1.5,
          child: Row(
            children: [],
          ),
        ),
      );
    }

    Widget poll() {
      return Obx(
        () => Card(
          elevation: 5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(2.0.h),
                width: 65.0.w,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            controller.togglePoll();
                          },
                          icon: Icon(Icons.close_rounded, color: Colors.black)),
                    ),
                    ListView.builder(
                      itemCount: controller.currentchoicelength.value,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return customTextField(
                            width: 75.0.w,
                            choice: index,
                            txtcontroller: controller.choicescontroller[index]);
                      },
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          if (controller.currentchoicelength < 4) {
                            controller.currentchoicelength.value =
                                controller.currentchoicelength.value + 1;
                          } else {
                            controller.currentchoicelength.value = 2;
                          }
                        },
                        child: Icon(
                          controller.currentchoicelength.value < 4
                              ? Icons.add_circle
                              : CupertinoIcons.arrow_up_circle_fill,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Divider(
                      height: 0.1.h,
                      thickness: 0.1.h,
                    ),
                    ListTile(
                      onTap: () {
                        // showCupertinoDialog(
                        //   context: context,
                        //   builder: (context) => AlertDialog(
                        //     content: Container(
                        //       height: Get.height / 2,
                        //       width: Get.width / 1.5,
                        //       child: Container(
                        //         child: ListViewBuilder,
                        //       ),
                        //     ),
                        //   ),
                        // );
                        // showDatePicker(
                        //     context: Get.context,
                        //     initialDate: DateTime.now(),
                        //     selectableDayPredicate: (day) {
                        //       return true;
                        //     },
                        //     builder: (BuildContext context, Widget child) {
                        //       return Theme(
                        //         data: ThemeData.light().copyWith(
                        //           primaryColor: const Color(0xFF8CE7F1),
                        //           accentColor: const Color(0xFF8CE7F1),
                        //           colorScheme: ColorScheme.light(
                        //               primary: const Color(0xFF8CE7F1)),
                        //           buttonTheme: ButtonThemeData(
                        //               textTheme: ButtonTextTheme.primary),
                        //         ),
                        //         child: child,
                        //       );
                        //     },
                        //     firstDate: DateTime.now(),
                        //     initialDatePickerMode: DatePickerMode.day,
                        //     lastDate: DateTime.now().add(Duration(days: 365)));

                        // showModalBottomSheet(
                        //   context: context,
                        //   builder: (context) => Center(
                        //     child: Container(
                        //       height: Get.height / 2,
                        //       width: Get.width,
                        //       child: Row(
                        //         children: [
                        //           Column(
                        //             children: [
                        //               Text('Day'),
                        //               Text('1'),
                        //               Text('2')
                        //             ],
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // );
                      },
                      title: Text(AppLocalizations.of('Poll length')),
                      subtitle: Text('${controller.currentPollLength.value}'),
                    )
                    // customTextField(width: 75.0.w, choice: 2),
                    // customTextField(width: 75.0.w, choice: 3),
                    // customTextField(width: 75.0.w, choice: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget videoCard() {
      return Obx(() => controller.listoffiles.length == 0
          ? Container()
          : Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(2.0.w),
                    child: SamplePlayer(
                      url: controller.listoffiles.first,
                    )),
                InkWell(
                  onTap: () {
                    controller.resetVideo();
                  },
                  child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.7),
                      child: Icon(
                        Icons.close_rounded,
                        size: 3.0.h,
                        color: Colors.white,
                      )),
                ),
              ],
            ));
    }

    Widget mentionTile({name: "Name", memberId: "memberId"}) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black,
        ),
        onTap: () {
          controller.showMentions.value = false;
        },
        title: Text('$name'),
      );
    }

    Widget showMentions() {
      return Container(
        height: Get.height / 3.5,
        width: Get.width,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) => mentionTile()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Get.delete<BuzzerfeedController>();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                )),
            ElevatedButton(
              onPressed: () async {
                // if (controller.getcurrentposttype() == "poll" &&
                //     controller.descriptioncontroller.value.text == "") {
                //   Get.snackbar('Error', 'Enter Description',
                //       backgroundColor: Colors.white,
                //       icon: Icon(Icons.error_outline, color: Colors.red));
                //   Get.snackbar('Success', 'Commented successfully',
                //       backgroundColor: Colors.white,
                //       icon: Icon(Icons.check_box_rounded, color: Colors.black));
                //   return;
                // }
                if (widget.purpose == "retweet") {
                  Navigator.of(context).pop();

                  await controller.requoteBuzz();
                  widget.buzzfeedmaincontroller!
                      .fetchFirstPost(controller.recentid);
                  Get.snackbar(AppLocalizations.of('Success'),
                      AppLocalizations.of('Quote Buzzed successfully!!'),
                      backgroundColor: Colors.white,
                      icon: Icon(Icons.check_box_rounded, color: Colors.black));
                  return;
                }
                if (widget.purpose == "post_edit") {
                  widget.buzzfeedmaincontroller!.isUpload.value = true;
                  Navigator.of(context).pop();

                  await controller.updateData();
                  Get.snackbar(AppLocalizations.of('Success'),
                      AppLocalizations.of('Buzz Updated successfully'),
                      backgroundColor: Colors.white,
                      icon: Icon(Icons.check_box_rounded, color: Colors.black));
                  widget.buzzfeedmaincontroller!.fetchFirstPost(
                      controller.recentid,
                      type: "edit",
                      index: widget.editIndex);
                  // widget.buzzfeedmaincontroller.isUpload.value = false;
                  return;
                }
                if (widget.purpose == "comment_upload_reply") {
                  Navigator.of(context).pop();
                  print("commentid  id=${widget.buzzerfeedId}");
                  await controller.postCommentReply(
                      widget.buzzerfeedId, widget.replymemberId);
                  // if (widget.from == "expanded")
                  //   widget.buzzerfeedExpandedController.getRecentComment(widget.buzzerfeedId);
                  Get.snackbar(AppLocalizations.of('Success'),
                      AppLocalizations.of('Reply successfully'),
                      backgroundColor: Colors.white,
                      icon: Icon(Icons.check_box_rounded, color: Colors.black));

                  return;
                }
                if (widget.purpose == "comment_upload") {
                  Navigator.of(context).pop();
                  var id = await controller.postComment(widget.buzzerfeedId);
                  if (widget.from == "expanded")
                    widget.buzzerfeedExpandedController!.getRecentComment(id);
                  Get.snackbar(AppLocalizations.of('Success'),
                      AppLocalizations.of('Commented successfully'),
                      backgroundColor: Colors.white,
                      icon: Icon(Icons.check_box_rounded, color: Colors.black));

                  return;
                }
                Navigator.of(context).pop();

                await controller.sendData();

                widget.buzzfeedmaincontroller!
                    .fetchFirstPost(controller.recentid);
                Get.snackbar(AppLocalizations.of('Success'),
                    AppLocalizations.of('Uploaded successfully'),
                    backgroundColor: Colors.white,
                    icon: Icon(Icons.check_box_rounded, color: Colors.black));
              },
              child: Text((widget.purpose == "comment_upload")
                  ? AppLocalizations.of('Reply')
                  : (widget.purpose == "post_edit")
                      ? AppLocalizations.of("Update")
                      : (widget.purpose == 'retweet')
                          ? AppLocalizations.of('Quote')
                          : AppLocalizations.of('BUZzz')),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black)))),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.pink,
          // height: Get.height,
          // width: 90.w,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // width: 90.w,
              // margin: EdgeInsets.all(9),
              // child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 7.5.w,
                    backgroundColor: Colors.black,
                    backgroundImage:
                        NetworkImage(CurrentUser().currentUser.image!),
                  ),
                  Column(children: [
                    Container(
                      width: 80.0.w,
                      margin: EdgeInsets.only(right: 5),
                      child: RawKeyboardListener(
                        focusNode: FocusNode(),
                        onKey: (RawKeyEvent event) {
                          if (event.logicalKey ==
                                  LogicalKeyboardKey.backspace &&
                              controller.descriptioncontroller.value.text ==
                                  '@') {
                            widget.buzzfeedmaincontroller!.resetTag();
                            controller.showMentions.value = false;
                            print('backspace clicked');
                          }
                        },
                        child: TextFormField(
                          onChanged: (val) async {
                            // print("i am here @ text=$val length-${val.length}");
                            // if ((val == '@' && val.length == 1) ||
                            //     (val[val.length - 1] == '@' &&
                            //         val[val.length - 2] == ' ')) {
                            //   print("i am here @ text=$val");
                            //   controller.showMentions.value = true;
                            // } else
                            //   controller.showMentions.value = false;
                            if (!val.contains('@') ||
                                val[val.length - 1] == ' ')
                              widget.buzzfeedmaincontroller!.tag.value =
                                  val[val.length - 1];
                            else {
                              widget.buzzfeedmaincontroller!.tag.value +=
                                  val[val.length - 1];
                            }
                            print(
                                "current text start= ${widget.buzzfeedmaincontroller!.tag.value} tag.value[0]=${widget.buzzfeedmaincontroller!.tag.value[0]}, val=$val controller=${controller.descriptioncontroller.text}");
                            if (!widget.buzzfeedmaincontroller!.checkTag() &&
                                controller.descriptioncontroller.text != '') {
                              widget.buzzfeedmaincontroller!.resetTag();
                              controller.showMentions.value = false;
                            } else {
                              controller.showMentions.value = true;
                            }
                            print(
                                "current text end= ${widget.buzzfeedmaincontroller!.tag.value}");
                          },
                          maxLines: null,
                          // initialValue: controller.description.value != ''
                          //     ? controller.description.value
                          //     : null,
                          controller: controller.descriptioncontroller,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                            hintText: widget.purpose == "comment_upload"
                                ? AppLocalizations.of("Buzz your reply")
                                : AppLocalizations.of("What\'s happening ?"),
                            //  AppLocalizations.of(
                            //   "Description",
                            // ),
                            hintStyle: TextStyle(
                                color: Colors.grey, fontSize: 15.0.sp),
                          ),
                        ),
                      ),
                    ),
                    Obx(() => controller.showVideo.value
                        ? videoCard()
                        : SizedBox(
                            height: 0,
                          )),
                    Obx(() => controller.showImage.value
                        ? Column(
                            children: [
                              listofimagecard(),
                            ],
                          )
                        : Container()),
                    Obx(() => !controller.showImage.value &&
                            controller.selectedGif.value &&
                            controller.selectedGif.value &&
                            controller.currentGif.value != ''
                        ? gifCard()
                        : Container()),
                    Obx(() => controller.currentCity.value != '' &&
                            controller.locationselected.value
                        ? location()
                        : Container()),
                    Obx(() => controller.showPoll.value ? poll() : Container()),
                  ]),
                ],
              ),
              (widget.purpose == "retweet") ? retweetCard() : Container()
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => controller.showMentions.value
            ? showMentions()
            : Container(
                // margin: EdgeInsets.only(top: 4.0.h),
                height: Get.height / 5.3,
                width: Get.width,
                decoration: BoxDecoration(
                  // color: Colors.yellow,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                  border: Border.fromBorderSide(
                      BorderSide(color: Colors.black, width: 1.0)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      width: Get.width,
                      color: Colors.white,
                      child: GestureDetector(
                        onTap: () {
                          showPrivacy();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.public_outlined,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 2.0.h,
                            ),
                            Obx(
                              () => Text(
                                controller.currentPrivacy.value ==
                                        '${privacy.public}'
                                    ? AppLocalizations.of('Everyone can reply')
                                    : controller.currentPrivacy.value ==
                                            '${privacy.follow}'
                                        ? AppLocalizations.of(
                                            'People you follow can reply')
                                        : AppLocalizations.of(
                                            'People you mention can only reply'),
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      // child: ElevatedButton(
                      //   style: ButtonStyle*,
                      //   onPressed: () {},
                      //   child: Text(
                      //     'Everyone can reply',
                      //     textAlign: TextAlign.start,
                      //   ),
                      // ),
                    ),
                    listIcons()
                  ],
                ),
                // color: Colors.white,
              ),
      ),
    );
  }
}
