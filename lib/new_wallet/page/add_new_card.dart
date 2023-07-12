
// import 'package:card_scanner/card_scanner.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_brand.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
// import 'package:stripe_payment/stripe_payment.dart';

// import '../connection/wallet_connection.dart';

// class AddNewCard extends StatefulWidget {
//   const AddNewCard({Key key}) : super(key: key);

//   @override
//   State<AddNewCard> createState() => _AddNewCardState();
// }

// class _AddNewCardState extends State<AddNewCard> {
//   String cardNumber = '';
//   String expiryDate = '';
//   String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;
//   bool useGlassMorphism = false;
//   bool useBackgroundImage = false;
//   OutlineInputBorder border;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   bool cardScan = false;
//    String _error;
//   String customerId = "cus_MofXpz82rCSrKh";
//   bool isLoading = false;

//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

//   @override
//   void initState() {
//     border = OutlineInputBorder(
//       borderSide: BorderSide(
//         color: Colors.grey.withOpacity(1),
//         width: 2.0,
//       ),
//     );
//     StripePayment.setOptions(StripeOptions(
//         publishableKey:
//             "pk_test_51M3vYuSEoIoePsappaWvoC9M6VqmslJwBqoXbs6lWNttRTjxUuwmJWKmWhNCtc6xKGVWtREEPXYldXQUiKYPVJHM005yNigfaW",
//         androidPayMode: 'test'));
//     super.initState();
//   }

//   void getUserTokenAuth(String authToken) {
//     setState(() {
//       String userToken = authToken;
//     });
//   }

//    CardDetails _cardDetails;

//   CardScanOptions scanOptions = const CardScanOptions(
//     scanCardHolderName: true,
//     scanExpiryDate: true,
//     enableDebugLogs: true,
//     validCardsToScanBeforeFinishingScan: 5,
//     possibleCardHolderNamePositions: [
//       CardHolderNameScanPosition.aboveCardNumber,
//     ],
//   );

//   Future<void> scanCard() async {
//     var cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);

