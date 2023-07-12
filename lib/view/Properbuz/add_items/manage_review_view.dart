import 'dart:io';
import 'package:bizbultest/models/Properbuz/city_list_model.dart';
import 'package:bizbultest/models/Properbuz/country_list_model.dart';
import 'package:bizbultest/services/Properbuz/api/country_api.dart';
import 'package:bizbultest/services/Properbuz/api/location_reviews_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http_parser/http_parser.dart';
import 'package:bizbultest/services/Properbuz/write_review_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart' as formdata;
import 'package:dio/src/multipart_file.dart' as multi;
import 'package:extended_image/extended_image.dart';
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:country_picker/country_picker.dart';

import '../../../Language/appLocalization.dart';
import '../../../api/api.dart';

// class ManageLocationReviewView
//     extends GetView<> {
//   ManageLocationReviewView({Key key}) : super(key: key);
class ManageLocationReviewView extends StatefulWidget {
  int? index;
  ManageLocationReviewView({Key? key, this.index}) : super(key: key);

  @override
  State<ManageLocationReviewView> createState() =>
      _ManageLocationReviewViewState();
}

class _ManageLocationReviewViewState extends State<ManageLocationReviewView> {
  WriteReviewController controller = Get.put(WriteReviewController());

  TextEditingController textEditingController = TextEditingController();
  TextEditingController enteredLoc = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController review = TextEditingController();
  TextEditingController url = TextEditingController();
  ScrollController countrylistscroll = ScrollController();

  @override
  void initState() {
    super.initState();
    getReviewData();
  }

  Future<List<dynamic>> getReviewList() async {
    controller.editLoding.value = true;
    var response = await ApiProvider().fireApi(
        'https://www.bebuzee.com/api/get_my_reviews_list.php?user_id=${CurrentUser().currentUser.memberID}');
    controller.editLoding.value = false;

    if (response.data['success'] == 1 &&
        response.data['data'] != null &&
        response.data['data'] != "") {
      print(response.data['data']);
      print("------- ${response.data['data'][widget.index]}");
      List<dynamic> ranges = response.data['data'];
      return ranges;
    } else {
      return [];
    }
  }

  getReviewData() async {
    var dataList = await getReviewList();
    controller.selectedCountry.value = dataList[widget.index!]['country'];
    enteredLoc.text = dataList[widget.index!]['location'];
    title.text = dataList[widget.index!]['review_title'];
    url.text = dataList[widget.index!]['video_url'];
    review.text = dataList[widget.index!]['review'];
    controller.rating.value = double.parse(dataList[widget.index!]['rating']);
    controller.thumbnail.value =
        dataList[widget.index!]['videothumbnail'].length == 0 ||
                dataList[widget.index!]['videothumbnail'] == []
            ? File("aa")
            : File(dataList[widget.index!]['videothumbnail'][0]);
    dataList[widget.index!]['images'].forEach((element) {
      controller.photos.add(File(element));
    });

    print("---------${controller.photos} ");
  }

