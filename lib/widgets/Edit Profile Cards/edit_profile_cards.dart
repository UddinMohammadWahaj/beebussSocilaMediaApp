import 'package:bizbultest/models/business_categories_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class EditProfileTextInput extends StatelessWidget {
  final String? title;
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLines;

  EditProfileTextInput(
      {Key? key, this.title, this.controller, this.hintText, this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2.0.h, bottom: 1.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller!.text == ""
              ? Container()
              : Text(
                  title!,
                  style: greyNormal.copyWith(fontSize: 10.0.sp),
                ),
          TextFormField(
            controller: controller,
            maxLines: maxLines == null ? null : maxLines,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: hintText,
                contentPadding: EdgeInsets.only(
                  left: 1.0.w,
                ),
                hintStyle: TextStyle(fontSize: 12.0.sp, color: Colors.grey)
                // 48 -> icon width
                ),
          ),
        ],
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final String? title;
  final String? value;
  final VoidCallback? onPress;

  ProfileInfoCard({Key? key, this.title, this.value, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress ?? () {},
      child: Container(
        padding: EdgeInsets.only(top: 3.5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title!,
              style: TextStyle(fontSize: 11.5.sp),
            ),
            Row(
              children: [
                Text(
                  value!,
                  style: greyNormal.copyWith(fontSize: 10.0.sp),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.5.w),
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 2.5.h,
                    color: Colors.grey,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CategorySelection extends StatefulWidget {
  final String? title;
  TextEditingController? controller;
  final String? hintText;
  final VoidCallback? selectedCategory;
  final Function? setCategory;

  CategorySelection(
      {Key? key,
      this.title,
      this.hintText,
      this.controller,
      this.selectedCategory,
      this.setCategory})
      : super(key: key);

  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  bool areCategoriesLoaded = false;
  late BusinessCategories categoriesList;

//TODO:: inSheet 330
  Future<void> getCategories(String search) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=get_category_list_data&user_id=${CurrentUser().currentUser.memberID}&keyword=$search");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/member_category.php", {
      // "user_id": CurrentUser().currentUser.memberID,
      "search_category": search,
    });

    if (response!.success == 1) {
      late BusinessCategories categoryData;

      print("response of category=${response!.data}");
      try {
        categoryData = BusinessCategories.fromJson(response!.data['data']);
      } catch (e) {
        print("exception =${e}");
      }
      if (mounted) {
        setState(() {
          print("category data reached ${categoryData.categories.length}");
          categoriesList = categoryData;
          areCategoriesLoaded = true;
        });
      }
    }
    if (response!.success != 1 || response!.data['data'] == null) {
      if (mounted) {
        setState(() {
          areCategoriesLoaded = false;
        });
      }
    }
  }

//TODO:: inSheet 333
  Future<void> updateCategory(String categoryID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=update_user_category&user_id=${CurrentUser().currentUser.memberID}&category_id=$categoryID");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_category_update.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "category_id": categoryID,
    });

    print(response!.data['data']);
    if (response!.success == 1) {}
  }

  // List categoryList = [
  //   "Artist",
  //   "Education",
  //   "Entrepreneur",
  //   "Health/Beauty",
  //   "Editor",
  //   "Writer",
  //   "Personal Blog",
  //   "Product/Service",
  //   "Games",
  //   "Media",
  //   "Entertainment",
  //   "Sports",
  //   "Finance",
  //   "Real Estate"
  // ];

  @override
  void initState() {
    getCategories("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: 2.0.h, bottom: 1.0.h, left: 2.0.w, right: 2.0.w),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: TextFormField(
              onChanged: (val) {
                if (val != "") {
                  getCategories(val);
                } else {
                  getCategories("");
                }
              },
              controller: widget.controller,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,

                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: widget.hintText,
                contentPadding: EdgeInsets.only(top: 14),
                hintStyle: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
                alignLabelWithHint: true,
                // contentPadding: EdgeInsets.zero
                // 48 -> icon width
              ),
            ),
          ),
          Container(
              height: 52.0.h,
              child: areCategoriesLoaded
                  ? ListView.builder(
                      itemCount: categoriesList.categories.length,
                      itemBuilder: (context, index) {
                        var category =
                            categoriesList.categories[index].category;
                        return GestureDetector(
                          onTap: () {
                            updateCategory(
                                categoriesList.categories[index].categoryId!);
                            setState(() {
                              CurrentUser().currentUser.category = category;
                              widget.controller!.text = category.toString();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80.0.w,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.0.w, vertical: 1.5.h),
                                  child: Text(
                                    category.toString(),
                                    style: TextStyle(fontSize: 12.0.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              category == CurrentUser().currentUser.category
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : Container()
                            ],
                          ),
                        );
                      })
                  : Container()),
        ],
      ),
    );
  }
}
