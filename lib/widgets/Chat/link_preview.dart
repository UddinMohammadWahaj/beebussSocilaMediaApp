import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LinkPreview extends StatelessWidget {
  final String? title;
  final String? description;
  final String? domain;
  final String? image;
  final VoidCallback? close;
  final int? showClose;

  const LinkPreview(
      {Key? key,
      this.title,
      this.description,
      this.domain,
      this.image,
      this.close,
      this.showClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: (image == "" ? 5 : 0)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          image != ""
              ? Padding(
                  padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                  child: Container(
                      height: 80,
                      width: 80,
                      child: CachedNetworkImage(
                        imageUrl: image!,
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      )),
                )
              : Container(),
          SizedBox(
            width: 5,
          ),
          Container(
            color: Colors.grey.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80.0.w - (image == "" ? 30 : 115),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            title!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                description!,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14.5),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                domain!,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14.5),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  showClose == 1
                      ? IconButton(
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.all(0),
                          onPressed: close,
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 18,
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