  Widget _spacer() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
    );
  }

  Widget _customSelectButton(String val, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: 50,
        width: 100.0.w - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              val,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
            )
          ],
        ),
      ),
    );
  }

  Widget _locationField(double ht) {
    return Container(
      height: ht,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 0.6,
        ),
      ),
      child: TypeAheadFormField(
        hideSuggestionsOnKeyboardHide: true,
        hideOnEmpty: true,
        hideOnError: true,
        keepSuggestionsOnLoading: false,
        getImmediateSuggestions: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: enteredLoc,
          onTap: () {
            print(controller.cityList);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIconConstraints: BoxConstraints(),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: AppLocalizations.of('Enter') +
                ' ' +
                AppLocalizations.of('Location'),
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
        ),
        suggestionsCallback: (pattern) async {
          await controller.fetchLoc(pattern);

          if (pattern == '')
            return controller.cityList
                .where(
                    (element) => element.city!.toLowerCase().contains(pattern))
                .toList();
          else if (pattern != ' ') {
            return controller.cityList
                .where((element) =>
                    element.city!.toLowerCase().contains(pattern.toLowerCase()))
                .toList();
          } else
            return [];
        },
        itemBuilder: (context, dynamic suggestion) {
          return ListTile(
            leading: Icon(Icons.location_city),
            title: Text(suggestion!.city),
            // subtitle: Text('\$${suggestion['price']}'),
          );
        },
        onSuggestionSelected: (dynamic suggestion) async {
          if (suggestion == '') return;
          enteredLoc.text = suggestion!.city;
        },
      ),
    );
  }

  Widget _headerCard(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          header,
          style: TextStyle(
              fontSize: 14,
              color: hotPropertiesThemeColor,
              fontWeight: FontWeight.w500),
        ));
  }

  Widget _customTextFieldCountry(
    String hintText,
    double ht,
    TextEditingController textEditingController,
  ) {
    return Container(
      height: ht,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 0.6,
        ),
      ),
      child: TextFormField(
        maxLines: null,
        onChanged: (val) {},
        cursorColor: Colors.grey.shade500,
        controller: textEditingController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      ),
    );
  }

  Widget _customTextField(
    String hintText,
    double ht,
    TextEditingController textEditingController,
  ) {
    return Container(
      height: ht,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 0.6,
        ),
      ),
      child: TextFormField(
        maxLines: null,
        cursorColor: Colors.grey.shade500,
        controller: textEditingController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      ),
    );
  }

  Widget _ratingItemStar() {
    return Icon(
      Icons.star,
      color: hotPropertiesThemeColor,
      size: 10,
    );
  }

  Widget _ratingsBuilder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RatingBar.builder(
        initialRating: controller.rating.value,
        itemSize: 30,
        minRating: 0,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: 5,
        itemPadding: EdgeInsets.only(right: 10),
        itemBuilder: (context, index) => _ratingItemStar(),
        onRatingUpdate: (rating) {
          print(rating);
          controller.rating.value = rating;
        },
        glowRadius: 0,
      ),
    );
  }

  Widget _ratingString() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: new BoxDecoration(
          color: hotPropertiesThemeColor,
          borderRadius: BorderRadius.all(Radius.circular(2)),
          shape: BoxShape.rectangle,
        ),
        child: Obx(() => Text(
              controller.ratingString(controller.rating.value.toInt()),
              style: TextStyle(color: Colors.white, fontSize: 15),
            )));
  }

  Widget _ratingsRow() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_ratingsBuilder(), _ratingString()],
      ),
    );
  }

  Widget _selectionCard(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: 100,
          width: 100.0.w - 20,
          decoration: new BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: hotPropertiesThemeColor,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
          )),
    );
  }

  Widget _photoCard1(String filePath, VoidCallback onTap) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image.network(
                filePath,
                fit: BoxFit.cover,
                height: 250,
                width: 100.0.w,
              ),
            ),
          ),
          Positioned.fill(
            right: 10,
            top: 10,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  splashRadius: 15,
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(5),
                  onPressed: onTap,
                  icon: Icon(
                    CupertinoIcons.delete_solid,
                    color: hotPropertiesThemeColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _photoCard(File file, int index, VoidCallback onTap) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                height: 250,
                width: 100.0.w,
              ),
            ),
          ),
          Positioned.fill(
            right: 10,
            top: 10,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  splashRadius: 15,
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(5),
                  onPressed: onTap,
                  icon: Icon(
                    CupertinoIcons.delete_solid,
                    color: hotPropertiesThemeColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _thumbnailCard() {
    return Obx(
      () => Container(
        child: controller.thumbnail.value.path == "aa" ||
                controller.thumbnail.value == null
            ? _selectionCard("Select a photo for thumbnail",
                () => controller.pickThumbnail())
            : controller.pickedThumbnail.isTrue
                ? _photoCard(controller.thumbnail.value, 0,
                    () => controller.thumbnail.value = File("aa"))
                : _photoCard1(controller.thumbnail.value.path, () {
                    controller.thumbnail.value = File("aa");
                  }),
      ),
      //
    );
  }

  Widget _photosLengthCard() {
    return Positioned.fill(
      left: 20,
      bottom: 10,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Obx(() => Text(
                  "${controller.photos.length} ${controller.photosString()}",
                  style: TextStyle(
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ))),
      ),
    );
  }

  Widget countryListShow() {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10),
      title: _customTextFieldCountry(
          AppLocalizations.of('Select') + ' ' + AppLocalizations.of('Country'),
          50.0,
          textEditingController),
      scrollable: true,
      content: Container(
        height: Get.size.height / 1.5,
        width: Get.size.width / 1.5,
        child: ListView.builder(
          shrinkWrap: true,
          controller: ScrollController(initialScrollOffset: 2),
          itemCount: controller.countryList.length,
          itemBuilder: (context, index) => ListTile(
            contentPadding: EdgeInsets.all(10),
            onTap: () async {
              controller.selectedCountry.value =
                  controller.countryList[index].country!;
              // await controller.fetchCity();

              Navigator.of(context).pop();
            },
            leading: Icon(Icons.location_city),
            title: Text(controller.countryList[index].country!),
          ),
        ),
      ),
    );
  }

  Widget _photosBuilder() {
    return Obx(
      () => Container(
          child: controller.photos.isEmpty
              ? _selectionCard(
                  "Select photos from gallery",
                  () => controller.pickPhotosFiles(),
                )
              : Container(
                  height: 250,
                  child: Stack(
                    children: [
                      PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.photos.length,
                          itemBuilder: (context, index) {
                            return controller.pickedPhotosFile.isTrue
                                ? _photoCard(controller.photos[index], index,
                                    () => controller.deleteFile(index))
                                : _photoCard1(controller.photos[index].path,
                                    () => controller.deleteFile(index));
                          }),
                      _photosLengthCard()
                    ],
                  ),
                )),
    );
  }

  Future<bool> showError() async {
//  if(country=='Select a Country')
    //  await Get.showSnackbar(GetB)
    if (controller.selectedCountry.value == 'Select a country') {
      await Get.showSnackbar(GetBar(
        messageText: Text(
          AppLocalizations.of("Select a country"),
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
        duration: Duration(seconds: 1),
      ));
      return true;
    }
    if (enteredLoc.text == '') {
      await Get.showSnackbar(GetBar(
        messageText: Text(AppLocalizations.of("Enter a location"),
            style: TextStyle(color: Colors.white, fontSize: 20)),
        duration: Duration(seconds: 1),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
      ));
      return true;
    }
    if (review.text == '' ||
        controller.rating.value == 0.0 ||
        title.value.text == '') {
      await Get.showSnackbar(GetBar(
        messageText: Text(AppLocalizations.of("Enter the necessary fields"),
            style: TextStyle(color: Colors.white, fontSize: 20)),
        duration: Duration(seconds: 1),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
      ));
      return true;
    }
    return false;
  }

  Future showSuccess(context) async {
    await Get.showSnackbar(GetBar(
      messageText: Text(
        AppLocalizations.of("Added Location review Successfully.."),
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      icon: Icon(
        Icons.done_all_rounded,
        color: Colors.green,
      ),
      duration: Duration(seconds: 3),
    ));

    Navigator.of(context).pop();
    // Get.delete<WriteReviewController>();
    // Get.put(WriteReviewController());
    url.text = '';
    enteredLoc.text = '';
    title.text = '';
    review.text = '';
    enteredLoc.text = '';
  }

  Widget _submitButton(context) {
    return InkWell(
      onTap: () async {
        print("response is ${controller.selectedCountry.value}");
        Map<String, dynamic> query = {
          "user_id": '${CurrentUser().currentUser.memberID}',
          "country": controller.selectedCountry.value,
          "location": enteredLoc.text,
          "title": title.text,
          "review": review.text,
          'rating': controller.rating.value,
          'video_url': url.text
        };
        if (await showError()) {
          return;
        }

        await controller.onSubmit(context, query, showSuccess);
      },
      child: Container(
        height: 50,
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
            color: hotPropertiesThemeColor),
        margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
        child: Obx(
          () => Center(
            child: (controller.isUploading.isFalse)
                ? Text(
                    AppLocalizations.of("Submit"),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )
                : FittedBox(
                    child: CircularProgressIndicator(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(WriteReviewController());
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Get.delete<WriteReviewController>();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: hotPropertiesThemeColor,
          brightness: Brightness.dark,
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.keyboard_backspace,
              size: 28,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              Get.delete<WriteReviewController>();
            },
          ),
          title: Text(
            AppLocalizations.of("Update") +
                " " +
                AppLocalizations.of("Location") +
                " " +
                AppLocalizations.of("Reviews"),
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        body: Obx(
          () => controller.editLoding.isTrue
              ? Center(
                  child:
                      CircularProgressIndicator(color: hotPropertiesThemeColor),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _headerCard(AppLocalizations.of("Country")),
                      Obx(
                        () => _customSelectButton(
                            controller.selectedCountry.value, () {
                          return showCountryPicker(
                            context: context,
                            onSelect: (Country ct) async {
                              print("this country is ${ct.name}");
                              controller.selectCountry(ct);
                            },
                            countryListTheme: CountryListThemeData(
                              bottomSheetHeight:
                                  MediaQuery.of(context).size.height / 1.5,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                          );
                        }),
                      ),
                      _headerCard(AppLocalizations.of("Enter") +
                          " " +
                          AppLocalizations.of("Location")),
                      _locationField(50.0),
                      _headerCard(AppLocalizations.of("Title") +
                          " " +
                          AppLocalizations.of("of") +
                          " " +
                          AppLocalizations.of("your") +
                          " " +
                          AppLocalizations.of("review")),
                      _customTextField(
                          AppLocalizations.of("Summarize") +
                              " " +
                              AppLocalizations.of("your") +
                              " " +
                              AppLocalizations.of("visit") +
                              "...",
                          75,
                          title),
                      _headerCard(AppLocalizations.of("Your") +
                          " " +
                          AppLocalizations.of("Overall") +
                          " " +
                          AppLocalizations.of("Rating") +
                          " " +
                          AppLocalizations.of("of") +
                          " " +
                          AppLocalizations.of("this") +
                          " " +
                          AppLocalizations.of("Location")),
                      _ratingsRow(),
                      _headerCard(AppLocalizations.of("Your") +
                          " " +
                          AppLocalizations.of("Review")),
                      _customTextField(
                          AppLocalizations.of("Describe") +
                              " " +
                              AppLocalizations.of("your") +
                              " " +
                              AppLocalizations.of("visit") +
                              "...",
                          150,
                          review),
                      _headerCard(AppLocalizations.of("Enter") +
                          " " +
                          AppLocalizations.of("Video") +
                          " " +
                          AppLocalizations.of("URL") +
                          " " +
                          AppLocalizations.of("of") +
                          " " +
                          AppLocalizations.of("this") +
                          " " +
                          AppLocalizations.of("Location")),
                      _customTextField(
                          AppLocalizations.of("Enter") +
                              " " +
                              AppLocalizations.of("YouTube") +
                              ' ' +
                              AppLocalizations.of("URL"),
                          50,
                          url),
                      _headerCard(AppLocalizations.of("Video") +
                          " " +
                          AppLocalizations.of("Thumbnail") +
                          " " +
                          AppLocalizations.of("Image")),
                      _thumbnailCard(),
                      _headerCard(AppLocalizations.of("Upload") +
                          " " +
                          AppLocalizations.of("Photos") +
                          " " +
                          AppLocalizations.of("of") +
                          " " +
                          AppLocalizations.of("this") +
                          " " +
                          AppLocalizations.of("location")),
                      _photosBuilder(),
                      _submitButton(context)
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
