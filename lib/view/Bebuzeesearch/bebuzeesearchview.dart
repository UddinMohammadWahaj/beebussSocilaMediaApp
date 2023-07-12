import 'package:bizbultest/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../../services/current_user.dart';
import 'bebuzeesearchinnerview.dart';

class BebuzeeSearchView extends StatefulWidget {
  const BebuzeeSearchView({Key? key}) : super(key: key);

  @override
  State<BebuzeeSearchView> createState() => _BebuzeeSearchViewState();
}

class _BebuzeeSearchViewState extends State<BebuzeeSearchView> {
  var controller = Get.put(BebuzeeSearchController());
  var textconttroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // var controller = Get.put(BebuzeeSearchController());
    // var textconttroller = TextEditingController();
    Widget customTextBox() {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20)),
          child: TextField(
            cursorColor: Colors.black,
            enabled: true,
            controller: textconttroller,
            onChanged: (v) {
              // controller.search.value = v;
              controller.search.value = textconttroller.text;
            },
            onSubmitted: (value) async {
              controller.getsearchload.value = true;
              try {
                await controller.getSearch(search: value);
                controller.getsearchload.value = false;
              } catch (e) {
                controller.getsearchload.value = false;
              }

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    BebuzeeSearchInnerView(controller: controller,keysearch:value ),
              ));
            },
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              focusColor: Colors.white,
              prefixIcon: Icon(Icons.search, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: Colors.white, width: 2, style: BorderStyle.solid)),
              fillColor: Colors.white,
              // filled: true,
              disabledBorder: InputBorder.none,
              hintText: 'Bebuzee Search',
              hintStyle: TextStyle(
                  fontFamily: 'LeagueSpartanMedium',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w200),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: kToolbarHeight * 1.5,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: customTextBox(),
      ),
      body: Obx(
        () => controller.searchList.value.length == 0
            ? Container()
            : controller.getsearchload.value
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      ListView.builder(
                        itemCount: controller.searchList.value.length,
                        itemBuilder: (context, index) => ListTile(
                          onTap: () async {
                            controller.getsearchload.value = true;
                            await controller
                                .getSearch(
                                    search: controller.searchList.value[index])
                                .then((value) {
                              controller.getsearchload.value = false;
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BebuzeeSearchInnerView(
                                  controller: controller,
                                  keysearch: controller.searchList.value[index],
                                ),
                              ));
                            });
                          },
                          title: Text('${controller.searchList.value[index]}'),
                        ),
                      ),
                      CircularProgressIndicator(
                        color: Colors.black,
                      )
                    ],
                  )
                : ListView.builder(
                    itemCount: controller.searchList.value.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () async {
                        controller.getSearch(
                            search: controller.searchList.value[index]);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              BebuzeeSearchInnerView(controller: controller,
                              
                              keysearch: controller.searchList.value[index],
                              ),
                        ));
                      },
                      title: Text('${controller.searchList.value[index]}'),
                    ),
                  ),
      ),
    );
  }
}

class BebuzeeSearchController extends GetxController {
  var searchList = [].obs;
  var statussearch = false.obs;
  var search = ''.obs;
  var bebuzeesearch = ''.obs;
  var bebuzeesearchdata = <BebuzeeSearchModel>[].obs;
  Future<void> fetchSearch(key) async {
    var resp = await ApiProvider().fireApi(
        'https://www.bebuzee.com/api/search/suggestion?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&search=$key');
    try {
      if (resp.data['status'] == 1) {
        searchList.value = resp.data['data'];
      } else {
        searchList.value = <String>[];
      }
    } catch (e) {
      searchList.value = <String>[];
    }
  }

  var getsearchload = false.obs;
  Future<void> getSearch({page: 1, search: ''}) async {
    print(
        "get search called 'https://www.bebuzee.com/api/search/suggestionData?user_id=${CurrentUser().currentUser.memberID}&search=${search}&type=all&page=${page}");
    var resp = await ApiProvider().fireApi(
        'https://www.bebuzee.com/api/search/suggestionData?user_id=${CurrentUser().currentUser.memberID}&search=${search}&type=all&page=${page}');
    var data = <BebuzeeSearchModel>[];
    var statussearch = false.obs;

    print("search data length ${resp.data['data'].length}");
    for (int i = 0; i < resp.data['data'].length; i++) {
      var e = resp.data['data'][i];
      try {
        data.add(BebuzeeSearchModel.fromJson(e));
      } catch (e) {
        print("search error index=${i} ${e}");
      }
    }
    // resp.data['data'].forEach((e) {
    //   data.add(BebuzeeSearchModel.fromJson(e));
    // });
    bebuzeesearchdata.value = data;

    ;
  }

  void onInit() {
    debounce(search, (callback) async {
      getsearchload.value = true;
      try {
        if (search.value.isNotEmpty) {
          await fetchSearch(search.value);
          getsearchload.value = false;
        } else {
          getsearchload.value = false;
        }
      } catch (e) {
        getsearchload.value = false;
      }
    }, time: Duration(milliseconds: 500));

    // debounce(bebuzeesearch, (callback) async {
    //   if (bebuzeesearch.value.isNotEmpty)
    //     getSearch(search: bebuzeesearch.value, page: 1);
    // }, time: Duration(milliseconds: 500));
    super.onInit();
  }
}

class BebuzeeSearchModel {
  BebuzeeSearchModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.type,
    required this.url,
    required this.views,
    required this.date,
  });
  late final int id;
  late final String title;
  late final String description;
  late final String image;
  late final String type;
  late final String url;
  late final String views;
  late final String date;

  BebuzeeSearchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    type = json['type'];
    url = json['url'];
    views = json['views'].toString() ?? '0';
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['description'] = description;
    _data['image'] = image;
    _data['type'] = type;
    _data['url'] = url;
    _data['views'] = views;
    _data['date'] = date;
    return _data;
  }
}
