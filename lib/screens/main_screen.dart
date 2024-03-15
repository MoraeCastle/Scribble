import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribble/providers/data_provider.dart';
import 'package:scribble/screens/note_list_screen.dart';

/// 메인 씬
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataClass(),
      child: const Scaffold(
        body: NoteListView(),
      ),
    );
  }
}