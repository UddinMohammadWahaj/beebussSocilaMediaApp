import 'package:bizbultest/models/Properbuz/location_reviews_model.dart';
import 'package:bizbultest/services/Properbuz/api/location_reviews_api.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationReviewsController extends GetxController {
  var selectedCountry = "".obs;
  var selectedCity = "".obs;
  var isLoading = false.obs;
  var locationReviewsList = <LocationReviewsModel>[].obs;
  List<String> images = [
    "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8YXBhcnRtZW50JTIwbGl2aW5nJTIwcm9vbXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80",
    "https://res.cloudinary.com/apartmentlist/image/fetch/f_auto,q_auto,t_renter_life_cover/https://images.ctfassets.net/jeox55pd4d8n/63f7dRCQZRCXDDOYx6p9fo/5d0dd6ba4a252bbc5415d437ee09270a/images_Studio-Apartment-.jpg",
    "http://cdn.home-designing.com/wp-content/uploads/2018/06/Studio-apartment-with-loft-bed.jpg",
    "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/35jon-9979new-1593615607.jpg",
    "https://www.thespruce.com/thmb/ms_TeL_W-keH53AacSifzYGYi5o=/1200x800/filters:no_upscale():max_bytes(150000):strip_icc()/commonwealth_ave-01-d7c62f2d66584c6f93558b6700a881e1.jpeg",
    "https://www.arlingtonhouse.co.uk/wp-content/uploads/2020/09/Superior-Two-Bedroom-Apartment-with-Street-View003-1366x768-fp_mm-fpoff_0_0.jpg",
    "https://pyxis.nymag.com/v1/imgs/3b7/66f/9f550fcdabe47c4fd4f7943e4988993522-small-apartment-lede.jpg",
    "https://cdn.decorilla.com/online-decorating/wp-content/uploads/2020/07/Luxury-bedroom-with-modern-apartment-decor-ideas-by-TabbyTiara.jpg",
    "https://cdn.decoratorist.com/wp-content/uploads/modern-simple-bedroom-apartment-design-style-laredoreads-145411.jpg",
    "https://www.essexapartmenthomes.com/-/media/Project/EssexPropertyTrust/Sites/EssexApartmentHomes/Blog/2021/2021-01-12-Studio-vs-One-Bedroom-Apartment-How-They-Measure-Up/Studio-vs-One-Bedroom-Apartment-How-They-Measure-Up-1.jpg"
  ];
  List<LocationReviewsModel> getReviewsList(int value) {
    if (value == 1) {
      return locationReviewsList;
    } else {
      return <LocationReviewsModel>[];
    }
  }

  Future<void> getLocationReviews() async {
    isLoading.value = true;
    var reviews = await LocationReviewsAPI.fetchLocationReviews(
        selectedCountry.value, selectedCity.value);
    isLoading.value = false;
    if (reviews != null && reviews.isNotEmpty) {
      locationReviewsList.assignAll(reviews);
    } else {
      locationReviewsList.value = [];
    }
    print("object.. elements ${locationReviewsList}");
    locationReviewsList.forEach((element) {
      print("object.. elements $element");
      if (element.images!.length == 0) {
        // element.images = images;
      }
    });
  }

  void changeIndex(int page, int index, int val) {
    getReviewsList(val)[index].currentIndex!.value = page + 1;
  }

  var reviewsList = [
    {
      "name": "Betty",
      "location": "Gibraltar, Gibraltar",
      "description": "Moving To Gibraltar? Some Mistakes to Avoid",
      "image":
          "https://www.properbuz.com/user/uploads/reviews-of-gibraltar-gibraltar--moving-to-gibraltar--some-mistakes-to-avoid-768-1553792038092-6337150-6402707-image-a-1_1542539462084.jpg",
      "user_image":
          "https://www.properbuz.com/users/main/bettyroberts-1553791975-1664049296.jpg"
    },
    {
      "name": "Oscar",
      "location": "Dublin, Ireland",
      "description":
          "The five best and five worst things about living in Dublin",
      "image":
          "https://www.properbuz.com/user/uploads/reviews-of-ireland-dublin-the-five-best-and-five-worst-things-about-living-in-dublin-585-1552474746654-Copper-Face-Jacks.jpg",
      "user_image":
          "https://www.properbuz.com/users/main/oscarlawrence-1552475505-932327987.JPG"
    },
    {
      "name": "Ada",
      "location": "Frankfurt, Germany",
      "description": "The pros and cons of expat life in Frankfurt",
      "image":
          "https://www.properbuz.com/user/uploads/reviews-of-germany-frankfurt-the-pros-and-cons-of-expat-life-in-frankfurt-865-1551703105041-525_2_Frankfurt_Fotolia_93429875_Subscription_Monthly_XL.jpg",
      "user_image":
          "https://www.properbuz.com/users/main/adakoch-1551697033-201832404.jpg"
    },
  ].obs;

  void openYouTube(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
