import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../services/BebuzeeShop/bebuzeeshopmerchantcontroller.dart';

class BebuzeeShopProductAddSuccess extends StatefulWidget {
  BebuzeeShopMerchantController? controller;
  String? from;
  BebuzeeShopProductAddSuccess({Key? key, this.controller, this.from})
      : super(key: key);

  @override
  State<BebuzeeShopProductAddSuccess> createState() =>
      BebuzeeShopProductAddSuccessState();
}

class BebuzeeShopProductAddSuccessState
    extends State<BebuzeeShopProductAddSuccess> {
  late ConfettiController _controllerCenter;
  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;
  late ConfettiController _controllerTopCenter;
  late ConfettiController _controllerBottomCenter;
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        elevation: 0,
      ),
      body: Container(
        height: 100.0.h,
        width: 100.0.w,
        child: Stack(
          children: [
            Center(
                child: Column(
              children: [
                SizedBox(
                  height: 30.0.h,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.done_all_sharp,
                      color: Colors.black, size: 10.0.h),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Success',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 5.0.h,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                widget.from == "PRODUCTADD"
                    ? Text('Your product has been added successfully')
                    : widget.from == "COLLECTIONADD"
                        ? Text('Your collection has been created successfully')
                        : Text('Your store has been created successfully'),
                SizedBox(
                  height: 15.0.h,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () {
                      if (widget.from == "COLLECTIONADD") {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                      if (widget.from == "PRODUCTADD") {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        widget.controller!.fetchProductList();
                        return;
                      }
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      widget.controller!.getMerchantStores();
                    },
                    child: Text('Back to Store'))
              ],
            )),
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                shouldLoop:
                    true, // start again as soon as the animation is finished
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
                createParticlePath: drawStar, // define a custom shape/path.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
