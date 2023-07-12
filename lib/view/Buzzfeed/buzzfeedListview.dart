import 'package:bizbultest/models/Buzzerfeed/BuzzListDiscoverModel.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedmaincontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedListPageDetailsview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import '../../Language/appLocalization.dart';
import '../../api/api.dart';
import '../../services/BuzzfeedControllers/BuzzerfeedListpagecontroller.dart';
import '../../widgets/Properbuz/utils/header_footer.dart';
import '../Properbuz/menu/user_properties/searched_properties_tab.dart';

class BuzzFeedList extends StatefulWidget {
  var purpose;
  var memberId;
  BuzzerfeedMainController buzzfeedmaincontroller;
  BuzzFeedList(
      {Key? key,
      this.purpose = '',
      this.memberId = '',
      required this.buzzfeedmaincontroller})
      : super(key: key);

  @override
  State<BuzzFeedList> createState() => _BuzzFeedListState();
}

class _BuzzFeedListState extends State<BuzzFeedList>
    with TickerProviderStateMixin {
  var controller = Get.put(BuzzerFeedListPageController());

  RefreshController refreshController1 =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    controller.myListController = new TabController(
        vsync: this, length: 2, initialIndex: controller.currentIndex.value);
    controller.getDiscoverList();
    addLisId();
    // controller.getMyList();
    super.initState();
  }

  addLisId() async {
    print("---- feed_user_id == ${widget.memberId}");
    controller.getMyList(feedMemberId: widget.memberId);
    controller.selectedList.value = [];
    controller.mylist.forEach((element) {
      element.memberStatus == 1
          ? controller.selectedList.value = [
              element.listId,
              ...controller.selectedList
            ]
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _tab(String tabTitle) {
      return Tab(
        text: tabTitle.toUpperCase(),
      );
    }

    Widget _customTextField(
        TextEditingController textEditingController, String labelText) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  labelText,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 45,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                shape: BoxShape.rectangle,
              ),
              child: TextFormField(
                cursorColor: Colors.black,
                autofocus: false,
                controller: textEditingController,
                maxLines: 1,
                keyboardType: TextInputType.text,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  // 48 -> icon width
                ),
              ),
            ),
          ],
        ),
      );
    }

    void showAdd(
        {purpose: '', listname: '', listdescription, image: '', listid: 0}) {
      if (purpose == 'edit') {
        controller.listname.value = TextEditingValue(text: listname);
        controller.description.value = TextEditingValue(text: listdescription);
        controller.imgFilepath.value = image;
      }
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (cntx) {
            return WillPopScope(
              onWillPop: () async {
                Navigator.pop(context);
                setState(() {
                  controller.listname.clear();
                  controller.description.clear();
                });
                return true;
              },
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: 90.0.h,
                    width: 100.0.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.of('Edit'),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 3.0.h,
                                        fontWeight: FontWeight.bold)),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(cntx).pop();
                                    },
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: Colors.black,
                                    ))
                              ],
                            )),
                        _customTextField(
                            controller.listname,
                            AppLocalizations.of('Enter') +
                                ' ' +
                                AppLocalizations.of('List') +
                                ' ' +
                                AppLocalizations.of('Name')),
                        _customTextField(
                            controller.description,
                            AppLocalizations.of('Enter') +
                                ' ' +
                                AppLocalizations.of('List') +
                                ' ' +
                                AppLocalizations.of('Description')),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of('Add') +
                                ' ' +
                                AppLocalizations.of('List') +
                                ' ' +
                                AppLocalizations.of('Image'),
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Obx(() => image != '' &&
                                controller.imgFilepath.value != ''
                            ? Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 30.0.h,
                                    width: 100.0.w,
                                    child: CachedNetworkImage(imageUrl: image),
                                  ),
                                  IconButton(
                                    icon:
                                        Icon(Icons.delete, color: Colors.white),
                                    onPressed: () {
                                      // controller.imgFilepath.value
                                      controller.imgFilepath.value != ''
                                          ? controller.imgFilepath.value = ''
                                          : controller.filepath.value = '';
                                    },
                                  )
                                ],
                              )
                            : controller.filepath.value == ''
                                ? InkWell(
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                              type: FileType.image,
                                              allowMultiple: false);
                                      if (result != null) {
                                        controller.filepath.value =
                                            result.files.single.path!;
                                      }
                                    },
                                    child: Container(
                                      color: Colors.grey.shade100,
                                      height: 30.0.h,
                                      width: 100.0.w,
                                      child: Center(
                                          child:
                                              Icon(Icons.add_a_photo_outlined)),
                                    ),
                                  )
                                : Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        height: 30.0.h,
                                        width: 100.0.w,
                                        child: Image.file(
                                            File(controller.filepath.value)),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          controller.filepath.value = '';
                                        },
                                      )
                                    ],
                                  )),
                        TextButton(
                            child: Obx(() => controller.isLoading.value
                                ? CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : Text(
                                    AppLocalizations.of("Update").toUpperCase(),
                                    style: TextStyle(fontSize: 14))),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side:
                                            BorderSide(color: Colors.black)))),
                            onPressed: () async {
                              controller.editList(() {
                                Navigator.of(cntx).pop();
                                Get.snackbar(
                                    AppLocalizations.of('Success'),
                                    AppLocalizations.of(
                                        'List updated Successfully!!'),
                                    duration: Duration(seconds: 2));
                              }, listid);
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    }

    Widget tab1() {
      return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Obx(
            () => controller.disCoverListLoder.isTrue
                ? Center(child: Container(child: loadingAnimation()))
                : controller.discovernewlist.length == 0
                    ? Center(child: Text("No Discover List available yet..!!"))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.discovernewlist.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              maxRadius: 40,
                              backgroundColor: Colors.black,
                              backgroundImage: CachedNetworkImageProvider(
                                  controller.discovernewlist[index].images! ==
                                          ''
                                      ? controller
                                          .discovernewlist[index].userPicture!
                                      : controller
                                          .discovernewlist[index].images!),
                            ),
                            title: Text(
                                '${controller.discovernewlist[index].name}'),
                            subtitle: Text(
                                '@${controller.discovernewlist[index].shortcode}'),
                            trailing: InkWell(
                              onTap: () async {
                                controller.discovernewlist[index].isFollowing!
                                        .value =
                                    !controller.discovernewlist[index]
                                        .isFollowing!.value;
                                print(
                                    "response of url=https://www.bebuzee.com/api/buzzerfeed/listFollowUnfollow?list_id=${controller.discovernewlist[index].listId}&user_id=${CurrentUser().currentUser.memberID}");
                                var response = await ApiProvider().fireApi(
                                    'https://www.bebuzee.com/api/buzzerfeed/listFollowUnfollow?list_id=${controller.discovernewlist[index].listId}&user_id=${CurrentUser().currentUser.memberID}');
                                print(
                                    "response of follow list=${controller.discovernewlist[index].isFollowing!.value}");
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                    color: Colors.black,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Obx(
                                        () => Text(
                                          '${controller.discovernewlist[index].isFollowing!.value ? AppLocalizations.of("Following") : AppLocalizations.of('Follow')}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          );
                        },
                      ),
          ));
    }

    Widget tab2() {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Obx(
          () => controller.myListLoder.isTrue
              ? Center(child: Container(child: loadingAnimation()))
              : Container(
                  child: controller.mylist.length == 0
                      ? Center(
                          child:
                              Text(AppLocalizations.of('Your List is Empty')),
                        )
                      : ListView.builder(
                          itemCount: controller.mylist.length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) => ListTile(
                            onTap: () async {
                              print("-------tapped on list");

                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                    builder: (context) =>
                                        BuzzfeedListDetailView(
                                            edit: showAdd,
                                            mylistdata:
                                                controller.mylist[index],
                                            buzzfeedmaincontroller:
                                                widget.buzzfeedmaincontroller),
                                  ))
                                  .then((value) => controller.getMyList());
                            },
                            leading: CircleAvatar(
                                maxRadius: 40,
                                backgroundColor: Colors.black,
                                backgroundImage: CachedNetworkImageProvider(
                                    controller.mylist[index].images!)),
                            title: Text('${controller.mylist[index].name}'),
                            subtitle:
                                Text('@${controller.mylist[index].shortcode}'),
                          ),
                        ),
                ),
        ),
      );
    }

    Future<String> addList(listId) async {
      // var listId = controller.mylist[controller.selctedListIndex].listId;
      print("---- ${widget.memberId}");
      print(
          "====== 'https://www.bebuzee.com/api/buzzerfeed/listUserAddRemove?list_id=$listId&user_id=${CurrentUser().currentUser.memberID}&list_user_id=${widget.memberId}");
      var response = await ApiProvider().fireApi(
          'https://www.bebuzee.com/api/buzzerfeed/listUserAddRemove?list_id=$listId&user_id=${CurrentUser().currentUser.memberID}&list_user_id=${widget.memberId}');
      Navigator.of(context).pop();
      print("response of add to lis---=${response.data}");
      return response.data['message'];
    }

    selectedListId(int index) {
      !controller.selectedList.contains(controller.mylist[index].listId)
          ? controller.selectedList.value = [
              controller.mylist[index].listId,
              ...controller.selectedList
            ]
          : controller.selectedList.remove(controller.mylist[index].listId);
    }

    Widget tab3() {
      // controller.selctedListIndex = -1;
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Obx(
          () => controller.myListLoder.isTrue
              ? Center(child: Container(child: loadingAnimation()))
              : controller.mylist.length == 0
                  ? Center(
                      child: Text(AppLocalizations.of('Your List is Empty')),
                    )
                  : ListView.builder(
                      itemCount: controller.mylist.length,
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) => ListTile(
                        trailing:
                            // controller.mylist[index].memberStatus == 1
                            Obx(
                          () => controller.selectedList
                                  .contains(controller.mylist[index].listId)
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedListId(index);
                                    });
                                  },
                                  color: Colors.blue,
                                  icon: Icon(Icons.check_box))
                              // : controller.selctedListIndex == index
                              // ?
                              // IconButton(
                              //     onPressed: () {
                              //       setState(() {
                              //         controller.selctedListIndex = -1;
                              //       });
                              //     },
                              //     color: Colors.blue,
                              // icon: Icon(Icons.check_box))
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedListId(index);
                                    });
                                  },
                                  icon: Icon(Icons.check_box_outline_blank)),
                        ),
                        leading: CircleAvatar(
                            maxRadius: 40,
                            backgroundColor: Colors.black,
                            backgroundImage: CachedNetworkImageProvider(
                                // controller.mylist[index].images == ''
                                //     ? controller
                                //         .mylist[index].userPicture
                                //     : controller
                                //         .discovernewlist[index].images,
                                controller.mylist[index].images!)),
                        title: Text('${controller.mylist[index].name}'),
                        subtitle:
                            Text('@${controller.mylist[index].shortcode}'),
                      ),
                    ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        // physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
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
              actions: [
                widget.purpose == 'add'
                    ? IconButton(
                        onPressed: () async {
                          print("----## ${controller.selectedList}");
                          var data = controller.selectedList.join(",");
                          print("----** $data");
                          var msg = await addList(data);
                          controller.getMyList();

                          // var selectedList = controller.mylist
                          //     .where((p0) => p0.isSelected.value == true)
                          //     .toList();

                          // String selectedListString =
                          //     selectedList.map((e) => e.listId).toString();
                          // selectedListString = selectedListString.substring(
                          //     1, selectedListString.length - 1);
                          // print(
                          //     "member added listid=$selectedListString  'https://www.bebuzee.com/api/buzzerfeed/listUserAddRemove?user_id=${widget.memberId}&list_id=${selectedListString}");
                          // var response = await ApiProvider()
                          //     .fireApi(
                          //         'https://www.bebuzee.com/api/buzzerfeed/listUserAddRemove?user_id=${widget.memberId}&list_id=${selectedListString}')
                          //     .then((value) => value);
                          // print("member added to list =${response.data}");
                          // Navigator.of(context).pop();
                          Get.snackbar(AppLocalizations.of("Success"),
                              AppLocalizations.of(msg),
                              duration: Duration(seconds: 2));
                        },
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
                        ))
                    : Container()
              ],
              toolbarHeight: 50,
              titleSpacing: 5,
              pinned: true,
              floating: true,
              elevation: 0,
              brightness: Brightness.dark,
              backgroundColor: Colors.white,
              title: Text(
                '${widget.purpose == 'add' ? AppLocalizations.of("Add") + " " + AppLocalizations.of("to") + "  " + AppLocalizations.of("List") : AppLocalizations.of("Buzz") + "  " + AppLocalizations.of("List")}',
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
              bottom: widget.purpose == 'add'
                  ? null
                  : PreferredSize(
                      preferredSize: Size.fromHeight(48),
                      child: TabBar(
                        indicatorColor: Colors.black,
                        labelColor: Colors.black,
                        labelStyle: TextStyle(
                            fontSize: 10.0.sp, fontWeight: FontWeight.w500),
                        unselectedLabelColor: Colors.grey.shade600,
                        controller: controller.myListController,
                        onTap: (index) =>
                            controller.switchUserPropertyTabs(index),
                        tabs: [
                          _tab(
                            AppLocalizations.of("Discover") +
                                " " +
                                AppLocalizations.of("List"),
                          ),
                          _tab(
                            AppLocalizations.of("My List"),
                          ),
                        ],
                      )),
              automaticallyImplyLeading: false,
            ),
          ];
        },
        body: widget.purpose == 'add'
            ? tab3()
            : Obx(
                () => IndexedStack(
                  index: controller.currentIndex.value,
                  children: [
                    tab1(),
                    tab2(),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.small(
          backgroundColor: Colors.black,
          child: Icon(Icons.add_circle_outlined),
          onPressed: () {
            setState(() {
              controller.listname.clear();
              controller.description.clear();
              controller.filepath.value = '';
            });
            showModalBottomSheet(
                context: context,
                enableDrag: false,
                isScrollControlled: true,
                // isDismissible: true,
                builder: (ctx) {
                  return SingleChildScrollView(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 90.0.h,
                        width: 100.0.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        AppLocalizations.of('Create') +
                                            ' ' +
                                            AppLocalizations.of('a') +
                                            ' ' +
                                            AppLocalizations.of('New') +
                                            ' ' +
                                            AppLocalizations.of('List'),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 3.0.h,
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        icon: Icon(
                                          Icons.close_rounded,
                                          color: Colors.black,
                                        ))
                                  ],
                                )),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Text(AppLocalizations.of('List Name')),
                            // ),
                            _customTextField(
                                controller.listname,
                                AppLocalizations.of('Enter') +
                                    ' ' +
                                    AppLocalizations.of('List') +
                                    ' ' +
                                    AppLocalizations.of('Name')),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child:
                            //       Text(AppLocalizations.of('List Description')),
                            // ),
                            _customTextField(
                                controller.description,
                                AppLocalizations.of('Enter') +
                                    ' ' +
                                    AppLocalizations.of('List') +
                                    ' ' +
                                    AppLocalizations.of('Description')),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of('Add') +
                                    ' ' +
                                    AppLocalizations.of('List') +
                                    ' ' +
                                    AppLocalizations.of('Image'),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Obx(() => controller.filepath.value == ''
                                  ? InkWell(
                                      onTap: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                                type: FileType.image,
                                                allowMultiple: false);
                                        if (result != null) {
                                          controller.filepath.value =
                                              result.files.single.path!;
                                        }
                                      },
                                      child: Container(
                                        color: Colors.grey.shade100,
                                        height: 30.0.h,
                                        width: 100.0.w,
                                        child: Center(
                                            child: Icon(
                                                Icons.add_a_photo_outlined)),
                                      ),
                                    )
                                  : Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          height: 30.0.h,
                                          width: 100.0.w,
                                          child: Image.file(
                                              File(controller.filepath.value)),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            controller.filepath.value = '';
                                          },
                                        )
                                      ],
                                    )),
                            ),
                            TextButton(
                                child: Obx(() => controller.isLoading.value
                                    ? CircularProgressIndicator(
                                        color: Colors.black,
                                      )
                                    : Text(
                                        AppLocalizations.of("Create")
                                                .toUpperCase() +
                                            " " +
                                            AppLocalizations.of("List")
                                                .toUpperCase(),
                                        style: TextStyle(fontSize: 14))),
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(15)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.black)))),
                                onPressed: () async {
                                  controller.createList(() {
                                    Navigator.of(ctx).pop();
                                    Get.snackbar(
                                        AppLocalizations.of('Success'),
                                        AppLocalizations.of(
                                            'List created Successfully!!'),
                                        duration: Duration(seconds: 2));
                                  });
                                }),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
