import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:bizbultest/models/Streaming/genres_model.dart';
import 'package:bizbultest/services/Streaming/streaming_home_api_calls.dart';
import 'package:get/get.dart';

class CoverPageController extends GetxController {
  var isLoading = true.obs;
  var coverPageVideoList = <StreamCategoriesModel>[].obs;
  var coverPageMovieList = <StreamCategoriesModel>[].obs;
  var coverPageSeriesList = <StreamCategoriesModel>[].obs;
  var movieGenres = <GenresModel>[].obs;
  var seriesGenres = <GenresModel>[].obs;
  var selectedMovieGenre = "All Genres".obs;
  var selectedSeriesGenre = "All Genres".obs;

  @override
  void onInit() {
    getGenres();
    coverPageVideo();
    getCoverPageMovies();
    getCoverPageSeries();
    super.onInit();
  }

  List<GenresModel> genres(int val) {
    if (val == 1) {
      return movieGenres;
    } else {
      return seriesGenres;
    }
  }

  void selectGenre(int index, int val) {
    genres(val).forEach((element) {
      if (element.selected!.value) {
        element.selected!.value = false;
      }
    });
    genres(val)[index].selected!.value = true;
  }

  void resetGenres(int val) {
    genres(val).forEach((element) {
      if (element.selected!.value) {
        element.selected!.value = false;
      }
    });
  }

  void getGenres() async {
    var genres = await StreamHomeApi.getGenres();
    movieGenres.assignAll(genres);
    seriesGenres.assignAll(genres);
  }

  void coverPageVideo() async {
    var coverPageVideos = await StreamHomeApi.getCoverPage("");
    if (coverPageVideos != null) {
      coverPageVideoList.assignAll(coverPageVideos.videos);
    }
  }

  void getCoverPageMovies() async {
    var coverPageVideos = await StreamHomeApi.getCoverPage("movies");
    if (coverPageVideos != null) {
      coverPageMovieList.assignAll(coverPageVideos.videos);
    }
  }

  void getCoverPageSeries() async {
    var coverPageVideos = await StreamHomeApi.getCoverPage("series");
    if (coverPageVideos != null) {
      coverPageSeriesList.assignAll(coverPageVideos.videos);
    }
  }
}
