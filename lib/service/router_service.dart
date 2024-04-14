import 'package:flutter/material.dart';
import 'package:scribble/screens/main_screen.dart';
import 'package:scribble/screens/note_edit_screen.dart';
import 'package:scribble/screens/note_list_screen.dart';
import 'package:scribble/screens/note_view_screen.dart';
import 'package:scribble/screens/permission_screen.dart';
import 'package:scribble/screens/setting_screen.dart';
import 'package:scribble/service/routing_service.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case PermissionRoute:
      return MaterialPageRoute(builder: (context) => PermissionView());
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => HomeView());
    case NoteListRoute:
      return MaterialPageRoute(builder: (context) => NoteListView());
    case NoteEditRoute:
      // 넘어가는 메모 제목...
      String? argument = settings.arguments as String?;

      return MaterialPageRoute(builder: (context) => NoteEditView(arguments: argument ?? ''));
    case NoteViewRoute:
      // 넘어가는 메모 제목...
      String? argument = settings.arguments as String?;

      return MaterialPageRoute(builder: (context) => NoteView(arguments: argument ?? ''));
    case SettingRoute:
      return MaterialPageRoute(builder: (context) => SettingView());
    default:
      return MaterialPageRoute(builder: (context) => HomeView());
  }
}
