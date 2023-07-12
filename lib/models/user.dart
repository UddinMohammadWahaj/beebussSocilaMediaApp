import 'dart:async';
import 'dart:io';

import 'package:multipart_request/multipart_request.dart' as mp;

class User {
  String? email;
  String? fullName;
  String? code;
  String? phone;
  String? shortcode;
  String? username;
  String? password;
  int? memberType;
  int? dobMonth;
  int? dobDay;
  int? dobYear;
  String? gender;
  String? memberID;
  String? image;
  String? country;
  String? logo;
  String? category;
  String? contactEmail;
  String? contactNumber;
  bool? shortbuzIsMuted = true;
  bool? feedIsMuted = true;
  String? followers;
  String? following;
  String? posts;
  String? otherMemberID;
  bool? autoplay;
  bool? changeNavbarColor;
  bool? isPlaying = true;
  bool? isUploading = false;
  File? file;
  bool? refreshProfile = false;
  bool? refreshStory = false;
  double? keyBoardHeight = 0;
  int? storyPostID;
  String? index;
  late mp.MultipartRequest storyRequest;
  late mp.MultipartRequest shortbuzRequest;
  String? timeZone;
  Timer? timer;
  String? token;
  bool? onlineStatus = false;
  String? currentOpenMemberID;
  String? currentOpenGroupID;
  String? aboutStatus;
  String? tradesmanType;
  String? properbuzLogo;
  String? shoppingbuzLogo;
  String? tradesmenLogo;  
  User(
      {this.properbuzLogo,
      this.shoppingbuzLogo,
      this.email,
      this.following,
      this.followers,
      this.posts,
      this.shortcode,
      this.fullName,
      this.memberType,
      this.changeNavbarColor,
      this.code,
      this.phone,
      this.username,
      this.password,
      this.dobDay,
      this.dobMonth,
      this.dobYear,
      this.gender,
      this.memberID,
      this.image,
      this.country,
      this.logo,
      this.category,
      this.shortbuzIsMuted,
      this.tradesmanType,
      this.contactEmail,
      this.onlineStatus,
      this.aboutStatus,
      this.tradesmenLogo,
      this.contactNumber});
}
