import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/refinance_calculator_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/calculator_appbar.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/custom_header.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/custom_textfield.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:high_chart/high_chart.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:sizer/sizer.dart';

class RefinanceCalculatorView extends GetView<RefinanceCalculatorController> {
  const RefinanceCalculatorView({Key? key}) : super(key: key);

  static final TextEditingController textEditingController =
      TextEditingController();

  Widget _title() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          AppLocalizations.of(
              "Use our refinance calculator to see if you should refinance your mortgage. Enter the details of your current home loan, along with details of a new loan, to estimate your savings and see if refinancing can help you meet your financial goals."),
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
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: MaterialSegmentedControl(
              horizontalPadding: EdgeInsets.symmetric(horizontal: 0),
              children: {
                0: _tabCard(
                    AppLocalizations.of(
                      "Breakdown",
                    ),
                    0),
                1: _tabCard(
                    AppLocalizations.of(
                      "Report",
                    ),
                    1),
              },
              selectionIndex: controller.mortgageIndex.value,
              borderColor: hotPropertiesThemeColor,
              selectedColor: hotPropertiesThemeColor,
              unselectedColor: Colors.white,
              borderRadius: 5.0,
              onSegmentChosen: (dynamic index) {
                controller.changeMortgageIndex(index);
              },
            ),
          ),
          if (controller.mortgageIndex == 0.obs)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),

                Text(AppLocalizations.of("Monthly").toUpperCase() +
                    " " +
                    AppLocalizations.of("Savings").toUpperCase() +
                    " : \$${controller.MONTHLY_SAVINGS ?? 0}"),
                Text(AppLocalizations.of("New").toUpperCase() +
                    " " +
                    AppLocalizations.of("Savings").toUpperCase() +
                    " : \$${controller.NEW_PAYMENT ?? 0}"),
                Text(AppLocalizations.of("Cost").toUpperCase() +
                    " : \$${controller.COST ?? 0}"),
                Text(AppLocalizations.of("Break").toUpperCase() +
                    " " +
                    AppLocalizations.of("Even").toUpperCase() +
                    " : \$${controller.BREAK_EVEN ?? 0}"),
                Text(AppLocalizations.of("Lifetime").toUpperCase() +
                    " " +
                    AppLocalizations.of("Savings").toUpperCase() +
                    " : \$${controller.LIFETIME_SAVINGS ?? 0}"),

                // Text(
                //     "MONTHLY SAVINGS \t ${((controller.MONTHLY_SAVINGS ?? 0 as num).sign < 0) ? '-' : ''}\$${(controller.MONTHLY_SAVINGS ?? 0 as num).abs()}"),
                // Text(
                //     "NEW PAYMENT \t ${((controller.NEW_PAYMENT ?? 0 as num).sign < 0) ? '-' : ''}\$${(controller.NEW_PAYMENT ?? 0 as num).abs()}"),
                // Text(
                //     "BREAK EVEN \t ${((controller.BREAK_EVEN ?? 0 as num).sign < 0) ? '-' : ''}\$${(controller.BREAK_EVEN ?? 0 as num).abs()}"),
                // Text(
                //     "COST \t ${((controller.COST ?? 0 as num).sign < 0) ? '-' : ''}\$${(controller.COST ?? 0 as num).abs()}"),
                // Text(
                //     "LIFETIME SAVINGS \t ${((controller.LIFETIME_SAVINGS ?? 0 as num).sign < 0) ? '-' : ''}\$${(controller.LIFETIME_SAVINGS ?? 0 as num).abs()}"),

                SizedBox(
                  height: 10,
                ),

                if (controller.barChart != null && controller.barChart != "")
                  Container(
                    key: ValueKey(controller.barChart),
                    width: double.infinity,
                    height: 450,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: greyColor.withOpacity(.5), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: HighCharts(
                      key: ValueKey(DateTime.now()),
                      data: controller.barChart.value,
                      size: Size(10, 10),
                    ),
                  ),
                // AspectRatio(
                //   aspectRatio: 16 / 10,
                //   child: SizedBox(
                //     width: double.infinity,
                //     child: Padding(
                //       padding: EdgeInsets.only(top: 20),
                //       child: HorizontalBarChart.withSampleData(),
                //     ),
                //   ),
                // ),
                if (controller.lineChart != null && controller.lineChart != "")
                  Container(
                    key: ValueKey(controller.lineChart),
                    width: double.infinity,
                    height: 450,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: greyColor.withOpacity(.5), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: HighCharts(
                      key: ValueKey(DateTime.now()),
                      data: controller.lineChart.value,
                      size: Size(10, 10),
                    ),
                  ),
                // AspectRatio(
                //   aspectRatio: 16 / 10,
                //   child: SizedBox(
                //     width: double.infinity,
                //     child: Padding(
                //       padding: EdgeInsets.only(top: 20),
                //       child: SimpleTimeSeriesChart.withSampleData(),
                //     ),
                //   ),
                // ),
              ],
            ),
          if (controller.mortgageIndex == 1.obs) _fullReport(),
        ],
      ),
    );
  }

  Widget _fullReport() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: <
        Widget>[
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('Refinancing could save you'),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${controller.MONTHLY_SAVINGS ?? 0} /mo',
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('Estimated').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('Payment').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('Loan').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('Amount').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${controller.home_price_TextController.text}',
                    style: TextStyle(
                        fontSize: 12,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('Interest') +
                        ' ' +
                        AppLocalizations.of('Rate'),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${controller.ir_TextController.text}%',
                    style: TextStyle(
                        fontSize: 12,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('Origination').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('Year').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${controller.originated_year_TextController.text}',
                    style: TextStyle(
                        fontSize: 12,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('Term').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${controller.months_pay_TextController.text}',
                    style: TextStyle(
                        fontSize: 12,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('New').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('loan').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('Loan').toUpperCase() +
                        " " +
                        AppLocalizations.of('amount').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${controller.new_loanamt_TextController.text}',
                    style: TextStyle(
                        fontSize: 12,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('Interest').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('Rate').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${controller.new_ir_rate_TextController.text}%',
                    style: TextStyle(
                        fontSize: 12,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('Term').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${controller.new_months_pay_TextController.text}',
                    style: TextStyle(
                        fontSize: 12,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('Refinance').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('Payment').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${controller.ref_fees_TextController.text}',
                    style: TextStyle(
                        fontSize: 12,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('Roll').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('Payment').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    controller.roll_fees
                        ? AppLocalizations.of("Yes")
                        : AppLocalizations.of("No"),
                    style: TextStyle(
                        fontSize: 12,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of('Cash').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('Out').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${controller.cashout_TextController.text}',
                    style: TextStyle(
                        fontSize: 12,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              if (controller.lineChart != null && controller.lineChart != "")
                Container(
                  key: ValueKey(controller.lineChart.value),
                  width: double.infinity,
                  height: 450,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: greyColor.withOpacity(.5), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: HighCharts(
                    key: ValueKey(DateTime.now()),
                    data: controller.lineChart.value,
                    size: Size(10, 10),
                  ),
                ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of("Monthly").toUpperCase() +
                          " " +
                          AppLocalizations.of("Savings").toUpperCase()),
                      SizedBox(height: 5),
                      Text('\$${controller.MONTHLY_SAVINGS ?? 0}'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(AppLocalizations.of("Lifetime").toUpperCase() +
                          " " +
                          AppLocalizations.of("Savings").toUpperCase()),
                      SizedBox(height: 5),
                      Text('\$${controller.LIFETIME_SAVINGS ?? 0}'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of("New").toUpperCase() +
                          " " +
                          AppLocalizations.of("Payment").toUpperCase()),
                      SizedBox(height: 5),
                      Text('\$${controller.NEW_PAYMENT ?? 0}'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(AppLocalizations.of("Break").toUpperCase() +
                          " " +
                          AppLocalizations.of("Even").toUpperCase()),
                      SizedBox(height: 5),
                      Text("${controller.BREAK_EVEN}"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                key: ValueKey(controller.scheduleChartData.value),
                width: double.infinity,
                height: 450,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: greyColor.withOpacity(.5), width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: HighCharts(
                  key: ValueKey(DateTime.now()),
                  data: controller.scheduleChartData.value,
                  size: Size(10, 10),
                ),
              ),
            ],
          ),
        ),
      ),
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of('Principal') +
                    ' vs. ' +
                    AppLocalizations.of('Interest'),
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
                    border:
                        Border.all(color: greyColor.withOpacity(.5), width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: HighCharts(
                  key: ValueKey(DateTime.now()),
                  data: controller.irPrChartData.value,
                  size: Size(10, 10),
                ),
              ),
            ],
          ),
        ),
      ),
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(
                    'Over 360 months you will spend \$${controller.totalInterest} in interest.'),
                style: TextStyle(
                    fontSize: 14,
                    color: greyColor,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          AppLocalizations.of('Month').toUpperCase(),
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppLocalizations.of('Amount').toUpperCase(),
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppLocalizations.of('Interest').toUpperCase(),
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppLocalizations.of('Principal').toUpperCase(),
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppLocalizations.of('Balance').toUpperCase(),
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      ...controller.irPrTablearr
                          .map((e) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text("${e['i']}")),
                                  DataCell(Text("\$${e['E']}")),
                                  DataCell(Text("\$${e['ir']}")),
                                  DataCell(Text("\$${e['pr']}")),
                                  DataCell(Text("\$${e['bal']}")),
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(RefinanceCalculatorController());
    return GetBuilder<RefinanceCalculatorController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        appBar: calculatorAppBar(
            context,
            AppLocalizations.of("Refinance") +
                " " +
                AppLocalizations.of("Calculators")),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                CustomHeader(
                  header: AppLocalizations.of("Current") +
                      " " +
                      AppLocalizations.of("Loan") +
                      " " +
                      AppLocalizations.of("Amount"),
                ),
                CustomTextField(
                  prefix: _dollarPrefix(),
                  controller: controller.home_price_TextController,
                  hintText: AppLocalizations.of("Enter Amount"),
                  onChanged: (val) {
                    controller.new_cal_c(isChangeFrom: "home_price");
                  },
                ),
                Row(
                  children: [
                    CustomHeader(
                      header: AppLocalizations.of("Current") +
                          " " +
                          AppLocalizations.of("Term"),
                    ),
                    _infoButton(() {})
                  ],
                ),
                CustomTextField(
                  controller: controller.months_pay_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Amount"),
                  onChanged: (val) {
                    controller.new_cal_c();
                  },
                  suffix: _textCard(AppLocalizations.of("Month").toLowerCase()),
                ),
                CustomHeader(
                  header: AppLocalizations.of("Interest") +
                      " " +
                      AppLocalizations.of("Rate"),
                ),
                CustomTextField(
                  controller: controller.ir_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Rate"),
                  onChanged: (val) {
                    controller.new_cal_c();
                  },
                  suffix: _percentageSuffix(),
                ),
                CustomHeader(
                  header: AppLocalizations.of("Origination") +
                      " " +
                      AppLocalizations.of("Year"),
                ),
                CustomTextField(
                  controller: controller.originated_year_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Year"),
                  onChanged: (val) {
                    controller.new_cal_c(isChangeFrom: "home_price");
                  },
                ),
                CustomHeader(
                  header: AppLocalizations.of("New") +
                      " " +
                      AppLocalizations.of("Loan") +
                      " " +
                      AppLocalizations.of("Amount"),
                ),
                CustomTextField(
                  prefix: _dollarPrefix(),
                  controller: controller.new_loanamt_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Amount"),
                  onChanged: (val) {
                    controller.new_cal_c(isChangeFrom: "home_price");
                  },
                ),
                CustomHeader(
                  header: AppLocalizations.of("New") +
                      " " +
                      AppLocalizations.of("Interest") +
                      " " +
                      AppLocalizations.of("Rate"),
                ),
                CustomTextField(
                  suffix: _percentageSuffix(),
                  controller: controller.new_ir_rate_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Rate"),
                  onChanged: (val) {
                    controller.new_cal_c();
                  },
                ),
                Row(
                  children: [
                    CustomHeader(
                      header: AppLocalizations.of("New") +
                          " " +
                          AppLocalizations.of("Term"),
                    ),
                    _infoButton(() {})
                  ],
                ),
                CustomTextField(
                  suffix: _textCard(AppLocalizations.of("months")),
                  controller: controller.new_months_pay_TextController,
                  hintText: AppLocalizations.of("Enter Term"),
                  onChanged: (val) {
                    controller.new_cal_c();
                  },
                ),
                CustomHeader(
                  header: AppLocalizations.of("Refinance") +
                      " " +
                      AppLocalizations.of("Payment"),
                ),
                CustomTextField(
                  prefix: _dollarPrefix(),
                  controller: controller.ref_fees_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Payment"),
                  onChanged: (val) {
                    controller.new_cal_c(isChangeFrom: "home_price");
                  },
                ),
                CustomHeader(
                  header: AppLocalizations.of("Cash") +
                      " " +
                      AppLocalizations.of("Out"),
                ),
                CustomTextField(
                  prefix: _dollarPrefix(),
                  controller: controller.cashout_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Amount"),
                  onChanged: (val) {
                    controller.new_cal_c(isChangeFrom: "home_price");
                  },
                ),
                Row(
                  children: [
                    Checkbox(
                        value: controller.roll_fees,
                        fillColor:
                            MaterialStateProperty.all(hotPropertiesThemeColor),
                        onChanged: controller.changeRollFees),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        AppLocalizations.of("Roll fees into new loan"),
                        style: TextStyle(
                            fontSize: 14.5, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                _control()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HorizontalBarChart extends StatelessWidget {
  final List<charts.Series>? seriesList;
  final bool? animate;

  HorizontalBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory HorizontalBarChart.withSampleData() {
    return new HorizontalBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new charts.BarChart(
      seriesList as List<charts.Series<dynamic, String>>,
      animate: animate,
      vertical: false,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool? animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData() {
    return new SimpleTimeSeriesChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList as List<charts.Series<dynamic, DateTime>>,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
