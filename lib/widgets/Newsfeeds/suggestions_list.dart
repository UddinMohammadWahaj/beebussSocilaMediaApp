import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SuggestionsList extends StatelessWidget {
  final int? length;
  final String? image;
  final String? shortcode;
  final String? name;
  final VoidCallback? onPressed;
  final String? followStatus;
  final VoidCallback? onTap;
  final VoidCallback? remove;

  SuggestionsList(
      {Key? key,
      this.length,
      this.image,
      this.shortcode,
      this.name,
      this.onPressed,
      this.followStatus,
      this.onTap,
      this.remove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          InkWell(
            onTap: onTap ?? () {},
            child: Container(
              height: 26.h,
              decoration: new BoxDecoration(
                // color: Colors.yellow,
                shape: BoxShape.rectangle,
                border: new Border.all(
                  color: Colors.grey.withOpacity(0.4),
                  width: 0.3,
                ),
              ),
              width: _currentScreenSize.width * 0.45,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.transparent,
                        backgroundImage: CachedNetworkImageProvider(image!),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      shortcode!,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      name!,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        height: 4.h,
                        width: _currentScreenSize.width * 0.4,
                        child: ElevatedButton(
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(5)),
                            onPressed: onPressed ?? () {},
                            // color: primaryBlueColor,
                            // disabledColor: primaryBlueColor,
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(primaryBlueColor),
                                // disabledColor: primaryBlueColor,
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)))),
                            child: Text(
                              followStatus!,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: remove ?? () {},
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey.withOpacity(0.6),
                        size: 25,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
