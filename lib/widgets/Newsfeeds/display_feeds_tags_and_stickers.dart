import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class DisplayFeedTags extends StatelessWidget {
  final Position? e;

  const DisplayFeedTags({Key? key, this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: double.parse(e!.posx!) - 125,
      top: double.parse(e!.posy!) - 125,
      right: -125,
      bottom: -125,
      child: Align(
          alignment: Alignment.center,
          child: Container(
            height: double.parse(e!.height!),
            width: double.parse(e!.width!),
            color: Colors.transparent,
            child: Center(
              child: Text(
                e!.text!,
                style: GoogleFonts.getFont(e!.name == "Raleway_regular"
                        ? "Raleway"
                        : e!.name == "PlayfairDisplay_regular"
                            ? "Playfair Display"
                            : e!.name == "OpenSansCondensed_300"
                                ? "Open Sans Condensed"
                                : e!.name == "Anton_regular"
                                    ? "Anton"
                                    : e!.name == "BebasNeue_regular"
                                        ? "Bebas Neue"
                                        : e!.name == "DancingScript_regular"
                                            ? "Dancing Script"
                                            : e!.name == "AmaticaSC_regular"
                                                ? "Amatica SC"
                                                : e!.name ==
                                                        "Sacramento_regular"
                                                    ? "Sacramento"
                                                    : e!.name ==
                                                            "SpecialElite_regular"
                                                        ? "Special Elite"
                                                        : e!.name ==
                                                                "PoiretOne_regular"
                                                            ? "Poiret One"
                                                            : e!.name ==
                                                                    "Monoton_regular"
                                                                ? "Monoton"
                                                                : e!.name ==
                                                                        "FingerPaint_regular"
                                                                    ? "Finger Paint"
                                                                    : e!.name ==
                                                                            "VastShadow_regular"
                                                                        ? "Vast Shadow"
                                                                        : e!.name ==
                                                                                "Flavors_regular"
                                                                            ? "Flavors"
                                                                            : e!.name ==
                                                                                    "RibeyeMarrow_regular"
                                                                                ? "Ribeye Marrow"
                                                                                : e!.name ==
                                                                                        "Jomhuria_regular"
                                                                                    ? "Jomhuria"
                                                                                    : e!.name ==
                                                                                            "ZillaSlabHighlight_regular"
                                                                                        ? "Zilla Slab Highlight"
                                                                                        : e!.name ==
                                                                                                "Monofett_regular"
                                                                                            ? "Monofett"
                                                                                            : "Roboto")
                    .copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(
                            int.parse(e!.color!.split(",")[0]),
                            int.parse(e!.color!.split(",")[1]),
                            int.parse(e!.color!.split(",")[2]),
                            1),
                        fontSize: 25),
                textAlign: TextAlign.center,
                textScaleFactor: double.parse(e!.scale!),
              ),
            ),
          )),
    );
  }
}

class DisplayFeedStickers extends StatelessWidget {
  final Sticker? s;

  DisplayFeedStickers({Key? key, this.s}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: double.parse(s!.posx!) - 125,
      top: double.parse(s!.posy!) - 125,
      right: -125,
      bottom: -125,
      child: Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.transparent,
            child: Transform(
              transform: new Matrix4.diagonal3(new v.Vector3(
                  double.parse(s!.scale!),
                  double.parse(s!.scale!),
                  double.parse(s!.scale!))),
              alignment: FractionalOffset.center,
              child: Container(
                color: Colors.transparent,
                child: Transform(
                  transform: new Matrix4.diagonal3(new v.Vector3(
                      double.parse(s!.scale!),
                      double.parse(s!.scale!),
                      double.parse(s!.scale!))),
                  alignment: FractionalOffset.center,
                  child: Image.network(
                    s!.name!,
                    height: 85,
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
