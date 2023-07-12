import 'package:bizbultest/services/Properbuz/tradesmen_results_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Language/appLocalization.dart';

class ServicesTab extends GetView<TradesmenResultsController> {
  TradesmenResultsController? ctrl;
  bool? iscompany;
  ServicesTab({Key? key, this.ctrl, this.iscompany}) : super(key: key);

  Widget _titleCard(String title, color) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Text(
          AppLocalizations.of(title),
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: color),
        ));
  }

  Widget _customTextCard(String value, align) {
    return Container(
      child: Text(
        "- " + AppLocalizations.of(value),
        style: TextStyle(fontSize: 15, color: settingsColor),
        textAlign: align,
      ),
    );
  }

  Widget _separator() {
    return Divider(
      thickness: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _subCatListBuilderSolo(BuildContext context, index) {
    return Container(
        width: MediaQuery.of(context).size.width / 2.5,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.tradesmenServiceSolo.length,
            itemBuilder: (context, sindex) {
              return _customTextCard(
                  AppLocalizations.of(controller
                      .tradesmenServiceSolo[index].subcategory!.subcatName!),
                  TextAlign.right);
            }));
  }

  Widget _subCatListBuilder(BuildContext context, index) {
    return Container(
        width: MediaQuery.of(context).size.width / 2.5,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount:
                controller.tradesmenServicesCompany[index].subcategory!.length,
            itemBuilder: (context, sindex) {
              return _customTextCard(
                  AppLocalizations.of(controller.tradesmenServicesCompany[index]
                      .subcategory![sindex].subcatName!),
                  TextAlign.right);
            }));
  }

  Widget _serviceListBuilder(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.separated(
          separatorBuilder: (context, index) => _separator(),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.tradesmenServicesCompany.length,
          itemBuilder: (context, index) {
            return Container(
                padding:
                    EdgeInsets.only(left: 10, bottom: 15, right: 10, top: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _customTextCard(
                          AppLocalizations.of(controller
                              .tradesmenServicesCompany[index]!.name!),
                          TextAlign.left),
                      _subCatListBuilder(context, index),
                    ]));
          }),
    );
  }

  Widget _serviceListBuilderSolo(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.separated(
          separatorBuilder: (context, index) => _separator(),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.tradesmenServiceSolo.length,
          itemBuilder: (context, index) {
            return Container(
                padding:
                    EdgeInsets.only(left: 10, bottom: 15, right: 10, top: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _customTextCard(
                          AppLocalizations.of(
                              controller.tradesmencatsolo.string),
                          TextAlign.left),
                      _subCatListBuilderSolo(context, index),
                    ]));
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("iscompanyservice=${this.iscompany}");
    return Obx(
      () => Container(
        alignment: controller.tradesmenServicesCompany.length > 0
            ? Alignment.topCenter
            : Alignment.center,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: this.iscompany! && controller.tradesmenServiceSolo.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleCard(AppLocalizations.of("Main work undertaken"),
                        settingsColor),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _titleCard(AppLocalizations.of("Category"),
                            Colors.grey.shade700),
                        _titleCard(
                            AppLocalizations.of("Sub") +
                                " " +
                                AppLocalizations.of("Category"),
                            Colors.grey.shade700),
                      ],
                    ),
                    _serviceListBuilderSolo(context),
                  ],
                )
              : this.iscompany! &&
                      controller.tradesmenServicesCompany.length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleCard(AppLocalizations.of("Main works undertaken"),
                            settingsColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _titleCard(AppLocalizations.of("Category"),
                                Colors.grey.shade700),
                            _titleCard(
                                AppLocalizations.of("Sub") +
                                    " " +
                                    AppLocalizations.of("Category"),
                                Colors.grey.shade700),
                          ],
                        ),
                        _serviceListBuilder(context),
                      ],
                    )
                  : Center(
                      child:
                          Text(AppLocalizations.of("No Service Added Yet..!"))),
        ),
      ),
    );
  }
}
