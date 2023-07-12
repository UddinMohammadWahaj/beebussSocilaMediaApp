import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/app.dart';
import 'package:bizbultest/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:bizbultest/constance/constance.dart' as constance;
import 'package:flutter_phoenix/flutter_phoenix.dart';

class Selectlanguage extends StatefulWidget {
  const Selectlanguage({Key? key}) : super(key: key);

  @override
  _SelectlanguageState createState() => _SelectlanguageState();
}

class _SelectlanguageState extends State<Selectlanguage> {
  List<RadioModel> sampleData = [];
  List<RadioModel> searchSampleData = [];
  // String searchText;

  @override
  void initState() {
    super.initState();

    // simulateInitialDataLoading();

    sampleData.add(RadioModel(false, 'English', "en", "English"));
    sampleData.add(RadioModel(false, 'English (UK)', "en", "English (UK)"));

    sampleData.add(RadioModel(false, 'Indonesian', "id", "Bahasa Indonesia"));
    sampleData.add(RadioModel(false, 'Pilipino', "fil", "Filipino"));
    sampleData.add(RadioModel(false, 'Hrvatski', "hr", "Croatian"));
    sampleData.add(RadioModel(false, 'Magyar', "hu", "Hungarian"));
    sampleData.add(RadioModel(false, 'Malay', "ms", "Bahasa Melayu"));
    sampleData.add(RadioModel(false, 'فارسی', "fa", "Persian"));
    sampleData
        .add(RadioModel(false, 'Français (Canada)', "fr", "French (Canada)"));
    sampleData
        .add(RadioModel(false, 'Français (France)', "fr", "French (France)"));
    sampleData.add(RadioModel(false, 'Deutsch', "de", "German"));
    sampleData
        .add(RadioModel(false, 'Española (españa)', "es", "Spanish (Spain)"));
    sampleData
        .add(RadioModel(false, 'Español', "es", "Spanish (Latin America)"));
    sampleData.add(RadioModel(false, 'Italiano', "it", "Italian"));
    sampleData.add(
        RadioModel(false, 'Portuguese (Brasil)', "pt", "Portugues (Brasil)"));
    sampleData.add(RadioModel(
        false, 'Portuguese (Portugal)', "pt", "Portugues (Portugal)"));
    sampleData.add(RadioModel(false, 'Africa', "af", "Afrikaans"));
    sampleData.add(RadioModel(false, 'عربي', "ar", "Arabic"));
    sampleData.add(RadioModel(false, 'български', "bg", "Bulgarian"));
    sampleData.add(RadioModel(false, 'čeština', "cs", "Czech"));
    sampleData.add(RadioModel(false, 'Dansk', "da", "Danish"));
    sampleData.add(RadioModel(false, 'Ελληνικά', "el", "Greek"));
    sampleData.add(RadioModel(false, 'Dutch', "nl", "NederLands"));
    sampleData
        .add(RadioModel(false, 'Norwegian (bokmal)', "no", "Norsk (bokmal)"));
    sampleData.add(RadioModel(false, 'Polish', "pl", "Polaski"));
    sampleData.add(RadioModel(false, 'Romena', "ro", "Romanian"));
    sampleData.add(RadioModel(false, 'Slovenský', "sk", "Slovak"));
    sampleData.add(RadioModel(false, 'Suomi', "fi", "Finnish"));
    sampleData.add(RadioModel(false, 'Svenska', "sv", "Swedish"));
    sampleData.add(RadioModel(false, 'Tiếng Việt', "vi", "Vietnamese"));
    sampleData.add(RadioModel(false, 'Türk', "tr", "Turkish"));
    sampleData.add(RadioModel(false, 'русский', "ru", "Russian"));
    sampleData.add(RadioModel(false, 'Yкраїнська', "uk", "Ukrainian"));
    sampleData.add(RadioModel(false, 'Српски', "sr", "Serbian"));
    sampleData.add(RadioModel(false, 'עִברִית', "he", "Hebrew"));
    sampleData.add(RadioModel(false, 'हिंदी', "hi", "Hindi"));
    sampleData.add(RadioModel(false, 'ไทย', "th", "Thai"));
    sampleData.add(RadioModel(false, '中国人 （簡化）', "zh", "Chinese (Simplified)"));
    sampleData.add(RadioModel(
        false, '中國人 (繁體, 台灣)', "zh", "Chinese (Traditional, Taiwan)"));
    sampleData.add(RadioModel(
        false, '中文（繁體，香港', "zh", "Chinese (Traditional, Hong kong)"));
    sampleData.add(RadioModel(false, '日本', "ja", "Japanese"));
    sampleData.add(RadioModel(false, '한국인', "ko", "Korean"));

    getLanguage();
    searchSampleData = sampleData;
  }

