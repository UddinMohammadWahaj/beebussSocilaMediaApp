import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'apply_program_view.dart';
import 'creators_program_controller.dart';

class CreatorsProgramView extends GetView<CreatorsProgramController> {
  const CreatorsProgramView({Key? key}) : super(key: key);

  Widget _loadingIndicator() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Obx(
          () => controller.isUrlLoading.value
              ? new Center(
                  child: const CupertinoActivityIndicator(
                  radius: 20,
                ))
              : Container(),
        ),
      ),
    );
  }

  Widget _applyButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Center(
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ApplyProgramView()));
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              AppLocalizations.of(
                "Apply Now",
              ),
              style: blackBold.copyWith(
                fontSize: 22,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _webPageView() {
    return WebView(
      initialUrl: 'https://www.bebuzee.com/creators1',
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (String url) {
        print('Page started loading: $url');
        controller.isUrlLoading.value = true;
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
        controller.isUrlLoading.value = false;
        print(controller.isUrlLoading.value);
      },
      onProgress: (int progress) {
        print("WebView is loading (progress : $progress%)");
      },
    );
  }

  Widget creatorProgramBody() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0.w), bottomLeft: Radius.circular(30.0.w)),
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0.w),
                  bottomLeft: Radius.circular(30.0.w))),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl:
                'https://www.timebulletin.com/wp-content/uploads/2020/05/What-is-Bebuzee-used-for.jpg',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CreatorsProgramController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            size: 25,
            color: Colors.black,
          ),
          splashRadius: 20,
          constraints: BoxConstraints(),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(
            "Creators Program",
          ),
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize: 22),
        ),
      ),
      body: Stack(
        children: [
          // _webPageView(),
          // _loadingIndicator(),
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  creatorProgramBody(),
                  Text('Why create with us?',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 2.5.h)),
                  SizedBox(
                    height: 3.0.h,
                  ),
                  Text(
                    'Earn a living while creating the contents you love.',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 3.0.h),
                  ),
                  ClipRRect(
                    child: Container(
                      // color: Colors.pinkAccent.shade100,
                      height: 30.0.h,
                      width: 100.0.w,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ListTile(
                            leading: Icon(Icons.star,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('Get creative',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.0.h)),
                            subtitle: Text(
                                'Discover new ways to express your ideas.'),
                          ),
                          ListTile(
                            leading: Icon(Icons.people,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('Get connected',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.0.h)),
                            subtitle: Text(
                                'Bring friends and fans to view your contents.'),
                          ),
                          ListTile(
                            leading: Icon(Icons.monetization_on,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('Get rewarded',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.0.h)),
                            subtitle:
                                Text('Earn money from your videos and blogs.'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0.w),
                    alignment: Alignment.topLeft,
                    child: Text('Countries',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 3.0.h)),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0.w),
                    child: Text(
                        'We are approving only 10,000 content creators from each of the countries below:'),
                  ),
                  ClipRRect(
                    child: Container(
                      // color: Colors.pinkAccent.shade100,
                      height: 30.0.h,
                      width: 100.0.w,
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            leading: Icon(Icons.location_city,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('EUROPE',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.0.h)),
                            subtitle: Text('Ireland, Italy, United Kingdom'),
                          ),
                          ListTile(
                            leading: Icon(Icons.location_city,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('Africa',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.0.h)),
                            subtitle: Text(
                                'Algeria, Cameroon, Egypt, Ethiopia, Ghana, Kenya, Liberia, Morocco, Nigeria, Rwanda, South Africa, Sudan, Tanzania, Uganda, Zambia, Zimbabwe'),
                          ),
                          ListTile(
                            leading: Icon(Icons.location_city,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('North America',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.0.h)),
                            subtitle: Text('Canada, United States'),
                          ),
                          ListTile(
                            leading: Icon(Icons.location_city,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('Asia',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.0.h)),
                            subtitle: Text('India, Philippines'),
                          ),
                          ListTile(
                            leading: Icon(Icons.location_city,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('OCEANIA',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.0.h)),
                            subtitle: Text('Australia, New Zealand'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(2.0.w),
                    child: Text('To be approved:',
                        style: TextStyle(
                            fontSize: 3.0.h, fontWeight: FontWeight.w500)),
                  ),
                  ClipRRect(
                    child: Container(
                      // color: Colors.pinkAccent.shade100,
                      height: 30.0.h,
                      width: 100.0.w,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ListTile(
                            leading: Icon(Icons.video_collection,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('Video Creators',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.0.h)),
                            subtitle: Column(
                              children: [
                                Text(
                                    '1.You must have published atleast 3 original videos'),
                                Text(
                                    '2.Each of your videos must have recieved atleast 10K views')
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.blog,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('Bloggers',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.0.h)),
                            subtitle: Column(
                              children: [
                                Text(
                                    '1.You must have published atleast 5 non-plagiarism blogs'),
                                Text(
                                    '2.Each of your blogs must have recieved atleast 5K views')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ClipRRect(
                    child: Container(
                      // color: Colors.pinkAccent.shade100,
                      height: 40.0.h,
                      width: 100.0.w,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ListTile(
                            leading: Icon(Icons.video_collection,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('Video Creators',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.0.h)),
                            subtitle: Column(
                              children: [
                                Text(
                                    'You will only earn when ad shows on your video:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                Text(
                                  'For example you will earn \$500 for 50K views of your videos monthly',
                                ),
                                Text('\$1,000 for 100K views of your videos'),
                                Text('\$2,000 for 200K views of your videos')
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.blog,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('Bloggers',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.0.h)),
                            isThreeLine: true,
                            subtitle: Column(
                              children: [
                                Text(
                                    'You will only earn when ad shows on your blog contents:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                Text(
                                  'For example you will earn \$250 for 50K ad impression on your blog',
                                ),
                                Text(
                                    '\$500 for 100K ad impression on your blog'),
                                Text(
                                    '\$1,000 for 500K ad impression on your blog')
                              ],
                            ),
                          ),
                          // ListTile(
                          //   leading: Icon(Icons.monetization_on,
                          //       size: 3.0.h, color: Colors.blueGrey),
                          //   title: Text('Get rewarded',
                          //       style: TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 2.0.h)),
                          //   subtitle:
                          //       Text('Earn money from your videos and blogs.'),
                          // )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(2.0.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.tips_and_updates,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 2.0.w,
                        ),
                        Text('Tips to earn more money',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 2.0.h))
                      ],
                    ),
                  ),
                  ClipRRect(
                    child: Container(
                      // color: Colors.pinkAccent.shade100,
                      height: 20.0.h,
                      width: 100.0.w,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ListTile(
                            leading: Icon(Icons.emoji_people_outlined,
                                size: 3.0.h, color: Colors.blueGrey),
                            title: Text('Create engaging contents',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 2.0.h)),
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.instagram,
                                size: 3.0.h, color: Colors.purpleAccent),
                            title: Text(
                                'Share your contents to you followers on other social media network',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 2.0.h)),
                          ),
                          // ListTile(
                          //   leading: Icon(Icons.monetization_on,
                          //       size: 3.0.h, color: Colors.blueGrey),
                          //   title: Text('Get rewarded',
                          //       style: TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 2.0.h)),
                          //   subtitle:
                          //       Text('Earn money from your videos and blogs.'),
                          // )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: kToolbarHeight)
                ],
              ),
            ),
          ),

          _applyButton(context),
        ],
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: SizedBox(height: kToolbarHeight),
      // ),
    );
  }
}
