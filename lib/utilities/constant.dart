import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final isIOS = Platform.isIOS;

TextStyle greyNormal = TextStyle(
  color: Colors.grey,
);

TextStyle greyBold = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold);

TextStyle whiteBold = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

TextStyle whiteNormal = TextStyle(color: Colors.white, fontWeight: FontWeight.normal);

final TextStyle buttonTextStyle = TextStyle(
  fontSize: 16,
);

TextStyle blackBold = TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

TextStyle blackBoldShaded = TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold);

TextStyle blackLight = TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.normal);