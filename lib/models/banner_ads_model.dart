// To parse this JSON data, do
//
//     final bannerAdsModel = bannerAdsModelFromJson(jsonString);

import 'dart:convert';

List<BannerAdsModel> bannerAdsModelFromJson(String str) =>
    List<BannerAdsModel>.from(
      json.decode(str).map(
            (x) => BannerAdsModel.fromJson(x),
          ),
    );

String bannerAdsModelToJson(List<BannerAdsModel> data) => json.encode(
      List<dynamic>.from(
        data.map(
          (x) => x.toJson(),
        ),
      ),
    );

class BannerAdsModel {
  BannerAdsModel({
    this.dataId,
    this.linkTitle,
    this.image,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
    this.status,
    this.date,
    this.totalViews,
    this.totalClicks,
    this.totalRow,
  });

  String? dataId;
  String? linkTitle;
  String? image;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? image5;
  String? status;
  String? date;
  String? totalViews;
  String? totalClicks;
  int? totalRow;

  factory BannerAdsModel.fromJson(Map<String, dynamic> json) => BannerAdsModel(
        dataId: json["data_id"],
        linkTitle: json["link_title"],
        image: json["image"],
        image1: json["image1"],
        image2: json["image2"],
        image3: json["image3"],
        image4: json["image4"],
        image5: json["image5"],
        status: json["status"],
        date: json["date"],
        totalViews: json["total_views"],
        totalClicks: json["total_clicks"],
        totalRow: json["total_row"],
      );

  Map<String, dynamic> toJson() => {
        "data_id": dataId,
        "link_title": linkTitle,
        "image": image,
        "image1": image1,
        "image2": image2,
        "image3": image3,
        "image4": image4,
        "image5": image5,
        "status": status,
        "date": date,
        "total_views": totalViews,
        "total_clicks": totalClicks,
        "total_row": totalRow,
      };
}

class BannerAds {
  List<BannerAdsModel> banners;
  BannerAds(this.banners);
  factory BannerAds.fromJson(List<dynamic> parsed) {
    List<BannerAdsModel> banners = <BannerAdsModel>[];
    banners = parsed.map((i) => BannerAdsModel.fromJson(i)).toList();
    return new BannerAds(banners);
  }
}
