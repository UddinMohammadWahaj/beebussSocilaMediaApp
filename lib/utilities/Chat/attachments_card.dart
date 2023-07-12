import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatAttachmentsCard extends StatelessWidget {
  final VoidCallback? openGallery;
  final VoidCallback? openDocuments;
  final VoidCallback? openAudio;
  final VoidCallback? openCamera;
  final VoidCallback? openContacts;
  final VoidCallback? openLocation;
  final VoidCallback? openGif;

  const ChatAttachmentsCard(
      {Key? key,
      this.openGallery,
      this.openDocuments,
      this.openAudio,
      this.openCamera,
      this.openContacts,
      this.openLocation,
      this.openGif})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 75),
        child: Container(
          height: 325,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                          elevation: 0,
                          disabledElevation: 0,
                          backgroundColor: Colors.indigo.shade700,
                          onPressed: openDocuments ?? () {},
                          child: Icon(
                            Icons.insert_drive_file,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        AppLocalizations.of("Document"),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                          elevation: 0,
                          disabledElevation: 0,
                          backgroundColor: Colors.pink.shade600,
                          onPressed: openCamera ?? () {},
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        AppLocalizations.of(
                          "Gallery",
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                          elevation: 0,
                          disabledElevation: 0,
                          backgroundColor: Colors.purple.shade400,
                          onPressed: openGallery ?? () {},
                          child: Icon(
                            Icons.photo,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        AppLocalizations.of(
                          "Gallery",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                          elevation: 0,
                          disabledElevation: 0,
                          backgroundColor: Colors.orange.shade800,
                          onPressed: openAudio ?? () {},
                          child: Icon(
                            Icons.headset,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        AppLocalizations.of(
                          "Audio",
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                          elevation: 0,
                          disabledElevation: 0,
                          backgroundColor: Colors.green.shade600,
                          onPressed: openLocation ?? () {},
                          child: Icon(
                            Icons.add_location_rounded,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        AppLocalizations.of("Location"),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                          elevation: 0,
                          disabledElevation: 0,
                          backgroundColor: Colors.blue,
                          onPressed: openContacts ?? () {},
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        AppLocalizations.of(
                          "Contact",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                          elevation: 0,
                          disabledElevation: 0,
                          backgroundColor: Colors.brown.shade600,
                          onPressed: openGif ?? () {},
                          child: Icon(
                            Icons.gif,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text("GIF's"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
