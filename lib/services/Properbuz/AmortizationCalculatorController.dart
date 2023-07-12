import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AmortizationCalculatorController extends GetxController {
  var mortgageIndex = 0.obs;
  void changeMortgageIndex(int? index) {
    mortgageIndex.value = index!;
    update();
  }

  TextEditingController loan_amt_TextController =
      TextEditingController(text: "200000");
  var months_pay = 360;
  TextEditingController interest_TextController =
      TextEditingController(text: "4.424");
  int showBy = 1;

  var startYear = DateTime.now().year;
  var startMonth = DateTime.now().month;

  var amount = 0.0;
  var interest = 0.0;
  var graphData = '';
  var detail = [];
  var detail_less = [];
  var detail_year = [];
  var detail_year_less = [];
  check() {
    var loanamt = double.parse(loan_amt_TextController.text);
    var paymnt = months_pay;
    var rate = double.parse(interest_TextController.text);
    detail = [];
    detail_less = [];
    detail_year = [];
    detail_year_less = [];

    if (loanamt.isNaN || loanamt == 0) {
      return;
    } else if (paymnt.isNaN || paymnt == 0) {
      return;
    } else if (rate.isNaN || rate == 0) {
      return;
    } else {
      show();
    }
  }

  fixVal(value, numberOfCharacters, numberOfDecimals, padCharacter) {
    var i, stringObject, stringLength, numberToPad; // define local variables
    value = value *
        math.pow(10,
            numberOfDecimals); // shift decimal point numberOfDecimals places
    value = (value).round(); //  to the right and round to nearest integer

    stringObject =
        (value).toString(); // convert numeric value to a String object
    stringLength = stringObject.length; // get length of string
    while (stringLength < numberOfDecimals) {
      // pad with leading zeroes if necessary
      stringObject = "0" + stringObject; // add a leading zero
      stringLength = stringLength + 1; //  and increment stringLength variable
    }

    if (numberOfDecimals > 0) {
      // now insert a decimal point
      stringObject = stringObject.substring(
              0, stringLength - numberOfDecimals) +
          "." +
          stringObject.substring(stringLength - numberOfDecimals, stringLength);
    }

    if (stringObject.length < numberOfCharacters && numberOfCharacters > 0) {
      numberToPad = numberOfCharacters -
          stringObject.length; // number of leading characters to pad
      for (i = 0; i < numberToPad; i = i + 1) {
        stringObject = padCharacter + stringObject;
      }
    }

    return double.parse(stringObject).round(); // return the string object
  }

  show() {
    amount = double.parse(loan_amt_TextController.text);
    var numpay = double.parse(months_pay.toString());
    var rate = double.parse(interest_TextController.text);
    var amount_less, amount_year, amount_year_less;
    var numpay_less, numpay_year, numpay_year_less;
    var rate_less, rate_year, rate_year_less;
    amount_less = amount_year = amount_year_less = amount;
    numpay_less = numpay_year = numpay_year_less = numpay;
    rate_less = rate_year = rate_year_less = rate;

    rate = rate / 100;
    rate_less = rate_less / 100;
    rate_year = rate_year / 100;
    rate_year_less = rate_year_less / 100;
    var monthly = rate / 12;
    var payment = ((amount * monthly) / (1 - math.pow((1 + monthly), -numpay)));
    var total = payment * numpay;
    interest = total - amount;

    var monthly_less = rate_less / 12;
    var payment_less = ((amount_less * monthly_less) /
        (1 - math.pow((1 + monthly_less), -numpay_less)));
    var total_less = payment_less * numpay_less;
    var interest_less = total_less - amount_less;

    var monthly_year = rate_year / 12;
    var payment_year = ((amount_year * monthly_year) /
        (1 - math.pow((1 + monthly_year), -numpay_year)));
    var total_year = payment_year * numpay_year;
    var interest_year = total_year - amount_year;

    var monthly_year_less = rate_year_less / 12;
    var payment_year_less = ((amount_year_less * monthly_year_less) /
        (1 - math.pow((1 + monthly_year_less), -numpay_year_less)));
    var total_year_less = payment_year_less * numpay_year_less;
    var interest_year_less = total_year_less - amount_year_less;

    var newPrincipal;
    var newPrincipal_less;
    var newPrincipal_year;
    var newPrincipal_year_less;

    newPrincipal = amount;
    newPrincipal_less = amount_less;
    newPrincipal_year = amount_year;
    newPrincipal_year_less = amount_year_less;
    var newInterest_arr = [];
    var newreduction_arr = [];
    var newPrincipal_arr = [];
    var category = [];
    var newInterest_arr_less = [];
    var newreduction_arr_less = [];
    var newPrincipal_arr_less = [];
    var category_less = [];
    var newInterest_arr_year = [];
    var newreduction_arr_year = [];
    var newPrincipal_arr_year = [];
    var category_year = [];

    var newInterest_arr_year_less = [];
    var newreduction_arr_year_less = [];
    var newPrincipal_arr_year_less = [];
    var category_year_less = [];

    var year = startYear;
    var j, m;

    var i = 1;
    var k = 1;
    var l = 1;
    var n = 1;
    var month_start = startMonth;
    //console.log(numpay);
    //var
    var month_st = '';
    var year_st = '';
    var month_less = '';
    var year_less = '';
    var month_year = '';
    var year_year = '';
    var month_year_less = '';
    var year_year_less = '';

    while (i <= numpay) {
      //if (i != 0) {

      var newInterest = monthly * newPrincipal;
      var reduction = payment - newInterest;
      newPrincipal = newPrincipal - reduction;

      //newInterest=Math.round(monthly*newPrincipal);
      //reduction=Math.round(payment-newInterest);
      //newPrincipal=Math.round(newPrincipal-reduction);
      //console.log(i);
      //console.log(Math.round(payment-newInterest));
      //console.log(Math.round(newPrincipal-reduction));

      var fn_payment = fixVal(payment, 0, 2, ' ');
      var fn_newInterest = fixVal(newInterest, 0, 2, ' ');
      var fn_reduction = fixVal(reduction, 0, 2, ' ');
      var fn_newPrincipal = fixVal(newPrincipal, 0, 2, ' ');

      if (month_st == '' && year_st == '') {
        //console.log('string');
        month_st = month_start.round().toString();
        year_st = year.toString();
      }
      detail.add({
        "date": "${month_st}/${year_st}",
        "amount": fn_payment,
        "interest": fn_newInterest,
        "principal": fn_reduction,
        "balance": fn_newPrincipal,
      });

      month_st = (double.parse(month_st).round() + 1).toString();

      if (month_st == "13") {
        month_st = "1";
        //console.log(year_st);
        year_st = (double.parse(year_st).round() + 1).toString();
      }
      var last_int = (newInterest_arr != null && newInterest_arr.isNotEmpty)
          ? newInterest_arr?.last
          : null;
      var last_reduct =
          (newreduction_arr != null && newreduction_arr.isNotEmpty)
              ? newreduction_arr?.last
              : null;

      if (last_int != null) {
        newInterest_arr.add(fn_newInterest + last_int);
      } else {
        newInterest_arr.add(fn_newInterest);
      }

      if (last_reduct != null) {
        newreduction_arr.add(fn_reduction + last_reduct);
      } else {
        newreduction_arr.add(fn_reduction);
      }

      newPrincipal_arr.add(fn_newPrincipal);
      category.add(i);
      i++;
    }

    var newInterest_less;
    var reduction_less;
    /* less data start */
    while (k <= 2) {
      //if (i != 0) {

      newInterest_less = monthly_less * newPrincipal_less;
      reduction_less = payment_less - newInterest_less;
      newPrincipal_less = newPrincipal_less - reduction_less;

      //newInterest=Math.round(monthly*newPrincipal);
      //reduction=Math.round(payment-newInterest);
      //newPrincipal=Math.round(newPrincipal-reduction);
      //console.log(i);
      //console.log(Math.round(payment-newInterest));
      //console.log(Math.round(newPrincipal-reduction));

      var fn_payment = fixVal(payment_less, 0, 2, ' ');
      var fn_newInterest = fixVal(newInterest_less, 0, 2, ' ');
      var fn_reduction = fixVal(reduction_less, 0, 2, ' ');
      var fn_newPrincipal = fixVal(newPrincipal_less, 0, 2, ' ');

      if (month_less == '' && year_less == '') {
        //console.log('string');
        month_less = month_start.round().toString();
        year_less = year.toString();
      }

      detail_less.add({
        "date": "${month_less}/${year_less}",
        "amount": fn_payment,
        "interest": fn_newInterest,
        "principal": fn_reduction,
        "balance": fn_newPrincipal,
      });

      month_less = (double.parse(month_less).round() + 1).toString();

      if (month_less == "13") {
        month_less = "1";
        year_less = (double.parse(year_less).round() + 1).toString();
      }

      var last_int =
          (newInterest_arr_less != null && newInterest_arr_less.isNotEmpty)
              ? newInterest_arr_less?.last
              : null;
      var last_reduct =
          (newreduction_arr_less != null && newreduction_arr_less.isNotEmpty)
              ? newreduction_arr_less?.last
              : null;
      if (last_int != null) {
        newInterest_arr_less.add(fn_newInterest + last_int);
      } else {
        newInterest_arr_less.add(fn_newInterest);
      }

      if (last_reduct != null) {
        newreduction_arr_less.add(fn_reduction + last_reduct);
      } else {
        newreduction_arr_less.add(fn_reduction);
      }

      newPrincipal_arr_less.add(fn_newPrincipal);
      category_less.add(k);

      k++;
    }

    var newInterest_year;
    var reduction_year;
    /*data year */
    while (l <= numpay_year) {
      //if (i != 0) {

      newInterest_year = monthly_year * newPrincipal_year;
      reduction_year = payment_year - newInterest_year;
      newPrincipal_year = newPrincipal_year - reduction_year;

      //newInterest=Math.round(monthly*newPrincipal);
      //reduction=Math.round(payment-newInterest);
      //newPrincipal=Math.round(newPrincipal-reduction);
      //console.log(i);
      //console.log(Math.round(payment-newInterest));
      //console.log(Math.round(newPrincipal-reduction));

      var fn_payment = fixVal(payment_year, 0, 2, ' ');
      var fn_newInterest = fixVal(newInterest_year, 0, 2, ' ');
      var fn_reduction = fixVal(reduction_year, 0, 2, ' ');
      var fn_newPrincipal = fixVal(newPrincipal_year, 0, 2, ' ');

      if (month_year == '' && year_year == '') {
        //console.log('string');
        month_year = month_start.round().toString();
        year_year = year.toString();
      }

      if (month_year == "1") {
        detail_year.add({
          "date": "${month_year}/${year_year}",
          "amount": fn_payment,
          "interest": fn_newInterest,
          "principal": fn_reduction,
          "balance": fn_newPrincipal,
        });
      }
      month_year = (double.parse(month_year).round() + 1).toString();

      if (month_year == "13") {
        month_year = "1";
        //console.log(year_st);
        year_year = (double.parse(year_year).round() + 1).toString();
      }
      var last_int =
          (newInterest_arr_year != null && newInterest_arr_year.isNotEmpty)
              ? newInterest_arr_year?.last
              : null;
      var last_reduct =
          (newreduction_arr_year != null && newreduction_arr_year.isNotEmpty)
              ? newreduction_arr_year?.last
              : null;
      if (last_int != null) {
        newInterest_arr_year.add(fn_newInterest + last_int);
      } else {
        newInterest_arr_year.add(fn_newInterest);
      }

      if (last_reduct != null) {
        newreduction_arr_year.add(fn_reduction + last_reduct);
      } else {
        newreduction_arr_year.add(fn_reduction);
      }

      newPrincipal_arr_year.add(fn_newPrincipal);
      category_year.add(l);

      l++;
    }

    var newInterest_year_less;
    var reduction_year_less;
    /*data less year */
    while (n <= numpay_year_less) {
      //  console.log(numpay_year_less);
      //if (i != 0) {

      newInterest_year_less = monthly_year_less * newPrincipal_year_less;
      reduction_year_less = payment_year_less - newInterest_year_less;
      newPrincipal_year_less = newPrincipal_year_less - reduction_year_less;

      //newInterest=Math.round(monthly*newPrincipal);
      //reduction=Math.round(payment-newInterest);
      //newPrincipal=Math.round(newPrincipal-reduction);
      //console.log(i);
      //console.log(Math.round(payment-newInterest));
      //console.log(Math.round(newPrincipal-reduction));

      var fn_payment = fixVal(payment_year_less, 0, 2, ' ');
      var fn_newInterest = fixVal(newInterest_year_less, 0, 2, ' ');
      var fn_reduction = fixVal(reduction_year_less, 0, 2, ' ');
      var fn_newPrincipal = fixVal(newPrincipal_year_less, 0, 2, ' ');

      if (month_year_less == '' && year_year_less == '') {
        //console.log('string');
        month_year_less = month_start.round().toString();
        year_year_less = year.toString();
      }

      if (month_year_less == "1") {
        if (n == 1 || n == 13) {
          detail_year_less.add({
            "date": "${month_year_less}/${year_year_less}",
            "amount": fn_payment,
            "interest": fn_newInterest,
            "principal": fn_reduction,
            "balance": fn_newPrincipal,
          });
        }
      }

      month_year_less = (double.parse(month_year_less).round() + 1).toString();

      if (month_year_less == "13") {
        month_year_less = "1";
        year_year_less = (double.parse(year_year_less).round() + 1).toString();
      }
      var last_int = (newInterest_arr_year_less != null &&
              newInterest_arr_year_less.isNotEmpty)
          ? newInterest_arr_year_less?.last
          : null;
      var last_reduct = (newreduction_arr_year_less != null &&
              newreduction_arr_year_less.isNotEmpty)
          ? newreduction_arr_year_less?.last
          : null;
      if (last_int != null) {
        newInterest_arr_year_less.add(fn_newInterest + last_int);
      } else {
        newInterest_arr_year_less.add(fn_newInterest);
      }

      if (last_reduct != null) {
        newreduction_arr_year_less.add(fn_reduction + last_reduct);
      } else {
        newreduction_arr_year_less.add(fn_reduction);
      }

      newPrincipal_arr_year_less.add(fn_newPrincipal);
      category_year_less.add(l);

      n++;
    }
    graphData = ''' {

    xAxis: {labels: {   formatter: function () {return this.value+" mo";}} },
      
    legend: {
        layout: 'vertical',
        align: 'right',
        verticalAlign: 'middle'
    },
    
 title: {
          text: ''
        },
    

    series: [{
        name: 'Remaining',
        data: [''' +
        newPrincipal_arr.join(", ") +
        ''']
    }, {
        name: 'Interest',
        data: [''' +
        newInterest_arr.join(", ") +
        ''']
    }, {
        name: 'Principal',
        data: [''' +
        newreduction_arr.join(", ") +
        ''']
    }, ],

    responsive: {
        rules: [{
            condition: {
                maxWidth: 500
            },
            chartOptions: {
                legend: {
                    layout: 'horizontal',
                    align: 'center',
                    verticalAlign: 'bottom'
                }
            }
        }]
    }

} ''';

    update();
  }
}
