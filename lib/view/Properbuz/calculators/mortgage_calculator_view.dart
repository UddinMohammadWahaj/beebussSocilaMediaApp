import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/calculator_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/calculator_appbar.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/custom_header.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/custom_textfield.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:high_chart/high_chart.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:sizer/sizer.dart';

class MortgageCalculatorView extends GetView<CalculatorController> {
  MortgageCalculatorView({Key? key}) : super(key: key);

  static final TextEditingController textEditingController =
      TextEditingController();

  Widget _title() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          AppLocalizations.of(
              "Use our home loan calculator to estimate your mortgage payment, with taxes and insurance. Simply enter the price of the home, your down payment, and details about the home loan to calculate your mortgage payment breakdown, schedule, and more."),
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
                0: _tabCard(AppLocalizations.of("Breakdown"), 0),
                1: _tabCard(AppLocalizations.of("Schedule"), 1),
                2: _tabCard(AppLocalizations.of("Report"), 2),
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
            PieChartSample2(
              chartdata: controller.pieChartData,
            ),
          if (controller.mortgageIndex == 1.obs)
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
          if (controller.mortgageIndex == 2.obs) _fullReport()
        ],
      ),
    );
  }

  Widget _fullReport() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
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
                      AppLocalizations.of('Estimated').toUpperCase() +
                          ' ' +
                          AppLocalizations.of('Payment').toUpperCase(),
                      style: TextStyle(
                          fontSize: 14,
                          color: greyColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '\$1,505 /mo',
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
                          ' ' +
                          AppLocalizations.of('Amount').toUpperCase(),
                      style: TextStyle(
                          fontSize: 14,
                          color: greyColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$240,000',
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
                      '\$60,000',
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
                      '4.435%',
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
                          AppLocalizations.of('Duration').toUpperCase(),
                      style: TextStyle(
                          fontSize: 14,
                          color: greyColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '30 ' + AppLocalizations.of('years'),
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
                      AppLocalizations.of('Taxe').toUpperCase() +
                          ' & ' +
                          AppLocalizations.of('Insurance').toUpperCase() +
                          ' ' +
                          AppLocalizations.of('Included').toUpperCase() +
                          '?',
                      style: TextStyle(
                          fontSize: 14,
                          color: greyColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      AppLocalizations.of('Yes'),
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
                          AppLocalizations.of('Taxes').toUpperCase(),
                      style: TextStyle(
                          fontSize: 14,
                          color: greyColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '0.77%/yr',
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
                      AppLocalizations.of('Homeowner\'s').toUpperCase() +
                          ' ' +
                          AppLocalizations.of('Insurance').toUpperCase(),
                      style: TextStyle(
                          fontSize: 14,
                          color: greyColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '1,260/yr',
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
                      '0/mo',
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
                      AppLocalizations.of('HOA').toUpperCase() +
                          ' ' +
                          AppLocalizations.of('Dues').toUpperCase(),
                      style: TextStyle(
                          fontSize: 14,
                          color: greyColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '0/mo',
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
                const SizedBox(width: double.infinity),
                Text(
                  AppLocalizations.of('More') +
                      ' ' +
                      AppLocalizations.of('Calculators'),
                  style: TextStyle(
                      fontSize: 14,
                      color: greyColor,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 15),
                Text(
                  AppLocalizations.of('Affordability') +
                      ' ' +
                      AppLocalizations.of('Calculators'),
                  style: TextStyle(
                      fontSize: 14,
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Text(
                  AppLocalizations.of('Amortization') +
                      ' ' +
                      AppLocalizations.of('Calculators'),
                  style: TextStyle(
                      fontSize: 14,
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Text(
                  AppLocalizations.of('Debt-to-Income') +
                      ' ' +
                      AppLocalizations.of('Calculators'),
                  style: TextStyle(
                      fontSize: 14,
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Text(
                  AppLocalizations.of('Mortgage') +
                      ' ' +
                      AppLocalizations.of('Calculators'),
                  style: TextStyle(
                      fontSize: 14,
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Text(
                  AppLocalizations.of('Refinance') +
                      ' ' +
                      AppLocalizations.of('Calculators'),
                  style: TextStyle(
                      fontSize: 14,
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of('Payment Breakdown'),
                  style: TextStyle(
                      fontSize: 14,
                      color: greyColor,
                      fontWeight: FontWeight.w600),
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
                        chartdata: controller.pieChartData,
                      ),
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
                      ' ' +
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
                      border: Border.all(
                          color: greyColor.withOpacity(.5), width: 1),
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
                            AppLocalizations.of('Month'),
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of('Amount'),
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of('INTEREST'),
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of('PRINCIPAL'),
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of('BALANCE'),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CalculatorController());
    return GetBuilder<CalculatorController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        appBar: calculatorAppBar(
            context,
            AppLocalizations.of("Mortgage") +
                " " +
                AppLocalizations.of("Calculators")),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                CustomHeader(
                  header: AppLocalizations.of("Home") +
                      " " +
                      AppLocalizations.of("Price"),
                ),
                CustomTextField(
                  prefix: _dollarPrefix(),
                  controller: controller.annual_income_TextController,
                  hintText: AppLocalizations.of("Enter Amount"),
                  onChanged: (val) {
                    controller.new_cal_c(isChangeFrom: "home_price");
                  },
                ),
                CustomHeader(
                  header: AppLocalizations.of("Down") +
                      " " +
                      AppLocalizations.of("Payment"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      width: 70.0.w,
                      padding: 20,
                      prefix: _dollarPrefix(),
                      controller: controller.dp_TextController,
                      hintText: AppLocalizations.of("Enter Amount"),
                      onChanged: (val) {
                        controller.new_cal_c(isChangeFrom: "dp");
                      },
                    ),
                    CustomTextField(
                      width: 30.0.w,
                      padding: 20,
                      suffix: _percentageSuffix(),
                      controller:
                          controller.down_payment_percent_TextController,
                      hintText: AppLocalizations.of("Na"),
                      onChanged: (val) {
                        controller.new_cal_c(
                            isChangeFrom: "down_payment_percent");
                      },
                    ),
                  ],
                ),
                CustomHeader(
                  header: AppLocalizations.of("Loan") +
                      " " +
                      AppLocalizations.of("Program"),
                ),
                CustomDropdownField(
                  padding: 20,
                  dropDownItems: [
                    {"name": "30 Year Fixed", "val": 360},
                    {"name": "15 Year Fixed", "val": 180},
                    {"name": "5/1 ARM", "val": 361},
                  ],
                  value: controller.months_pay,
                  onChanged: (val) {
                    controller.months_pay = val;
                    controller.new_cal_c(isChangeFrom: "loan_program");
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
                  hintText: AppLocalizations.of("Enter Rate"),
                  onChanged: (val) {
                    controller.new_cal_c(isChangeFrom: "dp");
                  },
                ),
                Row(
                  children: [
                    Checkbox(
                        value: controller.ipmi,
                        fillColor:
                            MaterialStateProperty.all(hotPropertiesThemeColor),
                        onChanged: controller.changeIPMI!),
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
                    _infoButton(() {})
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: controller.iti,
                        fillColor:
                            MaterialStateProperty.all(hotPropertiesThemeColor),
                        onChanged: controller.changeITI),
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
                    _infoButton(() {})
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomHeader(
                      header: AppLocalizations.of("Property") +
                          " " +
                          AppLocalizations.of("Tax"),
                    ),
                    _infoButton(() {})
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      width: 70.0.w,
                      padding: 20,
                      prefix: _dollarPrefix(),
                      controller:
                          controller.propertytax_percent_val_TextController,
                      hintText: AppLocalizations.of("Enter Amount"),
                      suffix: _textCard(AppLocalizations.of("/year")),
                      onChanged: (val) {
                        controller.new_cal_c(
                            isChangeFrom: "propertytax_percent");
                      },
                    ),
                    CustomTextField(
                      width: 30.0.w,
                      padding: 20,
                      suffix: _percentageSuffix(),
                      controller: controller.property_tax_TextController,
                      hintText: AppLocalizations.of("NaN"),
                      onChanged: (val) {
                        controller.new_cal_c(isChangeFrom: "property_tax");
                      },
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  width: 100.0.w,
                  prefix: _dollarPrefix(),
                  controller: controller.hi_TextController,
                  hintText: AppLocalizations.of("Enter Amount"),
                  suffix: _textCard(AppLocalizations.of("/") +
                      AppLocalizations.of("Year").toLowerCase()),
                  onChanged: (val) {
                    controller.new_cal_c(isChangeFrom: "home_insurance");
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  width: 100.0.w,
                  prefix: _dollarPrefix(),
                  controller: controller.hoa_TextController,
                  hintText: AppLocalizations.of("Enter Amount"),
                  suffix: _textCard(AppLocalizations.of("/") +
                      AppLocalizations.of("Month").toLowerCase()),
                  onChanged: (val) {
                    controller.new_cal_c(isChangeFrom: "HOA");
                  },
                ),
                _control(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PieChartSample2 extends StatefulWidget {
  final List<PieChartSectionData> chartdata;
  const PieChartSample2({Key? key, required this.chartdata}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State(chartdata);
}

class PieChart2State extends State<StatefulWidget> {
  int touchedIndex = -1;
  List<PieChartSectionData> chartdata;
  PieChart2State(this.chartdata);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                    setState(() {
                      if (pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 60,
                  sections: chartdata,
                ),
              ),
            ),
          ),
          // Column(
          //   mainAxisSize: MainAxisSize.max,
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     Indicator(
          //       color: Colors.blue.shade600,
          //       text: 'Insurance',
          //       isSquare: true,
          //     ),
          //     SizedBox(
          //       height: 4,
          //     ),
          //     Indicator(
          //       color: Colors.blue.shade400,
          //       text: 'Second',
          //       isSquare: true,
          //     ),
          //     SizedBox(
          //       height: 4,
          //     ),
          //     Indicator(
          //       color: Colors.blue.shade200,
          //       text: 'P&I',
          //       isSquare: true,
          //     ),
          //     SizedBox(
          //       height: 4,
          //     ),
          //     SizedBox(
          //       height: 18,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 22.0 : 16.0;
      final radius = isTouched ? 40.0 : 30.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue.shade200,
            value: 105,
            title: AppLocalizations.of('Insurance') + ' \$105',
            titlePositionPercentageOffset: 1.5,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.blue.shade400,
            value: 193,
            title: AppLocalizations.of('Taxes') + '\$193',
            radius: radius,
            titlePositionPercentageOffset: 1.5,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.blue.shade600,
            value: 1207,
            title: AppLocalizations.of('P&I') + ' \$1,207',
            radius: radius,
            titlePositionPercentageOffset: 1.5,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
          );

        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          AppLocalizations.of(text),
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}

class LineChart1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: bottomTitles,
        leftTitles: leftTitles(
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1k';
              case 2:
                return '2k';
              case 3:
                return '3k';
              case 4:
                return '5k';
            }
            return '';
          },
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  SideTitles leftTitles({required GetTitleFunction? getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 8,
        reservedSize: 30,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 22,
        margin: 10,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return '2m';
            case 7:
              return '7m';
            case 12:
              return '12m';
          }
          return '';
        },
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        colors: [const Color(0xff4af699)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, 0.28),
          FlSpot(6, 0.28 * 6),
          FlSpot(10, 0.28 * 11),
          FlSpot(14, 0.28 * 12),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        colors: [const Color(0xffaa4cfc)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false, colors: [
          const Color(0x00aa4cfc),
        ]),
        spots: [
          FlSpot(1, 0.28 * 14),
          FlSpot(8, 0.28 * 9),
          FlSpot(14, 0.28),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        colors: const [Color(0xff27b6fc)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, 0.28),
          FlSpot(8, 0.28 * 5),
          FlSpot(14, 0.28 * 14),
        ],
      );
}
