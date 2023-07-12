import 'package:bizbultest/services/Properbuz/virtual_tour_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class AddVirtualTourView extends GetView<VirtualTourController> {
  const AddVirtualTourView({Key? key}) : super(key: key);

  static final TextEditingController textEditingController =
      TextEditingController();

  Widget _selectionCard(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
          height: 100,
          width: 100.0.w - 20,
          decoration: new BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: hotPropertiesThemeColor,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CustomIcons.virtual_reality,
                  color: Colors.grey.shade700,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
              ],
            ),
          )),
    );
  }

  Widget _uploadButton() {
    return GestureDetector(
      onTap: () {
        WebView.platform = SurfaceAndroidWebView();
        Navigator.of(Get.context!).push(MaterialPageRoute(
            builder: (ctx) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: hotPropertiesThemeColor,
                    title: Text('360° property view'),
                  ),
                  body: Material(
                    child: Container(
                      height: 100.0.h,
                      width: 100.0.w,
                      child: WebView(
                        onWebViewCreated: (controller) async {
                          var url = await controller.currentUrl();
                          print('current url=$url');
                        },
                        onPageStarted: (s) {
                          print("webview=$s");
                        },
                        onPageFinished: (s) {
                          print("webview=finished");
                          ;
                        },
                        onWebResourceError: (w) {
                          print("error=${w}");
                        },
                        initialUrl:
                            'https://www.bebuzee.com/virtual-tour?property_id=6',
                        javascriptMode: JavascriptMode.unrestricted,
                        allowsInlineMediaPlayback: true,
                        gestureNavigationEnabled: true,
                        onProgress: (progress) {
                          print("progress=$progress");
                        },
                      ),
                    ),
                  ),
                )));
      },
      child: Container(
        height: 50,
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
            color: hotPropertiesThemeColor),
        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Center(
            child: Text(
          "Upload",
          style: TextStyle(fontSize: 16, color: Colors.white),
        )),
      ),
    );
  }

  Widget _customButton(String text, VoidCallback onTap) {
    return Container(
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 0.6,
        ),
      ),
      child: ListTile(
          onTap: onTap,
          title: Text(text, style: TextStyle(color: Colors.grey)),
          trailing: Icon(Icons.arrow_drop_down)),
    );
  }

  Widget _customTextField(TextEditingController controller, String hintText) {
    return Container(
      height: 50,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 0.6,
        ),
      ),
      child: TextFormField(
        maxLines: null,
        cursorColor: Colors.grey.shade500,
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      ),
    );
  }

  Widget _photoCard(File file, int index, VoidCallback onTap) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                height: 250,
                width: 100.0.w,
              ),
            ),
          ),
          Positioned.fill(
            right: 10,
            top: 10,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  splashRadius: 15,
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(5),
                  onPressed: onTap,
                  icon: Icon(
                    CupertinoIcons.delete_solid,
                    color: hotPropertiesThemeColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _photosLengthCard() {
    return Positioned.fill(
      left: 20,
      bottom: 10,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Obx(() => Text(
                  "${controller.photos.length} ${controller.photosString()}",
                  style: TextStyle(
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ))),
      ),
    );
  }

  Widget _photosBuilder() {
    return Obx(
      () => Container(
          child: controller.photos.isEmpty
              ? _selectionCard(
                  "Select photos from gallery",
                  () => controller.pickPhotosFiles(),
                )
              : GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 250,
                    child: Stack(
                      children: [
                        PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.photos.length,
                            itemBuilder: (context, index) {
                              return _photoCard(controller.photos[index], index,
                                  () => controller.deleteFile(index));
                            }),
                        _photosLengthCard()
                      ],
                    ),
                  ),
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(VirtualTourController());
    return WillPopScope(
      onWillPop: () async {
        print("Went back");
        Get.delete<VirtualTourController>();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0.5,
            backgroundColor: hotPropertiesThemeColor,
            brightness: Brightness.dark,
            leading: IconButton(
              splashRadius: 20,
              icon: Icon(
                Icons.keyboard_backspace,
                size: 28,
              ),
              color: Colors.white,
              onPressed: () {
                textEditingController.clear();
                Get.delete<VirtualTourController>();
                Navigator.pop(context);
              },
            ),
            title: Text('Virtual Tour')),
        body: SingleChildScrollView(
          child: Container(
            // color: Colors.pink,
            height: 88.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _selectionCard("Select jpg or jpeg image file", () async {
                //   controller.pickPhotosFiles();
                // }),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.current.value = 'scene';
                            },
                            child: Column(
                              children: [
                                Text('Scenes',
                                    style: TextStyle(fontSize: 2.0.h)),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 0.5.h,
                                    width: 15.0.w,
                                    color: controller.current.value == 'scene'
                                        ? Colors.red
                                        : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20.0.w,
                          ),
                          InkWell(
                            onTap: () {
                              controller.current.value = 'hotspot';
                            },
                            child: Column(
                              children: [
                                Text('Hotspots',
                                    style: TextStyle(fontSize: 2.0.h)),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 0.5.h,
                                    width: 20.0.w,
                                    color: controller.current.value != 'scene'
                                        ? Colors.red
                                        : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => controller.current.value == 'scene'
                      ? Column(
                          children: [
                            _customTextField(
                                textEditingController, "Enter Name"),
                            _customTextField(
                                textEditingController, "Enter Title"),
                            _photosBuilder(),
                          ],
                        )
                      : Column(
                          children: [
                            _customTextField(textEditingController, "Text"),
                            _customButton("Target scene*", () {}),
                            _customButton("Scenes *", () {})

                            // _photosBuilder(),
                          ],
                        ),
                ),

                Spacer(),
                _uploadButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
