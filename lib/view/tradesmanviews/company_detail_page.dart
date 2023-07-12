import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/tradesmanviews/editsolotradesmenview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../utilities/loading_indicator.dart';
import 'company_tradesmen_add_view.dart';
import 'companylist.dart';
import 'editsolotradesmenviewcompany.dart';

class CompanyDetailPageView extends StatefulWidget {
  String? id;
  CompanyListingController controller;

  CompanyDetailPageView({Key? key, this.id, required this.controller})
      : super(key: key);

  @override
  State<CompanyDetailPageView> createState() => _CompanyDetailPageViewState();
}

class _CompanyDetailPageViewState extends State<CompanyDetailPageView> {
  Widget customIndividualTradesmen(index, {name: '', img: '', approval: ''}) {
    return Card(
      elevation: 0.5,
      child: ListTile(
        trailing: IconButton(
            onPressed: () {
              showBarModalBottomSheet(
                  context: context,
                  builder: (ctx) => Container(
                        height: 25.0.h,
                        width: 100.0.w,
                        child: Column(
                          children: [
                            ListTile(
                              trailing: Icon(Icons.close),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: Text('Edit Tradesmen'),
                              trailing: Icon(Icons.edit),
                              onTap: () {
                                print(
                                    "tradesmen_id=${widget.controller.tradesmenList[index].tradesmenId}");
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) =>
                                        EditSoloTradesmenViewCompany(
                                          from: 'company',
                                          companyId: widget.id!,
                                          tradesmenId: widget.controller
                                              .tradesmenList[index].tradesmenId
                                              .toString(),
                                        )));
                              },
                            ),
                            ListTile(
                              title: Text('Delete Tradesmen'),
                              trailing: Icon(Icons.delete),
                              onTap: () {
                                Navigator.of(context).pop();
                                var id = widget.controller.tradesmenList[index]
                                    .tradesmenId;
                                widget.controller.tradesmenList.removeAt(index);
                                widget.controller.removeCompanyTradesmen(id);
                              },
                            )
                          ],
                        ),
                      ));
            },
            icon: Icon(Icons.more_vert)),

        leading: CircleAvatar(
            backgroundColor: settingsColor,
            backgroundImage: CachedNetworkImageProvider(img)),
        isThreeLine: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.controller.tradesmenList[index].status!),
            Text(widget.controller.tradesmenList[index].experience! + ' yrs')
          ],
        ),
        title: Text('${name}'),
        // subtitle: approval,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.controller.getTradesmenList(widget.id);
  }

  @override
  void dispose() {
    widget.controller.tradesmenList.value = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void refreshList() {
      widget.controller.getTradesmenList(widget.id);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: settingsColor,
        title: Text('Company Name'),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: widget.controller.tradesmenList.length > 0
              ? Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.controller.tradesmenList.length,
                        itemBuilder: (ctx, index) => customIndividualTradesmen(
                            index,
                            name:
                                widget.controller.tradesmenList[index].fullName,
                            img: widget
                                .controller.tradesmenList[index].profileImage))
                  ],
                )
              : Center(
                  child: loadingAnimation(),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: settingsColor,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => NewCompanyTradesmenView(
                    "solo", widget.id!, [],
                    from: 'company', refresh: refreshList)));
          },
          label: Text('Add Tradesmen')),
    );
  }
}
