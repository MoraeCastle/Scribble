import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribble/service/routing_service.dart';
import 'package:scribble/service/router_service.dart' as router;
import 'package:scribble/utils/string.dart';
import 'package:scribble/utils/system_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

String route = HomeViewRoute;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SystemUtil.requestPermission();
  await checkDirectory();

  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

/// 메모 폴더가 없다면 폴더 생성.
Future<void> checkDirectory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  Directory newPath = Directory('${appDocDirectory.path}/ScribbleMemo');

  if (!await newPath.exists()) {
    await newPath.create(recursive: true).then((value) {
      debugPrint('>>> 폴더 생성: 폴더가 생성되었습니다...');
    }, onError: (e) {
      debugPrint('>>> 폴더 생성 : [오류 발생]: ' + e.toString());

    });
  } else {
    debugPrint('>>> 폴더 생성: 이미 폴더가 있습니다...');
  }

  String path = prefs.getString(SystemData.path) ?? "";
  if (path.isEmpty) {
    prefs.setString(SystemData.path, newPath.path);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // route = NoteListRoute;

    return MaterialApp(
      title: '끄적끄적',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => router.generateRoute(settings),
      initialRoute: route,
    );
  }
}