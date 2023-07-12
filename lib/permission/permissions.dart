import 'package:permission_handler/permission_handler.dart';

class Permissions {
  Future<bool> getCameraPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();

    if (statuses[Permission.camera] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

class Permissions1{
  Future<bool> getCallpermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
    ].request();

    if (statuses[Permission.phone] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}
