import 'package:flutter/material.dart';
import 'package:scribble/service/routing_service.dart';
import 'package:scribble/service/router_service.dart' as router;

String route = HomeViewRoute;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    route = NoteListRoute;

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