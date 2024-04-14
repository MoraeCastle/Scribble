import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribble/service/routing_service.dart';
import 'package:scribble/service/router_service.dart' as router;
import 'package:scribble/utils/routeObserver.dart';
import 'package:scribble/utils/string.dart';
import 'package:scribble/utils/system_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

// String route = HomeViewRoute;
String route = PermissionRoute;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  bool permission = await SystemUtil.getPermissionGranted();
  route = permission ? HomeViewRoute : PermissionRoute;

  FlutterNativeSplash.remove();
  runApp(const MyApp());
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
      navigatorObservers: [routeObserver],
    );
  }
}