//     if (!mounted) return;
//     setState(() {
//       _cardDetails = cardDetails;
//       cardNumber = _cardDetails.cardNumber.toString();
//       cardHolderName = _cardDetails.cardHolderName.toString();
//       expiryDate = _cardDetails.expiryDate.toString();
//       cardScan = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         decoration: BoxDecoration(
//           color: Color(0xB3000000),
//         ),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 children: [
//                   SizedBox(
//                     width: 15,
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       Navigator.pop(context, false);
//                     },
//                     child: ImageIcon(
//                       AssetImage("assets/back_arrow.png"),
//                       color: Color(0xFFFFFFFF),
//                       size: 20,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Text(
//                     'New Card',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: Colors.white),
//                   ),
//                   Expanded(child: SizedBox()),
//                   GestureDetector(
//                     onTap: () async {
//                       scanCard();
//                     },
//                     child: ImageIcon(
//                       AssetImage("assets/scanner.png"),
//                       color: Color(0xFFFFFFFF),
//                       size: 35,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                 ],
//               ),
//               CreditCardWidget(
//                 glassmorphismConfig:
//                     useGlassMorphism ? Glassmorphism.defaultConfig() : null,
//                 cardNumber: cardNumber,
//                 expiryDate: expiryDate,
//                 cardHolderName: cardHolderName,
//                 cvvCode: cvvCode,
//                 bankName: '',
//                 showBackView: isCvvFocused,
//                 obscureCardNumber: true,
//                 obscureCardCvv: true,
//                 isHolderNameVisible: true,
//                 cardBgColor: Colors.black87,
//                 isSwipeGestureEnabled: true,
//                 onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
//               ),
//               cardScan
//                   ? Expanded(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: <Widget>[
//                             CreditCardForm(
//                               formKey: formKey,
//                               obscureCvv: true,
//                               obscureNumber: true,
//                               cardNumber: cardNumber,
//                               cvvCode: cvvCode,
//                               isHolderNameVisible: true,
//                               isCardNumberVisible: true,
//                               isExpiryDateVisible: true,
//                               cardHolderName: cardHolderName,
//                               expiryDate: expiryDate,
//                               themeColor: Colors.black,
//                               textColor: Colors.white,
//                               cardNumberDecoration: InputDecoration(
//                                 labelText: 'Number',
//                                 hintText: 'XXXX XXXX XXXX XXXX',
//                                 hintStyle: const TextStyle(color: Colors.white),
//                                 labelStyle:
//                                     const TextStyle(color: Colors.white),
//                                 focusedBorder: border,
//                                 enabledBorder: border,
//                               ),
//                               expiryDateDecoration: InputDecoration(
//                                 hintStyle: const TextStyle(color: Colors.white),
//                                 labelStyle:
//                                     const TextStyle(color: Colors.white),
//                                 focusedBorder: border,
//                                 enabledBorder: border,
//                                 labelText: 'Expired Date',
//                                 hintText: 'XX/XX',
//                               ),
//                               cvvCodeDecoration: InputDecoration(
//                                 hintStyle: const TextStyle(color: Colors.white),
//                                 labelStyle:
//                                     const TextStyle(color: Colors.white),
//                                 focusedBorder: border,
//                                 enabledBorder: border,
//                                 labelText: 'CVV',
//                                 hintText: 'XXX',
//                               ),
//                               cardHolderDecoration: InputDecoration(
//                                 hintStyle: const TextStyle(color: Colors.white),
//                                 labelStyle:
//                                     const TextStyle(color: Colors.white),
//                                 focusedBorder: border,
//                                 enabledBorder: border,
//                                 labelText: 'Card Holder',
//                               ),
//                               onCreditCardModelChange: onCreditCardModelChange,
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 primary: Color(0xffF18910),
//                                 padding: EdgeInsets.symmetric(horizontal: 50),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                               ),
//                               child: Container(
//                                 margin: const EdgeInsets.all(12),
//                                 child: isLoading
//                                     ? SizedBox(
//                                         height: 25,
//                                         width: 25,
//                                         child: CircularProgressIndicator(
//                                           valueColor: AlwaysStoppedAnimation(
//                                               Colors.white),
//                                         ),
//                                       )
//                                     : const Text(
//                                         'Save',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontFamily: 'halter',
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                               ),
//                               onPressed: () {
//                                 if (formKey.currentState.validate()) {
//                                   print('valid!');
//                                   setState(() {
//                                     isLoading = true;
//                                   });
//                                   var monthYear = expiryDate.split('/');
//                                   int month = int.parse(monthYear[0].trim());
//                                   int year = int.parse(
//                                       monthYear.sublist(1).join('/').trim());
//                                   final CreditCard cardData = CreditCard(
//                                       number: cardNumber,
//                                       expMonth: month,
//                                       expYear: year,
//                                       cvc: cvvCode,
//                                       name: cardHolderName);
//                                   StripePayment.createTokenWithCard(
//                                     cardData,
//                                   ).then((token) {
//                                     setState(() {
//                                       print('card - ${token}');
//                                       WalleteConnection().storeCard(token.tokenId.toString(),
//                                               customerId)
//                                           .then((value) => {
//                                                 if (value != null)
//                                                   {
//                                                     if (value.status == 1)
//                                                       {
//                                                         showSuccess(
//                                                             "Card Add Successfully"),
//                                                       }
//                                                     else
//                                                       {
//                                                         showFailed(
//                                                             "Card Add Failed"),
//                                                       }
//                                                   }
//                                               });
//                                     });
//                                   }).catchError(setError);
//                                 } else {
//                                   var monthYear = expiryDate.split('/');
//                                   var month = monthYear[0].trim();
//                                   var year =
//                                       monthYear.sublist(1).join('/').trim();
//                                   print('invalid! ${month} ${year}');
//                                 }
//                               },
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : Container(),
//               !cardScan
//                   ? Expanded(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: <Widget>[
//                             CreditCardForm(
//                               formKey: formKey,
//                               obscureCvv: true,
//                               obscureNumber: true,
//                               cardNumber: cardNumber,
//                               cvvCode: cvvCode,
//                               isHolderNameVisible: true,
//                               isCardNumberVisible: true,
//                               isExpiryDateVisible: true,
//                               cardHolderName: cardHolderName,
//                               expiryDate: expiryDate,
//                               themeColor: Colors.black,
//                               textColor: Colors.white,
//                               cardNumberDecoration: InputDecoration(
//                                 labelText: 'Number',
//                                 hintText: 'XXXX XXXX XXXX XXXX',
//                                 hintStyle: const TextStyle(color: Colors.white),
//                                 labelStyle:
//                                     const TextStyle(color: Colors.white),
//                                 focusedBorder: border,
//                                 enabledBorder: border,
//                               ),
//                               expiryDateDecoration: InputDecoration(
//                                 hintStyle: const TextStyle(color: Colors.white),
//                                 labelStyle:
//                                     const TextStyle(color: Colors.white),
//                                 focusedBorder: border,
//                                 enabledBorder: border,
//                                 labelText: 'Expired Date',
//                                 hintText: 'XX/XX',
//                               ),
//                               cvvCodeDecoration: InputDecoration(
//                                 hintStyle: const TextStyle(color: Colors.white),
//                                 labelStyle:
//                                     const TextStyle(color: Colors.white),
//                                 focusedBorder: border,
//                                 enabledBorder: border,
//                                 labelText: 'CVV',
//                                 hintText: 'XXX',
//                               ),
//                               cardHolderDecoration: InputDecoration(
//                                 hintStyle: const TextStyle(color: Colors.white),
//                                 labelStyle:
//                                     const TextStyle(color: Colors.white),
//                                 focusedBorder: border,
//                                 enabledBorder: border,
//                                 labelText: 'Card Holder',
//                               ),
//                               onCreditCardModelChange: onCreditCardModelChange,
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 primary: Color(0xffF18910),
//                                 padding: EdgeInsets.symmetric(horizontal: 50),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                               ),
//                               child: Container(
//                                 margin: const EdgeInsets.all(12),
//                                 child: isLoading
//                                     ? SizedBox(
//                                         height: 25,
//                                         width: 25,
//                                         child: CircularProgressIndicator(
//                                           valueColor: AlwaysStoppedAnimation(
//                                               Colors.white),
//                                         ),
//                                       )
//                                     : const Text(
//                                         'Save',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                               ),
//                               onPressed: () {
//                                 if (formKey.currentState.validate()) {
//                                   print('valid!');
//                                   setState(() {
//                                     isLoading = true;
//                                   });
//                                   var monthYear = expiryDate.split('/');
//                                   int month = int.parse(monthYear[0].trim());
//                                   int year = int.parse(
//                                       monthYear.sublist(1).join('/').trim());
//                                   final CreditCard cardData = CreditCard(
//                                       number: cardNumber,
//                                       expMonth: month,
//                                       expYear: year,
//                                       cvc: cvvCode,
//                                       name: cardHolderName);
//                                   /*Token Generation data*/
//                                   StripePayment.createTokenWithCard(
//                                     cardData,
//                                   ).then((token) {
//                                     setState(() {
//                                       print('card Token -> ${token.tokenId}');
//                                       WalleteConnection()
//                                           .storeCard(token.tokenId.toString(),
//                                               customerId)
//                                           .then((value) => {
//                                                 setState(() {
//                                                   isLoading = false;
//                                                 }),
//                                                 if (value != null)
//                                                   {
//                                                     if (value.status == 1)
//                                                       {
//                                                         showSuccess(
//                                                             "Card Add Successfully"),
//                                                       }
//                                                     else
//                                                       {
//                                                         showFailed(
//                                                             "Card Add Failed"),
//                                                       }
//                                                   }
//                                               });
//                                     });
//                                   }).catchError(setError);
//                                 } else {
//                                   setState(() {
//                                     isLoading = false;
//                                   });
//                                   print('invalid!');
//                                 }
//                               },
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : Container(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void onCreditCardModelChange(CreditCardModel creditCardModel) {
//     setState(() {
//       cardNumber = creditCardModel.cardNumber;
//       expiryDate = creditCardModel.expiryDate;
//       cardHolderName = creditCardModel.cardHolderName;
//       cvvCode = creditCardModel.cvvCode;
//       isCvvFocused = creditCardModel.isCvvFocused;
//     });
//   }

//   void setError(dynamic error) {
//     setState(() {
//       isLoading = false;
//       _error = error.toString();
//     });
//   }

//   showSuccess(String msg) {
//     Widget continueButton = TextButton(
//       child: const Text(
//         "Ok",
//         style: TextStyle(
//             color: Color(0xff2B25CC),
//             fontSize: 15,
//             fontWeight: FontWeight.bold),
//       ),
//       onPressed: () {
//         Navigator.pop(context);
//         /*Navigation List view */
//         Navigator.pop(context, true);
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text(
//         "Bebuzee Wallet",
//         style: TextStyle(fontSize: 17, color: Color(0xff91596F)),
//         textAlign: TextAlign.center,
//       ),
//       content: Text(
//         msg,
//         style: TextStyle(fontSize: 15),
//         textAlign: TextAlign.center,
//       ),
//       actions: [
//         continueButton,
//       ],
//       actionsAlignment: MainAxisAlignment.center,
//     );

//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   showFailed(String msg) {
//     Widget continueButton = TextButton(
//       child: const Text(
//         "Ok",
//         style: TextStyle(
//             color: Color(0xff2B25CC),
//             fontSize: 15,
//             fontWeight: FontWeight.bold),
//       ),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text(
//         "Bebuzee Wallet",
//         style: TextStyle(fontSize: 17, color: Color(0xff91596F)),
//         textAlign: TextAlign.center,
//       ),
//       content: Text(
//         msg,
//         style: TextStyle(fontSize: 15),
//         textAlign: TextAlign.center,
//       ),
//       actions: [
//         continueButton,
//       ],
//       actionsAlignment: MainAxisAlignment.center,
//     );

//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
