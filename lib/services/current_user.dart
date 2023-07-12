import 'package:bizbultest/models/user.dart';

class CurrentUser {
  CurrentUser._internal();
  static final CurrentUser _singleton = CurrentUser._internal();
  factory CurrentUser() => _singleton;
  User currentUser = User();
}

class OtherUser {
  OtherUser._internal();
  static final OtherUser _singleton = OtherUser._internal();
  factory OtherUser() => _singleton;
  User otherUser = User();
}
