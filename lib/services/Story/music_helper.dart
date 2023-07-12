import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Story/musicdetail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class StoryMusicApi {
  static Future<List<SongDatum>> getMusicDetail({term: '', limit: '10'}) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_post_share_on_story.php?user_id=${CurrentUser().currentUser.memberID}&post_id=$postID");
    var url =
        'https://api.music.apple.com/v1/catalog/us/search?types=songs&term=$term&limit=$limit';
    print("music data url=$url");
    var response = await ApiProvider().fireMusicApi(url).then((value) => value);

    if (response != null) {
      print("music data=${response.data}");
      List<SongDatum> data =
          MusicDetailsModel.fromJson(response.data).results!.songs!.data!;

      print("music res2 data=${data}");
      return data;
    } else
      return <SongDatum>[];
  }

  static Future<List<SongDatum>> search({term: '', limit: '10'}) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_post_share_on_story.php?user_id=${CurrentUser().currentUser.memberID}&post_id=$postID");
    var url =
        'https://api.music.apple.com/v1/catalog/us/search?types=songs,albums,artists,playlists&term=$term&limit=$limit';
    print("music data url=$url");
    var response = await ApiProvider().fireMusicApi(url).then((value) => value);
    if (response != null) {
      print("music data=${response.data}");
    }
    if (response != null) {
      print("music data=${response.data}");
      List<SongDatum> data =
          MusicDetailsModel.fromJson(response.data).results!.songs!.data!;

      print("music res2 data=${data}");
      return data;
    } else
      return <SongDatum>[];
  }
}
