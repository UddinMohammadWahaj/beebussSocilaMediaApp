import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StoryTimeWidget extends StatelessWidget {
  final DateTime dateData;
  const StoryTimeWidget({Key? key, required this.dateData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateStr = DateFormat.jm().format(dateData);
    var ampm = dateStr.split(" ")[1];
    var time = dateStr.split(" ")[0];
    var hours = time.split(":")[0];
    var mini = time.split(":")[1].padLeft(2, '0');
    return Container(
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StoryTimeCard(
            timeText: hours.length > 1 ? hours.substring(0, 1) : "",
            subTimeText: ampm.toUpperCase(),
          ),
          StoryTimeCard(
            timeText: hours.length > 1 ? hours.substring(1, 2) : hours,
          ),
          SizedBox(width: 3),
          StoryTimeCard(
            timeText: mini.substring(0, 1),
          ),
          StoryTimeCard(
            timeText: mini.substring(1, 2),
          ),
        ],
      ),
    );
  }
}

class StoryTimeCard extends StatelessWidget {
  final String? timeText;
  final String? subTimeText;
  const StoryTimeCard({
    Key? key,
    this.timeText,
    this.subTimeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 28,
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.5),
              borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(1.5),
          child: Center(
            child: Text(
              timeText!,
              style: GoogleFonts.rajdhani().copyWith(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 1.5,
          right: 1.5,
          child: Center(
            child: Container(
              height: 2,
              width: double.infinity,
              color: Colors.black.withOpacity(.4),
            ),
          ),
        ),
        if (subTimeText != null)
          Positioned(
            bottom: 3,
            left: 3,
            child: Container(
              child: Text(
                subTimeText!,
                style: GoogleFonts.rajdhani().copyWith(
                    color: Colors.white,
                    fontSize: 7,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }
}
