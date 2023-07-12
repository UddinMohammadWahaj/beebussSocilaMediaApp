import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Chat/detailed_chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PeakProfileCard extends StatelessWidget {
  final String? image;

  const PeakProfileCard({Key? key, this.image}) : super(key: key);

  _customButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(image);
    return Center(
      child: Container(
          color: Colors.white,
          height: 250.0,
          width: 250.0,
          child: Column(
            children: [
              Container(
                width: 250,
                height: 200,

                //child: Text(""),
                child: image != null
                    ? CachedNetworkImage(
                        imageUrl: image!,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
              ),
              gradientContainer(
                Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  width: 250,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _customButton(Icons.call, () {
                        print("call");
                      }),
                      _customButton(Icons.message, () {
                        // return Navigator.of(context)
                        //     .push(MaterialPageRoute(builder: (context) {
                        //   return DetailedChatScreen(
                        //     token: ,
                        //     memberID: ,
                        //     image: ,
                        //     name: ,
                        //   );
                        // }));
                      }),
                      _customButton(Icons.video_call, () {
                        print("video call");
                      })
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
