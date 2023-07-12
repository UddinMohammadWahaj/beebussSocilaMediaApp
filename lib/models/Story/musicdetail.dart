// To parse this JSON data, do
//
//     final musicDetailsModel = musicDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

MusicDetailsModel musicDetailsModelFromJson(String str) =>
    MusicDetailsModel.fromJson(json.decode(str));

String musicDetailsModelToJson(MusicDetailsModel data) =>
    json.encode(data.toJson());

class MusicDetailsModel {
  MusicDetailsModel({
    this.results,
    this.meta,
  });

  MusicDetailsModelResults? results;
  Meta? meta;

  factory MusicDetailsModel.fromJson(Map<String, dynamic> json) =>
      MusicDetailsModel(
        results: MusicDetailsModelResults.fromJson(json["results"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "meta": meta!.toJson(),
      };
}

class Meta {
  Meta({
    this.results,
  });

  MetaResults? results;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        results: MetaResults.fromJson(json["results"]),
      );

  Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
      };
}

class MetaResults {
  MetaResults({
    this.order,
    this.rawOrder,
  });

  List<String>? order;
  List<String>? rawOrder;

  factory MetaResults.fromJson(Map<String, dynamic> json) => MetaResults(
        order: List<String>.from(json["order"].map((x) => x)),
        rawOrder: List<String>.from(json["rawOrder"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "order": List<dynamic>.from(order!.map((x) => x)),
        "rawOrder": List<dynamic>.from(rawOrder!.map((x) => x)),
      };
}

class MusicDetailsModelResults {
  MusicDetailsModelResults({
    this.songs,
  });

  Songs? songs;

  factory MusicDetailsModelResults.fromJson(Map<String, dynamic> json) =>
      MusicDetailsModelResults(
        songs: Songs.fromJson(json["songs"]),
      );

  Map<String, dynamic> toJson() => {
        "songs": songs!.toJson(),
      };
}

class Songs {
  Songs({
    this.href,
    this.next,
    this.data,
  });

  String? href;
  String? next;
  List<SongDatum>? data;

  factory Songs.fromJson(Map<String, dynamic> json) => Songs(
        href: json["href"],
        next: json["next"],
        data: List<SongDatum>.from(
            json["data"].map((x) => SongDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "href": href,
        "next": next,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SongDatum {
  SongDatum(
      {this.id,
      this.type,
      this.href,
      this.attributes,
      this.isPlaying,
      this.currentPlayingIndex});

  String? id;
  String? type;
  String? href;
  RxBool? isPlaying;
  RxString? currentPlayingIndex;
  Attributes? attributes;

  factory SongDatum.fromJson(Map<String, dynamic> json) => SongDatum(
        id: json["id"],
        type: json["type"],
        href: json["href"],
        isPlaying: false.obs,
        attributes: Attributes.fromJson(json["attributes"]),
        currentPlayingIndex: '-1'.obs,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "href": href,
        "attributes": attributes!.toJson(),
      };
}

class Attributes {
  Attributes({
    this.previews,
    this.artwork,
    this.artistName,
    this.url,
    this.discNumber,
    this.genreNames,
    this.durationInMillis,
    this.releaseDate,
    this.isAppleDigitalMaster,
    this.name,
    this.isrc,
    this.hasLyrics,
    this.albumName,
    this.playParams,
    this.trackNumber,
    this.composerName,
    this.editorialNotes,
  });

  List<Preview>? previews;
  Artwork? artwork;
  String? artistName;
  String? url;
  int? discNumber;
  List<String>? genreNames;
  int? durationInMillis;
  DateTime? releaseDate;
  bool? isAppleDigitalMaster;
  String? name;
  String? isrc;
  bool? hasLyrics;
  String? albumName;
  PlayParams? playParams;
  int? trackNumber;
  String? composerName;
  EditorialNotes? editorialNotes;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        previews: List<Preview>.from(
            json["previews"].map((x) => Preview.fromJson(x))),
        artwork: Artwork.fromJson(json["artwork"]),
        artistName: json["artistName"],
        url: json["url"],
        discNumber: json["discNumber"],
        genreNames: List<String>.from(json["genreNames"].map((x) => x)),
        durationInMillis: json["durationInMillis"],
        // releaseDate: DateTime.parse(json["releaseDate"]),
        isAppleDigitalMaster: json["isAppleDigitalMaster"],
        name: json["name"],
        isrc: json["isrc"],
        hasLyrics: json["hasLyrics"],
        albumName: json["albumName"],
        playParams: PlayParams.fromJson(json["playParams"]),
        trackNumber: json["trackNumber"],
        composerName: json["composerName"],
        editorialNotes: json["editorialNotes"] == null
            ? null
            : EditorialNotes.fromJson(json["editorialNotes"]),
      );

  Map<String, dynamic> toJson() => {
        "previews": List<dynamic>.from(previews!.map((x) => x.toJson())),
        "artwork": artwork!.toJson(),
        "artistName": artistName,
        "url": url,
        "discNumber": discNumber,
        "genreNames": List<dynamic>.from(genreNames!.map((x) => x)),
        "durationInMillis": durationInMillis,
        "releaseDate":
            "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
        "isAppleDigitalMaster": isAppleDigitalMaster,
        "name": name,
        "isrc": isrc,
        "hasLyrics": hasLyrics,
        "albumName": albumName,
        "playParams": playParams!.toJson(),
        "trackNumber": trackNumber,
        "composerName": composerName,
        "editorialNotes":
            editorialNotes == null ? null : editorialNotes!.toJson(),
      };
}

class Artwork {
  Artwork({
    this.width,
    this.height,
    this.url,
    this.bgColor,
    this.textColor1,
    this.textColor2,
    this.textColor3,
    this.textColor4,
  });

  int? width;
  int? height;
  String? url;
  String? bgColor;
  String? textColor1;
  String? textColor2;
  String? textColor3;
  String? textColor4;

  factory Artwork.fromJson(Map<String, dynamic> json) => Artwork(
        width: json["width"],
        height: json["height"],
        url: json["url"],
        bgColor: json["bgColor"],
        textColor1: json["textColor1"],
        textColor2: json["textColor2"],
        textColor3: json["textColor3"],
        textColor4: json["textColor4"],
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "url": url,
        "bgColor": bgColor,
        "textColor1": textColor1,
        "textColor2": textColor2,
        "textColor3": textColor3,
        "textColor4": textColor4,
      };
}

class EditorialNotes {
  EditorialNotes({
    this.short,
  });

  String? short;

  factory EditorialNotes.fromJson(Map<String, dynamic> json) => EditorialNotes(
        short: json["short"],
      );

  Map<String, dynamic> toJson() => {
        "short": short,
      };
}

class PlayParams {
  PlayParams({
    this.id,
    this.kind,
  });

  String? id;
  String? kind;

  factory PlayParams.fromJson(Map<String, dynamic> json) => PlayParams(
        id: json["id"],
        kind: json["kind"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kind": kind,
      };
}

class Preview {
  Preview({
    this.url,
  });

  String? url;

  factory Preview.fromJson(Map<String, dynamic> json) => Preview(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
