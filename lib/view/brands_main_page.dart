import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/brand_category_list_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/models/detailed_brands_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandsMainPage extends StatefulWidget {
  final String? category;

  BrandsMainPage({Key? key, this.category}) : super(key: key);

  @override
  _BrandsMainPageState createState() => _BrandsMainPageState();
}

class _BrandsMainPageState extends State<BrandsMainPage> {
  late DetailedBrands brandsList;
  bool areBrandsLoaded = false;
  bool showSearch = false;
  bool areCategoriesLoaded = false;
  late BrandCategories categoryList;
  var selectedCategory;

  bool abc = false;
  bool def = false;
  bool ghi = false;
  bool jkl = false;
  bool mno = false;
  bool pqr = false;
  bool stu = false;
  bool vwx = false;
  bool yz = false;
  String brand = "";

  TextEditingController _searchController = TextEditingController();

  Future<void> getBrands(String letters, String search, String brand) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blogbuzfeed_brand_details_page_data&user_id=${CurrentUser().currentUser.memberID}&category_data=$brand&id="
        "&country=${CurrentUser().currentUser.country}&name=$search&data_seq=$letters&all_ids=");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      DetailedBrands feedData =
          DetailedBrands.fromJson(jsonDecode(response.body));
      setState(() {
        brandsList = feedData;
        areBrandsLoaded = true;
      });
    }
  }

  Future<void> getCategoryList() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blogbuzfeed_brand_details_page_top&user_id=${CurrentUser().currentUser.memberID}&category_data=${widget.category}&country=${CurrentUser().currentUser.country}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      BrandCategories categoryData =
          BrandCategories.fromJson(jsonDecode(response.body));
      setState(() {
        categoryList = categoryData;
        areCategoriesLoaded = true;
        categoryList.categories.forEach((element) {
          if (element.category!.toLowerCase() ==
              widget.category.toString().toLowerCase()) {
            setState(() {
              element.isSelected = true;
            });
          }
        });
      });
    }
  }

  Widget _categoryListTile(BrandCategoryListModel category, int index) {
    return ListTile(
      onTap: () {
        _onTap(category.category!);
        setState(() {
          categoryList.categories[index].isSelected = true;
        });
        getBrands("", _searchController.text, selectedCategory);
      },
      title: Text(
        category.category!,
        style: TextStyle(fontSize: 16),
      ),
      trailing: category.isSelected!
          ? Icon(
              Icons.check,
              color: Colors.black,
              size: 30,
            )
          : null,
    );
  }

  Widget _brandSheetHeaderCard() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: Border(
            bottom: BorderSide(color: Colors.black, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                splashRadius: 20,
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.back();
                }),
            Text(
              AppLocalizations.of(
                "Filter by brand",
              ),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              "",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }

  Widget _brandBottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _brandSheetHeaderCard(),
        Container(
          height: 40.0.h,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: categoryList.categories.length,
              itemBuilder: (context, index) {
                return _categoryListTile(categoryList.categories[index], index);
              }),
        ),
      ],
    );
  }

  void _onTap(String cat) {
    categoryList.categories.forEach((element) {
      if (element.isSelected!) {
        setState(() {
          element.isSelected = false;
        });
      }
    });
    setState(() {
      selectedCategory = cat;
    });

    Get.back();
  }

  @override
  void initState() {
    selectedCategory =
        widget.category![0].toUpperCase() + widget.category!.substring(1);
    getCategoryList();
    getBrands("", "", selectedCategory);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 3.0.h),
              child: Text(
                selectedCategory.toUpperCase() + " " + "\n" "BRANDS",
                style: TextStyle(fontSize: 40.0.sp, fontFamily: 'Arial'),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                print(widget.category![0].toUpperCase() +
                    widget.category!.substring(1));
                setState(() {
                  showSearch = !showSearch;
                  abc = false;
                  def = false;
                  ghi = false;
                  jkl = false;
                  mno = false;
                  pqr = false;
                  stu = false;
                  vwx = false;
                  yz = false;
                });
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: new Border.all(
                      color: primaryBlueColor,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of('Search'),
                    style: TextStyle(fontFamily: 'Arial', fontSize: 15.0.sp),
                    textAlign: TextAlign.center,
                  )),
            ),
            showSearch == true
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 70.0.w - 40,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade500, width: 0.6),
                            ),
                          ),
                          height: 50,
                          child: TextFormField(
                            onTap: () {},
                            maxLines: 1,
                            controller: _searchController,
                            keyboardType: TextInputType.text,
                            style: Theme.of(context).textTheme.bodyText1,
                            onChanged: (val) {},
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              suffixIconConstraints: BoxConstraints(),
                              suffixIcon: Icon(
                                Icons.search,
                                color: primaryBlueColor,
                              ),
                              hintText: AppLocalizations.of(
                                "Search by brand name",
                              ),

                              // 48 -> icon width
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              _brandBottomSheet(),
                              backgroundColor: Colors.white,
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 30.0.w - 20,
                            height: 50,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.shade500, width: 0.6),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 25.0.w - 25,
                                  child: Text(
                                    selectedCategory,
                                    style: TextStyle(fontSize: 10.0.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            showSearch == true
                ? Padding(
                    padding: EdgeInsets.only(top: 2.0.h, bottom: 1.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LetterButton(
                          onPress: () {
                            getBrands("a~b~c", _searchController.text,
                                selectedCategory);
                            setState(() {
                              abc = true;
                              def = false;
                              ghi = false;
                              jkl = false;
                              mno = false;
                              pqr = false;
                              stu = false;
                              vwx = false;
                              yz = false;
                            });
                          },
                          changeColor: abc,
                          isLast: false,
                          letter1: "A",
                          letter2: "B",
                          letter3: "C",
                        ),
                        LetterButton(
                          onPress: () {
                            getBrands("d~e~f", _searchController.text,
                                selectedCategory);
                            setState(() {
                              abc = false;
                              def = true;
                              ghi = false;
                              jkl = false;
                              mno = false;
                              pqr = false;
                              stu = false;
                              vwx = false;
                              yz = false;
                            });
                          },
                          changeColor: def,
                          isLast: false,
                          letter1: "D",
                          letter2: "E",
                          letter3: "F",
                        ),
                        LetterButton(
                          onPress: () {
                            getBrands("g~h~i", _searchController.text,
                                selectedCategory);
                            setState(() {
                              abc = false;
                              def = false;
                              ghi = true;
                              jkl = false;
                              mno = false;
                              pqr = false;
                              stu = false;
                              vwx = false;
                              yz = false;
                            });
                          },
                          changeColor: ghi,
                          isLast: false,
                          letter1: "G",
                          letter2: "H",
                          letter3: "I",
                        ),
                        LetterButton(
                          onPress: () {
                            getBrands("j~k~l", _searchController.text,
                                selectedCategory);
                            setState(() {
                              abc = false;
                              def = false;
                              ghi = false;
                              jkl = true;
                              mno = false;
                              pqr = false;
                              stu = false;
                              vwx = false;
                              yz = false;
                            });
                          },
                          changeColor: jkl,
                          isLast: true,
                          letter1: "J",
                          letter2: "K",
                          letter3: "L",
                        ),
                      ],
                    ),
                  )
                : Container(),
            showSearch == true
                ? Padding(
                    padding: EdgeInsets.only(top: 1.0.h, bottom: 1.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LetterButton(
                          onPress: () {
                            getBrands("m~n~o", _searchController.text,
                                selectedCategory);
                            setState(() {
                              abc = false;
                              def = false;
                              ghi = false;
                              jkl = false;
                              mno = true;
                              pqr = false;
                              stu = false;
                              vwx = false;
                              yz = false;
                            });
                          },
                          changeColor: mno,
                          isLast: false,
                          letter1: "M",
                          letter2: "N",
                          letter3: "O",
                        ),
                        LetterButton(
                          onPress: () {
                            getBrands("p~q~r", _searchController.text,
                                selectedCategory);
                            setState(() {
                              abc = false;
                              def = false;
                              ghi = false;
                              jkl = false;
                              mno = false;
                              pqr = true;
                              stu = false;
                              vwx = false;
                              yz = false;
                            });
                          },
                          changeColor: pqr,
                          isLast: false,
                          letter1: "P",
                          letter2: "Q",
                          letter3: "R",
                        ),
                        LetterButton(
                          onPress: () {
                            getBrands("s~t~u", _searchController.text,
                                selectedCategory);
                            setState(() {
                              abc = false;
                              def = false;
                              ghi = false;
                              jkl = false;
                              mno = false;
                              pqr = false;
                              stu = true;
                              vwx = false;
                              yz = false;
                            });
                          },
                          changeColor: stu,
                          isLast: false,
                          letter1: "S",
                          letter2: "T",
                          letter3: "U",
                        ),
                        LetterButton(
                          onPress: () {
                            getBrands("v~w~x", _searchController.text,
                                selectedCategory);
                            setState(() {
                              abc = false;
                              def = false;
                              ghi = false;
                              jkl = false;
                              mno = false;
                              pqr = false;
                              stu = false;
                              vwx = true;
                              yz = false;
                            });
                          },
                          changeColor: vwx,
                          isLast: true,
                          letter1: "V",
                          letter2: "W",
                          letter3: "X",
                        ),
                      ],
                    ),
                  )
                : Container(),
            showSearch == true
                ? Padding(
                    padding: EdgeInsets.only(top: 1.0.h, bottom: 1.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LetterButton(
                          onPress: () {
                            getBrands("y~z", _searchController.text,
                                selectedCategory);
                            setState(() {
                              abc = false;
                              def = false;
                              ghi = false;
                              jkl = false;
                              mno = false;
                              pqr = false;
                              stu = false;
                              vwx = false;
                              yz = true;
                            });
                          },
                          changeColor: yz,
                          isLast: false,
                          letter1: "Y",
                          letter2: "Z",
                        ),
                      ],
                    ),
                  )
                : Container(),
            areBrandsLoaded == true
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: brandsList.brands.length,
                    itemBuilder: (context, index) {
                      var brand = brandsList.brands[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  brand.showInfo = true;
                                });
                              },
                              child: brand.showInfo == false
                                  ? Container(
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: brand.image!,
                                        // errorWidget: (context, url, error) => new Icon(Icons.error),
                                      ),
                                    )
                                  : GestureDetector(
                                      /*  onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WebsiteView(
                                                  url: brand.description: ""
                                              )));
                                },*/
                                      child: Container(
                                        color: primaryBlueColor,
                                        height: 60.0.h,
                                        width: 100.0.w,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0.h,
                                              horizontal: 5.0.h),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                brand.category!.toUpperCase() +
                                                    " BRAND",
                                                style: whiteBold.copyWith(
                                                    fontSize: 12.0.sp,
                                                    fontFamily: 'Arial'),
                                              ),
                                              Text(
                                                brand.description!,
                                                style: whiteNormal.copyWith(
                                                    fontSize: 17.0.sp,
                                                    fontFamily: 'Georgie'),
                                                textAlign: TextAlign.center,
                                                maxLines: 8,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Container(
                                                  decoration: new BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    border: new Border.all(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2.0.w,
                                                            vertical: 1.0.h),
                                                    child: Text(
                                                        brand.name!
                                                            .toUpperCase(),
                                                        style:
                                                            whiteBold.copyWith(
                                                          fontSize: 12.0.sp,
                                                          fontFamily: 'Arial',
                                                        )),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      );
                    })
                : Container()
          ],
        )),
      ),
    );
  }
}

