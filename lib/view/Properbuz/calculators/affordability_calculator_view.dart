import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/AffordabilityCalculatorController.dart';
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

import 'mortgage_calculator_view.dart';

class AffordabilityCalculatorView
    extends GetView<AffordabilityCalculatorController> {
  const AffordabilityCalculatorView({Key? key}) : super(key: key);

  static final TextEditingController textEditingController =
      TextEditingController();

  Widget _title() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          AppLocalizations.of(
              "Use this calculator to determine how much house you can afford. By entering details about your income, down payment, and monthly debts, you can estimate the mortgage amount that works with your budget."),
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

  Widget _infoButton2(VoidCallback onTap) {
    return IconButton(
        padding: EdgeInsets.only(left: 5, top: 10, bottom: 10, right: 5),
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
        () => Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: MaterialSegmentedControl(
                horizontalPadding: EdgeInsets.symmetric(horizontal: 0),
                children: {
                  0: _tabCard(
                      AppLocalizations.of("Home") +
                          " " +
                          AppLocalizations.of("Price"),
                      // AppLocalizations.of(
                      //   "Breakdown",
                      // ),
                      0),
                  1: _tabCard(
                      AppLocalizations.of("Payment"),
                      // AppLocalizations.of(
                      //   "Schedule",
                      // ),
                      1),
                  2: _tabCard(
                      AppLocalizations.of(
                        AppLocalizations.of("Report"),
                      ),
                      2),
                },
                selectionIndex: controller.mortgageIndex.value,
                borderColor: hotPropertiesThemeColor,
                selectedColor: hotPropertiesThemeColor,
                unselectedColor: Colors.white,
                borderRadius: 5.0,
                onSegmentChosen: (int index) {
                  controller.changeMortgageIndex(index!);
                },
              ),
            ),
            if (controller.mortgageIndex == 0.obs) _homeprice(),
            if (controller.mortgageIndex == 1.obs)
              PieChartSample2(
                chartdata: controller.pieChartData,
              ),
            if (controller.mortgageIndex == 2.obs) _fullReport(),
          ],
        ),
      ),
    );
  }

  Widget _homeprice() {
    return GetBuilder<AffordabilityCalculatorController>(
      // no need to initialize Controller ever again, just mention the type
      builder: (value) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of("You can afford a house up to"),
              style: TextStyle(
                  fontSize: 14, color: greyColor, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Text(
              "\$${controller.house_cost}",
              style: TextStyle(
                  fontSize: 22, color: greyColor, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                text: controller.score_msg_start,
                children: [
                  TextSpan(
                    text: controller.score_msg_color,
                    style: TextStyle(
                        fontSize: 10,
                        color: controller.score_msg_text_color,
                        fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: controller.score_msg_end,
                  ),
                ],
              ),
              style: TextStyle(
                  fontSize: 10, color: greyColor, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                    child: Icon(Icons.savings, size: value.pigSize),
                  ),
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                    child: Icon(Icons.home, size: value.homeSize),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            SliderTheme(
              data: SliderThemeData().copyWith(
                activeTrackColor: Colors.red[700],
                inactiveTrackColor: Colors.red[100],
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                thumbColor: Colors.redAccent,
                overlayColor: Colors.red.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.red[700],
                inactiveTickMarkColor: Colors.red[100],
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Colors.redAccent,
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              child: Slider(
                value: value.sliderValue,
                min: 0,
                max: 43,
                divisions: 43,
                label: '${value.sliderValue.toStringAsFixed(0)}',
                onChanged: value.changeSliderValue,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _fullReport() {
    var _chart_data = '''{
    chart: {
        type: 'area'
    },
    title: {
        text: 'Principal vs. interest'
    },
    
    accessibility: {
        point: {
            valueDescriptionFormat: '{index}. {point.category}, {point.y:,.0f} millions, {point.percentage:.1f}%.'
        }
    },
    xAxis: {
        // categories: ['1750', '1800', '1850', '1900', '1950', '1999', '2050'],
        tickmarkPlacement: 'on',
        title: {
            enabled: false
        }
    },
    yAxis: {
        labels: {
            format: '{value}%'
        },
        title: {
            enabled: false
        }
    },
    tooltip: {
        pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.percentage:.1f}%</b> ({point.y:,.0f} millions)<br/>',
        split: true
    },
    plotOptions: {
        area: {
            stacking: 'percent',
            lineColor: '#ffffff',
            lineWidth: 1,
            marker: {
                lineWidth: 1,
                lineColor: '#ffffff'
            }
        }
    },
    series: [{
        name: 'Principal',
        data: [''' +
        List.generate(80, (i) => 80 - i).toList().join(', ') +
        ''']
    }, {
        name: 'interest',
        data: [''' +
        List.generate(80, (i) => i + 20).toList().join(', ') +
        ''']
    }]
}''';

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
                    AppLocalizations.of('You can afford'),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '\$${controller.house_cost}',
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
                    AppLocalizations.of('Annual').toUpperCase() +
                        " " +
                        AppLocalizations.of('Income').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${controller.annual_income_TextController.text}',
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
                    AppLocalizations.of('Down').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('Payment').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${controller.dp_TextController.text}',
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
                    AppLocalizations.of('Monthly').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('Debts').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${controller.md_TextController.text}',
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
                    AppLocalizations.of("Debt-to-Income").toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${controller.dti_TextController.text}%',
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
                    AppLocalizations.of('Loan').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('term').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${controller.lt_TextController.text} ' +
                        AppLocalizations.of('Month').toLowerCase(),
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
                    AppLocalizations.of('Taxes').toUpperCase() +
                        ' & ' +
                        AppLocalizations.of('Insurance').toUpperCase() +
                        AppLocalizations.of('Included').toUpperCase() +
                        '?',
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    (controller.iti ?? false)
                        ? AppLocalizations.of('Yes')
                        : AppLocalizations.of('No'),
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
                    AppLocalizations.of('Property').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('Tax').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${controller.pt_TextController.text}%/yr',
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
                    AppLocalizations.of('Homeowner').toUpperCase() +
                        '\'S ' +
                        AppLocalizations.of('Insurance').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${controller.hi_TextController.text}/yr',
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
                    AppLocalizations.of('Mortgage').toUpperCase() +
                        ' ' +
                        AppLocalizations.of('Insurance').toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${controller.mortgageInsurance}/mo',
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
                    AppLocalizations.of('HOA') +
                        ' ' +
                        AppLocalizations.of('Dues'),
                    style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${controller.hoa_TextController.text}/mo',
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of('Monthly').toUpperCase() +
                    ' ' +
                    AppLocalizations.of('Budget').toUpperCase(),
                style: TextStyle(
                    fontSize: 14,
                    color: greyColor,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: greyColor.withOpacity(.5), width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: PieChartSample2(
                          chartdata: controller.pieChartDataMonth,
                        ),
                      ),
                      Positioned.fill(
                          child: Center(
                        child: Text(AppLocalizations.of("Monthly") +
                            " " +
                            AppLocalizations.of("income") +
                            " \n${controller.monthly_income}"),
                      ))
                    ],
                  ),
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
                AppLocalizations.of('Payment') +
                    " " +
                    AppLocalizations.of('Breakdown'),
                style: TextStyle(
                    fontSize: 14,
                    color: greyColor,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: greyColor.withOpacity(.5), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: PieChartSample2(
                    chartdata: controller.pieChartDataBreakDown,
                  )),
                ),
              )
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
                width: double.infinity,
                height: 450,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: greyColor.withOpacity(.5), width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: HighCharts(
                  key: ValueKey(DateTime.now()),
                  data: controller.scheduleChartData,
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
                    AppLocalizations.of('interest'),
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
                  data: controller.irPrChartData,
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
    Get.put(AffordabilityCalculatorController());
    return GetBuilder<AffordabilityCalculatorController>(
      // no need to initialize Controller ever again, just mention the type
      builder: (value) => Scaffold(
        backgroundColor: Colors.white,
        appBar: calculatorAppBar(
            context,
            AppLocalizations.of("Affordability") +
                " " +
                AppLocalizations.of("Calculators")),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                CustomHeader(
                  header: AppLocalizations.of("Annual") +
                      " " +
                      AppLocalizations.of("Income"),
                ),
                CustomTextField(
                  prefix: _dollarPrefix(),
                  controller: controller.annual_income_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Amount"),
                  onChanged: (val) {
                    controller.calc_amt();
                  },
                ),
                CustomHeader(
                  header: AppLocalizations.of("Monthly") +
                      " " +
                      AppLocalizations.of("Debts"),
                ),
                CustomTextField(
                  prefix: _dollarPrefix(),
                  controller: controller.md_TextController,
                  hintText: AppLocalizations.of("Enter Amount"),
                  onChanged: (val) {
                    controller.calc_amt();
                  },
                ),
                CustomHeader(
                  header: AppLocalizations.of("Down") +
                      " " +
                      AppLocalizations.of("Payment"),
                ),
                CustomTextField(
                  prefix: _dollarPrefix(),
                  controller: controller.dp_TextController,
                  hintText: AppLocalizations.of("Enter Amount"),
                  onChanged: (val) {
                    controller.calc_amt();
                  },
                ),
                Row(
                  children: [
                    CustomHeader(
                      header: AppLocalizations.of("Debt-to-Income"),
                    ),
                    _infoButton(() {})
                  ],
                ),
                CustomTextField(
                  prefix: _dollarPrefix(),
                  controller: controller.dti_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Rate"),
                  onChanged: (val) {
                    controller.calc_amt();
                  },
                ),
                CustomHeader(
                  header: AppLocalizations.of("Interest") +
                      " " +
                      AppLocalizations.of("Rate"),
                ),
                CustomTextField(
                  suffix: _percentageSuffix(),
                  controller: controller.ir_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Rate"),
                  onChanged: (val) {
                    controller.calc_amt();
                  },
                ),
                Row(
                  children: [
                    CustomHeader(
                      header: AppLocalizations.of("Loan") +
                          " " +
                          AppLocalizations.of("Term"),
                    ),
                    _infoButton(() {})
                  ],
                ),
                CustomTextField(
                  suffix: _textCard(AppLocalizations.of("Month").toLowerCase()),
                  controller: controller.lt_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Term"),
                  onChanged: (val) {
                    controller.calc_amt();
                  },
                ),
                Row(
                  children: [
                    Checkbox(
                        value: controller.iti,
                        fillColor:
                            MaterialStateProperty.all(hotPropertiesThemeColor),
                        onChanged: controller.changeIti),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        AppLocalizations.of("Include") +
                            " " +
                            AppLocalizations.of("Taxes"),
                        style: TextStyle(
                            fontSize: 14.5, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _infoButton2(() {})
                  ],
                ),
                Row(
                  children: [
                    CustomHeader(
                      header: AppLocalizations.of("Property") +
                          " " +
                          AppLocalizations.of("Tax"),
                    ),
                    _infoButton(() {})
                  ],
                ),
                CustomTextField(
                  suffix: _percentageSuffix(),
                  controller: controller.pt_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Amount"),
                  onChanged: (val) {
                    controller.calc_amt();
                  },
                ),
                Row(
                  children: [
                    CustomHeader(
                      header: AppLocalizations.of("Home") +
                          " " +
                          AppLocalizations.of("Insurance"),
                    ),
                    _infoButton(() {})
                  ],
                ),
                CustomTextField(
                  prefix: _dollarPrefix(),
                  suffix: _textCard(AppLocalizations.of("/") +
                      AppLocalizations.of("Year").toLowerCase()),
                  controller: controller.hi_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Amount"),
                  onChanged: (val) {
                    controller.calc_amt();
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: controller.ipmi,
                        fillColor:
                            MaterialStateProperty.all(hotPropertiesThemeColor),
                        onChanged: controller.changeIpmi),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        AppLocalizations.of("Include") +
                            " " +
                            AppLocalizations.of("PMI"),
                        style: TextStyle(
                            fontSize: 14.5, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _infoButton2(() {})
                  ],
                ),
                Row(
                  children: [
                    CustomHeader(
                      header: AppLocalizations.of("HOA") +
                          " " +
                          AppLocalizations.of("Dues"),
                    ),
                    _infoButton(() {})
                  ],
                ),
                CustomTextField(
                  prefix: _dollarPrefix(),
                  suffix: _textCard(AppLocalizations.of("/") +
                      AppLocalizations.of("Month").toLowerCase()),
                  controller: controller.hoa_TextController,
                  hintText: AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Amount"),
                  onChanged: (val) {
                    controller.calc_amt();
                  },
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
