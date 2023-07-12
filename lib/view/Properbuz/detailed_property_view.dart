import 'package:bizbultest/Language/appLocalization.dart';

import 'package:bizbultest/services/Properbuz/api/properties_api.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Properbuz/property/contacts_stack_row.dart';
import 'package:bizbultest/widgets/Properbuz/property/detailed_info_row.dart';
import 'package:bizbultest/widgets/Properbuz/property/property_advertiser_card.dart';
import 'package:bizbultest/widgets/Properbuz/property/property_content_card.dart';
import 'package:bizbultest/widgets/Properbuz/property/property_content_card_saved.dart';
import 'package:bizbultest/widgets/Properbuz/property/property_description_card.dart';
import 'package:bizbultest/widgets/Properbuz/property/property_images_pageview.dart';
import 'package:bizbultest/widgets/Properbuz/property/property_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:share/share.dart';

import 'calculators/mortgage_calculator_view.dart';

class DetailedPropertyView extends StatefulWidget {
  final int? index;
  final int? val;

  const DetailedPropertyView({Key? key, this.index, this.val})
      : super(key: key);

  @override
  State<DetailedPropertyView> createState() => _DetailedPropertyViewState();
}

class _DetailedPropertyViewState extends State<DetailedPropertyView> {
  PropertiesController controller = Get.put(PropertiesController());

  Widget _iconButton(
      IconData iconData, double size, VoidCallback onTap, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: IconButton(
        constraints: BoxConstraints(),
        splashRadius: 20,
        icon: Icon(
          iconData,
          size: size,
          color: color,
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _iconButton2(
      IconData iconData, double size, VoidCallback onTap, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      decoration:
          controller.properties(widget.val!)[widget.index!].savedStatus!.value
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                )
              : null,
      child: IconButton(
        constraints: BoxConstraints(),
        splashRadius: 20,
        icon: Icon(
          iconData,
          size: size,
          color: color,
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _affordCard() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 0.5,
        ),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          CustomIcons.calculator,
          color: Colors.grey.shade700,
          size: 28,
        ),
        title: Text(
          AppLocalizations.of(
            "Can you afford it?",
          ),
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          AppLocalizations.of(
            "Find out what mortgage you can get",
          ),
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        trailing: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MortgageCalculatorView())),
          child: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 22,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    print("infoooooooo");
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller
          .properties(widget.val!)[widget.index!]
          .selectedPhotoIndex!
          .value = 0;
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        // foregroundColor: hotPropertiesThemeColor,
        backgroundColor: hotPropertiesThemeColor,
        brightness: Brightness.dark,
        actions: [
          _iconButton(Icons.share, 25, () {
            Share.share(
                "Check out this property on Properbuz \n ${controller.properties(widget.val!)[widget.index!].shareurl}",
                subject: "Properbuz property");
          }, Colors.white),
          // _iconButton(
          //     CupertinoIcons.delete_solid,
          //     22,
          //     () => controller.removePropertyDetailed(
          //         widget.index, widget.val, context),
          //     Colors.white),
          // PropertyAPI.memberID ==
          //         controller.properties(widget.val)[widget.index].agentId
          //     ? _iconButton(
          //         CupertinoIcons.delete_solid,
          //         22,
          //         () => controller.removePropertyDetailed(
          //             widget.index, widget.val, context),
          //         Colors.white)
          //     : _iconButton(
          //         controller
          //                 .properties(widget.val)[widget.index]
          //                 .alertStatus
          //                 .value
          //             ? Icons.notifications_on
          //             : Icons.notifications_none,
          //         26,
          //         () {
          //           controller.alertUnalertDetailed(widget.index, widget.val);
          //           if (controller.alertProperties.length > 0) {
          //             controller.alertProperties.removeAt(widget.index);
          //           }
          //           Navigator.of(context).pop();
          //         },
          //         // controller
          //         //         .properties(widget.val)[widget.index]
          //         //         .alertStatus
          //         //         .value
          //         //     ? Colors.red.shade700
          //         //     : Colors.white
          //         Colors.white,
          //       ),

          Obx(
            () => _iconButton2(CupertinoIcons.heart_fill, 25, () {
              controller.saveUnsaveDetailed(widget.index!, widget.val!);
              if (controller.savedProperties.length > 0) {
                controller.savedProperties.removeAt(widget.index!);
              }
              Navigator.of(context).pop();
            },
                controller
                        .properties(widget.val!)[widget.index!]
                        .savedStatus!
                        .value
                    ? Colors.red.shade700
                    : Colors.white),
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    PropertyImagesPageView(
                      index: widget.index!,
                      val: widget.val!,
                    ),
                    DetailedInfoRow(
                      index: widget.index!,
                      val: widget.val!,
                    ),
                    PropertyInfoCard(
                      index: widget.index,
                      val: widget.val,
                      padding: 15,
                    ),
                    _affordCard(),

                    PropertyDescriptionCard(
                      index: widget.index!,
                      val: widget.val!,
                    ),

                    widget.val == 1
                        ? FutureBuilder(
                            future: controller.fetchDetails(controller
                                .properties(widget.val!)[widget.index!]
                                .propertyId),
                            // controller.hotmodel.length > 0
                            //     ? controller
                            //         .hotmodel[widget.index].propertyId
                            // : null),
                            builder: (context, snapshot) {
                              print("infooooo 11---");
                              if (snapshot.data != null) {
                                return PropertyContentCardSaved(
                                  index: widget.index!,
                                  val: widget.val!,
                                );
                              } else
                                print(" 12---");

                              return PropertyContentCard(
                                index: widget.index!,
                                val: widget.val!,
                              );
                            },
                          )
                        : FutureBuilder(
                            future: controller.fetchDetails(controller
                                    .properties(widget.val!)[widget.index!]
                                    .propertyId ??
                                null),
                            builder: (context, snapshot) {
                              return PropertyContentCard(
                                index: widget.index!,
                                val: widget.val!,
                              );
                            }),

                    PropertyAdviserCard(
                      index: widget.index!,
                      val: widget.val!,
                    ),
                    //SimilarListingsCard()
                  ],
                ),
              ),
            ),
            ContactsStackRow(
              index: widget.index!,
              val: widget.val!,
            )
          ],
        ),
      ),
    );
  }
}
