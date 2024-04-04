import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:keyboard_service/keyboard_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:scribble/models/Memo.dart';
import 'package:scribble/utils/system_util.dart';

/// 메모 읽기 씬.
class NoteView extends StatefulWidget {
  const NoteView({Key? key, required this.arguments}) : super(key: key);

  final String arguments;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  Memo item = Memo();

  @override
  void initState() {
    super.initState();

    readMemoFiles();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 메모 파일 읽기...
  Future<void> readMemoFiles() async {
    // 앱의 디렉토리 경로 가져오기
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String appPath = appDirectory.path;

    // 메모 파일이 있는 경로
    String memoFolderPath = '$appPath/ScribbleMemo';

    // 디렉토리 열기
    Directory memoDirectory = Directory(memoFolderPath);

    // 디렉토리 내 파일들 읽기
    List<FileSystemEntity> files = memoDirectory.listSync();

    // 각 파일에 대해
    for (FileSystemEntity file in files) {
      // 파일 읽기
      String fileContent = await File(file.path).readAsString();
      // 파일 내용을 줄 단위로 나누기
      List<String> lines = fileContent.split('\n');

      for (String line in lines) {
        if (line.startsWith('# 제목:')) {
          item.setTitle(line.substring(6).trim());
        } else if (line.startsWith('# 작성일:')) {
          String dateString = line.substring(7).trim();
          item.setDate(DateTime.parse(dateString));
        }
      }

      // 맞는 제목만.
      if (item.getTitle() != widget.arguments) continue;

      String content = lines.skipWhile((line) => line.startsWith('#')).join('\n').trim();
      item.setContent(content);
    }

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // 탑 바
              Container(
                width: double.infinity,
                height: 40,
                margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: IconButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey,
                        surfaceTintColor: Colors.white,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      icon: const Icon(
                        Icons.chevron_left_outlined,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Material(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            widget.arguments,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      onPressed: () => _writeNote(),
                      style: IconButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey,
                        surfaceTintColor: Colors.white,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // 리스트
              Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 15
                    ),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(top: 10),
                      child: item.getContent().isNotEmpty ? SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              '${item.getRemoveHtmlTags()}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ) : null,
                    ),
                  )
              ),
            ],
          ),
        )
    );
  }

  void _writeNote() {}

}