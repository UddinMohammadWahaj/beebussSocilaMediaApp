// import 'dart:io';
// import 'package:bizbultest/Language/appLocalization.dart';
// import 'package:helpers/helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:video_editor/video_editor.dart';
// import 'add_tags_shortbuz.dart';

// class ShortbuzVideoEditor extends StatefulWidget {
//   ShortbuzVideoEditor({Key key, this.file, this.refreshFromShortbuz, this.from})
//       : super(key: key);

//   final File file;
//   final Function refreshFromShortbuz;
//   final bool from;

//   @override
//   _ShortbuzVideoEditorState createState() => _ShortbuzVideoEditorState();
// }

// class _ShortbuzVideoEditorState extends State<ShortbuzVideoEditor> {
//   final _exportingProgress = ValueNotifier<double>(0.0);
//   final _isExporting = ValueNotifier<bool>(false);
//   final double height = 60;
//   bool _exported = false;
//   String _exportText = "";
//   VideoEditorController _controller;
//   double maxCrop;
//   double minCrop;

//   @override
//   void initState() {
//     print(widget.file.path);
//     _controller = VideoEditorController.file(widget.file)
//       ..initialize().then((_) => setState(() {
//             maxCrop = _controller.maxCrop.dy;
//             minCrop = _controller.minCrop.dy;
//           }));
//     super.initState();
//   }

//   @override
//   void dispose() async {
//     print("disposeeee editorrrrr");
//     _controller.dispose();
//     super.dispose();
//   }

//   void _exportVideo() async {
//     Misc.delayed(500, () => _isExporting.value = true);
//     //NOTE: To use [-crf 17] and [VideoExportPreset] you need ["min-gpl-lts"] package

//     final File file = await _controller.exportVideo(
//       customInstruction: "-crf 17",
//       preset: VideoExportPreset.ultrafast,
//       onProgress: (statics) {
//         if (_controller.video != null) {
//           _exportingProgress.value =
//               statics.time / _controller.video.value.duration.inMilliseconds;
//         } else {}
//       },
//     );
//     _isExporting.value = false;

//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => AddTagsShortbuz(
//                   refreshFromShortbuz: widget.refreshFromShortbuz,
//                   file: file,
//                   flip: false,
//                   from: widget.from,
//                 )));

//     //GallerySaver.saveImage() for GIF or GallerySaver.saveVideo() for VIDEOS
//     //Note: GallerySave don't override files.

//     /*   if (file != null) {
//       await GallerySaver.saveVideo(file.path, albumName: "Video Editor");
//       _exportText = "Video success export!";
//     } else {
//       _exportText = "Error on export video :(";
//     }*/

//     setState(() => _exported = true);

//     Misc.delayed(2000, () => setState(() => _exported = false));
//   }

//   void _openCropScreen() => context.to(CropScreen(controller: _controller));

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(0),
//         child: AppBar(
//           backgroundColor: Colors.black,
//           elevation: 0,
//           brightness: Brightness.dark,
//         ),
//       ),
//       backgroundColor: Colors.black,
//       body: _controller.initialized
//           ? AnimatedBuilder(
//               animation: _controller,
//               builder: (_, __) {
//                 return Stack(children: [
//                   Column(children: [
//                     _topNavBar(),
//                     Expanded(
//                       child: ClipRRect(
//                         child: CropGridViewer(
//                           controller: _controller,
//                           showGrid: false,
//                         ),
//                       ),
//                     ),
//                     ..._trimSlider(),
//                   ]),
//                   Center(
//                     child: OpacityTransition(
//                       visible: !_controller.isPlaying,
//                       child: GestureDetector(
//                         onTap: _controller.video.play,
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(Icons.play_arrow),
//                         ),
//                       ),
//                     ),
//                   ),
//                   ValueListenableBuilder(
//                     valueListenable: _isExporting,
//                     builder: (_, bool export, __) => OpacityTransition(
//                       visible: export,
//                       child: AlertDialog(
//                         title: Center(
//                           child: ValueListenableBuilder(
//                             valueListenable: _exportingProgress,
//                             builder: (_, double value, __) => Text(
//                               "Processing ${(value * 100).ceil()}%",
//                               // color: Colors.black,
//                               // bold: true,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ]);
//               })
//           : Center(child: CircularProgressIndicator()),
//     );
//   }

