import 'package:flutter/material.dart';
import 'package:scribble/screens/main_screen.dart';
import 'package:scribble/screens/note_list_screen.dart';
import 'package:scribble/service/routing_service.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => HomeView());
    case NoteListRoute:
      return MaterialPageRoute(builder: (context) => NoteListView());
    default:
      return MaterialPageRoute(builder: (context) => HomeView());
  }
}
