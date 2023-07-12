import 'package:get/get.dart';

class SearchLocationViewPageController extends GetxController {
  var currentIndex = 0.obs;
  var textVisiblity = 5.obs;
  void jumpToImage(index) {
    currentIndex.value = index;
  }
}