class LetterButton extends StatefulWidget {
  final String? letter1;
  final String? letter2;
  final String? letter3;
  final bool? changeColor;
  final VoidCallback? onPress;
  final bool? isLast;

  LetterButton(
      {Key? key,
      this.letter1,
      this.letter2,
      this.letter3,
      this.changeColor,
      this.onPress,
      this.isLast})
      : super(key: key);

  @override
  _LetterButtonState createState() => _LetterButtonState();
}

class _LetterButtonState extends State<LetterButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress ?? () {},
      child: Padding(
        padding: EdgeInsets.only(right: widget.isLast == false ? 3.0.w : 0),
        child: Container(
          height: 2.5.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.letter1!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        widget.changeColor == true ? Colors.black : Colors.grey,
                    fontSize: 12.0.sp),
              ),
              SizedBox(
                width: 3.0.w,
              ),
              Text(
                widget.letter2!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        widget.changeColor == true ? Colors.black : Colors.grey,
                    fontSize: 12.0.sp),
              ),
              SizedBox(
                width: widget.letter3 == null ? 0 : 3.0.w,
              ),
              widget.letter3 != null
                  ? Text(
                      widget.letter3!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.changeColor == true
                              ? Colors.black
                              : Colors.grey,
                          fontSize: 12.0.sp),
                    )
                  : Container(),
              SizedBox(
                width: widget.letter3 == null ? 0 : 3.0.w,
              ),
              widget.letter3 != null
                  ? Container(
                      width: 2,
                      color: Colors.grey,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
