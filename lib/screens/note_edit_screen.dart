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
import 'package:scribble/screens/note_list_screen.dart';
import 'package:scribble/service/routing_service.dart';
import 'package:scribble/utils/system_util.dart';

/// 메인 씬
class NoteEditView extends StatefulWidget {
  const NoteEditView({Key? key, required this.arguments}) : super(key: key);

  final String arguments;

  @override
  State<NoteEditView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteEditView> {
  bool isDeleteMode = false;

  late TextEditingController titleController = TextEditingController();
  late QuillEditorController controller;
  final _toolbarColor = Colors.grey.shade200;
  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontFamily: 'Roboto');
  final _hintTextStyle = const TextStyle(
      fontSize: 18, color: Colors.black38, fontWeight: FontWeight.normal);
  bool _hasFocus = false;
  Memo item = Memo();

  @override
  void initState() {
    controller = QuillEditorController();
    controller.onTextChanged((text) {
      debugPrint('listening to $text');
    });
    controller.onEditorLoaded(() {
      debugPrint('Editor Loaded :)');
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
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
          if (line.substring(6).trim() == widget.arguments) {
            item.setTitle(line.substring(6).trim());
          }
        } else if (line.startsWith('# 작성일:')) {
          String dateString = line.substring(7).trim();
          item.setDate(DateTime.parse(dateString));
        }
      }

      if (item.getTitle().isNotEmpty) {
        String content = lines.skipWhile((line) => line.startsWith('#')).join('\n').trim();
        item.setContent(content);

        break;
      }
    }

    debugPrint('dfsdfsdfsdfdsf');

    titleController.text = item.getTitle();
    controller.setText(item.getContent());

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAutoDismiss(
      scaffold: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // 탑 바
                Container(
                  width: double.infinity,
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
                          child: TextField(
                            controller: titleController,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: '제목',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                BorderSide(width: 1, color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                BorderSide(width: 1, color: Colors.black),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(11),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      IconButton(
                        onPressed: () => _saveData(),
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
                          Icons.save_outlined,
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
                        margin: EdgeInsets.only(top: 10),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: ToolBar.scroll(
                                toolBarColor: Colors.white,
                                activeIconColor: Colors.black,
                                padding: const EdgeInsets.all(8),
                                iconSize: 20,
                                iconColor: Colors.grey,
                                controller: controller,
                              ),
                            ),
                            Expanded(
                              child: QuillHtmlEditor(
                                text: "",
                                hintText: '내용 입력...',
                                controller: controller,
                                isEnabled: true,
                                ensureVisible: false,
                                minHeight: 10,
                                autoFocus: false,
                                textStyle: _editorTextStyle,
                                hintTextStyle: _hintTextStyle,
                                hintTextAlign: TextAlign.start,
                                padding: const EdgeInsets.only(left: 10, top: 10),
                                hintTextPadding: const EdgeInsets.only(left: 20),
                                backgroundColor: Colors.transparent,
                                inputAction: InputAction.newline,
                                onEditingComplete: (s) => debugPrint('Editing completed $s'),
                                loadingBuilder: (context) {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                        color: Colors.black,
                                      ));
                                },
                                onFocusChanged: (focus) {
                                  debugPrint('has focus $focus');

                                  if (mounted) {
                                    setState(() {
                                      _hasFocus = focus;
                                    });
                                  }
                                },
                                onTextChanged: (text) => debugPrint('widget text change $text'),
                                onEditorCreated: () {
                                  debugPrint('Editor has been loaded');

                                  // 메모 수정모드일 경우...
                                  if (widget.arguments.isNotEmpty) {
                                    readMemoFiles();
                                  }
                                  // setHtmlText('Testing text on load');
                                },
                                onEditorResized: (height) =>
                                    debugPrint('Editor resized $height'),
                                onSelectionChanged: (sel) =>
                                    debugPrint('index ${sel.index}, range ${sel.length}'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget textButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: _toolbarIconColor,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: _toolbarColor),
          )),
    );
  }

  Future<String> getHtmlText() async {
    String? htmlText = await controller.getText();
    return htmlText;
  }
  void setHtmlText(String text) async {
    await controller.setText(text);
  }

  void insertNetworkImage(String url) async {
    await controller.embedImage(url);
  }
  void insertVideoURL(String url) async {
    await controller.embedVideo(url);
  }

