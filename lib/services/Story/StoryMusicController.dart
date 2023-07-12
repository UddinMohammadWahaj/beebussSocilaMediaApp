import 'package:bizbultest/models/Story/musicdetail.dart';
import 'package:bizbultest/services/Story/music_helper.dart';
import 'package:get/get.dart';

class StoryMusicController extends GetxController {
  var songs = <SongDatum>[].obs;
  var romantic = <SongDatum>[].obs;
  var rock = <SongDatum>[].obs;
  var blues = <SongDatum>[].obs;
  var dance = <SongDatum>[].obs;
  var searchedSongs = <SongDatum>[].obs;
  var currentPlayingIndex = '-1'.obs;
  var currentSongId = ''.obs;
  void getSongs() async {
    var res = await StoryMusicApi.getMusicDetail(term: 'romantic', limit: '12');
    print("music res=$res");
    songs.value = res;
  }

  var search = ''.obs;
  Future searchSongs(String term) async {
    searchedSongs.value = await StoryMusicApi.search(term: term, limit: '10');
  }

  Future browseSongs() async {
    romantic.value =
        await StoryMusicApi.getMusicDetail(term: 'romantic', limit: '3');
    rock.value = await StoryMusicApi.getMusicDetail(term: 'rock', limit: '3');
    blues.value = await StoryMusicApi.getMusicDetail(term: 'blues', limit: '3');
    dance.value = await StoryMusicApi.getMusicDetail(term: 'dance', limit: '3');
    return true;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getSongs();
    super.onInit();
  }
}
