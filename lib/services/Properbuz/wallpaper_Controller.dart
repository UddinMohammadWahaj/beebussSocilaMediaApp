// import 'package:bizbultest/api/api.dart';
// import 'package:bizbultest/models/SavedPropertiesModel.dart';
// import 'package:bizbultest/models/SearchPropertiesListModel.dart';
// import 'package:bizbultest/services/current_user.dart';
// import 'package:get/get.dart';

// class WallpaperController extends GetxController {
//   var lstWallpaper = Map<dynamic,String>().obs;

//   @override
//   void onInit() {
//     super.onInit();
//     String uid = CurrentUser().currentUser.memberID;
//     // uid = "1796768";
//     fetchData(uid);
//   }

//   Future<void> fetchData(uid) async {
//     var wallpapers = await ApiProvider().wallpaper(uid);
//     lstWallpaper = wallpapers;
//   }
// }
