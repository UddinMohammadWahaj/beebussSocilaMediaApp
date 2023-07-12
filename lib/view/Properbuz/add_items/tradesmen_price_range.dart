// import 'package:bizbultest/Language/appLocalization.dart';
// import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
// import 'package:bizbultest/utilities/colors.dart';
// import 'package:bizbultest/widgets/Properbuz/utils/properbuz_snackbar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';

// import '../../../services/Properbuz/add_tradesman_controller.dart';
// import '../../../services/Properbuz/tradesman_controller.dart';

// class newPriceRangeView extends GetView<AddTradesmenController> {
//   const newPriceRangeView({Key key}) : super(key: key);

//   Widget _customTextField(
//       TextEditingController textEditingController, String hintText) {
//     return Container(
//       height: 50,
//       width: 50.0.w - 30,
//       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       padding: EdgeInsets.symmetric(
//         horizontal: 10,
//       ),
//       decoration: new BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(5)),
//         shape: BoxShape.rectangle,
//         border: new Border.all(
//           color: Colors.white,
//           width: 1,
//         ),
//       ),
//       child: TextFormField(
//         maxLines: 1,
//         cursorColor: Colors.white,
//         controller: textEditingController,
//         keyboardType: TextInputType.text,
//         textCapitalization: TextCapitalization.sentences,
//         style: TextStyle(
//             color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           suffixIconConstraints: BoxConstraints(),
//           focusedBorder: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           errorBorder: InputBorder.none,
//           disabledBorder: InputBorder.none,
//           hintText: AppLocalizations.of(
//             hintText,
//           ),
//           hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 16),
//         ),
//       ),
//     );
//   }

//   Widget _priceCard(String price, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//           alignment: Alignment.center,
//           color: Colors.transparent,
//           width: 50.0.w - 30,
//           margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//           padding: EdgeInsets.symmetric(
//             horizontal: 10,
//           ),
//           child: Text(
//             price,
//             style: TextStyle(fontSize: 12.0.sp, color: settingsColor),
//           )),
//     );
//   }

//   Widget _commonListBuilder(RxList<dynamic> list, int val) {
//     return Expanded(
//       child: Obx(
//         () => ListView.builder(
//             shrinkWrap: true,
//             itemCount: list.length,
//             itemBuilder: (context, index) {
//               return _priceCard(list[index].toString(), () {
//                 if (val == 1) {
//                   controller.minPriceController.text = list[index].toString();
//                 } else {
//                   controller.maxPriceController.text = list[index].toString();
//                 }
//               });
//             }),
//       ),
//     );
//   }

//   Widget _clearButton() {
//     return GestureDetector(
//       onTap: () {
//         controller.minPriceController.clear();
//         controller.maxPriceController.clear();
//       },
//       child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//           decoration: new BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(Radius.circular(3)),
//             shape: BoxShape.rectangle,
//           ),
//           child: Center(
//             child: Text(
//               "Clear",
//               style: TextStyle(
//                   color: appBarColor,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500),
//             ),
//           )),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Get.put(ProperbuzController());
//     return WillPopScope(
//       onWillPop: () async {
//         if (controller.minPriceController.text.isEmpty &&
//             controller.maxPriceController.text.isNotEmpty) {
//           Get.showSnackbar(properbuzSnackBar("Please select both the ranges"));
//           return false;
//         } else if (controller.minPriceController.text.isNotEmpty &&
//             controller.maxPriceController.text.isEmpty) {
//           Get.showSnackbar(properbuzSnackBar("Please select both the ranges"));
//           return false;
//         } else {
//           Navigator.pop(context);
//           return true;
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           elevation: 0.5,
//           backgroundColor: appBarColor,
//           brightness: Brightness.dark,
//           leading: IconButton(
//             splashRadius: 20,
//             icon: Icon(
//               Icons.keyboard_backspace,
//               size: 28,
//             ),
//             color: Colors.white,
//             onPressed: () {
//               if (controller.minPriceController.text.isEmpty &&
//                   controller.maxPriceController.text.isNotEmpty) {
//                 Get.showSnackbar(
//                     properbuzSnackBar("Please select both the ranges"));
//               } else if (controller.minPriceController.text.isNotEmpty &&
//                   controller.maxPriceController.text.isEmpty) {
//                 Get.showSnackbar(
//                     properbuzSnackBar("Please select both the ranges"));
//               } else {
//                 Navigator.pop(context);
//               }
//             },
//           ),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Select price range",
//                 style: TextStyle(
//                     fontSize: 14.0.sp,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500),
//               ),
//               _clearButton(),
//             ],
//           ),
//           bottom: PreferredSize(
//               preferredSize: Size.fromHeight(60),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _customTextField(controller.minPriceController, "Min price"),
//                   Text(
//                     "to",
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500),
//                   ),
//                   _customTextField(controller.maxPriceController, "Max price"),
//                 ],
//               )),
//         ),
//         body: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _commonListBuilder(controller.minPricesList, 1),
//             _commonListBuilder(controller.maxPricesList, 2),
//           ],
//         ),
//       ),
//     );
//   }
// }
