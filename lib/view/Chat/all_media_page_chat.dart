import 'dart:io';
import 'dart:math';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/Chat/text_helpers.dart';
import 'package:open_file/open_file.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Chat/view_contact_single_expanded.dart';
import 'package:bizbultest/view/Chat/view_singe_group_file.dart';
import 'package:bizbultest/view/Chat/view_single_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllMediaPageChat extends StatefulWidget {
  final String? title;
  final String? uniqueID;
  final String? token;
  final String? topic;
  final String? from;

  const AllMediaPageChat(
      {Key? key, this.title, this.uniqueID, this.token, this.topic, this.from})
      : super(key: key);

  @override
  _AllMediaPageChatState createState() => _AllMediaPageChatState();
}

class _AllMediaPageChatState extends State<AllMediaPageChat>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;
  late Future<ChatMessages> _mediaMessagesFuture;
  late Future<ChatMessages> _linkMessagesFuture;
  late Future<ChatMessages> _docMessagesFuture;
  ChatMessages _mediaMessages = new ChatMessages([]);
  ChatMessages _filteredMediaMessages = new ChatMessages([]);
  ChatMessages _docMessages = new ChatMessages([]);
  ChatMessages _filteredDocMessages = new ChatMessages([]);
  ChatMessages _mainDocMessages = new ChatMessages([]);
  TextEditingController _searchBarController = TextEditingController();
  ChatMessages _linkMessages = new ChatMessages([]);
  ChatMessages _filteredLinkMessages = new ChatMessages([]);
  bool isSearchOpen = false;
  List<String> messageIDs = [];

  void _selectMessages() {}

  void _searchDocs(String docName) async {
    setState(() {
      _filteredDocMessages.messages = _mainDocMessages.messages
          .where((element) => element.fileNameUploaded
              .toString()
              .toLowerCase()
              .contains(docName.toLowerCase()))
          .toList();
    });
  }

  void _searchLinks(String text) async {
    setState(() {
      _linkMessages.messages = _filteredLinkMessages.messages
          .where((element) =>
              element.message!
                  .split("~~~")[0]
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              element.message!
                  .split("~~~")[1]
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              element.message!
                  .split("~~~")[3]
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              element.message!
                  .split("~~~")[4]
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()))
          .toList();
    });
  }

  Widget searchBar() {
    return TextField(
      style: TextStyle(color: Colors.black, fontSize: 18),
      cursorColor: Colors.black,
      onChanged: (val) {
        if (selectedIndex == 1) {
          _searchDocs(val);
        } else if (selectedIndex == 2) {
          _searchLinks(val);
        }
      },
      controller: _searchBarController,
      autofocus: true,
      decoration: InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 18, color: Colors.black)),
    );
  }

  void _tabListener() {
    _tabController.animation!
      ..addListener(() {
        var value = _tabController.animation!.value.round();
        if (value != selectedIndex) {
          setState(() {
            selectedIndex = _tabController.animation!.value.round();
          });
        }
        if (selectedIndex == 0) {
          setState(() {});
        }
      });
  }

  void _closeTextField() {
    setState(() {
      isSearchOpen = false;
    });
    _searchBarController.clear();
    if (selectedIndex == 1) {
      setState(() {
        _filteredDocMessages = _mainDocMessages;
      });
    } else if (selectedIndex == 2) {
      setState(() {
        _linkMessages = _filteredLinkMessages;
      });
    }
  }

  Future<String> getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  void _removeDeletedMediaFiles() {
    _mediaMessages.messages.forEach((element) {
      String path =
          element.you == 1 ? element.path! : element.receiverDevicePath!;
      if (File(path).existsSync()) {
        setState(() {
          _filteredMediaMessages.messages.add(element);
        });
      } else {
        print("not found");
      }
    });
  }

  void _removeDeletedDocs() {
    _docMessages.messages.forEach((element) {
      String path =
          element.you == 1 ? element.path! : element.receiverDevicePath!;
      if (File(path).existsSync()) {
        setState(() {
          _filteredDocMessages.messages.add(element);
          _mainDocMessages.messages.add(element);
        });
        _filteredDocMessages.messages.forEach((element) {
          getFileSize(element.path!, 1).then((value) {
            setState(() {
              element.fileSize = value;
            });
          });
        });
      } else {
        print("not found");
      }
    });
  }

  void _getMediaFiles() async {
    print("media files");
    _mediaMessagesFuture =
        ChatApiCalls.getAllMedia(widget.uniqueID!, "").then((value) {
      setState(() {
        _mediaMessages.messages = value.messages.reversed.toList();
      });
      _removeDeletedMediaFiles();
      return value;
    });
  }

  void _getDocs() async {
    print("doc files");

    _docMessagesFuture =
        ChatApiCalls.getAllDocs(widget.uniqueID!, "").then((value) {
      setState(() {
        _docMessages.messages = value.messages.reversed.toList();
      });
      _removeDeletedDocs();
      return value;
    });
  }

  void _getLinks() async {
    print("linksssssss");
    _linkMessagesFuture =
        ChatApiCalls.getAllLinks(widget.uniqueID!).then((value) {
      setState(() {
        _linkMessages.messages = value.messages.reversed.toList();
        _filteredLinkMessages.messages = value.messages.reversed.toList();
      });

      return value;
    });
  }

  Tab _tab(String tabTitle) {
    return Tab(
      child: Text(
        tabTitle.toUpperCase(),
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _docCard(ChatMessagesModel message) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Icon(
                      Icons.insert_drive_file_rounded,
                      color: message.fileTypeExtension == "pdf"
                          ? Colors.red.shade600
                          : message.fileTypeExtension == "doc" ||
                                  message.fileTypeExtension == "docx"
                              ? Colors.blue.shade900
                              : Colors.grey.shade600,
                      size: 32,
                    ),
                    Positioned.fill(
                      bottom: 4,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TextHelpers().simpleTextCard(
                            message.fileTypeExtension!.toUpperCase(),
                            FontWeight.bold,
                            8,
                            Colors.white,
                            1,
                            TextOverflow.ellipsis),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Expanded(
                    child: TextHelpers().simpleTextCard(
                        message.fileNameUploaded!,
                        FontWeight.w400,
                        16,
                        Colors.black,
                        1,
                        TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      TextHelpers().simpleTextCard(
                          message.fileSize!,
                          FontWeight.normal,
                          13,
                          Colors.grey,
                          1,
                          TextOverflow.ellipsis),
                      TextHelpers().simpleTextCard(" • ", FontWeight.normal, 13,
                          Colors.grey, 1, TextOverflow.ellipsis),
                      message.fileTypeExtension == "pdf"
                          ? TextHelpers().simpleTextCard(
                              message.pageCount == 1
                                  ? message.pageCount.toString() + " page"
                                  : message.pageCount.toString() + " pages",
                              FontWeight.normal,
                              13,
                              Colors.grey,
                              1,
                              TextOverflow.ellipsis)
                          : Container(),
                      message.fileTypeExtension == "pdf"
                          ? TextHelpers().simpleTextCard(
                              " • ",
                              FontWeight.normal,
                              13,
                              Colors.grey,
                              1,
                              TextOverflow.ellipsis)
                          : Container(),
                      TextHelpers().simpleTextCard(
                          message.fileTypeExtension!.toUpperCase(),
                          FontWeight.normal,
                          13,
                          Colors.grey,
                          1,
                          TextOverflow.ellipsis),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelpers().simpleTextCard(
                          message.dateData!,
                          FontWeight.normal,
                          13,
                          Colors.grey,
                          1,
                          TextOverflow.ellipsis),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                height: 0.5,
                width: 100.0.w,
                color: Colors.grey.withOpacity(0.3),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _linkCard(ChatMessagesModel message) {
    return GestureDetector(
      onTap: () {
        ChatApiCalls().openLink(message.message!.split("~~~")[4]);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: Colors.grey,
              width: 0.3,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                tileColor: Colors.grey.shade200,
                title: Container(
                  child: TextHelpers().simpleTextCard(
                      message.message!.split("~~~")[0],
                      FontWeight.normal,
                      15,
                      Colors.black87,
                      1,
                      TextOverflow.ellipsis),
                ),
                subtitle: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      message.message != ""
                          ? TextHelpers().simpleTextCard(
                              message.message!.split("~~~")[1],
                              FontWeight.normal,
                              14.5,
                              Colors.grey,
                              2,
                              TextOverflow.ellipsis)
                          : Container(),
                      message.message != ""
                          ? TextHelpers().simpleTextCard(
                              message.message!.split("~~~")[3],
                              FontWeight.normal,
                              14.5,
                              Colors.grey,
                              2,
                              TextOverflow.ellipsis)
                          : Container(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: message.message != ""
                    ? TextHelpers().simpleTextCard(
                        message.message!.split("~~~")[4],
                        FontWeight.normal,
                        14.5,
                        Colors.grey,
                        1,
                        TextOverflow.ellipsis)
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allMediaFiles(Future future, List<ChatMessagesModel> message) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                itemCount: message.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, crossAxisSpacing: 2, mainAxisSpacing: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {},
                    onTap: () {
                      if (widget.from == "chat") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewSingleChatFile(
                                      token: widget.token,
                                      memberID: widget.uniqueID,
                                      messages: message,
                                      selectedIndex: index,
                                    )));
                      } else if (widget.from == "group") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewSingleGroupFile(
                                      topic: widget.topic,
                                      memberID: widget.uniqueID,
                                      messages: message,
                                      selectedIndex: index,
                                    )));
                      } else {
                        print("nothing");
                      }
                    },
                    child: ChatMediaCard(
                      path: message[index].you == 0
                          ? message[index].receiverThumbnail
                          : message[index].thumbPath,
                      image: message[index].messageType == "video"
                          ? message[index]
                              .videoImage
                              ?.replaceAll(".mp4", ".jpg")
                          : message[index]
                              .imageData
                              .toString()
                              .replaceAll("/resized", ""),
                    ),
                  );
                });
          } else {
            return Center(
                child: Container(child: customCircularIndicator(3, darkColor)));
          }
        });
  }

  Widget _allDocs(Future future) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: _filteredDocMessages.messages.length,
                itemBuilder: (context, index) {
                  var message = _filteredDocMessages.messages;
                  return GestureDetector(
                      onTap: () {
                        String path = "";
                        if (message[index].you == 1) {
                          path = message[index].path!;
                        } else {
                          path = message[index].receiverDevicePath!;
                        }

                        print(path);

                        OpenFile.open(path);
                      },
                      child: _docCard(message[index]));
                });
          } else {
            return Center(
                child: Container(child: customCircularIndicator(3, darkColor)));
          }
        });
  }

  Widget _allLinks(Future future) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: _linkMessages.messages.length,
                itemBuilder: (context, index) {
                  var message = _linkMessages.messages[index];
                  return _linkCard(message);
                });
          } else {
            return Center(
                child: Container(child: customCircularIndicator(3, darkColor)));
          }
        });
  }

  Widget _searchButton(VoidCallback onTap) {
    return IconButton(
      icon: Icon(
        Icons.search,
        color: darkColor,
      ),
      onPressed: onTap,
    );
  }

  @override
  void initState() {
    _tabController =
        new TabController(vsync: this, length: 3, initialIndex: selectedIndex);
    _tabListener();
    _getMediaFiles();
    _getDocs();
    _getLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          selectedIndex != 0 && !isSearchOpen
              ? _searchButton(() {
                  setState(() {
                    isSearchOpen = true;
                  });
                })
              : Container()
        ],
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            if (isSearchOpen) {
              _closeTextField();
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(
            Icons.arrow_back,
            color: darkColor,
          ),
        ),
        title: isSearchOpen
            ? searchBar()
            : Text(
                widget.title!,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black),
              ),
        bottom: TabBar(
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: darkColor,
                width: 2.0,
              ),
            ),
          ),
          labelColor: darkColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: <Tab>[
            _tab(
              AppLocalizations.of(
                "media",
              ),
            ),
            _tab(
              AppLocalizations.of(
                "docs",
              ),
            ),
            _tab(
              AppLocalizations.of("links"),
            )
          ],
          controller: _tabController,
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (isSearchOpen) {
            _closeTextField();
            return false;
          } else {
            Navigator.pop(context);
            return true;
          }
        },
        child: TabBarView(
          children: [
            _allMediaFiles(
                _mediaMessagesFuture, _filteredMediaMessages.messages),
            _allDocs(_docMessagesFuture),
            _allLinks(_linkMessagesFuture)
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
