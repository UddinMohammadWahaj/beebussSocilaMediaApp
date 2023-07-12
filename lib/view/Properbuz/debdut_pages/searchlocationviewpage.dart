import 'dart:ffi';

import 'package:bizbultest/view/Properbuz/debdut_pages/debdut_getxcontroller/searchlocationviewpagecontroller.dart';
import 'package:bizbultest/view/Properbuz/debdut_pages/helper/stringfunction.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webviewx/webviewx.dart';

class SearchLocationViewPage extends StatefulWidget {
  final String? username;
  final String? ratings;
  final String? reviewtitle;
  final String? review;
  final String? location;
  final List? listimages;
  final String? videourl;
  final String? country;
  final Function? getRatings;
  SearchLocationViewPage(
      {Key? key,
      this.username,
      this.ratings,
      this.reviewtitle = '',
      this.review = '',
      this.location = '',
      this.listimages = const [],
      this.videourl = '',
      this.country,
      this.getRatings})
      : super(key: key);

  @override
  _SearchLocationViewPageState createState() => _SearchLocationViewPageState();
}

/* Structure
   Review of place name
   Photos
   Sliding picture
   button images
   Icons user
   username
   userlocation
   no of review
   what should you
   full review
   Videos youtube 
*/

class _SearchLocationViewPageState extends State<SearchLocationViewPage> {
  final controller = Get.put(SearchLocationViewPageController());

  PageController _pageController = new PageController();
  String dummyReview =
      'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.';
  List images = [
    'https://media-cdn.tripadvisor.com/media/photo-s/0e/7b/97/d0/beautiful-ambience.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdv9QJSNERhsX1qxeCNzHFXT5T7W1_PCBExw&usqp=CAU',
    'https://b.zmtcdn.com/data/pictures/4/18670184/0c017c56b29c6ca5e6f1ffd355c4bcb7_featured_v2.jpg',
    'https://imgmedia.lbb.in/media/2018/08/5b682aa394deab19657490e4_1533553315100.jpg',
    'https://media-cdn.tripadvisor.com/media/photo-s/0e/7b/97/d0/beautiful-ambience.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdv9QJSNERhsX1qxeCNzHFXT5T7W1_PCBExw&usqp=CAU'
  ];

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  Widget boxOfImages(index) {
    return InkWell(
      onTap: () {
        _pageController.jumpToPage(index);
        controller.jumpToImage(index);
      },
      child: Obx(
        () => Container(
          margin: EdgeInsets.all(5),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(
                color: (controller.currentIndex == index)
                    ? Colors.black54
                    : Colors.transparent,
                width: 10),
            image: DecorationImage(
              image: NetworkImage(images[index]),
              fit: BoxFit.fill,
            ),
            shape: BoxShape.rectangle,
          ),
        ),
      ),
    );
  }

  Widget getBoxImageArray() {
    List<Widget> listofBoxImage = [];
    for (int i = 0; i < images.length; i++) {
      listofBoxImage.add(boxOfImages(i));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: listofBoxImage,
      ),
    );
  }

  Widget _photoCard(imglink, int index, VoidCallback onTap) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(images[index]),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.rectangle,
            ),
          ),
          // Container(
          //   alignment: Alignment.center,
          //   child: ClipRRect(
          //       borderRadius: BorderRadius.circular(3),
          //       child: Image.network(
          //         imglink,
          //         fit: BoxFit.cover,
          //       )),
          // ),
          // Positioned.fill(
          //   right: 10,
          //   top: 10,
          //   child: Align(
          //     alignment: Alignment.topRight,
          //     child: Container(
          //       decoration: new BoxDecoration(
          //         color: Colors.white,
          //         shape: BoxShape.circle,
          //       ),
          //       child: IconButton(
          //         splashRadius: 15,
          //         constraints: BoxConstraints(),
          //         padding: EdgeInsets.all(5),
          //         onPressed: onTap,
          //         icon: Icon(
          //           CupertinoIcons.delete_solid,
          //           color: Colors.white12,
          //           size: 20,
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  // Widget getStars() {
  //   return Row(
  //     children: [
  //       Icon(
  //         Icons.star,
  //         color: Colors.indigo,
  //       ),
  //       Icon(
  //         Icons.star,
  //         color: Colors.indigo,
  //       ),
  //       Icon(
  //         Icons.star,
  //         color: Colors.indigo,
  //       ),
  //       Icon(
  //         Icons.star,
  //         color: Colors.indigo,
  //       ),
  //       Icon(
  //         Icons.star,
  //         color: Colors.indigo,
  //       ),
  //     ],
  //   );
  // }

  Widget getUserDetails() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              //userIcon
              Icon(
                Icons.account_circle,
                size: 50,
              ),
              Text(
                widget.username!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
              //city
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: widget.getRatings!(int.parse(widget.ratings!))),
                    Icon(Icons.location_city),
                    Text(widget.location!),
                  ],
                ),
              ),
              //title
              Text(
                widget.reviewtitle!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              //Review
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Card(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Obx(() => Html(
                                data: (controller.textVisiblity.value != 5)
                                    ? widget.review
                                    : StringHelper().maskString(widget.review!),
                              )

                          //     Text(
                          //   removeAllHtmlTags(widget.review),
                          //   maxLines: controller.textVisiblity.value,
                          //   style: TextStyle(
                          //       fontSize: 15, fontWeight: FontWeight.w500),
                          // ),
                          )),
                  Positioned(
                    child: InkWell(
                        onTap: () {
                          print("tapped ${controller.textVisiblity.value}");
                          if (controller.textVisiblity.value == 5)
                            controller.textVisiblity.value =
                                widget.review!.length;
                          else
                            controller.textVisiblity.value = 5;
                        },
                        child: FittedBox(
                          child: Obx(
                            () => Row(
                              children: [
                                (controller.textVisiblity.value <= 5)
                                    ? Icon(
                                        Icons.arrow_drop_down_rounded,
                                      )
                                    : Icon(Icons.arrow_drop_up_rounded),
                                (controller.textVisiblity.value <= 5)
                                    ? Text('See more')
                                    : Text('See less')
                              ],
                            ),
                          ),
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Review of ${widget.location},${widget.country}',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w300, color: Colors.black),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          )),
      body: SingleChildScrollView(
        clipBehavior: Clip.hardEdge,
        child: Container(
            child: Column(
          children: [
            Text(
              'Photos',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.indigo),
            ),
            Container(
              height: 250,
              child: Stack(
                children: [
                  PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        return _photoCard(
                            images[index], index, () => {print("yo")});
                      }),

                  // _photosLengthCard()
                ],
              ),
            ),
            getBoxImageArray(),
            SingleChildScrollView(child: getUserDetails()),
            Text(
              'Videos',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.black),
            ),
            (widget.videourl != '')
                ? SingleChildScrollView(
                    child: Card(
                      elevation: 10,
                      child: WebViewX(
                        width: double.infinity,
                        height: 200,
                        initialContent: widget.videourl!,
                      ),
                    ),
                  )
                : Text("No videos available to show!!")
          ],
        )),
      ),
    );
  }
}
