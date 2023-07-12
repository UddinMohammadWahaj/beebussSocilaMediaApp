import 'package:bizbultest/models/blogbuz_countries_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';
import 'language_bottom_sheet.dart';

class CountrySearchDemo extends StatefulWidget {
  List<Datum>? countrylist = [];
  var category;
  var recipeCategory;
  BlogCountries? mainCountries;
  CountrySearchDemo(
      {Key? key,
      this.countrylist,
      this.category,
      this.recipeCategory,
      this.mainCountries})
      : super(key: key);

  @override
  State<CountrySearchDemo> createState() => _CountrySearchDemoState();
}

class _CountrySearchDemoState extends State<CountrySearchDemo> {
  TextEditingController controller = TextEditingController();
  List<Datum> listdatum = [];

  @override
  void initState() {
    print("init state ${widget.mainCountries}");
    widget.mainCountries!.countries.forEach((element) {
      element.data!.forEach((element) {
        listdatum.add(element);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _openLanguageSheet(Datum data) {
      print(data.languages);
      print("Recipe categ ->cat = ${widget.category}${widget.recipeCategory}");
      Get.bottomSheet(
          LanguageBottomSheet(
            category: widget.category,
            recipeCategory: widget.recipeCategory,
            data: data,
          ),
          isScrollControlled: false,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0))));
    }

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
          onChanged: (val) {},
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

    return Scaffold(
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
              itemCount: listdatum.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    // _continentCard(countries.countries[index]),
                    GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listdatum.length,

                        //  countries.countries[index].data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 4 / 3),
                        itemBuilder: (context, countryIndex) {
                          return _countryCard(
                              listdatum[index].flag!, listdatum[index].country!,
                              () {
                            print("clicked on the country");
                          }, listdatum[index]);
                        })
                  ],
                );
              })),
    );
  }
}
