import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Blogs/expanded_blog_controller.dart';
import 'package:bizbultest/services/Blogs/related_blogs_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/deep_links.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import '../models/personal_blog_model.dart';
import '../utilities/Chat/dialogue_helpers.dart';
import '../view/promote_blog.dart';
import '../view/promote_post_page.dart';
import './Newsfeeds/direct_share_bottom_sheet.dart';
import 'package:bizbultest/utilities/toast_message.dart';
import 'package:bizbultest/view/Blogs/related_blogs_view.dart';
import 'package:bizbultest/view/edit_blog.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:bizbultest/widgets/expanded_blog_card_language.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:html/parser.dart';
import 'package:bizbultest/utilities/toast_message.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bizbultest/view/Chat/chat_home.dart';
import 'package:flutter_tts/flutter_tts.dart' as speech;
import 'Bookmark/save_to_board_sheet.dart';
import 'Chat/message_card.dart';
import 'package:translator/translator.dart';

enum TtsState { playing, stopped, paused, continued }

class ExpandedBlogCard extends StatefulWidget {
  final String? blogId;
  String? blogContent;
  final String? image;
  final String? views;
  final String? blogCategory;
  String? blogTitle;
  final String? byUser;
  final String? timeStamp;
  final String? videoUrl;
  final String? videPoster;
  final String? video;
  final String? referenceLink;
  final String? blogKeyword;
  final String? fullUrl;
  final String? fb;
  final String? whatsapp;
  final String? twitter;
  final String? pinterest;
  String? blogDesc;
  final List? keywordList;
  final VoidCallback? onTap;
  final String? memberID;
  final String? shortcode;
  final String? from;
  final Function? refresh;
  final VoidCallback? delete;
  final Function? setNavbar;
  String? langcode;
  final List? totlangcode;
  PersonalBlogModel? personalblog;
  ExpandedBlogCard(
      {Key? key,
      this.totlangcode,
      this.blogId,
      this.blogContent,
      this.image,
      this.views,
      this.personalblog,
      this.blogCategory,
      this.blogTitle,
      this.byUser,
      this.timeStamp,
      this.videoUrl,
      this.videPoster,
      this.video,
      this.referenceLink,
      this.blogKeyword,
      this.fullUrl,
      this.fb,
      this.whatsapp,
      this.twitter,
      this.pinterest,
      this.blogDesc,
      this.keywordList,
      this.onTap,
      this.memberID,
      this.shortcode,
      this.from,
      this.refresh,
      this.delete,
      this.langcode,
      this.setNavbar})
      : super(key: key);

  @override
  _ExpandedBlogCardState createState() => _ExpandedBlogCardState();
}

class _ExpandedBlogCardState extends State<ExpandedBlogCard> {
  var soundcontroller = Get.put(ExpandedBlogController());
  final translator = GoogleTranslator();
  List<Color> colors = [
    Colors.black,
    Colors.blue.shade900,
    Colors.indigo.shade900,
    Colors.green.shade900,
    Colors.orangeAccent.shade700,
    Colors.red.shade900,
    Colors.purple,
    Colors.pink.shade900,
    Colors.brown.shade900,
    Colors.teal.shade900,
    Colors.lime.shade900,
  ];
  List maindatalist = [];
  bool isCurrentLanguageInstalled = false;
  String language = 'it-IT';
  double fontSize = 20;
  Color selectedColor = Colors.black;
  var flutterTts = speech.FlutterTts();
  TtsState ttsState = TtsState.stopped;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String currentAccent = 'it-IT';
  String prevaccent = 'en';
  TextEditingController searchLang = new TextEditingController();

  Future _speak() async {
    String to = currentAccent.split('-')[0];

    print("to is this $to from=${widget.langcode}");
    var x = await translator.translate(
        parse(widget.blogTitle).documentElement!.text +
            parse(widget.blogContent).documentElement!.text,
        from: '${widget.langcode}',
        to: to);

    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (parse(widget.blogTitle).documentElement!.text.isNotEmpty) {
      await flutterTts.awaitSpeakCompletion(true);
      print("ye raha =${x.text}");
      await flutterTts.speak(
          // parse(widget.blogTitle).documentElement.text +
          //   parse(widget.blogContent).documentElement.text
          x.text);
    }
  }

