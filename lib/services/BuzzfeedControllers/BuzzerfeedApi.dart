import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Buzzerfeed/buzzerfeedmainpagemodel.dart';
import 'package:bizbultest/models/Buzzerfeed/buzzrefeed_commentlist_model.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedcontroller.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../current_user.dart';
import '../../../api/ApiRepo.dart' as ApiRepo;

class BuzzerFeedAPI {
  static Future<String?> getToken() async {
    return await ApiProvider()
        .refreshToken(CurrentUser().currentUser.memberID!);
  }

  static Future<List> getTrendingCountry() async {
    var url = 'https://www.bebuzee.com/api/buzzerfeed/tradingCountry';
    var token = await getToken();
    var client = Dio();
    var response = await client.get(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }));
    return response!.data['data'];
  }

  static Future<List> getTrendingList({country: ''}) async {
    var countrynew =
        country == '' ? CurrentUser().currentUser.memberID! : country;
    var url = 'https://www.bebuzee.com/api/blog/blogList?country=$countrynew';
    var token = await getToken();
    var client = Dio();
    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "country": CurrentUser().currentUser.country,
          // "comment_id": postId,
        });
    print("response of the trending list=${response!.data}");
    return response!.data['data'];
  }

  static Future likeUnlike(postId) async {
    var url = 'https://www.bebuzee.com/api/buzzerfeed/LikeUnlike';
    var client = Dio();
    var token = await getToken();
    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "buzzerfeed_id": postId,
          "user_id": CurrentUser().currentUser.memberID!,
        }).then((value) => value);
    if (response!.data['status'] == 201) {
      return {
        "like_status": response!.data['like_status'],
        "total_likes": response!.data['total_likes']
      };
    }
    return null;
  }

  static Future pollVote(answerID) async {
    var url = 'https://www.bebuzee.com/api/buzzerfeed_post_poll_voting.php';
    print("pollvote called");
    var token = await getToken();
    var client = Dio();
    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": CurrentUser().currentUser.memberID!,
          "answer_id": answerID,
        }).then((value) => value);
    var result = response!.data;
    return result;
  }

  static Future postRequote(Map<String, dynamic> topostdata,
      {List<dynamic> files: const []}) async {
    var formdata = FormData();
    print("response of upload");
    for (var file in files) {
      formdata.files
          .addAll([MapEntry("files[]", await MultipartFile.fromFile(file))]);
    }
    print("formdata.length =${formdata.files.length}");
    var url = 'https://www.bebuzee.com/api/buzzerfeed/reQuotes';
    var client = Dio();
    var token = await getToken();
    var response = await client
        .post(url,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }),
            data: formdata,
            queryParameters: topostdata)
        .then((value) => value);
    print("requote response=${response!.data}");
    if (response!.data['status'] == 201)
      return response!.data['buzzerfeed_id'].toString();
    else
      return "";
  }

  static Future commentLike(commentId) async {
    var url = 'https://www.bebuzee.com/api/buzzerfeed/commentLikeUnlike';
    var client = Dio();
    var token = await getToken();
    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": CurrentUser().currentUser.memberID!,
          "comment_id": commentId
        });
    print("commentLike response= ${response!.data}");
  }

  static Future rebuzz(buzzerfeedId) async {
    var url = 'https://www.bebuzee.com/api/buzzerfeed/reBuzzerfeed';
    var client = Dio();
    var token = await getToken();
    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": CurrentUser().currentUser.memberID!,
          "buzzerfeed_id": buzzerfeedId,
        }).then((value) => value);
    print("response of rebuzz=${response!.data}");
  }

  static Future<List<BuzzerfeedDatum>> getData(
      {page: 1, tag: '', listId: ''}) async {
    List<BuzzerfeedDatum> output = [];
    var url = 'https://www.bebuzee.com/api/buzzerfeed/list';
    var client = Dio();
    var token = await ApiProvider().getTheToken();
    print(" buzzerurl=${url}buzzerfeed=user_id=");
    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": CurrentUser().currentUser.memberID!,
          "country": CurrentUser().currentUser.country,
          "page": page,
          "hashtag": tag,
          'list_id': listId
        }).then((value) => value);
    print(
        " buzzerurl=${url}buzzerfeed=user_id=${CurrentUser().currentUser.memberID!}$listId=${response!.data}");

    if (response!.data['status'] == 1) {
      print("response=${response!.data}");
      try {
        output = BuzzerfeedMain.fromJson(response!.data).data!;
      } catch (e) {
        print("buzzer error=${e} getData");
        return <BuzzerfeedDatum>[];
      }
      print("response of buzzfeedmain=${output}");
      return output;
    } else
      return <BuzzerfeedDatum>[];
  }

  static Future<List<dynamic>> getTagsList({country: ''}) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/news_feed_hashtag_list.php?country=World Wide");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/blog/blogList", {
      "country":
          "${country == '' ? CurrentUser().currentUser.country : country}",
      "user_id": CurrentUser().currentUser.memberID!
    });
    print("tags called=${response!.data}");
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      print("got tags");
      List<dynamic> tags = response!.data['data'];
      return tags;
    } else {
      return [];
    }
  }

  static Future<void> deleteFile(postId, path, postType) async {
    var url = 'https://www.bebuzee.com/api/buzzerfeed/imageRemove';
    var client = Dio();
    var token = await getToken();
    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": CurrentUser().currentUser.memberID!,
          "buzzerfeed_id": postId,
          "url_path": "$path",
          "file_type": postType
        }).then((value) => value);
    print("response of delete file=${response!.data}");
  }

  static Future deleteComment(commentId) async {
    var url = 'https://www.bebuzee.com/api/buzzerfeed/commentDelete';
    var client = Dio();
    var token = await getToken();
    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": CurrentUser().currentUser.memberID!,
          "comment_id": commentId,
        }).then((value) => value);
    print("response of delete comment=${response!.data}");
  }

  static Future deletePost(postId) async {
    var url = 'https://www.bebuzee.com/api/buzzerfeed/singlePostData';
    var client = Dio();
    var token = await getToken();
    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": CurrentUser().currentUser.memberID!,
          "buzzerfeed_id": postId,
        }).then((value) => value);
    print("response of delete=${response!.data}");
  }

  // static Future rebuzz(postId) async {
  //   var url = 'https://www.bebuzee.com/api/buzzerfeed/reBuzzerfeed';
  //   var client = Dio();
  //   var token = await getToken();
  //   var response = await client.post(url,
  //       options: Options(headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       }),
  //       queryParameters: {
  //         "user_id": CurrentUser().currentUser.memberID!,
  //         "buzzerfeed_id": postId,
  //       }).then((value) => value);
  //   print('rebuzz response=${response}');
  // }

  static Future<List<BuzzerfeedDatum>> getMyBuzz(
      {page: 1, memberId: ''}) async {
    List<BuzzerfeedDatum> output = [];
    var url = 'https://www.bebuzee.com/api/buzzerfeed/userList';
    print(
        "get my buzz url= https://www.bebuzee.com/api/buzzerfeed/userList?user_id=$memberId&page=$page&country=${memberId == CurrentUser().currentUser.memberID! ? CurrentUser().currentUser.country : OtherUser().otherUser.country}");
    var client = Dio();
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token') ??"";

    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": memberId == CurrentUser().currentUser.memberID!
              ? CurrentUser().currentUser.memberID!
              : memberId,
          "country": CurrentUser().currentUser.country,
          "page": page,
        }).then((value) => value);
    if (response.data['status'] == 1) {
      print("response=${response.data}");
      try {
        output = BuzzerfeedMain.fromJson(response.data).data!;
      } catch (e) {
        print("error=$e");
        return <BuzzerfeedDatum>[];
      }
      print("response of buzzfeedmain=${output}");
      return output;
    } else
      return <BuzzerfeedDatum>[];
  }

  static Future<List<BuzzerfeedCommentDatum>> getRecentComment(postId) async {
    List<BuzzerfeedCommentDatum> output = [];
    var url = 'https://www.bebuzee.com/api/buzzerfeed/singleComment';
    var client = Dio();
    print(
        "recent url=https://www.bebuzee.com/api/buzzerfeed/singleComment?user_id=${CurrentUser().currentUser.memberID!}&buzzerfeed_id=${postId}");
    var token = await getToken();
    print("get recent data called");
    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": CurrentUser().currentUser.memberID!,
          "comment_id": postId,
        }).then((value) => value);
    if (response!.data['status'] == 201) {
      output = BuzzerfeedCommentListModel.fromJson(response!.data).data!;
      print("recent comment=${output[0].buzzerfeedId}");
      return output;
    } else
      return <BuzzerfeedCommentDatum>[];
  }

  static Future<List<BuzzerfeedDatum>> getRecentData(postId) async {
    List<BuzzerfeedDatum> output = [];
    var url = 'https://www.bebuzee.com/api/buzzerfeed/singlePostData';
    var client = Dio();
    print(
        "recent url=https://www.bebuzee.com/api/buzzerfeed/singlePostData?user_id=${CurrentUser().currentUser.memberID!}&buzzerfeed_id=${postId}");
    var token = await ApiProvider().getTheToken();
    print("get recent data called");
    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": CurrentUser().currentUser.memberID!,
          "buzzerfeed_id": postId,
        }).then((value) => value);
    if (response!.data['status'] == 1) {
      print("fetch first post=${response!.data}");
      output = BuzzerfeedMain.fromJson(response!.data).data!;
      print("recent data=${output[0].buzzerfeedId}");
      return output;
    } else
      return <BuzzerfeedDatum>[];
  }

  static Future updateData(Map<String, dynamic> topostdata,
      {List<dynamic> files: const []}) async {
    var url = 'https://www.bebuzee.com/api/buzzerfeed/edit';
    var client = Dio();
    var token = await getToken();
    var formdata = FormData();
    print("response of upload");
    try {
      for (var file in files) {
        if (!file.contains('https://'))
          formdata.files.addAll([
            MapEntry("files[]", await MultipartFile.fromFile(File(file).path))
          ]);
      }
      print("formdata.length =${formdata.files.length}");
    } catch (e) {}
    var response = await client.post(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
      data: formdata,
      queryParameters: topostdata,
    );
    print("upload update response=${response!.data}");
    if (response!.data['status'] == 201)
      return response!.data['buzzerfeed_id'].toString();
    else
      return "";
  }

  static Future<List<BuzzerfeedCommentDatum>> getReplyComments(commentId,
      {page: 1}) async {
    var url = 'https://www.bebuzee.com/api/buzzerfeed_replay_data.php';
    var client = Dio();
    print(
        "recent url=https://www.bebuzee.com/api/buzzerfeed_replay_data.php?user_id=${CurrentUser().currentUser.memberID!}&comment_id=${commentId}");
    var token = await getToken();

    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": CurrentUser().currentUser.memberID!,
          "comment_id": commentId,
          "page": page
        }).then((value) => value.data);
    print("resp of comm=${response}");
    if (response['success'] == 1) {
      print("response of get reply comment=${response['data']}");
      print("response of get reply comment length=${response['data'].length}");
      return BuzzerfeedCommentListModel.fromJson(response).data!;
    } else
      return <BuzzerfeedCommentDatum>[];
  }

  static Future<List<BuzzerfeedCommentDatum>> getComments(buzzerfeedId,
      {page: 1}) async {
    var url = 'https://www.bebuzee.com/api/buzzerfeed/commentList';
    var client = Dio();
    print(
        "recent url=https://www.bebuzee.com/api/buzzerfeed/commentList?user_id=${CurrentUser().currentUser.memberID!}&buzzerfeed_id=${buzzerfeedId}");
    var token = await getToken();

    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": CurrentUser().currentUser.memberID!,
          "buzzerfeed_id": buzzerfeedId,
          "page": page
        }).then((value) => value.data);
    print("resp of comm=${response}");
    if (response['success'] == 1) {
      print("response of get comment=${response['data']}");
      return BuzzerfeedCommentListModel.fromJson(response).data!;
    } else
      return <BuzzerfeedCommentDatum>[];
  }

  static Future postCommentReply(Map<String, dynamic> topostdata,
      {List<dynamic> files: const []}) async {
    var formdata = FormData();
    print("response of upload ");
    for (var file in files) {
      formdata.files.addAll(
          [MapEntry("files[]", await MultipartFile.fromFile(file.path))]);
    }
    print("formdata.length =${formdata.files.length}");
    var url = 'https://www.bebuzee.com/api/buzzerfeed/commentReplay';
    var client = Dio();
    String? token = await getToken();
    var response = await client.post(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
      data: formdata,
      queryParameters: topostdata,
    );
    print("comment reply response=${response!.data} ");
    // return response!.data['comment_id'];
    // if (response!.data['status'] == 201)
    //   return response!.data['buzzerfeed_id'].toString();
    // else
    //   return "";
  }

  static Future addMemberToList(memberId) async {
    var response = await ApiProvider().fireApi(
        'https://www.bebuzee.com/api/buzzerfeed/listUserAddRemove?user_id=${memberId}');
    print("response of ${response!.data}");
  }

  static Future postComment(Map<String, dynamic> topostdata,
      {List<dynamic> files: const []}) async {
    var formdata = FormData();
    print("response of upload");
    for (var file in files) {
      formdata.files.addAll(
          [MapEntry("files[]", await MultipartFile.fromFile(file.path))]);
    }
    print("formdata.length =${formdata.files.length}");
    var url = 'https://www.bebuzee.com/api/buzzerfeed/addComment';
    var client = Dio();
    String? token = await getToken();
    var response = await client.post(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
      data: formdata,
      queryParameters: topostdata,
    );
    print("comment response=${response!.data} ");
    return response!.data['comment_id'];
    // if (response!.data['status'] == 201)
    //   return response!.data['buzzerfeed_id'].toString();
    // else
    //   return "";
  }

  static Future<String> postData(Map<String, dynamic> topostdata,
      {List<dynamic> files: const []}) async {
    var formdata = FormData();
    print("response of upload");
    for (var file in files) {
      formdata.files
          .addAll([MapEntry("files[]", await MultipartFile.fromFile(file))]);
    }
    print("formdata.length =${formdata.files.length}");
    var url = 'https://www.bebuzee.com/api/buzzerfeed/add';
    var client = Dio();
    String? token = await getToken();
    var response = await client.post(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
      data: formdata,
      queryParameters: topostdata,
    );
    print("upload response=${response!.data}");
    if (response!.data['status'] == 201)
      return response!.data['buzzerfeed_id'].toString();
    else
      return "";
  }
}
