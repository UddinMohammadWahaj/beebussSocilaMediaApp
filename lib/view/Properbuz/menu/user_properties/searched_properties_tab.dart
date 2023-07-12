import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/SearchPropertiesListModel.dart';
import 'package:bizbultest/services/Properbuz/property_Searched_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../services/Properbuz/hot_properties_controller.dart';

// ignore: must_be_immutable

class SearchedPropertiesTab extends StatefulWidget {
  const SearchedPropertiesTab({Key? key}) : super(key: key);

  @override
  State<SearchedPropertiesTab> createState() => _SearchedPropertiesTabState();
}

class _SearchedPropertiesTabState extends State<SearchedPropertiesTab> {
  @override
  void initState() {
    super.initState();

    String uid = CurrentUser().currentUser.memberID!;
    controller.fetchData(uid);
    print("-----------------init------");
  }

// class SearchedPropertiesTab extends StatelessWidget {
  PropertySearchedController controller = Get.put(PropertySearchedController());
  PropertiesController ctr = Get.put(PropertiesController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.searchLoding.isTrue
          ? Center(
              child: CircularProgressIndicator(
              color: hotPropertiesThemeColor,
            ))
          : controller.lstPropertySearching.length == 0
              ? Container(
                  child: Center(
                    child: Text("No Searched Properties."),
                  ),
                )
              : Container(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GetX<PropertySearchedController>(
                      builder: (cntrlr) {
                        return ListView.builder(
                          itemCount: cntrlr.lstPropertySearching.length,
                          itemBuilder: (context, i) {
                            // if (cntrlr.lstPropertySearching != null &&
                            //     cntrlr.lstPropertySearching.length > 0) {
                            //   for (var i = 0;
                            //       i < cntrlr.lstPropertySearching.length;
                            //       i++) {
                            //     String imageName = "";
                            //     List<String> aa = cntrlr
                            //         .lstPropertySearching[i].imageGallery
                            //         .split("~~");

                            //     if (aa[0] != null && aa[0] != "") {
                            //       List<String> bb = aa[0].split("^^");
                            //       if (bb[0] != null && bb[0] != "") {
                            //         imageName = bb[0];
                            //       }
                            //     }
                            //     cntrlr.lstPropertySearching[i].oneImage =
                            //         imageName;
                            //   }
                            // }
                            return Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade300, width: 1),
                                ),
                              ),
                              padding: EdgeInsets.only(
                                  left: 15, top: 15, bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          child: CachedNetworkImage(
                                            imageUrl: cntrlr
                                                .lstPropertySearching[i]
                                                .defaultImage!,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Center(
                                                    child: CircularProgressIndicator(
                                                        color:
                                                            hotPropertiesThemeColor,
                                                        value: downloadProgress
                                                            .progress)),
                                            errorWidget:
                                                (context, url, error) => Center(
                                              child: Container(
                                                  height: 30.0.h,
                                                  width: 100.0.w,
                                                  color: Colors.grey.shade200,
                                                  child: Container()
                                                  //  Image(
                                                  //           image: CachedNetworkImageProvider(
                                                  //               "https://properbuz.bebuzee.com/gallery/main/" +
                                                  //                   cntrlr
                                                  //                       .lstPropertySearching[
                                                  //                           i]
                                                  //                       .oneImage),
                                                  //           fit: BoxFit.cover,
                                                  //           height: 30.0.h,
                                                  //           width: 100.0.w,
                                                  //         ),
                                                  ),
                                            ),
                                            fit: BoxFit.cover,
                                            height: 70,
                                            width: 70,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 4),
                                                width: 100.0.w - 150,
                                                child: Text(
                                                  cntrlr.lstPropertySearching[i]
                                                      .propertyTitle!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // Container(
                                              //   width: 100.0.w - 150,
                                              //   child: Text(
                                              //     cntrlr.lstPropertySearching[i]
                                              //         .area,
                                              //     style: TextStyle(
                                              //         fontSize: 14,
                                              //         color:
                                              //             Colors.grey.shade700),
                                              //   ),
                                              // ),
                                              Text(
                                                AppLocalizations.of(
                                                      "Price:",
                                                    ) +
                                                    " € " +
                                                    cntrlr
                                                        .lstPropertySearching[i]
                                                        .propertyPrice
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey.shade700,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    splashRadius: 20,
                                    icon: Icon(
                                      CupertinoIcons.delete,
                                      size: 22,
                                      color: hotPropertiesThemeColor,
                                    ),
                                    color: Colors.black,
                                    onPressed: () {
                                      controller.delete(
                                          controller.lstPropertySearching[i].id,
                                          i);
                                      // controller
                                      //     .lstPropertySearching[index].Navigator
                                      //     .pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}

// class SearchedPropertiesTab extends StatefulWidget {
//   const SearchedPropertiesTab({Key key}) : super(key: key);

//   @override
//   _SearchedPropertiesTabState createState() => _SearchedPropertiesTabState();
// }

// class _SearchedPropertiesTabState extends State<SearchedPropertiesTab> {
//   bool isLoading = false;

//   SearchPropertiesList objSearchPropertiesList = new SearchPropertiesList();

//   List<Message> message = [];

//   @override
//   void initState() {
//     super.initState();
//     getSearchData();
//   }

//   getSearchData() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       String uid = CurrentUser().currentUser.memberID;

//       objSearchPropertiesList = await ApiProvider().searchpropertiesList(uid);

//       if (objSearchPropertiesList != null && objSearchPropertiesList.message != null) {
//         for (var i = 0; i < objSearchPropertiesList.message.length; i++) {
//           String imageName = "";
//           List<String> aa = objSearchPropertiesList.message[i].imageGallery.split("~~");

//           if (aa[0] != null && aa[0] != "") {
//             List<String> bb = objSearchPropertiesList.message[i].imageGallery.split("^^");
//             if (bb[0] != null && bb[0] != "") {
//               imageName = bb[0];
//             }
//           }

//           objSearchPropertiesList.message[i].oneImage = imageName;

//           message.add(objSearchPropertiesList.message[i]);
//         }
//       }
//     } catch (e) {
//       print(e);
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: MediaQuery.removePadding(
//         context: context,
//         removeTop: true,
//         child: message != null && message.length > 0
//             ? ListView.builder(
//                 itemCount: message.length,
//                 itemBuilder: (context, i) {
//                   return Container(
//                     decoration: new BoxDecoration(
//                       shape: BoxShape.rectangle,
//                       border: Border(
//                         bottom: BorderSide(color: Colors.grey.shade300, width: 1),
//                       ),
//                     ),
//                     padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           child: Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(3),
//                                 child: CachedNetworkImage(
//                                   imageUrl: "https://properbuz.bebuzee.com/gallery/main/" + message[i].oneImage,
//                                   progressIndicatorBuilder: (context, url, downloadProgress) =>
//                                       CircularProgressIndicator(value: downloadProgress.progress),
//                                   errorWidget: (context, url, error) => Icon(Icons.error),
//                                   fit: BoxFit.cover,
//                                   height: 70,
//                                   width: 70,
//                                 ),
//                                 // Image(
//                                 //   image: CachedNetworkImageProvider(
//                                 //     message[i].oneImage,
//                                 //     // "https://properbuz.bebuzee.com/gallery/main/EP_16327369992.jpeg",
//                                 //     errorListener: () {},
//                                 //   ),
//                                 //   fit: BoxFit.cover,
//                                 //   height: 70,
//                                 //   width: 70,
//                                 // ),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.only(left: 15),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.only(bottom: 4),
//                                       width: 100.0.w - 150,
//                                       child: Text(
//                                         message[i].propertyTitle,
//                                         // AppLocalizations.of(
//                                         //   "Trilocale Via Poma 61, Milano",
//                                         // ),
//                                         style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                     Container(
//                                       width: 100.0.w - 150,
//                                       child: Text(
//                                         message[i].area,
//                                         // AppLocalizations.of(
//                                         //   "Milan, Via Carlo Poma",
//                                         // ),
//                                         style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
//                                       ),
//                                     ),
//                                     Text(
//                                       AppLocalizations.of(
//                                             "Price:",
//                                           ) +
//                                           // " € 555,000",
//                                           " € " +
//                                           message[i].cost,
//                                       style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           splashRadius: 20,
//                           icon: Icon(
//                             CupertinoIcons.delete,
//                             size: 22,
//                             color: settingsColor,
//                           ),
//                           color: Colors.black,
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               )
//             : Center(
//                 child: Text(
//                   "No Data Found",
//                 ),
//               ),
//       ),
//     );
//   }
// }

// class SearchedPropertiesTab extends GetView<UserPropertiesController> {
//   const SearchedPropertiesTab({Key key}) : super(key: key);

//   @override
//   void initState() {
//     super.initState();
//     getSearchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Get.put(UserPropertiesController());
//     return Container(
//       child: MediaQuery.removePadding(
//         context: context,
//         removeTop: true,
//         child: ListView.builder(
//             itemCount: 20,
//             itemBuilder: (context, index) {
//               return Container(
//                 decoration: new BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   border: Border(
//                     bottom: BorderSide(color: Colors.grey.shade300, width: 1),
//                   ),
//                 ),
//                 padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       child: Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(3),
//                             child: Image(
//                               image: CachedNetworkImageProvider("https://properbuz.bebuzee.com/gallery/main/EP_16327369992.jpeg"),
//                               fit: BoxFit.cover,
//                               height: 70,
//                               width: 70,
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.only(left: 15),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.only(bottom: 4),
//                                   width: 100.0.w - 150,
//                                   child: Text(
//                                     AppLocalizations.of(
//                                       "Trilocale Via Poma 61, Milano",
//                                     ),
//                                     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 100.0.w - 150,
//                                   child: Text(
//                                     AppLocalizations.of(
//                                       "Milan, Via Carlo Poma",
//                                     ),
//                                     style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
//                                   ),
//                                 ),
//                                 Text(
//                                   AppLocalizations.of(
//                                         "Price:",
//                                       ) +
//                                       " € 555,000",
//                                   style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       splashRadius: 20,
//                       icon: Icon(
//                         CupertinoIcons.delete,
//                         size: 22,
//                         color: settingsColor,
//                       ),
//                       color: Colors.black,
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             }),
//       ),
//     );
//   }
// }
