import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/AmortizationCalculatorController.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/calculator_appbar.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/custom_header.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:high_chart/high_chart.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:sizer/sizer.dart';

class AmortizationCalculatorView
    extends GetView<AmortizationCalculatorController> {
  const AmortizationCalculatorView({Key? key}) : super(key: key);

  static final TextEditingController textEditingController =
      TextEditingController();

  Widget _title() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          AppLocalizations.of(
              "The amortization calculator estimates how much money will be paid over the life of the loan for principal and interest. The calculator breaks down payments into interest and principal. The amortization calculator also provides a detailed amortization schedule that breaks down payments into interest and principal in the advanced report."),
          style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
        ));
  }

  Widget _dollarPrefix() {
    return Container(
        padding: EdgeInsets.only(
          right: 10,
        ),
        child: Icon(
          Icons.monetization_on,
          color: Colors.grey.shade500,
          size: 20,
        ));
  }

  Widget _percentageSuffix() {
    return Container(
        padding: EdgeInsets.only(left: 10),
        child: Icon(
          CupertinoIcons.percent,
          color: Colors.grey.shade500,
          size: 20,
        ));
  }

  Widget _textCard(String val) {
    return Text(val,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 15));
  }

  Widget _infoButton(VoidCallback onTap) {
    return IconButton(
        padding: EdgeInsets.only(left: 5, top: 20, bottom: 10, right: 5),
        constraints: BoxConstraints(),
        splashRadius: 1,
        onPressed: onTap,
        icon: Icon(
          Icons.info,
          size: 20,
          color: hotPropertiesThemeColor,
        ));
  }

  Widget _tabCard(String value, var index) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          value,
          style: TextStyle(
              fontSize: 10.0.sp,
              color: controller.mortgageIndex.value == index
                  ? Colors.white
                  : hotPropertiesThemeColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ));
  }

  Widget _control() {
    return Container(
      width: 100.0.w,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Obx(
        () => MaterialSegmentedControl(
          horizontalPadding: EdgeInsets.symmetric(horizontal: 0),
          children: {
            0: _tabCard(
                AppLocalizations.of(
                  "Breakdown",
                ),
                0),
            1: _tabCard(
                AppLocalizations.of(
                  "Schedule",
                ),
                1),
            2: _tabCard(
                AppLocalizations.of(
                  "Report",
                ),
                2),
          },
          selectionIndex: controller.mortgageIndex.value,
          borderColor: hotPropertiesThemeColor,
          selectedColor: hotPropertiesThemeColor,
          unselectedColor: Colors.white,
          borderRadius: 5.0,
          onSegmentChosen: (dynamic index) {
            controller.changeMortgageIndex(index!);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AmortizationCalculatorController());
    return GetBuilder<AmortizationCalculatorController>(
      // no need to initialize Controller ever again, just mention the type
      builder: (value) => Scaffold(
        backgroundColor: Colors.white,
        appBar: calculatorAppBar(
            context,
            AppLocalizations.of("Amortization") +
                " " +
                AppLocalizations.of("Calculators")),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                CustomHeader(
                  header: AppLocalizations.of("Loan") +
                      " " +
                      AppLocalizations.of("Amount"),
                ),
                CustomTextField(
                  prefix: _dollarPrefix(),
                  controller: controller.loan_amt_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Amount"),
                  onChanged: (_) {
                    controller.check();
                  },
                ),
                CustomHeader(
                  header: AppLocalizations.of("Loan") +
                      " " +
                      AppLocalizations.of("Term"),
                ),
                CustomDropdownField(
                  padding: 20,
                  dropDownItems: [
                    {
                      "name": "30 " +
                          AppLocalizations.of("Year") +
                          " " +
                          AppLocalizations.of("Fixed"),
                      "val": 360
                    },
                    {
                      "name": "15 " +
                          AppLocalizations.of("Year") +
                          " " +
                          AppLocalizations.of("Fixed"),
                      "val": 180
                    },
                    {"name": AppLocalizations.of("5/1 ARM"), "val": 361},
                  ],
                  value: controller.months_pay,
                  onChanged: (val) {
                    controller.months_pay = val;
                    controller.check();
                  },
                ),
                // CustomSelectButton(
                //   val: "30 Years Fixed",
                //   onTap: () {},
                // ),
                CustomHeader(
                  header: AppLocalizations.of("Annual") +
                      " " +
                      AppLocalizations.of("Interest") +
                      " " +
                      AppLocalizations.of("Rate"),
                ),
                CustomTextField(
                  controller: controller.interest_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Rate"),
                  onChanged: (_) {
                    controller.check();
                  },
                ),
                CustomHeader(
                  header: AppLocalizations.of("Start") +
                      " " +
                      AppLocalizations.of("Date"),
                ),
                CustomDropdownField(
                  padding: 20,
                  dropDownItems: [
                    {"name": AppLocalizations.of("January"), "val": 1},
                    {"name": AppLocalizations.of("Febuary"), "val": 2},
                    {"name": AppLocalizations.of("March"), "val": 3},
                    {"name": AppLocalizations.of("April"), "val": 4},
                    {"name": AppLocalizations.of("May"), "val": 5},
                    {"name": AppLocalizations.of("June"), "val": 6},
                    {"name": AppLocalizations.of("July"), "val": 7},
                    {"name": AppLocalizations.of("August"), "val": 8},
                    {"name": AppLocalizations.of("September"), "val": 9},
                    {"name": AppLocalizations.of("October"), "val": 10},
                    {"name": AppLocalizations.of("November"), "val": 11},
                    {"name": AppLocalizations.of("December"), "val": 12},
                  ],
                  value: controller.startMonth,
                  onChanged: (val) {
                    controller.startMonth = val;
                    controller.check();
                  },
                ),
                // CustomSelectButton(
                //   val: "Oct",
                //   onTap: () {},
                // ),
                SizedBox(height: 10),
                CustomDropdownField(
                  padding: 20,
                  dropDownItems: [
                    ...List.generate(
                        200,
                        (index) =>
                            {"name": "${1900 + index}", "val": 1900 + index})
                  ],
                  value: controller.startYear,
                  onChanged: (val) {
                    controller.startYear = val;
                    controller.check();
                  },
                ),
                // CustomSelectButton(
                //   val: "2021",
                //   onTap: () {},
                // ),
                SizedBox(
                  height: 20,
                ),

                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of('Amortization'),
                          style: TextStyle(
                              fontSize: 14,
                              color: greyColor,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 450,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: greyColor.withOpacity(.5), width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: HighCharts(
                            key: ValueKey(DateTime.now()),size: Size(10,10),
                            data: controller.graphData,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of("Amortization") +
                            " " +
                            AppLocalizations.of("Schedule") +
                            " " +
                            AppLocalizations.of("Breakdown"),
                        style: TextStyle(
                            fontSize: 20,
                            color: greyColor,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Text(
                        AppLocalizations.of("Over 30 years you'll pay") +
                            ": \$361,569",
                        style: TextStyle(
                            fontSize: 14,
                            color: greyColor,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(
                                "Based on an estimated monthly payment of") +
                            " \$1,004",
                        style: TextStyle(
                            fontSize: 14,
                            color: greyColor,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Text(
                        AppLocalizations.of("Total principal payments") +
                            ": \$${controller.amount}",
                        style: TextStyle(
                            fontSize: 14,
                            color: greyColor,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Text(
                        AppLocalizations.of("Total interest payments") +
                            ": \$${controller.fixVal(controller.interest, 0, 2, ' ')}",
                        style: TextStyle(
                            fontSize: 14,
                            color: greyColor,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      CustomDropdownField(
                        padding: 20,
                        dropDownItems: [
                          {
                            "name": AppLocalizations.of("Show") +
                                " " +
                                AppLocalizations.of("by") +
                                " " +
                                AppLocalizations.of("Month"),
                            "val": 0
                          },
                          {
                            "name": AppLocalizations.of("Show") +
                                " " +
                                AppLocalizations.of("by") +
                                " " +
                                AppLocalizations.of("Year"),
                            "val": 1
                          },
                        ],
                        value: controller.showBy,
                        onChanged: (val) {
                          controller.showBy = val;
                          controller.check();
                        },
                      ),
                      // CustomSelectButton(
                      //   val: "Show by month",
                      //   onTap: () {},
                      // ),
                    ],
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    AppLocalizations.of('Month').toUpperCase(),
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    AppLocalizations.of('Amount').toUpperCase(),
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    AppLocalizations.of('Interest')
                                        .toUpperCase(),
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    AppLocalizations.of('Principal')
                                        .toUpperCase(),
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    AppLocalizations.of('Balance')
                                        .toUpperCase(),
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                              rows: <DataRow>[
                                ...(controller.showBy == 0
                                        ? controller.detail
                                        : controller.detail_year)
                                    .map((e) => DataRow(
                                          key: ValueKey(
                                              e[AppLocalizations.of("date")]),
                                          cells: <DataCell>[
                                            DataCell(Text(e[
                                                AppLocalizations.of("date")])),
                                            DataCell(Text(
                                                '\$${e[AppLocalizations.of("amount")]}')),
                                            DataCell(Text(
                                                '\$${e[AppLocalizations.of("interest")]}')),
                                            DataCell(Text(
                                                '\$${e[AppLocalizations.of("principal")]}')),
                                            DataCell(Text(
                                                '\$${e[AppLocalizations.of("balance")]}')),
                                          ],
                                        ))
                                    .toList(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
