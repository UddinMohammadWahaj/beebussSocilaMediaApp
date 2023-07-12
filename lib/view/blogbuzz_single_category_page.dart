import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/blogbuzz_brand_model.dart';
import 'package:bizbultest/models/blogbuzz_category_model.dart';
import 'package:bizbultest/services/Blogs/blog_api_calls.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/common_appbar.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/widgets/Blogbuz/blogbuzz_featured_brand_card.dart';
import 'package:bizbultest/widgets/Blogbuz/blogbuzz_single_category_card.dart';
import 'package:bizbultest/widgets/Blogbuz/category_list_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Profile/profile_settings_page.dart';
import 'package:sizer/sizer.dart';

import 'brands_main_page.dart';

class BlogBuzzCategoryMainPage extends StatefulWidget {
  final String? category;
  final String? cateID;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final Function? refresh;
  final Function? refreshFromShortbuz;
  final Function? refreshFromMultipleStories;
  final String? recipeCategory;
  final String? country;
  final String? language;

  BlogBuzzCategoryMainPage(
      {Key? key,
      this.category,
      this.cateID,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.refresh,
      this.refreshFromShortbuz,
      this.refreshFromMultipleStories,
      this.recipeCategory,
      this.country,
      this.language})
      : super(key: key);

  @override
  _BlogBuzzCategoryMainPageState createState() =>
      _BlogBuzzCategoryMainPageState();
}

class _BlogBuzzCategoryMainPageState extends State<BlogBuzzCategoryMainPage> {
  late Future _blogsFuture;
  int selectedIndex = 0;
  bool areBrandsLoaded = false;
  String cateID = "";
  bool areBlogsLoaded = false;
  Brands brandList = new Brands([]);
  BlogCategories blogList = BlogCategories([]);
  int currentPage = 1;
  late int totalPages;

  Future<void> getBrands() async {
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/blogbuz_brand.php?action=blogbuzfeed_brand&category_data=${widget.category}&country=${CurrentUser().currentUser.country}');
    var client = Dio();
    await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) async {
      try {
        if (value.statusCode == 200) {
          print('Blobuz get brand=${value.data}');
          Brands brandData = Brands.fromJson(value.data['data']);
          await Future.wait(brandData.brands
              .map((e) => Preload.cacheImage(context, e.image!))
              .toList());
          if (mounted) {
            setState(() {
              brandList = brandData;
              areBrandsLoaded = true;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              areBrandsLoaded = false;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            areBrandsLoaded = false;
          });
        }
      }
    });

    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=blogbuzfeed_brand&category_data=${widget.category}&country=${CurrentUser().currentUser.country}");

    // var response = await http.get(url);

