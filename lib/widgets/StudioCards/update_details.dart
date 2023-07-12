import 'dart:convert';

import 'package:bizbultest/services/current_user.dart';
import 'package:http/http.dart' as http;
import '../../api/ApiRepo.dart' as ApiRepo;

class UpdateStudioDetails {
  Future<void> updatePlaylistTitle(String playlistID, String newTitle) async {
    //var url = Uri.parse(
    //    "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=save_playlist_title&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$playlistID&value=$newTitle");
//
    //var response = await http.get(url);
    var user_id =
        {CurrentUser().currentUser.memberID}.toString().replaceAll("{", "");
    var response =
        await ApiRepo.postWithToken("api/playlist_update_title.php", {
      "user_id": user_id.replaceAll("}", ""),
      "playlist_id": playlistID,
      "value": newTitle
    });

    if (response!.success == 1) {
      print(response!.data['data']);
    }
  }

  Future<void> updatePlaylistDescription(
      String playlistID, String newDescription) async {
    //var url = Uri.parse(
    //    "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=save_playlist_description&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$playlistID&value=$newDescription");
//
    //var response = await http.get(url);
    var user_id =
        {CurrentUser().currentUser.memberID}.toString().replaceAll("{", "");
    var response =
        await ApiRepo.postWithToken("api/playlist_update_description.php", {
      "user_id": user_id.replaceAll("}", ""),
      "playlist_id": playlistID,
      "value": newDescription
    });

    if (response!.success == 1) {
      print(response!.data['data']);
    }
  }

  Future<void> updatePrivacy(String playlistID, String type) async {
    //var url = Uri.parse(
    //    "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=update_playlist_type&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$playlistID&type=$type");
//
    //var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/playlist_update_type.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "playlist_id": playlistID,
      "type": type
    });

    if (response!.success == 1) {
      print(response!.data['data']);
    }
  }

  Future<void> deletePlaylist(String playlistID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=delete_playlist_data&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$playlistID");
//
    // var response = await http.get(url);
    var user_id =
        {CurrentUser().currentUser.memberID}.toString().replaceAll("{", "");
    var response = await ApiRepo.postWithToken("api/playlist_delete.php",
        {"user_id": user_id.replaceAll("}", ""), "playlist_id": playlistID});

    if (response!.success == 1) {
      print(response!.data['data']);
    }
  }

  Future<void> addVideosToPlaylist(String playlistID, String ids) async {
    //var url = Uri.parse(
    //    "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=add_videos_playlist&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$playlistID&all_post_ids=$ids");
//
    //var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/playlist_add_video.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "playlist_id": playlistID,
      "all_post_ids": ids
    });

    if (response!.success == 1) {
      print(response!.data['data']);
    }
  }

  Future<void> moveToTop(String playlistID, String postID) async {
    //var url = Uri.parse(
    //    "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=move_video_to_top_playlist&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$playlistID&post_id=$postID");
//
    //var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/post_top_to_playlist.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "playlist_id": playlistID,
      "post_id": postID
    });

    if (response!.success == 1) {
      print(response!.data['data']);
    }
  }

  Future<void> moveToBottom(String playlistID, String postID) async {
    //var url = Uri.parse(
    //    "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=move_video_to_bottom_playlist&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$playlistID&post_id=$postID");
//
    //var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/post_bottom_to_playlist.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "playlist_id": playlistID,
      "post_id": postID
    });

    if (response!.success == 1) {
      print(response!.data['data']);
    }
  }

  Future<void> removeVideoFromPlaylist(String playlistID, String postID) async {
    //var url = Uri.parse(
    //    "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=remove_video_from_playlist&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$playlistID&post_id=$postID");
//
    //var response = await http.get(url);
//

    var response =
        await ApiRepo.postWithToken("api/post_remove_to_playlist.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "playlist_id": playlistID,
      "post_id": postID
    });

    if (response!.success == 1) {
      print(response!.data['data']);
    }
  }

  Future<void> addToWatchLater(String postID) async {
    //var url = Uri.parse(
    //    "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=add_to_playlist_to_watchlater&user_id=${CurrentUser().currentUser.memberID}&ids_to_add=$postID");
    //
    //var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/video/videoAddWatchLater",
        {"user_id": CurrentUser().currentUser.memberID, "ids_to_add": postID});

    if (response!.success == 1) {
      print(response!.data['data']);
    }
  }

  Future<void> allowEmbedding(String playlistID, int value) async {
    //var url = Uri.parse(
    //    "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=update_embed_settings&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$playlistID&value=$value");
//
    //var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/playlist_update_embbed.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "playlist_id": playlistID,
      "value": value
    });

    if (response!.success == 1) {
      print(response!.data['data']);
    }
  }

  Future<void> addVideosToTop(String playlistID, int value) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=add_videos_to_the_top&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$playlistID&value=$value");
//
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/playlist_update_add_new.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "playlist_id": playlistID,
      "value": value
    });

    if (response!.success == 1) {
      print(response!.data['data']);
    }
  }
}
