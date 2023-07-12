import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/widgets/Properbuz/menu/user_properties/location_review_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utilities/colors.dart';

class LocationReviewsTab extends GetView<UserPropertiesController> {
  const LocationReviewsTab({Key? key}) : super(key: key);

  Future<List> getRev() async {
    // controller.revLoding.value = true;
    var data = await ApiProvider().fireApi(
        'https://www.bebuzee.com/api/get_my_reviews_list.php?user_id=${CurrentUser().currentUser.memberID}');

    // var data = await Dio()
    //     .get(
    //         'https://www.bebuzee.com/api/get_my_reviews_list.php?user_id=${CurrentUser().currentUser.memberID}')
    //     .then((value) => value.data);
// LocationReviewsModel
    print('--------getrev data =$data');
    // controller.revLoding.value = false;
    if (data.data['success'] == 0) return [];
    return data.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserPropertiesController());
    return
        //  Obx(() => controller.revLoding.isTrue
        //     ? Center(
        //         child: CircularProgressIndicator(
        //         color: settingsColor,
        //       ))
        // :
        Container(
            child: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: FutureBuilder(
          future: getRev(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length == 0)
                return Center(
                  child: Text("no reviews to show"),
                );
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    // print(
                    //     "------------review dta------ ${snapshot.data[9]['review'].toString()}");
                    return LocationReviewCard(
                      images: snapshot.data![index]['images'] ?? [],
                      approvalstatus: snapshot.data![index]['status'],
                      country: snapshot.data![index]['country'],
                      location: snapshot.data![index]['location'],
                      title: snapshot.data![index]['review_title'],
                      review: snapshot.data![index]['review'],
                      rating: int.parse(
                        snapshot.data![index]['rating'],
                      ),
                      index: index,
                    );
                  });
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: hotPropertiesThemeColor,
              ));
            }
          }),
    ));
    // ));
  }
}
