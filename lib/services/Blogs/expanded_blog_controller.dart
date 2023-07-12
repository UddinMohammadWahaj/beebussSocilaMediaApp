import 'package:get/get.dart';

class ExpandedBlogController extends GetxController {
  var maindatalist = [].obs;
  var speakContent = false.obs;

  void mute() {
    speakContent.value = false;
  }

  void unmute() {
    speakContent.value = true;
  }
}