//   Widget _topNavBar() {
//     return Container(
//       height: height,
//       child: Row(
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () => _controller.rotate90Degrees(RotateDirection.left),
//               child: Container(
//                   color: Colors.transparent,
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 7, bottom: 7),
//                     child: Icon(
//                       Icons.rotate_left,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   )),
//             ),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () => _controller.rotate90Degrees(RotateDirection.right),
//               child: Container(
//                   color: Colors.transparent,
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 7, bottom: 7),
//                     child: Icon(
//                       Icons.rotate_right,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   )),
//             ),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: _openCropScreen,
//               child: Container(
//                   color: Colors.transparent,
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 7, bottom: 7),
//                     child: Icon(
//                       Icons.crop,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   )),
//             ),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 if (_controller.rotation == 0 &&
//                     _controller.videoDuration.inSeconds < 62 &&
//                     (_controller.maxTrim *
//                             _controller.videoDuration.inSeconds ==
//                         _controller.videoDuration.inSeconds) &&
//                     (_controller.minTrim *
//                             _controller.videoDuration.inSeconds ==
//                         0) &&
//                     (maxCrop == _controller.maxCrop.dy)) {
//                   print("not edited");
//                   print(maxCrop);
//                   print(minCrop);
//                   print(_controller.maxCrop.dy);
//                   print(_controller.minCrop.dx);

//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AddTagsShortbuz(
//                                 refreshFromShortbuz: widget.refreshFromShortbuz,
//                                 file: widget.file,
//                                 flip: false,
//                                 from: widget.from,
//                               )));
//                 } else {
//                   print("Edited");
//                   _exportVideo();
//                 }

//                 //print(_controller.rotation);
//                 // print(_controller.videoDuration.inSeconds);
//                 //print(_controller.maxTrim * _controller.videoDuration.inSeconds);
//                 // print(_controller.minTrim * _controller.videoDuration.inSeconds);
//                 //print(_controller.maxTrim * 60);
//               },
//               child: Container(
//                   color: Colors.transparent,
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 7, bottom: 7),
//                     child: Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   )),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> _trimSlider() {
//     final duration = _controller.videoDuration.inSeconds;
//     final pos = _controller.trimPosition * duration;
//     final start = _controller.minTrim * duration;
//     final end = _controller.maxTrim * duration;

//     String formatter(Duration duration) =>
//         duration.inMinutes.remainder(60).toString().padLeft(2, '0') +
//         ":" +
//         (duration.inSeconds.remainder(60)).toString().padLeft(2, '0');

//     return [
//       Padding(
//         padding: Margin.horizontal(height / 4),
//         child: Row(children: [
//           // TextDesigned(
//           //   formatter(Duration(seconds: pos.toInt())),
//           //   color: Colors.white,
//           // ),
//           Expanded(child: SizedBox()),
//           OpacityTransition(
//             visible: _controller.isTrimming,
//             child: Row(mainAxisSize: MainAxisSize.min, children: [
//               // TextDesigned(
//               //   formatter(Duration(seconds: start.toInt())),
//               //   color: Colors.white,
//               // ),
//               // SizedBox(width: 10),
//               // TextDesigned(
//               //   formatter(Duration(seconds: end.toInt())),
//               //   color: Colors.white,
//               // ),
//             ]),
//           )
//         ]),
//       ),
//       Container(
//         height: height,
//         margin: Margin.all(height / 4),
//         child: TrimSlider(
//           controller: _controller,
//           // maxDuration: new Duration(seconds: 62),
//           height: height,
//         ),
//       )
//     ];
//   }
// }

// class CropScreen extends StatefulWidget {
//   CropScreen({
//     Key key,
//     @required this.controller,
//   }) : super(key: key);

//   final VideoEditorController controller;

//   @override
//   _CropScreenState createState() => _CropScreenState();
// }

// class _CropScreenState extends State<CropScreen> {
//   Offset _minCrop;
//   Offset _maxCrop;

//   @override
//   void initState() {
//     _minCrop = widget.controller.minCrop;
//     _maxCrop = widget.controller.maxCrop;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Padding(
//           padding: Margin.all(30),
//           child: Column(children: [
//             Expanded(
//               child: CropGridViewer(
//                 controller: widget.controller,
//                 // onChangeCrop: (min, max) => setState(() {
//                 //   _minCrop = min;
//                 //   _maxCrop = max;
//                 // }),
//               ),
//             ),
//             SizedBox(height: 15),
//             Row(children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => Navigator.of(context).pop(),
//                   child: Center(
//                     child: Text(
//                       AppLocalizations.of(
//                         "CANCEL",
//                       ),
//                       // color: Colors.white,
//                       // bold: true
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     // widget.controller.updateCrop(_minCrop, _maxCrop);
//                     widget.controller.updateCrop();
//                     Navigator.of(context).pop();
//                   },
//                   child: Center(
//                     child: Text(
//                       "OK",
//                       // color: Colors.white, bold: true
//                     ),
//                   ),
//                 ),
//               ),
//             ]),
//           ]),
//         ),
//       ),
//     );
//   }
// }
