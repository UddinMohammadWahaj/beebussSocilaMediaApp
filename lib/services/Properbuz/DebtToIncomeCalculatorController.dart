import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebtToIncomeCalculatorController extends GetxController {
  var mortgageIndex = 0.obs;

  void changeMortgageIndex(int index) {
    mortgageIndex.value = index;
    update();
  }

  double sliderValue = 50.0;
  double sliderValue_min = 0.0;
  double sliderValue_max = 100.0;

  double tmd = 0.0;
  num mp = 0.0;
  num rmi = 0.0;
  num tmd_color = 0.0;
  void changeSliderValue(double index) {
    sliderValue = index;
    print(sliderValue);
    var monthly_income = double.parse(annual_income_TextController.text) / 12;
    var tmd_val = tmd;
    var mp_val = mp;
    var rmi_val = rmi;
    mp_val = sliderValue - tmd_val;
    rmi_val = monthly_income - sliderValue;
    mp = mp_val.round();
    rmi = rmi_val.round();
    var dti_percent = (((monthly_income - rmi_val) / monthly_income) * 100);
    show_dti(dti_percent);
    slide_to(sliderValue.round());
    update();
  }

  changedSliderValue(double index) {
    sliderValue = index;
    print(sliderValue);
    // calc_dti();
  }

  TextEditingController annual_income_TextController =
      TextEditingController(text: "70000");
  TextEditingController mccp_TextController =
      TextEditingController(text: "200");
  TextEditingController clp_TextController = TextEditingController(text: "500");
  TextEditingController slp_TextController = TextEditingController(text: "300");
  TextEditingController csp_TextController = TextEditingController(text: "0");
  TextEditingController she_TextController = TextEditingController(text: "0");
  TextEditingController oldp_TextController = TextEditingController(text: "0");

  var score_msg_main = "Your DTI is over the limit.";
  var score_msg_dec =
      "In most cases, 50% is the highest debt-to-income that lenders will allow. Paying down debt or increasing your income can improve your DTI ratio.";
  var score_dti_percent = 0;

  void calc_dti() {
    var dti_percent = 36.00;
    var slab1 = 0;
    var slab2 = 0;
    var monthly_pay = 0.0;
    var annual_income = double.parse(annual_income_TextController.text);
    var monthly_income = (annual_income / 12).round();
    slab1 = ((monthly_income / 100) * 36).round();
    slab2 = ((monthly_income / 100) * 50).round();
    var mccp = double.parse(mccp_TextController.text);
    var clp = double.parse(clp_TextController.text);
    var slp = double.parse(slp_TextController.text);
    var csp = double.parse(csp_TextController.text);
    var she = double.parse(she_TextController.text);
    var oldp = double.parse(oldp_TextController.text);

    var debt_total = mccp + clp + slp + csp + she + oldp;

    sliderValue_min = debt_total;
    sliderValue_max = monthly_income.toDouble();

    if (sliderValue_min > sliderValue_max) {
      sliderValue_min = sliderValue_max - 1;
    }

    tmd_color = ((debt_total / monthly_income));

    var slab_val = debt_total;
    dti_percent = ((monthly_pay / monthly_income) * 100);
    if (debt_total < slab1) {
      dti_percent = 36;
      monthly_pay = slab1.toDouble() - debt_total;
      slab_val = slab1.toDouble();
      slide_to(slab1);
    } else if ((debt_total < slab2) && (debt_total > slab1)) {
      dti_percent = 50;
      monthly_pay = slab2 - debt_total;
      slab_val = slab2.toDouble();
      slide_to(slab2);
    } else {
      monthly_pay = sliderValue;
      dti_percent = ((monthly_pay / monthly_income) * 100);
      slab_val = monthly_pay;
      slide_to(0);
    }

    tmd = debt_total;
    mp = monthly_pay;
    rmi = (monthly_income - slab_val);
    show_dti(dti_percent);
  }

  slide_to(int val) {
    var get_val_now = sliderValue;
    var get_min_now = sliderValue_min;
    var get_max_now = sliderValue_max;
    if (val < get_val_now) {
      for (var i = val; i <= get_val_now; i++) {
        sliderValue--;
        if (sliderValue < sliderValue_min || sliderValue > sliderValue_max) {
          if (sliderValue < sliderValue_min) {
            print("min");
            print(sliderValue_min);
            sliderValue = sliderValue_min;
          } else {
            print("max");
            print(sliderValue_max);
            sliderValue = sliderValue_max;
          }
        }
        // document.getElementById("slider_input").stepDown(1);
      }
    } else if (val > get_val_now.toInt()) {
      for (var i = get_val_now; i <= val; i++) {
        sliderValue++;
        if (sliderValue < sliderValue_min || sliderValue > sliderValue_max) {
          if (sliderValue < sliderValue_min) {
            print("min");
            print(sliderValue_min);
            sliderValue = sliderValue_min;
          } else {
            print("max");
            print(sliderValue_max);
            sliderValue = sliderValue_max;
          }
        }
        // document.getElementById("slider_input").stepUp(1);
      }
    }
    var percent = (((sliderValue - sliderValue_min) /
                (sliderValue_max - sliderValue_min)) *
            100)
        .ceil();
  }

  void show_dti(dti) {
    var dti_percent = (dti).round();
    if (dti_percent > 50) {
      score_msg_main = "Your DTI is over the limit.";
      score_msg_dec =
          "In most cases, 50% is the highest debt-to-income that lenders will allow. Paying down debt or increasing your income can improve your DTI ratio.";
    } else if ((dti_percent < 51) && (dti_percent > 36)) {
      score_msg_main = "Your DTI is OK.";
      score_msg_dec =
          "It is under the 50% limit, but having a DTI ratio of 36% or less is considered ideal. Paying down debt or increasing your income can help improve your DTI ratio.";
    } else if ((dti_percent > 20) && (dti_percent < 37)) {
      score_msg_main = "Your DTI is good.";
      score_msg_dec = "Having a DTI ratio of 36% or less is considered ideal.";
    } else if (dti_percent < 20) {
      score_msg_main = "Your DTI is very good.";
      score_msg_dec =
          "Having a DTI ratio of 36% or less is considered ideal, and anything under 20% is excellent.";
    } else {
      score_msg_main = "Your DTI is good.";
      score_msg_dec = " Having a DTI ratio of 36% or less is considered ideal.";
    }
    score_dti_percent = dti_percent;

    update();
  }
}
