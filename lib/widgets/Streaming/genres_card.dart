import 'package:bizbultest/models/Streaming/genres_model.dart';
import 'package:bizbultest/services/Streaming/Controllers/category_controller.dart';
import 'package:bizbultest/services/Streaming/Controllers/cover_page_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class GenresCard extends StatefulWidget {
  final int val;
  final Function onTap;
  final VoidCallback close;

  const GenresCard(
      {Key? key, required this.onTap, required this.close, required this.val})
      : super(key: key);

  @override
  _GenresCardState createState() => _GenresCardState();
}

TextStyle _style(double size, FontWeight weight, Color color) {
  return GoogleFonts.publicSans(
      fontSize: size, fontWeight: weight, color: color);
}

class _GenresCardState extends State<GenresCard> {
  CoverPageController controller = Get.put(CoverPageController());

  Widget _seasonListButton(String text, int index) {
    return Container(
      child: ListTile(
          onTap: () {
            controller.selectGenre(index, widget.val);
            widget.close();
            CategoryController categoryController =
                Get.put(CategoryController());
            if (widget.val == 1) {
              controller.selectedMovieGenre.value =
                  controller.genres(widget.val)[index].categoryName!;
              categoryController.fetchCategoricalMovies(
                  controller.genres(widget.val)[index].categoryId!);
            } else {
              controller.selectedSeriesGenre.value =
                  controller.genres(widget.val)[index].categoryName!;
              categoryController.fetchCategoricalSeries(
                  controller.genres(widget.val)[index].categoryId!);
            }
          },
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          dense: true,
          title: Center(
            child: Text(
              text,
              style: _style(
                controller.genres(widget.val)[index].selected!.value ? 22 : 16,
                controller.genres(widget.val)[index].selected!.value
                    ? FontWeight.bold
                    : FontWeight.normal,
                Colors.white,
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      height: 100.0.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 100.0.h - 80,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.genres(widget.val).length,
                  itemBuilder: (context, index) {
                    return _seasonListButton(
                        controller.genres(widget.val)[index].categoryName!,
                        index);
                  }),
            ),
            FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: Colors.white,
                child: Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
                onPressed: widget.close)
          ],
        ),
      ),
    );
  }
}