  void _dataFilter(String searchText) {
    if (searchText != null && searchText.isEmpty) {
      searchSampleData = sampleData;
    } else if (searchText != null) {
      searchSampleData = sampleData
          .where((user) =>
              user.text
                  .toLowerCase()
                  .contains(searchText.toLowerCase().replaceAll(" ", "")) ||
              user.lngName
                  .toLowerCase()
                  .replaceAll(" ", "")
                  .contains(searchText.toLowerCase().replaceAll(" ", "")))
          // user.lngName
          //     .toString()
          //     .toLowerCase()
          //     .contains(searchText.toLowerCase()))
          .toList();
    }
    setState(() {
      searchSampleData;
    });
  }

  // Future<Timer> simulateInitialDataLoading() async {
  //   return Timer(
  //     const Duration(seconds: 2),
  //     () => Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const MainScreen(),
  //       ),
  //     ),
  //   );
  // }

  getLanguage() async {
    String? name = await MySharedPreferences().getSelectedLanguage();
    if (name != null && name != "") {
      sampleData.forEach((element) {
        if (element.lngName == name) {
          element.isSelected = true;
        } else {
          element.isSelected = false;
        }
      });
    } else {
      sampleData[0].isSelected = true;
    }
    setState(() {});
  }

  setLanguage(objRadioModel) async {
    // await ApiProvider().postSetLanguage(objRadioModel.lngCode);
    Navigator.pop(context);
    setState(() {
      sampleData.forEach((element) => element.isSelected = false);
      objRadioModel.isSelected = true;
    });
    MySharedPreferences().setSelectedLanguage(objRadioModel.lngName);
    selectLanguage(objRadioModel.lngCode);
    Phoenix.rebirth(context);
  }

  TextEditingController search = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height, left: 14, right: 14),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back)),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    AppLocalizations.of('Language'),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: search,
              onChanged: (value) {
                value.isEmpty ? searchSampleData = sampleData : "";
                setState(() {
                  // searchText = value;
                  _dataFilter(value);
                  searchSampleData;
                });
              },
              onTap: () {
                // _dataFilter();
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: AppLocalizations.of('search language'),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 10, left: 14, right: 14),
                children: [
                  for (var i = 0; i < searchSampleData.length; i++)
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _showMyDialog(searchSampleData[i]);
                          },
                          child: new RadioItem(
                            searchSampleData[i],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(RadioModel objRadioModel) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Change Language',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to change language to ${objRadioModel.lngName}?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        "Cancle",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {

                    Navigator.pop(context);
                    setState(() {
                      sampleData
                          .forEach((element) => element.isSelected = false);
                      objRadioModel.isSelected = true;
                    });
                    MySharedPreferences()
                        .setSelectedLanguage(objRadioModel.lngName);
                    selectLanguage(objRadioModel.lngCode);
                    Phoenix.rebirth(context);

                    // Navigator.pop(context);
                    // setState(() {
                    //   sampleData.forEach((element) => element.isSelected = false);
                    //   objRadioModel.isSelected = true;
                    // });
                    // MySharedPreferences().setSelectedLanguage(objRadioModel.lngName);
                    // selectLanguage(objRadioModel.lngCode);
                    // Phoenix.rebirth(context);
                    setLanguage(objRadioModel);

                  },
                  child: Container(
                    height: 40,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  selectLanguage(String languageCode) {
    constance.locale = languageCode;
    MyApp.setCustomeLanguage(context, languageCode);
  }
}

class RadioModel {
  bool isSelected;
  String text;
  String lngCode;
  String lngName;

  RadioModel(
    this.isSelected,
    this.text,
    this.lngCode,
    this.lngName,
  );
}

class RadioItem extends StatefulWidget {
  final RadioModel _item;
  RadioItem(this._item);

  @override
  _RadioItemState createState() => _RadioItemState();
}

class _RadioItemState extends State<RadioItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        new Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget._item.text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  widget._item.lngName,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            widget._item.isSelected
                ? Icon(
                    Icons.check,
                    color: Colors.blue,
                  )
                : SizedBox(),
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
