import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedmaincontroller.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:polls/polls.dart';
import 'package:sizer/sizer.dart';

class PollView extends StatefulWidget {
  List? polllist;
  String? answerId;
  BuzzerfeedMainController? buzzerfeedMainController;
  var userIndex;
  PollView(
      {this.polllist,
      this.buzzerfeedMainController,
      this.userIndex,
      this.answerId});
  @override
  _PollViewState createState() => _PollViewState();
}

class _PollViewState extends State<PollView> {
  double option1 = 0.0;
  double option2 = 0.0;
  double option3 = 0.0;
  double option4 = 0.0;
  double option5 = 1.0;
  double option6 = 3.0;
  double option7 = 2.0;
  double option8 = 1.0;

  String user = "king@mail.com";
  Map usersWhoVoted = {
    'sam@mail.com': 0,
    'mike@mail.com': 0,
    'john@mail.com': 0,
    'kenny@mail.com': 0,
  };
  String creator = "eddy@mail.com";

//  List<Widget> ch = widget.polllist;

  h() {
    widget.polllist!.forEach((element) {
      return element;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map map = widget.polllist!.asMap();
    int index = 0;
    for (int i = 0; i < widget.polllist!.length; i++) {
      index = i;
    }
    return Container(
        // color: Colors.black,
        // height: (widget.polllist.length == 2)
        //     ? 20.0.h
        //     : (widget.polllist.length == 3)
        //         ? 30.0.h
        //         : 35.0.h,
        width: 100.0.w,
        child: Polls(
          children: widget.polllist!.toList(),
          // ListView.builder(
          //     physics: NeverScrollableScrollPhysics(),
          //     itemCount: widget.polllist.length,
          //     itemBuilder: (context, index) {
          //       return widget.polllist[index];
          //     })

          // widget.polllist[0],
          // widget.polllist[1]
          // This cannot be less than 2, else will throw an exception
          // Polls.options(title: widget.polllist, value: option1),
          // Polls.options(title: 'Mecca', value: option2),
          // Polls.options(title: 'Denmark', value: option3),
          // Polls.options(title: 'Mogadishu', value: option4),
          // viewType: PollsType.readOnly,
          question: Text(''),
          currentUser: this.user,
          creatorID: this.creator,
          voteData: map,
          userChoice: map[this.user],
          onVoteBackgroundColor: Colors.blue,
          leadingBackgroundColor: Colors.blue,
          backgroundColor: Colors.white,
          onVote: (choice) {
            print("----- $choice");

            widget.buzzerfeedMainController!
                .pollvote(widget.answerId, choice - 1);

            // widget. buzzerfeedMainController.pollvote(
            //           widget.buzzerfeedMainController
            //               .listbuzzerfeeddata[this.userindex]
            //               .pollAnswer[index]
            //               .answerId,
            //           this.userindex);
            // setState(() {
            //   map[this.user] = choice;
            // });
            // if (choice == 1) {
            //   setState(() {
            //     option1 += 0.1;
            //   });
            // }
            // if (choice == 2) {
            //   setState(() {
            //     option2 += 1.0;
            //   });
            // }
            // if (choice == 3) {
            //   setState(() {
            //     option3 += 1.0;
            //   });
            // }
            // if (choice == 4) {
            //   setState(() {
            //     option4 += 1.0;
            //   });
            // }
          },
        )

        // Polls(
        //   children:

        //       // widget.polllist
        //       [
        //     // This cannot be less than 2, else will throw an exception
        //     Polls.options(
        //       title: 'Cairo',
        //       value: option1,
        //     ),
        //     Polls.options(title: 'Mecca', value: option2),
        //     Polls.options(title: 'Denmark', value: option3),
        //     Polls.options(title: 'Mogadishu', value: option4),
        //   ],
        //   question: Text(''),
        //   currentUser: this.user,
        //   outlineColor: Colors.black,
        //   creatorID: this.creator,
        //   voteData: usersWhoVoted,
        //   userChoice: usersWhoVoted[this.user],
        //   onVoteBackgroundColor: Colors.blueGrey,
        //   leadingBackgroundColor: Colors.blueGrey,
        //   backgroundColor: Colors.white,
        //   onVote: (choice) async {
        //     print("poll choice =${choice}");

        //     print(choice);
        //     setState(() {
        //       this.usersWhoVoted[this.user] = choice;
        //     });

        //     try {
        //       var answerId = widget
        //           .buzzerfeedMainController
        //           .listbuzzerfeeddata[widget.userIndex]
        //           .pollAnswer[choice - 1]
        //           .answerId;
        //       widget.buzzerfeedMainController.pollvote(answerId);
        //     } catch (e) {
        //       print("poll exception $e");
        //     }
        //     if (choice == 1) {
        //       setState(() {
        //         option1 += 0.5;
        //       });
        //     }
        //     if (choice == 2) {
        //       setState(() {
        //         option2 += 1.0;
        //       });
        //     }
        //     if (choice == 3) {
        //       setState(() {
        //         option3 += 1.0;
        //       });
        //     }
        //     if (choice == 4) {
        //       setState(() {
        //         option4 += 1.0;
        //       });
        //     }
        //     if (choice == 5) {
        //       setState(() {
        //         option5 += 1.0;
        //       });
        //     }
        //     if (choice == 6) {
        //       setState(() {
        //         option6 += 1.0;
        //       });
        //     }
        //     if (choice == 7) {
        //       setState(() {
        //         option7 += 1.0;
        //       });
        //     }
        //     if (choice == 8) {
        //       setState(() {
        //         option8 += 1.0;
        //       });
        //     }
        //   },
        // ),
        );
  }
}
