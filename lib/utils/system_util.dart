// 앱 내 주요 기능관련 클래스.
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scribble/utils/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemUtil {
  /// 저장소 권한 요청.
  static Future<bool> requestPermission() async {
    bool storagePermission = await Permission.storage.isGranted;
    bool mediaPermission = await Permission.accessMediaLocation.isGranted;
    bool manageExternal = await Permission.manageExternalStorage.isGranted;

    if (!storagePermission) {
      storagePermission = await Permission.storage.request().isGranted;
    }

    if (!mediaPermission) {
      mediaPermission =
      await Permission.accessMediaLocation.request().isGranted;
    }

    if (!manageExternal) {
      manageExternal =
      await Permission.manageExternalStorage.request().isGranted;
    }

    bool isPermissionGranted =
        storagePermission && mediaPermission && manageExternal;

    if (isPermissionGranted) {
      return true;
    } else {
      return false;
    }
  }

  /// 메모 폴더의 주소를 가져옵니다.
  static Future<String> getDataPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(SystemData.path) ?? "";
  }

  /// 날짜 형식변환.
  /// '2024-03-21 13:22'와 같은 형식으로 출력
  static String getDate(DateTime time) {
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(time);
    return formattedDate;
  }
}
