import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/blogbuz_countries_model.dart';
import 'package:bizbultest/services/Blogs/blog_api_calls.dart';
import 'package:bizbultest/widgets/Blogbuz/Recipe/countrysearchpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'language_bottom_sheet.dart';

class BlogBuzzCountryController extends GetxController {
  var countryList = <BlogCountries>[].obs;
}

class BlogBuzzCountryPage extends StatefulWidget {
  final String? category;
  final String? recipeCategory;
  Function? setNavBar;

  BlogBuzzCountryPage(
      {Key? key, this.category, this.recipeCategory, this.setNavBar})
      : super(key: key);

  @override
  _BlogBuzzCountryPageState createState() => _BlogBuzzCountryPageState();
}

class _BlogBuzzCountryPageState extends State<BlogBuzzCountryPage> {
  TextEditingController controller = TextEditingController();

  BlogCountries countries = BlogCountries([]);
  BlogCountries mainCountries = BlogCountries([]);
  late BlogCountriesModel country;
  var totallength;

  Widget _searchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: new BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        shape: BoxShape.rectangle,
      ),
      child: TextFormField(
        // onTap: () {
        //   Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => CountrySearchDemo(
        //         category: widget.category,
        //         countrylist: [],
        //         mainCountries: mainCountries,
        //         recipeCategory: widget.recipeCategory),
        //   ));
        // },
        onChanged: (val) => _searchCountries(val),
        maxLines: 1,
        cursorColor: Colors.grey.shade600,
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.search,
              color: Colors.grey.shade700,
            ),
          ),
          border: InputBorder.none,
          prefixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of('Search'),
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ),
    );
  }

  Widget _countryCard(
      String flag, String name, VoidCallback onTap, Datum data) {
    return GestureDetector(
      onTap: () => _openLanguageSheet(data),
      child: Card(
        color: Colors.grey.shade100,
        elevation: 3,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4),
          decoration: new BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                flag,
                style: TextStyle(fontSize: 24.0.sp),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                name,
                style: TextStyle(fontSize: 11.0.sp, color: Colors.black),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLanguageSheet(Datum data) {
    print(data.languages);
    print("Recipe categ ->cat = ${widget.category}${widget.recipeCategory}");
    Get.bottomSheet(
        LanguageBottomSheet(
          category: widget.category,
          recipeCategory: widget.recipeCategory,
          data: data,
          setNavBar: widget.setNavBar,
        ),
        isScrollControlled: false,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0))));
  }

  void filterdatum() async {
    List<Datum> listdatum = [];
    mainCountries.countries.forEach((element) {
      element.data!.forEach((element) {
        listdatum.add(element);
      });
    });
  }

  void _getCountries({String search = ''}) async {
    print("getCountries callledddd ");
    print("tapped on ${widget.category}");
    var countryData = await BlogApiCalls.getBlogCountries(
        widget.category!.replaceAll(" & ", "and"),
        recipe: widget.recipeCategory!,
        searchCountry: search);
    if (countries != null) {
      setState(() {
        countries.countries = countryData.countries;
        mainCountries.countries = countryData.countries;
        totallength = mainCountries.countries.length;
      });
      // _setUserCountry();
    }
  }

  void unhide() {
    for (int i = 0; i < mainCountries.countries.length; i++) {
      var region = mainCountries.countries[i].data;
      for (int j = 0; j < mainCountries.countries[i].data!.length; j++) {
        setState(() {
          mainCountries.countries[i].data![j].hide = false;
        });
      }
    }
  }

  void _searchCountries(String name) async {
    // print("search $name");
    // var listcountry = <BlogCountriesModel>[];

    // if (name == null || name.trim() == '') {
    //   print("name is empty");
    //   unhide();
    //   setState(() {
    //     countries.countries = mainCountries.countries;
    //   });

    //   return;
    // }
    // for (int i = 0; i < mainCountries.countries.length; i++) {
    //   var region = mainCountries.countries[i].data;
    //   for (int j = 0; j < mainCountries.countries[i].data.length; j++) {
    //     var country = mainCountries.countries[i].data[j];
    //     print("search= ${name} and country=${country.country}");
    //     if (!country.country
    //         .toLowerCase()
    //         .contains(name.toLowerCase().trimLeft())) {
    //       print("search falsereal= ${name} and country=${country.country}");
    //       setState(() {
    //         mainCountries.countries[i].data[j].hide = true;
    //       });
    //       setState(() {});
    //     } else {
    //       print("search truereal= ${name} and country=${country.country}");
    //       setState(() {
    //         mainCountries.countries[i].data[j].hide = false;
    //       });
    //     }
    //   }
    // }
    // List<BlogCountriesModel> temp = [];
    // mainCountries.countries.forEach((element) {
    //   var data =
    //       element.data.where((element) => element.hide == false).toList();
    //   var z = element;
    //   z.data = data;
    //   temp.add(z);
    // });
    // setState(() {
    //   countries.countries = temp;
    // });

    _getCountries(search: controller.value.text);
    return;

//Test
    List<BlogCountriesModel> listofblogcountrymodel = [];
    List<Datum> listofdatum = [];

    for (int i = 0; i < mainCountries.countries.length; i++) {
      listofdatum = countries.countries[i].data!
          .where((element) => element.country!
              .toLowerCase()
              .toString()
              .contains(name.toLowerCase()))
          .toList();
      mainCountries.countries[i].data = listofdatum;
    }
    // mainCountries.countries.forEach((element) {
    //   listofdatum = element.data.where((element) {
    //     return element.country
    //         .toLowerCase()
    //         .toString()
    //         .contains(name.toLowerCase());
    //   }).toList();
    //   element.data = listofdatum;
    //   // element.data.forEach((element) {
    //   //   if (element.country
    //   //       .toLowerCase()
    //   //       .toString()
    //   //       .contains(name.toLowerCase())) {}
    //   // });
    // }
    // );

//Test end
//TEST STOP
    mainCountries.countries.forEach((element) {
      element.data!.where((element) {
        return true;
      });

      element.data!.forEach((element) {
        if (element.country!
            .toLowerCase()
            .toString()
            .contains(name.toLowerCase())) {
          // return true;
        }
      });
    });
    //TEST STOP

    setState(() {
      countries.countries =
          //  mainCountries.countries;

          mainCountries.countries
              .where((element) => element.region
                  .toString()
                  .toLowerCase()
                  .contains(name.toLowerCase()))
              .toList();
    });
  }

  void _setUserCountry() {
    setState(() {
      country = mainCountries.countries[0];
      countries.countries.removeAt(0);
      mainCountries.countries.removeAt(0);
    });
  }

  //
  // Widget _userCountryCard() {
  //   return GestureDetector(
  //     onTap: () => _openLanguageSheet(country),
  //     child: Container(
  //       height: 50,
  //       padding: EdgeInsets.symmetric(horizontal: 15),
  //       decoration: new BoxDecoration(
  //         color: Colors.grey.shade200,
  //         shape: BoxShape.rectangle,
  //       ),
  //       child: Row(
  //         children: [
  //           Text(
  //             country.data[0].flag,
  //             style: TextStyle(fontSize: 22.0.sp),
  //           ),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           Text(
  //             country.data[0].country,
  //             style: TextStyle(fontSize: 11.0.sp, color: Colors.black),
  //             textAlign: TextAlign.center,
  //             maxLines: 1,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _continentCard(BlogCountriesModel country) {
    if (country.data!.length == 0 && country.region == 'users')
      return SizedBox(height: 0, width: 0);

    return ListTile(
      visualDensity: VisualDensity(horizontal: -4, vertical: 0),
      leading: Icon(
        country.region == "users"
            ? Icons.arrow_forward_ios_sharp
            : Icons.public,
        color: Colors.grey.shade800,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      title: Text(
        country.region == "users"
            ? "Continue with your current country"
            : country.region!,
        style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade800),
      ),
      //trailing: Icon(Icons.arrow_drop_down,color: Colors.grey.shade800,),
    );
  }

  @override
  void initState() {
    _getCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(40), child: _searchBar()),
          leading: IconButton(
            splashRadius: 20,
            constraints: BoxConstraints(),
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.symmetric(horizontal: 0),
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          title: Text(
            AppLocalizations.of(
              "Select a Country",
            ),
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black),
          ),
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
              itemCount: countries.countries.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _continentCard(countries.countries[index]),
                    GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: countries.countries[index].data!
                            .where((element) => element.hide == false)
                            .toList()
                            .length,

                        //  countries.countries[index].data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 4 / 3),
                        itemBuilder: (context, countryIndex) {
                          if (countries
                              .countries[index].data![countryIndex].hide!)
                            return Container(
                              height: 0,
                              width: 0,
                            );
                          return _countryCard(
                              countries
                                  .countries[index].data![countryIndex].flag!,
                              countries.countries[index].data![countryIndex]
                                  .country!, () {
                            print("clicked on the country");
                          }, countries.countries[index].data![countryIndex]);
                        })
                  ],
                );
              })),
    );
  }
}
