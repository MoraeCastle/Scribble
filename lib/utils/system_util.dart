// 앱 내 주요 기능관련 클래스.
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scribble/utils/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemUtil {
  /// 권한 상태 확인.
  /// 하나라도 허용되어 있다면 허용 처리됨.
  static Future<bool> getPermissionGranted() async {
    bool storagePermission = await Permission.storage.isGranted;
    bool mediaPermission = await Permission.accessMediaLocation.isGranted;
    bool manageExternal = await Permission.manageExternalStorage.isGranted;

    return storagePermission || mediaPermission || manageExternal;
  }

  static Future<bool> isPermanentlyDenied() async {
    bool storagePermission = await Permission.storage.isPermanentlyDenied;
    bool mediaPermission = await Permission.accessMediaLocation.isPermanentlyDenied;
    bool manageExternal = await Permission.manageExternalStorage.isPermanentlyDenied;

    return storagePermission || mediaPermission || manageExternal;
  }

  /// 저장소 권한 요청.
  static Future<bool> requestPermission() async {
    bool storagePermission = await Permission.storage.isGranted;
    bool mediaPermission = await Permission.accessMediaLocation.isGranted;
    bool manageExternal = await Permission.manageExternalStorage.isGranted;

    if (!storagePermission) {
      storagePermission = await Permission.storage.request().isGranted;
    }

    if (!mediaPermission) {
      mediaPermission = await Permission.accessMediaLocation.request().isGranted;
    }

    if (!manageExternal) {
      manageExternal = await Permission.manageExternalStorage.request().isGranted;
    }

    bool isPermissionGranted =
        storagePermission || mediaPermission || manageExternal;

    if (isPermissionGranted) {
      return true;
    } else {
      return false;
    }
  }

  /// 메모 폴더가 없다면 폴더 생성.
  static Future<void> checkDirectory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // /data/data/com.sandcastle.scribble/app_flutter/ScribbleMemo
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory newPath = Directory('${appDocDirectory.path}/ScribbleMemo');

    Logger logger = Logger();
    logger.d(newPath.path);

    if (!await newPath.exists()) {
      await newPath.create(recursive: true).then((value) {
        logger.d('>>> 폴더 생성: 폴더가 생성되었습니다...');
      }, onError: (e) {
        logger.d('>>> 폴더 생성 : [오류 발생]: ' + e.toString());

      });
    } else {
      logger.d('>>> 폴더 생성: 이미 폴더가 있습니다...');
    }

    String path = prefs.getString(SystemData.path) ?? "";
    if (path.isEmpty) {
      prefs.setString(SystemData.path, newPath.path);
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
