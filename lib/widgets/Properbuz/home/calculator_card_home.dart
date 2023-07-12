import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/view/Properbuz/calculators/affordability_calculator_view.dart';
import 'package:bizbultest/view/Properbuz/calculators/amortization_calculator_view.dart';
import 'package:bizbultest/view/Properbuz/calculators/debt_to_income_calculator.dart';
import 'package:bizbultest/view/Properbuz/calculators/mortgage_calculator_view.dart';
import 'package:bizbultest/view/Properbuz/calculators/refinance_calculator_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utilities/colors.dart';

class CalculatorCardHome extends GetView<ProperbuzController> {
  const CalculatorCardHome({Key? key}) : super(key: key);

  Widget _header() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Text(
              AppLocalizations.of(
                "Calculators",
              ),
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.calculate_outlined,
              color: Colors.black,
            )
          ],
        ));
  }

  Widget _customTile(String title, VoidCallback onTap, double rightPadding) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: new BoxDecoration(
          color: hotPropertiesThemeColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        margin: EdgeInsets.only(left: 15, right: rightPadding),
        width: 175,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          title: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            AppLocalizations.of(
              "Calculators",
            ),
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          trailing: Icon(
            Icons.arrow_right,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => (ProperbuzController()), fenix: true);
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _customTile(
                    AppLocalizations.of(
                      "Mortgage",
                    ),
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MortgageCalculatorView())),
                    0),
                _customTile(
                    AppLocalizations.of(
                      "Refinance",
                    ),
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RefinanceCalculatorView())),
                    0),
                _customTile(
                    AppLocalizations.of(
                      "Affordability",
                    ),
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AffordabilityCalculatorView())),
                    0),
                _customTile(
                    AppLocalizations.of(
                      "Amortization",
                    ),
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AmortizationCalculatorView())),
                    0),
                _customTile(
                    AppLocalizations.of(
                      "Debt-to-Income",
                    ),
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DebtToIncomeCalculatorView())),
                    15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