  initTts() {
    setState(() {
      // flutterTts = speech.FlutterTts();
      print("accent changed current=${currentAccent}");
      flutterTts.setLanguage(currentAccent);
    });

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  void _setTextPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("blog_text_size", fontSize);
    prefs.setInt("blog_text_color", selectedColor.value);
  }

  void _getTextPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? size = prefs.getDouble("blog_text_size");
    int? color = prefs.getInt("blog_text_color");
    if (size != null) {
      setState(() {
        fontSize = size;
      });
    }
    if (color != null) {
      setState(() {
        selectedColor = Color(color);
      });
    }
  }

  Widget _colorCard(VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            border: new Border.all(
              color: Colors.grey.shade600,
              width: color == selectedColor ? 5 : 0,
            ),
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: color,
          ),
        ),
      ),
    );
  }

  Future<dynamic> _getLanguages() => flutterTts.getLanguages;
  Widget _headerCard(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          header,
          style: TextStyle(
              fontSize: 14, color: settingsColor, fontWeight: FontWeight.w500),
        ));
  }

  void filterlanguage(String keyword) {
    // i
  }

  Future convertLang({String name: ''}) async {
    var blogContent, blogDesc, blogTitle;
    String to = currentAccent.split('-')[0];
    Get.dialog(ProcessingDialog(
      title: "Converting  to $name",
      heading: "",
    ));
    print("language error from=${widget.langcode} to=${to}");

    String text = '';
    // print(
    //     "blogContent before=${parse(widget.blogContent).documentElement.text}");
    try {
      text = parse(widget.blogContent).documentElement!.text;
      print("blogContent error text not=$text");
    } catch (e) {
      text = widget.blogContent!;
      print('blogContent error text=${text}');
    }
    try {
      // translator.translateAndPrint(text, from: '${widget.langcode}', to: to);
      blogContent =
          await translator.translate(text, from: '${widget.langcode}', to: to);
      print(
          "blogContent after=${parse(blogContent.text).documentElement!.text}");
    } catch (e) {
      print("blogContent $e");
    }
    try {
      blogDesc = await translator.translate(
          parse(widget.blogDesc).documentElement!.text,
          from: '${widget.langcode}',
          to: to);
    } catch (e) {
      print("blog desc=${parse(widget.blogDesc).documentElement!.text}");
      print("language error blogDesc=$e");
    }
    try {
      blogTitle = await translator.translate(
          parse(widget.blogTitle).documentElement!.text,
          from: '${widget.langcode}',
          to: to);
    } catch (e) {
      print("language error blogTitle=$e");
    }
    Get.back();
    setState(() {
      widget.langcode = currentAccent;

      widget.blogTitle = blogTitle.text;
      try {
        widget.blogContent = blogContent.text;
        print("blog content error=${blogContent.text}");
      } catch (e) {
        print("blog content error=$e");
      }

      try {
        widget.blogDesc = blogDesc.text ?? "";
      } catch (e) {
        print("blog desc error=${e}");
      }
    });
  }

  Widget searchBar(List datalist, List languagelist) {
    return Container(
      height: 5.0.h,
      decoration: new BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        shape: BoxShape.rectangle,
      ),
      child: TextFormField(
        cursorColor: Colors.grey,
        autofocus: true,
        onChanged: (val) {
          var templist = datalist;
          var temp2list = datalist;
          // var code= dataList[index].toString().split('-')[0]
          print("entered search --$val $languagelist");

          print("entered search $val");

          setState(() {
            maindatalist = datalist.where((element) {
              var code = element.toString().split('-')[0];
              String name = LanguageLocal().getDisplayLanguage(code)['name'];
              print("entered search name=$name val=$val");
              return name.toLowerCase().contains(val.toLowerCase());
            }).toList();
            print('entered search $maindatalist');
          });
        },
        controller: TextEditingController(),
        maxLines: 1,
        keyboardType: TextInputType.text,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: AppLocalizations.of('Search'),
            contentPadding: EdgeInsets.only(left: 20, bottom: 12),
            hintStyle:
                TextStyle(fontSize: 16, color: Colors.grey.withOpacity(0.8))
            // 48 -> icon width
            ),
      ),
    );
  }

  Future languageSheet(double h, String title, List dataList) async {
    List templist = [];
    // templist.addAll(dataList);

    templist.addAll(widget.totlangcode!);
    //---------------------------------------
    // List templistref = [];
    // templistref.addAll(widget.totlangcode);

    // for (int i = 0; i < templistref.length; i++) {
    //   var currentCode = templistref[i];
    //   for (int j = 0; j < templist.length; j++) {
    //     var countrycode = '';
    //     var code = '';
    //     if (templist[j].toString().contains('-')) {
    //       code = templist[j].toString().split('-')[0];
    //       countrycode = templist[j].toString().split('-')[1];
    //     } else
    //       code = templist[i];

    //     if (code == currentCode) {
    //       templistref[i] = templist[j];
    //     }
    //   }
    // }

    // print("templistref= ${templistref}  \n , templistmain= ${dataList}");

    //----------------------
    for (int i = 0; i < templist.length; i++) {
      try {
        // String name = LanguageLocal()
        //     .getDisplayLanguage(templist[i].toString().split('-')[0])['name'];
        String testname =
            LanguageLocal().getDisplayLanguage(templist[i].toString())['name'];
      } catch (e) {
        print("i am exception $e");
        templist[i] = "-";
      }
    }
    templist.removeWhere((element) => element == "-");

    dataList = templist;
    maindatalist = dataList;
    soundcontroller.maindatalist.value = maindatalist;

//---------------------------------------
    dataList = templist;
    List languagename = dataList.map((e) {
      var code = e.toString().split('-')[0];
      String name = LanguageLocal()
          .getDisplayLanguage(code)['name']
          .toString()
          .toLowerCase();
      return name;
    }).toList();
    print("templist=$templist");
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      expand: widget.setNavbar == null ? true : false,
      builder: (context) => Container(
          height: h,
          margin: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard('Select $title'),
                // searchBar(dataList, languagename),

                Container(
                  height: 5.0.h,
                  decoration: new BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    shape: BoxShape.rectangle,
                  ),
                  child: TextFormField(
                    cursorColor: Colors.grey,
                    autofocus: true,
                    onChanged: (val) {
                      // var templist = datalist;
                      // var temp2list = datalist;
                      // var code= dataList[index].toString().split('-')[0]
                      // print("entered search --$val $languagelist");

                      print("entered search $val");

                      soundcontroller.maindatalist.value =
                          dataList.where((element) {
                        var code = element.toString().split('-')[0];
                        String name =
                            LanguageLocal().getDisplayLanguage(code)['name'];
                        print("entered search name=$name val=$val");
                        return name.toLowerCase().contains(val.toLowerCase());
                      }).toList();
                      print('entered search $maindatalist');
                    },
                    controller: TextEditingController(),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: AppLocalizations.of('Search'),
                        contentPadding: EdgeInsets.only(left: 20, bottom: 12),
                        hintStyle: TextStyle(
                            fontSize: 16, color: Colors.grey.withOpacity(0.8))
                        // 48 -> icon width
                        ),
                  ),
                ),
                Container(
                  height: h,
                  child: Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      itemCount: soundcontroller.maindatalist.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () async {
                          print(
                              "clicked on ${LanguageLocal().getDisplayLanguage(soundcontroller.maindatalist[index].toString().split('-')[0])['name']}");
                          // Navigator.of(context).pop();
                          String code = soundcontroller.maindatalist[index]
                              .toString()
                              .split('-')[0];

                          String name =
                              LanguageLocal().getDisplayLanguage(code)['name'];

                          currentAccent = soundcontroller.maindatalist[index];

                          await flutterTts.setLanguage(currentAccent);
                          await convertLang(
                              name: LanguageLocal()
                                  .getDisplayLanguage(code)['name']
                                  .toString());
                          Navigator.of(context).pop();
                          // convertLang();
                          // print("accent changed ");
                          //
                        },
                        title: Text(
                          '${LanguageLocal().getDisplayLanguage(soundcontroller.maindatalist[index].toString().split('-')[0])['name']}',
                          style: TextStyle(color: Colors.black),
                        ),
                        tileColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _futureBuilder() => FutureBuilder<dynamic>(
      future: _getLanguages(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          print("lanuage ther = ${snapshot.data}");
          List data = [];
          data = snapshot.data;

          return IconButton(
            onPressed: () {
              print("CLICKED");
              flutterTts.stop();
              soundcontroller.mute();
              languageSheet(
                  MediaQuery.of(context).size.height / 2, 'A Language', data);
            },
            icon: Icon(Icons.language_rounded),
          );

          // return _languageDropDownSection(snapshot.data);
        } else if (snapshot.hasError) {
          return Text('Error loading languages...');
        } else
          return Text('Loading Languages...');
      });

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(
          DropdownMenuItem(value: type as String, child: Text(type as String)));
    }
    return items;
  }

  Widget _languageDropDownSection(dynamic languages) => Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        DropdownButton(
          value: language,
          items: getLanguageDropDownMenuItems(languages),
          onChanged: (p) {},
        ),
      ]));
  @override
  void dispose() {
    flutterTts.stop();
    Get.delete<ExpandedBlogController>();
    super.dispose();
  }

  @override
  void initState() {
    _getTextPreferences();
    initTts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("widget.blogContent=${widget.blogContent}");

    return Container(
      child: Column(
        children: [
          Image.network(
            widget.image!,
            fit: BoxFit.cover,

            // errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.remove_red_eye_outlined,
                  size: 35,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    widget.views! != null ? widget.views! : "0",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 20.0.sp),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25),
            child: Text(
              widget.blogCategory!.toUpperCase(),
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontFamily: 'Arial',
                  fontSize: 8.0.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0.h, vertical: 25),
            child: Text(
              parse(widget.blogTitle).documentElement!.text,
              style: TextStyle(fontSize: 35, fontFamily: 'Georgie'),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 0.0.h),
            child: Container(
              color: primaryBlueColor,
              height: 1.0.w,
              width: 10.0.w,
            ),
          ),
          InkWell(
            onTap: widget.onTap! ?? () {},
            splashColor: Colors.grey.withOpacity(0.3),
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Center(
                  child: Text(
                    widget.byUser!.toUpperCase(),
                    style: blackBold.copyWith(
                        fontFamily: "Arial",
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: Text(
              widget.timeStamp!.toUpperCase(),
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontFamily: 'Arial',
                  fontSize: 14),
            ),
          ),
          widget.blogDesc != null
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.0.h, vertical: 25),
                  child: Text(
                    widget.blogDesc != null
                        ? parse(widget.blogDesc).documentElement!.text
                        : "",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Georgie',
                        color: Colors.black.withOpacity(0.5)),
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(),
          Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _futureBuilder(),
                  Obx(() => IconButton(
                        onPressed: () {
                          if (soundcontroller.speakContent.isFalse) {
                            _speak();
                            soundcontroller.unmute();
                          } else {
                            flutterTts.stop();
                            soundcontroller.mute();
                          }
                        },
                        icon: (soundcontroller.speakContent.isFalse)
                            ? Icon(Icons.play_arrow)
                            : Icon(Icons.stop),
                        color: Colors.black,
                        iconSize: 30,
                      )),
                  IconButton(
                    //constraints: BoxConstraints(),
                    // padding: EdgeInsets.all(0),
                    onPressed: () async {
                      Uri uri = await DeepLinks.createBlogDeepLink(
                          widget.memberID!,
                          "blog",
                          widget.image!,
                          widget.blogTitle! != "" &&
                                  widget.blogTitle!.length > 50
                              ? widget.blogTitle!.substring(0, 50) + "..."
                              : widget.blogTitle!,
                          "${widget.shortcode}",
                          widget.blogId!);
                      Share.share(
                        '${uri.toString()}',
                      );
                    },
                    icon: Icon(
                      Icons.share,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    //constraints: BoxConstraints(),
                    // padding: EdgeInsets.all(0),
                    onPressed: () {
                      Get.bottomSheet(
                        DirectShareBottomSheet(
                          postID: widget.blogId!,
                          image: widget.image!,
                          shortcode: widget.shortcode!,
                        ),
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                      );
                      // widget.setNavbar(true);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ChatHome(
                      //               from: "blog",
                      //               setNavbar: widget.setNavbar,
                      //             )));
                    },
                    icon: Icon(
                      CustomIcons.chat_icon,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),
                  SizedBox(
                    width: 2.0.w,
                  ),
                  IconButton(
                    splashRadius: 20,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      CustomIcons.bookmark_thin,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Get.bottomSheet(
                          SaveToBoardSheet(
                            postID: widget.blogId!,
                            image: widget.image!,
                          ),
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20.0),
                                  topRight: const Radius.circular(20.0))));
                    },
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  )
                ],
              )),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 25),
          //   child: InkWell(
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => WebsiteView(
          //                     url: widget.referenceLink,
          //                     heading: "",
          //                   )));
          //     },
          //     child: Container(
          //       decoration: new BoxDecoration(
          //         color: Colors.transparent,
          //         shape: BoxShape.rectangle,
          //         border: new Border.all(
          //           color: Colors.grey,
          //           width: 1,
          //         ),
          //       ),
          //       child: Padding(
          //         padding: EdgeInsets.all(20),
          //         child: Text(
          //           AppLocalizations.of(
          //             "Read More",
          //           ),
          //           style: TextStyle(
          //               fontSize: 25,
          //               fontFamily: 'Arial',
          //               color: Colors.black.withOpacity(0.7)),
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Divider(
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 2.0.w),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(
                    "Text scaling:" + " ",
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
              trackHeight: 3,
              thumbColor: Colors.black,
              inactiveTrackColor: Colors.black38,
              activeTrackColor: Colors.black,
              overlayColor: Colors.transparent,
            ),
            child: Slider(
              onChanged: (value) {
                setState(() {
                  fontSize = value;
                });
                _setTextPreferences();
              },
              max: 45,
              min: 20,
              value: fontSize,
            ),
          ),
          FittedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 2.0.w),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(
                      "Drag the slider until you can read comfortably.",
                    ),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 2.0.w),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(
                        "Text color:",
                      ) +
                      " ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Container(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    return _colorCard(() {
                      setState(() {
                        selectedColor = colors[index];
                      });
                      _setTextPreferences();
                    }, colors[index]);
                  }),
            ),
          ),
          Divider(
            thickness: 1,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0.h, vertical: 20),
            child: Wrap(children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    child: Text(
                      parse(widget.blogContent).documentElement!.text,
                      style: TextStyle(
                          color: selectedColor,
                          fontFamily: 'Georgie',
                          fontSize: fontSize),
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 2.0.h, vertical: 20),
                  //   child: InkWell(
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => WebsiteView(
                  //                     url: widget.referenceLink,
                  //                     heading: "",
                  //                   )));
                  //     },
                  //     child: Text(
                  //       '...Read More',
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold, fontSize: 2.0.h),
                  //     ),
                  //   ),
                  // ),
                ],
              )

              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 2.0.h, vertical: 20),
              //   child: Text(
              //     '...Read More',
              //     style:
              //         TextStyle(fontWeight: FontWeight.bold, fontSize: 2.0.h),
              //   ),
              // )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebsiteView(
                              url: widget.referenceLink!,
                              heading: "",
                            )));
              },
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.rectangle,
                  border: new Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    AppLocalizations.of(
                      "Read More",
                    ),
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Arial',
                        // fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          widget.blogKeyword != null
              ? Padding(
                  padding:
                      EdgeInsets.only(left: 2.0.h, right: 2.0.h, bottom: 2.0.h),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Wrap(
                        // children: widget.keywordList
                        children: widget.blogKeyword!
                            .split(',')
                            .toList()
                            .asMap()
                            .map((i, value) => MapEntry(
                                  i,
                                  GestureDetector(
                                    onTap: () {
                                      RelatedBlogsController controller =
                                          Get.put(RelatedBlogsController());
                                      controller
                                          .getRelatedBlogs(value.toString());
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RelatedBlogsView()));
                                      // Get.to(RelatedBlogsView());
                                      //Get.to(() => RelatedBlogsView());
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 1.0.h, bottom: 1.0.h),
                                      child: Container(
                                        color: HexColor('#0110FF'),
                                        child: Padding(
                                          padding: EdgeInsets.all(1.5.w),
                                          child: Text(
                                            value.toString().toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'DomaineDisplay',
                                                letterSpacing: 1.0.w,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 8.0.sp),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .values
                            .toList()),
                  ),
                )
              : Container(),
          widget.memberID == CurrentUser().currentUser.memberID
              // &&
              //         widget.from == "personal"
              ? Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditBlog(
                                        blogID: widget.blogId!,
                                        blogCategory: widget.blogCategory!,
                                        blogImage: widget.image!,
                                        blogTitle: widget.blogTitle!,
                                        logo: CurrentUser().currentUser.logo,
                                        country:
                                            CurrentUser().currentUser.country,
                                        memberID:
                                            CurrentUser().currentUser.memberID,
                                        blogContent: widget.blogContent!,
                                      )));
                        },
                        child: Container(
                            height: 45,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey, width: 1),
                                  top:
                                      BorderSide(color: Colors.grey, width: 1)),
                            ),
                            width: 50.0.w - 0.5,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(
                                  "Edit",
                                ),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                      Container(
                        width: 1,
                        height: 45,
                        color: Colors.grey.withOpacity(.2),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20.0),
                                    topRight: const Radius.circular(20.0))),
                            //isScrollControlled:true,
                            context: context,
                            builder: (BuildContext bc) {
                              return Container(
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.5.h, horizontal: 2.0.w),
                                        child: Text(
                                          AppLocalizations.of(
                                            "Are you sure you want to delete this Blog?",
                                          ),
                                          style: TextStyle(fontSize: 14.0.sp),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: widget.delete ??
                                          () {
                                            //  widget.setNavbar(true);
                                          },
                                      title: Center(
                                          child: Text(
                                        AppLocalizations.of(
                                          "Yes",
                                        ),
                                        style: TextStyle(
                                            fontSize: 12.0.sp,
                                            color: Colors.red),
                                      )),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      title: Center(
                                          child: Text(
                                        AppLocalizations.of(
                                          "No",
                                        ),
                                        style: TextStyle(
                                          fontSize: 12.0.sp,
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 45,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 1),
                                top: BorderSide(color: Colors.grey, width: 1)),
                          ),
                          width: 50.0.w - 0.5,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(
                                "Delete",
                              ),
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          Center(
            child: widget.memberID == CurrentUser().currentUser.memberID
                ? GestureDetector(
                    onTap: () {
                      print("personal blog=${widget.personalblog}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PromoteBlog(
                                    memberName:
                                        CurrentUser().currentUser.fullName,
                                    memberImage:
                                        CurrentUser().currentUser.image,
                                    personalBlogs: widget.personalblog!,
                                    // feed: widget.feed,
                                    logo: CurrentUser().currentUser.logo,
                                    country: CurrentUser().currentUser.country,
                                    // locationString: CurrentUser().currentUser,
                                    memberID:
                                        CurrentUser().currentUser.memberID,
                                  )));
                    },
                    child: Container(
                      height: 45,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1),
                            top: BorderSide(color: Colors.grey, width: 1)),
                      ),
                      width: 50.0.w - 0.5,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(
                            "Promote",
                          ),
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
