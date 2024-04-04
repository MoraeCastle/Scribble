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
import 'package:scribble/utils/system_util.dart';

/// 메인 씬
class NoteEditView extends StatefulWidget {
  const NoteEditView({super.key});

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
                                toolBarColor: Colors.transparent,
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
                                minHeight: 500,
                                autoFocus: false,
                                textStyle: _editorTextStyle,
                                hintTextStyle: _hintTextStyle,
                                hintTextAlign: TextAlign.start,
                                padding: const EdgeInsets.only(left: 10, top: 10),
                                hintTextPadding: const EdgeInsets.only(left: 20),
                                backgroundColor: _backgroundColor,
                                inputAction: InputAction.newline,
                                onEditingComplete: (s) => debugPrint('Editing completed $s'),
                                loadingBuilder: (context) {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                        color: Colors.red,
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

  Future<void> _saveData() async {
    String path = await SystemUtil.getDataPath();

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
    File file = File(path + "/${title}.md");
    await file.writeAsString(htmlText);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Document saved')));

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