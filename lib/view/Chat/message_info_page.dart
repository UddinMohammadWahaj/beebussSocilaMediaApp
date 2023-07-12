import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Chat/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MessageInfoPage extends StatefulWidget {
  final ChatMessagesModel? message;

  const MessageInfoPage({Key? key, this.message}) : super(key: key);

  @override
  _MessageInfoPageState createState() => _MessageInfoPageState();
}

class _MessageInfoPageState extends State<MessageInfoPage> {
  ChatMessagesModel? newMessage;

  void _setMessage() {
    setState(() {
      newMessage = widget.message;
      newMessage!.isSelected = false;
    });
  }

  @override
  void initState() {
    _setMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: chatDetailScaffoldBgColor,
        elevation: 0,
        title: Text(
          AppLocalizations.of(
            "Message Info",
          ),
          style: whiteBold.copyWith(fontSize: 20),
        ),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 100.0.w,
                  color: chatDetailScaffoldBgColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: MessageItem(
                      message: newMessage,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Card(
                elevation: 3,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  CustomIcons.double_tick_indicator,
                                  size: 17,
                                  color: primaryBlueColor,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  AppLocalizations.of('Seen'),
                                  style: TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.message!.readTime!,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            thickness: 0.2,
                            color: Colors.grey,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  CustomIcons.double_tick_indicator,
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  AppLocalizations.of("Delivered"),
                                  style: TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.message!.receivedTime!,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
