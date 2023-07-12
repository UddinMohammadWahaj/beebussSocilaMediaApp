// To parse this JSON data, do
//
//     final videoTopSlider = videoTopSliderFromJson(jsonString);

import 'dart:convert';

List<VideoTopSlider> videoTopSliderFromJson(String str) =>
    List<VideoTopSlider>.from(
        json.decode(str).map((x) => VideoTopSlider.fromJson(x)));

String videoTopSliderToJson(List<VideoTopSlider> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoTopSlider {
  VideoTopSlider({
    this.category,
    this.categoryIt,
    this.image,
  });

  String? category;
  String? categoryIt;
  String? image;

  factory VideoTopSlider.fromJson(Map<String, dynamic> json) => VideoTopSlider(
        category: json["category"],
        categoryIt: json["category_it"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "category_it": categoryIt,
        "image": image,
      };
}

class SliderVideos {
  List<VideoTopSlider> sliderVideos;

  SliderVideos(this.sliderVideos);
  factory SliderVideos.fromJson(List<dynamic> parsed) {
    List<VideoTopSlider> sliderVideos = <VideoTopSlider>[];
    sliderVideos = parsed.map((i) => VideoTopSlider.fromJson(i)).toList();
    return new SliderVideos(sliderVideos);
  }
}