  void insertHtmlText(String text, {int? index}) async {
    await controller.insertText(text, index: index);
  }
  void clearEditor() => controller.clear();
  void enableEditor(bool enable) => controller.enableEditor(enable);
  void unFocusEditor() => controller.unFocus();

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/document.txt');
  }

  /// 같은 제목의 메모가 있는지 검증.
  Future<String> getAvailableMemoFileName(String desiredFileName) async {
    // 메모 파일이 있는 경로
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String appPath = appDirectory.path;
    String memoFolderPath = '$appPath/ScribbleMemo';

    // 디렉토리 열기
    Directory memoDirectory = Directory(memoFolderPath);

    // 디렉토리 내 파일들 읽기
    List<FileSystemEntity> files = memoDirectory.listSync();

    // 동일한 제목을 가진 메모 파일들 검사
    int count = 1;
    String newFileName = desiredFileName;
    while (files.any((file) => file.path.endsWith('/$newFileName.md'))) {
      newFileName = '$desiredFileName ($count)';
      count++;
    }

    return newFileName;
  }

  /// 메모 수정.
  Future<void> editMemo(String fileName, String newTitle, String newContent) async {
    // 메모 파일이 있는 경로
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String appPath = appDirectory.path;
    String memoFolderPath = '$appPath/ScribbleMemo';
    String oldFilePath = '$memoFolderPath/$fileName.md';

    // 새로운 파일 이름 생성
    String newFileName = '$newTitle.md';
    String newFilePath = '$memoFolderPath/$newFileName';

    // 파일 읽기
    File memoFile = File(oldFilePath);
    String fileContent = await memoFile.readAsString();

    DateTime currentDate = DateTime.now();
    String formattedDate = currentDate.toIso8601String();

    // 제목과 내용 수정
    /*String updatedContent = fileContent.replaceAllMapped(
        RegExp(r'^# 제목: .+$', multiLine: true), (match) => '# 제목: $newTitle');
    updatedContent = updatedContent.replaceAllMapped(
        RegExp(r'^# 작성일: .+$', multiLine: true), (match) => '# 작성일: $formattedDate');
    updatedContent = updatedContent.replaceAllMapped(
        RegExp(r'(?<=^# 작성일: .+\n\n).+?(?=\n*$)', multiLine: true), (match) => newContent);*/
    String updatedContent = fileContent
        .replaceFirst(RegExp(r'^# 제목: .+$', multiLine: true), '# 제목: $newTitle')
        .replaceFirst(RegExp(r'^# 작성일: .+$', multiLine: true), '# 작성일: $formattedDate')
        .replaceFirst(RegExp(r'(?<=^# 작성일: .+\n\n).+', multiLine: true), newContent);

    // 제목도 수정인지, 내용만 수정인지 구분.
    if (fileName != newTitle) {
      // 수정된 내용을 새 파일에 저장
      File newMemoFile = File(newFilePath);
      await newMemoFile.writeAsString(updatedContent);

      // 기존 파일 삭제
      await memoFile.delete();
    } else {
      // 내용만 수정일 경우.
      await memoFile.writeAsString(updatedContent);
    }
  }

  /// 메모 저장.
  Future<void> _saveData() async {
    // 수정모드라면 해당 메모 수정.
    if (widget.arguments.isNotEmpty) {
      String htmlText = await getHtmlText();
      await editMemo(widget.arguments, titleController.text, htmlText);

      // 홈으로 돌아가기.
      Navigator.pop(context);
      //Navigator.pushReplacementNamed(context, NoteListRoute);
      return;
    }

    // String path = await SystemUtil.getDataPath();
    // 도큐먼트 디렉토리 경로를 가져옵니다.
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory newPath = Directory('${appDocDirectory.path}/ScribbleMemo');

    // ScribbleMemo 디렉토리가 존재하지 않으면 생성합니다.
    if (!await newPath.exists()) {
      await newPath.create(recursive: true);
    }

    // final file = await _getLocalFile();
    String htmlText = await getHtmlText();

    DateTime currentDate = DateTime.now();
    String formattedDate = currentDate.toIso8601String();
    String title = titleController.text;

    if (title.isEmpty) {
      title = SystemUtil.getDate(currentDate);
    } else {
      // 같은 제목이 폴더 안에 있으면 (N)의 제목을 붙인다.
      title = await getAvailableMemoFileName(title);
    }

    htmlText = '# 제목: ${title}\n'
        '# 작성일: $formattedDate\n\n'
        '${htmlText}';

    // 제목이 같으면 덮어쓰기 되므로 조심...
    File file = File('${newPath.path}/$title.md');
    await file.writeAsString(htmlText);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('메모가 저장되었습니다.')));

    // 홈으로 돌아가기.
    Navigator.pop(context);
  }

  Future<String?> _readData() async {
    try {
      final file = await _getLocalFile();
      return await file.readAsString();
    } catch (e) {
      return null;
    }
  }
}