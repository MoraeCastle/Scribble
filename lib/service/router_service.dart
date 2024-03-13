import 'package:flutter/material.dart';
import 'package:scribble/screens/main_screen.dart';
import 'package:scribble/screens/note_edit_screen.dart';
import 'package:scribble/screens/note_list_screen.dart';
import 'package:scribble/screens/setting_screen.dart';
import 'package:scribble/service/routing_service.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => HomeView());
    case NoteListRoute:
      return MaterialPageRoute(builder: (context) => NoteListView());
    case NoteEditRoute:
      return MaterialPageRoute(builder: (context) => NoteEditView());
    case SettingRoute:
      return MaterialPageRoute(builder: (context) => SettingView());
    default:
      return MaterialPageRoute(builder: (context) => HomeView());
  }
}
