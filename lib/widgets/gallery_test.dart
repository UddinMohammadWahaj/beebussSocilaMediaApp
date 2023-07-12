import 'dart:async';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final Directory _photoDir = new Directory('/storage/emulated/0/');

void main() => runApp(GalleryTest());

class GalleryTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(
        'Document Scanner',
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageCapture(),
    );
  }
}

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of('Doc Scanner'),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          builder: (context, status) {
            return ImageGrid(directory: _photoDir);
          },
        ),
      ),
    );
  }
}

class ImageGrid extends StatelessWidget {
  final Directory? directory;

  const ImageGrid({Key? key, this.directory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var refreshGridView;
    var imageList = directory!
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".jpg"))
        .toList(growable: false);
    return GridView.builder(
      itemCount: imageList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 3.0 / 4.6),
      itemBuilder: (context, index) {
        File file = new File(imageList[index]);
        String name = file.path.split('/').last;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () => {
                /* refreshGridView =
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ImageEditClass(
                        imagepath: imageList[index],
                      );
                    })).then((refreshGridView) {
                      if (refreshGridView != null) {
                        build(context);
                      }
                    }).catchError((er) {
                      print(er);
                    }),*/
              },
              child: Padding(
                padding: new EdgeInsets.all(4.0),
                child: Image.file(
                  File(imageList[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
