// import 'dart:io';
// import 'package:bizbultest/widgets/Shortbuz/upload_shortbuz.dart';
// import 'package:bizbultest/widgets/Stories/multiple_story_files.dart';
// import 'package:helpers/helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_editor/video_editor.dart';
// import 'package:gallery_saver/gallery_saver.dart';

// class StoryVideoEditor extends StatefulWidget {
//   StoryVideoEditor(
//       {Key key,
//       this.file,
//       this.refreshFromMultipleStories,
//       this.from,
//       this.whereFrom})
//       : super(key: key);
//   final String whereFrom;
//   final File file;
//   final Function refreshFromMultipleStories;
//   final String from;

//   @override
//   _StoryVideoEditorState createState() => _StoryVideoEditorState();
// }

// class _StoryVideoEditorState extends State<StoryVideoEditor> {
//   final _exportingProgress = ValueNotifier<double>(0.0);
//   final _isExporting = ValueNotifier<bool>(false);
//   final double height = 60;
//   bool _exported = false;
//   String _exportText = "";
//   VideoEditorController _controller;

//   @override
//   void initState() {
//     print(widget.file.path);
//     _controller = VideoEditorController.file(widget.file)
//       ..initialize().then((_) => setState(() {
//             print(_controller.videoDuration.inSeconds);
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

//     print(_controller.videoDuration.inSeconds);

//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => MultipleStoriesView(
//                   whereFrom: widget.whereFrom,
//                   refreshFromMultipleStories: widget.refreshFromMultipleStories,
//                   file: file,
//                   flip: false,
//                   from: widget.from,
//                 )));

//     setState(() => _exported = true);
//     Misc.delayed(2000, () => setState(() => _exported = false));
//   }

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
//               onTap: () {
//                 if (_controller.rotation == 0 &&
//                     _controller.videoDuration.inSeconds < 62 &&
//                     (_controller.maxTrim *
//                             _controller.videoDuration.inSeconds ==
//                         _controller.videoDuration.inSeconds) &&
//                     (_controller.minTrim *
//                             _controller.videoDuration.inSeconds ==
//                         0)) {
//                   print("not edited");

//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => MultipleStoriesView(
//                                 whereFrom: widget.whereFrom,
//                                 from: widget.from,
//                                 refreshFromMultipleStories:
//                                     widget.refreshFromMultipleStories,
//                                 file: widget.file,
//                                 flip: false,
//                               )));
//                 } else {
//                   print("Edited");
//                   _exportVideo();

//                   print(_controller.videoDuration.inSeconds);
//                   print(_controller.minTrim *
//                       _controller.videoDuration.inSeconds);
//                   print(_controller.maxTrim *
//                       _controller.videoDuration.inSeconds);
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
//           Text(
//             formatter(Duration(seconds: pos.toInt())),
//             // color: Colors.white,
//           ),
//           Expanded(child: SizedBox()),
//           OpacityTransition(
//             visible: _controller.isTrimming,
//             child: Row(mainAxisSize: MainAxisSize.min, children: [
//               Text(
//                 formatter(Duration(seconds: start.toInt())),
//                 // color: Colors.white,
//               ),
//               SizedBox(width: 10),
//               Text(
//                 formatter(Duration(seconds: end.toInt())),
//                 // color: Colors.white,
//               ),
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
