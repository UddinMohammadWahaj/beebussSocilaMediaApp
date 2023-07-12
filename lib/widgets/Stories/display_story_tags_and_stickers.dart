import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bizbultest/models/expanded_story_model.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:bizbultest/services/current_user.dart';

class DisplayStoryTags extends StatefulWidget {
  final Position? e;

  const DisplayStoryTags({Key? key, this.e}) : super(key: key);

  @override
  _DisplayStoryTagsState createState() => _DisplayStoryTagsState();
}

class _DisplayStoryTagsState extends State<DisplayStoryTags> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: double.parse(widget.e!.posx!) - 125,
      top: double.parse(widget.e!.posy!) - 125,
      right: -125,
      bottom: -125,
      child: Align(
          alignment: Alignment.center,
          child: Container(
            height: double.parse(widget.e!.height!),
            width: double.parse(widget.e!.width!),
            color: Colors.transparent,
            child: Center(
              child: ParsedText(
                parse: [
                  MatchText(
                    onTap: (value) {
                      setState(() {
                        OtherUser().otherUser.memberID =
                            value.toString().replaceAll("@", "");
                        OtherUser().otherUser.shortcode =
                            value.toString().replaceAll("@", "");
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePageMain(
                                    from: "tags",
                                    otherMemberID:
                                        value.toString().replaceAll("@", ""),
                                  )));
                    },
                    pattern: "(@+[a-zA-Z0-9(_)]{1,})",
                  ),
                ],
                text: widget.e!.text!,
                style: GoogleFonts.getFont(widget.e!.name == "Raleway_regular"
                        ? "Raleway"
                        : widget.e!.name == "PlayfairDisplay_regular"
                            ? "Playfair Display"
                            : widget.e!.name == "OpenSansCondensed_300"
                                ? "Open Sans Condensed"
                                : widget.e!.name == "Anton_regular"
                                    ? "Anton"
                                    : widget.e!.name == "BebasNeue_regular"
                                        ? "Bebas Neue"
                                        : widget.e!.name ==
                                                "DancingScript_regular"
                                            ? "Dancing Script"
                                            : widget.e!.name ==
                                                    "AmaticaSC_regular"
                                                ? "Amatica SC"
                                                : widget.e!.name ==
                                                        "Sacramento_regular"
                                                    ? "Sacramento"
                                                    : widget.e!.name ==
                                                            "SpecialElite_regular"
                                                        ? "Special Elite"
                                                        : widget.e!.name ==
                                                                "PoiretOne_regular"
                                                            ? "Poiret One"
                                                            : widget.e!.name ==
                                                                    "Monoton_regular"
                                                                ? "Monoton"
                                                                : widget.e!.name ==
                                                                        "FingerPaint_regular"
                                                                    ? "Finger Paint"
                                                                    : widget.e!.name ==
                                                                            "VastShadow_regular"
                                                                        ? "Vast Shadow"
                                                                        : widget.e!.name ==
                                                                                "Flavors_regular"
                                                                            ? "Flavors"
                                                                            : widget.e!.name ==
                                                                                    "RibeyeMarrow_regular"
                                                                                ? "Ribeye Marrow"
                                                                                : widget.e!.name ==
                                                                                        "Jomhuria_regular"
                                                                                    ? "Jomhuria"
                                                                                    : widget.e!.name ==
                                                                                            "ZillaSlabHighlight_regular"
                                                                                        ? "Zilla Slab Highlight"
                                                                                        : widget.e!.name ==
                                                                                                "Monofett_regular"
                                                                                            ? "Monofett"
                                                                                            : "Roboto")
                    .copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(
                            int.parse(widget.e!.color!.split(",")[0]),
                            int.parse(widget.e!.color!.split(",")[1]),
                            int.parse(widget.e!.color!.split(",")[2]),
                            1),
                        fontSize: 25),
                alignment: TextAlign.center,
                textScaleFactor: double.parse(widget.e!.scale!),
              ),
            ),
          )),
    );
  }
}

class DisplayStoryStickers extends StatelessWidget {
  final Sticker? s;

  DisplayStoryStickers({Key? key, this.s}) : super(key: key);

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


// class Displaymantions extends StatefulWidget {
//  final Sticker s;

//    Displaymantions({Key key, this.s}) : super(key: key);
//   @override
//   _DisplaymantionsState createState() => _DisplaymantionsState();
// }

// class _DisplaymantionsState extends State<Displaymantions> {
//   @override
//   Widget build(BuildContext context) {
//     return Positioned.fill(
//       left: double.parse(widget.s.posx) - 125,
//       top: double.parse(widget.s.posy) -125,
//       right: -125,
//       bottom: -125,

//       child: Align(
//           alignment: Alignment.center,
//           child: Container(
//             color: Colors.transparent,
//             child: Transform(
//               transform: new Matrix4.diagonal3(new v.Vector3(double.parse(widget.s.scale), double.parse(widget.s.scale), double.parse(widget.s.scale))),
//               alignment: FractionalOffset.center,
//               child: Container(
//                 color: Colors.transparent,
//                 child: Transform(
//                   transform: new Matrix4.diagonal3(new v.Vector3(double.parse(widget.s.scale), double.parse(widget.s.scale), double.parse(widget.s.scale))),
//                   alignment: FractionalOffset.center,
//                   child: Text(
//                            widget.s.name,
//                            //style: e.font.copyWith(fontWeight: FontWeight.bold, color: e.color, fontSize: 25),
//                            textAlign: TextAlign.center,
//                            textScaleFactor: double.parse(widget.s.scale),
//                          ),
//                 ),
//               ),
//             ),
//           )),
//     );
//   }
// }