    // if (response.statusCode == 200 &&
    //     response.body != null &&
    //     response.body != "") {
    // Brands brandData = Brands.fromJson(jsonDecode(response.body));
    // await Future.wait(brandData.brands
    //     .map((e) => Preload.cacheImage(context, e.image))
    //     .toList());
    // if (mounted) {
    //   setState(() {
    //     brandList = brandData;
    //     areBrandsLoaded = true;
    //   });
    // }
    // }
    // if (response.body == null || response.statusCode != 200) {
    //   if (mounted) {
    //     setState(() {
    //       areBrandsLoaded = false;
    //     });
    //   }
    // }
  }

  void _getBlogs() async {
    print('Recipe categ aa ${widget.recipeCategory}');

    _blogsFuture = BlogApiCalls.geBlogCategories(
            context,
            widget.category!,
            widget.recipeCategory! == null ? cateID : widget.recipeCategory!,
            currentPage,
            widget.country!,
            widget.language!)
        .then((value) {
      if (mounted) {
        setState(() {
          blogList.categories = value.categories;
          totalPages = blogList.categories[0].totalPages!;
        });
        return value;
      }
    });
  }

  void setCategoryID() {
    if (widget.cateID != null) {
      setState(() {
        cateID = widget.cateID!;
      });
    }
  }

  Widget _paginationWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              if (currentPage > 1) {
                setState(() {
                  areBlogsLoaded = false;
                  currentPage = --currentPage;
                  blogList.categories = [];
                });
                _getBlogs();
              }
            },
            child: CircleAvatar(
                radius: 25,
                backgroundColor: currentPage == 1
                    ? Colors.grey.withOpacity(0.6)
                    : primaryBlueColor,
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.white,
                )),
          ),
          Text(
            AppLocalizations.of("Page") +
                " " +
                currentPage.toString() +
                "/" +
                totalPages.toString(),
            style: TextStyle(fontSize: 14),
          ),
          GestureDetector(
            onTap: () {
              if (currentPage < totalPages) {
                setState(() {
                  areBlogsLoaded = false;
                  currentPage = ++currentPage;
                  blogList.categories = [];
                });
                _getBlogs();
              }
            },
            child: CircleAvatar(
                radius: 25,
                backgroundColor: currentPage == totalPages
                    ? Colors.grey.withOpacity(0.6)
                    : primaryBlueColor,
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }

  Widget _brandsWidget() {
    return Container(
      height: 60.0.h,
      child: PageView.builder(
          onPageChanged: (ind) {
            setState(() {
              selectedIndex = ind;
            });
          },
          scrollDirection: Axis.horizontal,
          itemCount: brandList.brands.length,
          itemBuilder: (context, index) {
            return FeaturedBrandCard(
              index: index,
              lastIndex: brandList.brands.length - 1,
              brand: brandList.brands[index],
            );
          }),
    );
  }

  Widget _blogsWidget() {
    return FutureBuilder(
        future: _blogsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: blogList.categories.length,
                itemBuilder: (context, index) {
                  return BlogBuzzSingleCategoryCard(
                    refreshFromMultipleStories:
                        widget.refreshFromMultipleStories,
                    refresh: widget.refresh,
                    refreshFromShortbuz: widget.refreshFromShortbuz,
                    setNavBar: widget.setNavBar,
                    isChannelOpen: widget.isChannelOpen,
                    changeColor: widget.changeColor,
                    index: index,
                    lastIndex: blogList.categories.length - 1,
                    blog: blogList.categories[index],
                  );
                });
          } else {
            return Container();
          }
        });
  }

  Widget _brandHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.0.w,
            height: 3,
            color: Colors.black,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border(
                top: BorderSide(color: Colors.black, width: 7),
              ),
            ),
            child: Text(
              AppLocalizations.of(
                "Featured\nBrands",
              ),
              style: TextStyle(
                  fontSize: 20.0.sp,
                  fontFamily: "Georgie",
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
      //height: 2.2.w,
      //width: 10.0.w,
    );
  }

  Widget _moreBrands() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BrandsMainPage(
                      category: widget.category,
                    )));
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              AppLocalizations.of(
                "MORE BRANDS",
              ),
              style: blackBoldShaded.copyWith(fontSize: 14.0.sp),
            ),
            CircleAvatar(
                radius: 3.0.h,
                backgroundColor: primaryBlueColor,
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }

  Widget _dotCard(int index) {
    return Container(
      decoration: index == selectedIndex
          ? new BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(
                color: primaryBlueColor,
                width: 1,
              ),
            )
          : null,
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 7,
        child: CircleAvatar(
          backgroundColor:
              index == selectedIndex ? primaryBlueColor : Colors.grey.shade300,
          radius: index == selectedIndex ? 5 : 4,
        ),
      ),
    );
  }

  Widget _dotIndicatorRow() {
    return Container(
      color: Colors.transparent,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: brandList.brands
            .asMap()
            .map((index, value) => MapEntry(index, _dotCard(index)))
            .values
            .toList(),
      ),
    );
  }

  @override
  void initState() {
    setCategoryID();
    _getBlogs();
    getBrands();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CommonAppbar(
          setNavbar: widget.setNavBar,
          isChannelOpen: widget.isChannelOpen,
          profileButton: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileSettingsPage(
                          setNavbar: widget.setNavBar!,
                        )));
          },
          logo: CurrentUser().currentUser.logo,
          country: CurrentUser().currentUser.country,
          memberID: CurrentUser().currentUser.memberID,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              CategoryListCard(),
              brandList.brands.length > 0
                  ? Column(
                      children: [
                        _brandHeader(),
                        _brandsWidget(),
                        _dotIndicatorRow(),
                        _moreBrands(),
                      ],
                    )
                  : Container(),
              _blogsWidget(),
              blogList.categories.length > 0 ? _paginationWidget() : Container()
            ],
          ),
        ),
      ),
    );
  }
}
