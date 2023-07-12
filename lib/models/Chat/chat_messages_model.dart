import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

List<ChatMessagesModel> chatMessagesModelFromJson(String str) =>
    List<ChatMessagesModel>.from(
        json.decode(str).map((x) => ChatMessagesModel.fromJson(x)));

String chatMessagesModelToJson(List<ChatMessagesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatMessagesModel {
  ChatMessagesModel(
      {this.messageId,
      this.readStatus,
      this.forwarded,
      this.replyFilename,
      this.fileTypeExtension,
      this.fromUser,
      this.toUser,
      this.dateData,
      this.chatMessagesModelClass,
      this.memberFromName,
      this.memberFromId,
      this.timezone,
      this.isStar,
      this.message,
      this.you,
      this.video,
      this.videoImage,
      this.videoPlaytime,
      this.width,
      this.height,
      this.imageData,
      this.imgAudio,
      this.audioRead,
      this.messageType,
      this.url,
      this.fileNameUploaded,
      this.checkStatus,
      this.download,
      this.deleteMessage,
      this.forwardData,
      this.messageReply,
      this.youReplied,
      this.time,
      this.file,
      this.path,
      this.thumbPath,
      this.receiverDownload,
      this.receiverDevicePath,
      this.receiverThumbnail,
      this.isPicked,
      this.sentNow = 0,
      this.isSending = false,
      this.pageCount,
      this.pdfImage,
      this.audioDuration,
      this.receivedTime,
      this.readTime,
      this.contactName,
      this.contactNumber,
      this.contactType,
      this.dateCard,
      this.lat,
      this.long,
      this.latitude,
      this.longitude,
      this.locationTitle,
      this.locationSubtitle,
      this.isVideoUploading = false,
      this.username,
      this.userImage,
      this.color,
      this.playPop = false,
      this.replyParameters,
      this.postParameters,
      this.boardParameters});

  String? readStatus;
  String? messageId;
  int? forwarded;
  dynamic? replyFilename;
  String? fileTypeExtension;
  String? fromUser;
  String? toUser;
  String? dateData;
  dynamic chatMessagesModelClass;
  dynamic memberFromName;
  String? memberFromId;
  dynamic timezone;
  int? isStar;
  String? message;
  int? you;
  String? video;
  String? videoImage;
  String? videoPlaytime;
  dynamic width;
  dynamic height;
  dynamic imageData;
  dynamic imgAudio;
  String? audioRead;
  String? messageType;
  String? url;
  String? fileNameUploaded;
  int? checkStatus;
  int? download;
  int? deleteMessage;
  int? forwardData;
  String? messageReply;
  dynamic youReplied;
  String? time;
  bool? isSelected = false;
  File? file;
  String? path;
  String? thumbPath;
  bool? isVideoUploading = false;
  String? from = "";
  Uint8List? thumb;
  int? receiverDownload;
  String? receiverDevicePath;
  String? receiverThumbnail;
  bool? isDownloading = false;
  bool? isSending = false;
  int? isPicked = 0;
  int? pageCount;
  String? pdfImage;
  int? sentNow = 0;
  String? audioDuration;
  String? receivedTime;
  String? readTime;
  String? contactName;
  String? contactNumber;
  String? contactType;
  String? dateCard;
  double? lat;
  double? long;
  double? latitude;
  double? longitude;
  String? locationTitle;
  String? locationSubtitle;
  String? username;
  String? userImage;
  String? color;
  int? mediaIndex = 0;
  int? rotate = 0;
  bool? playPop;
  AudioPlayer? audioPlayer;
  String? fileSize;
  List<ReplyParameter>? replyParameters;
  List<PostParameter>? postParameters;
  List<BoardParameter>? boardParameters;
  double? downloadProgress = 0.0;

  factory ChatMessagesModel.fromJson(Map<String, dynamic> json) =>
      ChatMessagesModel(
        readStatus: json["read_status"] ?? "0",
        messageId: json["message_id"],
        time: json["time"],
        forwarded: json["forwarded"],
        replyFilename: json["reply_filename"],
        fileTypeExtension: json["file_type_extension"],
        fromUser: json["fromuser"],
        toUser: json["touser"],
        thumbPath: json["thumbnail"],
        dateData: json["date_data"],
        chatMessagesModelClass: json["class"],
        postParameters: List<PostParameter>.from(
            json["post_parameters"]?.map((x) => PostParameter.fromJson(x)) ??
                []),
        boardParameters: List<BoardParameter>.from(
            json["board_parameters"]?.map((x) => BoardParameter.fromJson(x)) ??
                []),
        memberFromName: json["member_from_name"],
        memberFromId: json["member_from_id"],
        timezone: json["timezone"],
        isStar: json["is_star"],
        message: json["message"],
        you: json["you"],
        video: json["video"],
        videoImage: json["video_image"],
        videoPlaytime: json["video_playtime"],
        width: json["width"],
        height: json["height"],
        imageData: json["image_data"],
        imgAudio: json["img_audio"],
        audioRead: json["audio_read"],
        messageType: json["message_type"],
        url: json["url"],
        fileNameUploaded: json["file_name_uploaded"] == null
            ? null
            : json["file_name_uploaded"],
        checkStatus: json["check_status"],
        download: json["download"],
        deleteMessage: json["delete_message"],
        forwardData: json["forward_data"],
        messageReply:
            json["message_reply"] == null ? null : json["message_reply"],
        youReplied: json["u_replyed"],
        path: json["device_path"],
        receiverDownload: json["receiver_download"],
        receiverDevicePath: json["receiver_device_path"],
        receiverThumbnail: json["receiver_thumbnail"],
        pageCount: json["pdf_pages"],
        pdfImage: json["pdf_image"],
        audioDuration: json["audio_duration"],
        receivedTime: json["received_time"],
        readTime: json["read_time"],
        contactName: json["contact_name"],
        contactNumber: json["contact_number"],
        contactType: json["contact_type"],
        dateCard: json["date_card"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        locationTitle: json["location_title"],
        locationSubtitle: json["location_subtitle"],
        username: json["name_data"],
        userImage: json["image_to"],
        color: json["color_data"],
        replyParameters: List<ReplyParameter>.from(
            json["reply_parameters"]?.map((x) => ReplyParameter.fromJson(x)) ??
                []),
      );

  Map<String, dynamic> toJson() => {
        "read_status": readStatus,
        "message_id": messageId,
        "device_path": path,
        "time": time,
        "thumbnail": thumbPath,
        "forwarded": forwarded,
        "reply_filename": replyFilename,
        "file_type_extension": fileTypeExtension,
        "fromuser": fromUser,
        "touser": toUser,
        "date_data": dateData,
        "class": chatMessagesModelClass,
        "member_from_name": memberFromName,
        "member_from_id": memberFromId,
        "timezone": timezone,
        "is_star": isStar,
        "message": message,
        "you": you,
        "video": video,
        "video_image": videoImage,
        "video_playtime": videoPlaytime,
        "width": width,
        "height": height,
        "image_data": imageData,
        "img_audio": imgAudio,
        "audio_read": audioRead,
        "message_type": messageType,
        "url": url,
        "file_name_uploaded":
            fileNameUploaded == null ? null : fileNameUploaded,
        "check_status": checkStatus,
        "download": download,
        "delete_message": deleteMessage,
        "forward_data": forwardData,
        "message_reply": messageReply == null ? null : messageReply,
        "u_replyed": youReplied,
        "receiver_download": receiverDownload,
        "receiver_device_path": receiverDevicePath,
        "receiver_thumbnail": receiverThumbnail,
        "pdf_pages": pageCount,
        "pdf_image": pdfImage,
        "audio_duration": audioDuration,
        "received_time": receivedTime,
        "read_time": readTime,
        "contact_name": contactName,
        "contact_number": contactNumber,
        "contact_type": contactType,
        "date_card": dateCard,
        "latitude": latitude,
        "longitude": longitude,
        "location_title": locationTitle,
        "location_subtitle": locationSubtitle,
        "name_data": username,
        "image_to": userImage,
        "color_data": color,
        "reply_parameters":
            List<dynamic>.from(replyParameters!.map((x) => x.toJson())),
      };
}

class ReplyParameter {
  ReplyParameter({
    this.type,
    this.message,
    this.thumb,
    this.name,
    this.videoPlaytime,
    this.fileName,
  });

  String? type;
  String? message;
  String? thumb;
  String? name;
  dynamic? videoPlaytime;
  String? fileName;

  factory ReplyParameter.fromJson(Map<String, dynamic> json) => ReplyParameter(
        type: json["type"],
        message: json["message"],
        thumb: json["thumb"],
        name: json["name"],
        videoPlaytime: json["video_playtime"],
        fileName: json["file_name"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "message": message,
        "thumb": thumb,
        "name": name,
        "video_playtime": videoPlaytime,
        "file_name": fileName,
      };
}

class PostParameter {
  PostParameter({
    this.postId,
    this.memberId,
    this.thumbnailUrl,
    this.userImage,
    this.userName,
    this.shortcode,
    this.description,
    this.isMultiple,
    this.blogTitle,
    this.message,
  });

  String? postId;
  String? memberId;
  String? thumbnailUrl;
  String? userImage;
  String? userName;
  String? shortcode;
  String? description;
  bool? isMultiple;
  String? blogTitle;
  String? message;

  factory PostParameter.fromJson(Map<String, dynamic> json) => PostParameter(
        postId: json["post_id"],
        memberId: json["user_id"] ?? "",
        thumbnailUrl: json["thumbnail_url"] ?? "",
        userImage: json["user_image"],
        userName: json["user_name"],
        shortcode: json["shortcode"] ?? "",
        description: json["description"],
        isMultiple: json["isMultiple"],
        blogTitle: json["blog_title"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "user_id": memberId,
        "thumbnail_url": thumbnailUrl,
        "user_image": userImage,
        "user_name": userName,
        "shortcode": shortcode,
        "description": description,
        "isMultiple": isMultiple,
      };
}

class BoardParameter {
  BoardParameter({
    this.boardId,
    this.posts,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.memberId,
    this.shortcode,
    this.name,
    this.userImage,
  });

  String? boardId;
  String? posts;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? memberId;
  String? shortcode;
  String? name;
  String? userImage;

  factory BoardParameter.fromJson(Map<String, dynamic> json) => BoardParameter(
        boardId: json["board_id"],
        posts: json["posts"],
        image1: json["image_1"],
        image2: json["image_2"],
        image3: json["image_3"],
        image4: json["image_4"],
        memberId: json["user_id"],
        shortcode: json["shortcode"],
        name: json["name"],
        userImage: json["user_image"],
      );
}

class ChatMessages {
  List<ChatMessagesModel> messages;

  ChatMessages(this.messages);

  factory ChatMessages.fromJson(List<dynamic> parsed) {
    List<ChatMessagesModel> messages = <ChatMessagesModel>[];
    messages = parsed.map((i) => ChatMessagesModel.fromJson(i)).toList();
    return new ChatMessages(messages);
  }
}
