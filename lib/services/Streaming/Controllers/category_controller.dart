import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:bizbultest/services/Streaming/streaming_home_api_calls.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var categoricalVideoList = <StreamCategoriesModel>[].obs;
  var categoricalMoviesList = <StreamCategoriesModel>[].obs;
  var categoricalSeriesList = <StreamCategoriesModel>[].obs;
  var allCategoryList = <StreamCategoriesModel>[].obs;
  var myListVideos = <StreamCategoriesModel>[].obs;

  @override
  void onInit() {
    fetchCategoricalVideos();
    fetchCategoricalMovies("");
    fetchCategoricalSeries("");
    fetchMyListVideos();
    super.onInit();
  }

  void fetchCategoricalVideos() async {
    var categoryVideos = await StreamHomeApi.getCategoricalVideos("", "");
    if (categoryVideos != null) {
      categoricalVideoList.assignAll(categoryVideos.videos
          .where((element) => element.categoryData!.length > 0));
    }
    allCategoryList.assignAll(categoryVideos.videos);
  }

  void fetchCategoricalMovies(String categoryID) async {
    var categoryVideos =
        await StreamHomeApi.getCategoricalVideos("movies", categoryID);
    if (categoryVideos != null) {
      categoricalMoviesList.assignAll(categoryVideos.videos);
    }
  }

  void fetchCategoricalSeries(String categoryID) async {
    var categoryVideos =
        await StreamHomeApi.getCategoricalVideos("series", categoryID);
    if (categoryVideos != null) {
      categoricalSeriesList.assignAll(categoryVideos.videos);
    }
  }

  void fetchMyListVideos() async {
    var videos = await StreamHomeApi.getMyListVideos();
    if (videos != null) {
      myListVideos.assignAll(videos.videos);
    }
  }

  void getSeasons(int index, String season, int catIndex) async {
    categoricalSeriesList[index].categoryData![catIndex].episodes!.clear();
    print(index.toString() + " is index");
    print(catIndex.toString() + " is catIndex");
    print(categoricalSeriesList[index].categoryData![catIndex].videoId);
    var episodes = await StreamHomeApi.fetchEpisodes(
        categoricalSeriesList[index].categoryData![catIndex].videoId!, season);
    int noOfSeasons = int.parse(categoricalSeriesList[index]
        .categoryData![catIndex]
        .season!
        .split("")[0]);
    print(noOfSeasons.toString() + " seasons");
    List<String> seasons =
        List.generate(noOfSeasons, (index) => "Season $index");
    categoricalSeriesList[index]
        .categoryData![catIndex]
        .seasons!
        .assignAll(seasons);
    categoricalSeriesList[index]
        .categoryData![catIndex]
        .episodes!
        .assignAll(episodes);
  }
}
