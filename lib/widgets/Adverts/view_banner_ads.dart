import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/banner_ads_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'banner_ads_overview.dart';

class ViewBannerAds extends StatefulWidget {
  @override
  _ViewBannerAdsState createState() => _ViewBannerAdsState();
}

class _ViewBannerAdsState extends State<ViewBannerAds> {
  late BannerAds adsList;

  bool areBannersLoaded = false;

  Future<void> getBanners() async {
    var url =
        "https://www.bebuzee.com/api/user_banner_advertisment.php?action=user_banner_advertisment&user_id=${CurrentUser().currentUser.memberID!}&all_data_ids=";
    var response = await ApiProvider().fireApi(url).then((value) => value);
    // var response = await http.get(url);
    print("response of banner adlist =${response!.data}");
    if (response!.statusCode == 200) {
      BannerAds bannerData = BannerAds.fromJson(response!.data['data']);

      if (mounted) {
        setState(() {
          adsList = bannerData;
          areBannersLoaded = true;
        });
      }
    }

    if (response!.data == null || response!.statusCode != 200) {
      if (mounted) {
        setState(() {
          areBannersLoaded = false;
        });
      }
    }
  }

  @override
  void initState() {
    getBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: areBannersLoaded
          ? ListView.builder(
              itemCount: adsList.banners.length,
              itemBuilder: (context, index) {
                return BannerCard(
                  banner: adsList.banners[index],
                );
              })
          : Container(),
    );
  }
}

class BannerCard extends StatelessWidget {
  final BannerAdsModel banner;

  const BannerCard({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 3.0.w),
      child: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.network(
                banner.image1!,
                fit: BoxFit.contain,
                height: 15.0.h,
                width: 20.0.w,
              ),
              SizedBox(
                width: 2.5.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50.0.w,
                    child: Text(
                      banner.linkTitle!,
                      style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.0.h),
                    child: Text(
                      AppLocalizations.of(
                            "Published on",
                          ) +
                          " " +
                          banner.date!,
                      style: TextStyle(fontSize: 10.0.sp),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          AppLocalizations.of(
                                "Views",
                              ) +
                              "   " +
                              banner.totalViews!,
                          style: TextStyle(fontSize: 12.0.sp),
                        ),
                        Text(
                          AppLocalizations.of(
                                "Clicks",
                              ) +
                              "   " +
                              banner.totalClicks!,
                          style: TextStyle(fontSize: 12.0.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  print(banner.dataId);
                  List<String> bannerImages = [];
                  if (banner.image1 != "" && banner.image1 != null) {
                    bannerImages.add(banner.image1!);
                  }

                  if (banner.image2 != "" && banner.image2 != null) {
                    bannerImages.add(banner.image2!);
                  }

                  if (banner.image3 != "" && banner.image3 != null) {
                    bannerImages.add(banner.image3!);
                  }

                  if (banner.image4 != "" && banner.image4 != null) {
                    bannerImages.add(banner.image4!);
                  }

                  if (banner.image5 != "" && banner.image5 != null) {
                    bannerImages.add(banner.image5!);
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BannerAdsOverview(
                                bannerImages: bannerImages,
                                dataID: banner.dataId,
                              )));
                },
                child: Container(
                    decoration: new BoxDecoration(
                      color: primaryBlueColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.0.w, vertical: 1.0.h),
                      child: Text(
                        AppLocalizations.of(
                          "View Ad",
                        ),
                        style: whiteBold.copyWith(fontSize: 10.0.sp),
                      ),
                    )),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
