import 'dart:async';

import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bizbultest/push/single_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'common_functions.dart';

class PhoneCallPage extends StatefulWidget {
//NPcom
  final ReceivedAction? receivedAction;

  //NPcom
  const PhoneCallPage({Key? key, this.receivedAction}) : super(key: key);

  @override
  State<PhoneCallPage> createState() => _PhoneCallPageState();
}

class _PhoneCallPageState extends State<PhoneCallPage> {
  Timer? _timer;
  Duration _secondsElapsed = Duration.zero;

  void startCallingTimer() {
    const oneSec = const Duration(seconds: 1);
    //NPcom
    AndroidForegroundService.stopForeground(1);

    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _secondsElapsed += oneSec;
        });
      },
    );
  }

  void finishCall() {
    /*  Vibration.vibrate(duration: 100);*/
    //NPcom
    AndroidForegroundService.stopForeground(1);
    Navigator.pop(context);
  }

  @override
  void initState() {
    lockScreenPortrait();
    super.initState();
    //NPcom
    if (widget.receivedAction!.buttonKeyPressed == 'ACCEPT')
      startCallingTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    unlockScreenPortrait();
    //NPcom
    AndroidForegroundService.stopForeground(1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    ThemeData themeData = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image

          //NPcom
          Image(
            image: widget.receivedAction!.largeIconImage!,
            fit: BoxFit.cover,
          ),

          // Black Layer
          DecoratedBox(
            decoration: BoxDecoration(color: Colors.black45),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //NPcom
                  Text(
                    widget.receivedAction!.payload!['username']
                            ?.replaceAll(r'\s+', r'\n') ??
                        'Unknow',
                    maxLines: 4,
                    style: themeData.textTheme.headline3
                        ?.copyWith(color: Colors.white),
                  ),
                  Text(
                    _timer == null
                        ? 'Incoming call'
                        : 'Call in progress: ${printDuration(_secondsElapsed)}',
                    style: themeData.textTheme.headline6?.copyWith(
                        color: Colors.white54,
                        fontSize: _timer == null ? 20 : 12),
                  ),
                  SizedBox(height: 50),
                  _timer == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(FontAwesomeIcons.solidClock,
                                        color: Colors.white54),
                                    Text('Reminder me',
                                        style: themeData.textTheme.headline6
                                            ?.copyWith(
                                                color: Colors.white54,
                                                fontSize: 12,
                                                height: 2))
                                  ],
                                )),
                            SizedBox(),
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.white12),
                              ),
                              child: Column(
                                children: [
                                  Icon(FontAwesomeIcons.solidEnvelope,
                                      color: Colors.white54),
                                  Text('Message',
                                      style: themeData.textTheme.headline6
                                          ?.copyWith(
                                              color: Colors.white54,
                                              fontSize: 12,
                                              height: 2))
                                ],
                              ),
                            )
                          ],
                        )
                      : SizedBox(),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.all(Radius.circular(45)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _timer == null
                          ? [
                              RoundedButton(
                                press: finishCall,
                                color: Colors.red,
                                icon: Icon(FontAwesomeIcons.phoneAlt,
                                    color: Colors.white),
                              ),
                              SingleSliderToConfirm(
                                onConfirmation: () {
                                  // Vibration.vibrate(duration: 100);
                                  startCallingTimer();
                                },
                                width: mediaQueryData.size.width * 0.55,
                                backgroundColor: Colors.white60,
                                text: 'Slide to Talk',
                                stickToEnd: true,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize:
                                            mediaQueryData.size.width * 0.05),
                                sliderButtonContent: RoundedButton(
                                  press: () {},
                                  color: Colors.white,
                                  icon: Icon(FontAwesomeIcons.phoneAlt,
                                      color: Colors.green),
                                ),
                              )
                            ]
                          : [
                              RoundedButton(
                                press: () {},
                                icon: Icon(FontAwesomeIcons.microphone),
                              ),
                              RoundedButton(
                                press: finishCall,
                                color: Colors.red,
                                icon: Icon(FontAwesomeIcons.phoneAlt,
                                    color: Colors.white),
                              ),
                              RoundedButton(
                                press: () {},
                                icon: Icon(FontAwesomeIcons.volumeUp),
                              ),
                            ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    this.size = 64,
    this.icon,
    this.color = Colors.white,
    this.press,
  }) : super(key: key);

  final double? size;
  final Icon? icon;
  final Color? color;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            )),
            padding:
                MaterialStateProperty.all(EdgeInsets.all(15 / 64 * size!))),
        // padding: EdgeInsets.all(15 / 64 * size),
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(100)),
        // ),
        // color: color,
        onPressed: press,
        child: icon,
      ),
    );
  }
}
