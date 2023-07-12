import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/DebtToIncomeCalculatorController.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/calculator_appbar.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/custom_header.dart';
import 'package:bizbultest/widgets/Properbuz/calculator/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:sizer/sizer.dart';

class DebtToIncomeCalculatorView
    extends GetView<DebtToIncomeCalculatorController> {
  DebtToIncomeCalculatorView({Key? key}) : super(key: key);

  static final TextEditingController textEditingController =
      TextEditingController();

  Color silderColor = Color.fromARGB(255, 238, 38, 38);

  Widget _title() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          AppLocalizations.of(
              "Use this calculator to estimate your debt-to-income ratio and determine if you are likely eligible for a mortgage."),
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
            controller.changeMortgageIndex(index);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DebtToIncomeCalculatorController());
    return GetBuilder<DebtToIncomeCalculatorController>(
      // no need to initialize Controller ever again, just mention the type
      builder: (controller) {
        print("DebtToIncomeCalculatorController reload");
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: calculatorAppBar(
              context,
              AppLocalizations.of("Debt-to-Income") +
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
                    onChanged: (val) {
                      controller.calc_dti();
                    },
                    hintText: AppLocalizations.of("Enter") +
                        " " +
                        AppLocalizations.of("Amount"),
                  ),
                  CustomHeader(
                    header: AppLocalizations.of("Minimum") +
                        " " +
                        AppLocalizations.of("Credit") +
                        " " +
                        AppLocalizations.of("Card") +
                        " " +
                        AppLocalizations.of("Payment"),
                  ),
                  CustomTextField(
                    prefix: _dollarPrefix(),
                    suffix: _textCard("/mo"),
                    controller: controller.mccp_TextController,
                    onChanged: (val) {
                      controller.calc_dti();
                    },
                    hintText: AppLocalizations.of("Enter") +
                        " " +
                        AppLocalizations.of("Amount"),
                  ),
                  CustomHeader(
                    header: AppLocalizations.of("Car") +
                        " " +
                        AppLocalizations.of("Loan") +
                        " " +
                        AppLocalizations.of("Payment"),
                  ),
                  CustomTextField(
                    prefix: _dollarPrefix(),
                    suffix: _textCard("/mo"),
                    controller: controller.clp_TextController,
                    onChanged: (val) {
                      controller.calc_dti();
                    },
                    hintText: AppLocalizations.of("Enter") +
                        AppLocalizations.of("Amount"),
                  ),
                  CustomHeader(
                    header: AppLocalizations.of("Student") +
                        " " +
                        AppLocalizations.of("Loan") +
                        " " +
                        AppLocalizations.of("Payment"),
                  ),
                  CustomTextField(
                    prefix: _dollarPrefix(),
                    suffix: _textCard("/mo"),
                    controller: controller.slp_TextController,
                    onChanged: (val) {
                      controller.calc_dti();
                    },
                    hintText: AppLocalizations.of("Enter") +
                        AppLocalizations.of("Amount"),
                  ),
                  CustomHeader(
                    header: AppLocalizations.of("Alimony") +
                        " / " +
                        AppLocalizations.of("Child") +
                        " " +
                        AppLocalizations.of("Support") +
                        " " +
                        AppLocalizations.of("Payments"),
                  ),
                  CustomTextField(
                    prefix: _dollarPrefix(),
                    suffix: _textCard("/mo"),
                    controller: controller.csp_TextController,
                    onChanged: (val) {
                      controller.calc_dti();
                    },
                    hintText: AppLocalizations.of("Enter") +
                        AppLocalizations.of("Amount"),
                  ),
                  Row(
                    children: [
                      CustomHeader(
                        header: AppLocalizations.of("Secondary") +
                            " " +
                            AppLocalizations.of("Home") +
                            " " +
                            AppLocalizations.of("Expenses"),
                      ),
                      _infoButton(() {})
                    ],
                  ),
                  CustomTextField(
                    prefix: _dollarPrefix(),
                    suffix: _textCard("/mo"),
                    controller: controller.she_TextController,
                    onChanged: (val) {
                      controller.calc_dti();
                    },
                    hintText: AppLocalizations.of("Enter") +
                        " " +
                        AppLocalizations.of("Amount"),
                  ),
                  Row(
                    children: [
                      CustomHeader(
                        header: AppLocalizations.of("Other") +
                            " " +
                            AppLocalizations.of("Loan") +
                            " " +
                            AppLocalizations.of("or") +
                            " " +
                            AppLocalizations.of("Debt") +
                            " " +
                            AppLocalizations.of("Payment"),
                      ),
                      _infoButton(() {})
                    ],
                  ),
                  CustomTextField(
                    prefix: _dollarPrefix(),
                    suffix: _textCard("/mo"),
                    controller: controller.oldp_TextController,
                    onChanged: (val) {
                      controller.calc_dti();
                    },
                    hintText: AppLocalizations.of("Enter") +
                        " " +
                        AppLocalizations.of("Amount"),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of("Debt-to-Income") +
                                " " +
                                AppLocalizations.of("Ratio"),
                            style: TextStyle(
                                fontSize: 20,
                                color: greyColor,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "${controller.score_dti_percent}%",
                            // "${controller.sliderValue.toStringAsFixed(0)}%",
                            style: TextStyle(
                                fontSize: 30,
                                color: controller.score_dti_percent < 50
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              text: controller.score_msg_main,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: greyColor,
                                  fontWeight: FontWeight.w600),
                              children: [
                                TextSpan(
                                  text: controller.score_msg_dec,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: greyColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          SliderTheme(
                            data: SliderThemeData().copyWith(
                              activeTrackColor: silderColor,
                              inactiveTrackColor: silderColor.withOpacity(.3),
                              trackShape: CustomTrackShape(),
                              trackHeight: 4.0,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 12.0),
                              thumbColor: silderColor,
                              overlayColor: silderColor.withAlpha(32),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 28.0),
                              tickMarkShape: RoundSliderTickMarkShape(),
                              activeTickMarkColor: silderColor.withOpacity(.7),
                              inactiveTickMarkColor:
                                  silderColor.withOpacity(.3),
                              valueIndicatorShape:
                                  PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor: silderColor.withOpacity(.5),
                              valueIndicatorTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            child: SizedBox(
                              width: 100.w,
                              child: LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  return Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: settingsColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(24),
                                            bottomLeft: Radius.circular(24),
                                          ),
                                        ),
                                        width: controller.tmd_color >= 1
                                            ? 90.w
                                            : constraints.minWidth *
                                                controller.tmd_color,
                                        height: 6,
                                      ),
                                      Expanded(
                                        child: Slider(
                                          value: controller.sliderValue,
                                          min: controller.sliderValue_min,
                                          max: controller.sliderValue_max,
                                          // divisions: 100,
                                          label:
                                              '${controller.sliderValue.toStringAsFixed(0)}',
                                          onChanged:
                                              controller.changeSliderValue,
                                          // onChanged: (_) {},
                                          onChangeEnd:
                                              controller.changedSliderValue,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(AppLocalizations.of("Total") +
                                  " " +
                                  AppLocalizations.of("monthly") +
                                  " " +
                                  AppLocalizations.of("debts")),
                              Spacer(),
                              Text("\$${controller.tmd}"),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(AppLocalizations.of("Mortgage") +
                                  " " +
                                  AppLocalizations.of("Payment")),
                              Spacer(),
                              Text("\$${controller.mp}"),
                              // "\$${((4833 / 100) * value.sliderValue).toStringAsFixed(0)}"),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(AppLocalizations.of("Remaining") +
                                  " " +
                                  AppLocalizations.of("Month") +
                                  " " +
                                  AppLocalizations.of("Income")),
                              Spacer(),
                              Text("\$${controller.rmi}"),
                              // "\$${(4833 - ((4833 / 100) * value.sliderValue)).toStringAsFixed(0)}"),
                            ],
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
