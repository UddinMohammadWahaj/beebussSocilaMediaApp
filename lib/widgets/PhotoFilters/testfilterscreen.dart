import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/widgets/photo_filter.dart';

class TestFilterScreen extends StatelessWidget {
  List<File>? image;
  TestFilterScreen({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Center(
          child: ListView.builder(
            itemCount: this.image!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Image.file(
                this.image![index],
                fit: BoxFit.contain,
              );
            },
          ),
        ));
  }
}
