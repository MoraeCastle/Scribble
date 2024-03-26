import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keyboard_service/keyboard_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribble/models/Memo.dart';
import 'package:scribble/providers/data_provider.dart';
import 'package:scribble/service/routing_service.dart';
import 'package:provider/provider.dart';
import 'package:scribble/utils/system_util.dart';

/// 메인 씬
class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  bool isDeleteMode = false;
  List<Memo> currentMemoList = [];

  @override
  void initState() {
    super.initState();
    debugPrint('>>> NoteListView: initState');

    currentMemoList = context.read<DataClass>().memoList;
    readMemoFiles();
  }

  @override
  void dispose() {
    super.dispose();

    debugPrint('>>> NoteListView: dispose');
  }

  /// 리스트 최신화.
  refreshMemoList() {
    debugPrint('>>> NoteListView: refreshMemoList...');

    if (mounted) {
      setState(() {
        currentMemoList = context.read<DataClass>().memoList;
      });
    }
  }

  List<Widget> setMemoList(List<Memo> dataList) {
    List<Widget> resultList = [];

    for (Memo item in dataList) {
      resultList.add(
          MemoItem(
            item: item,
            action: () {

            },
            longAction: () {
              if (!isDeleteMode) {
                setState(() {
                  isDeleteMode = true;
                });
              }
            },
            isSelectMode: isDeleteMode,
          )
      );
    }

    return resultList;
  }

  Future<void> readMemoFiles() async {
    currentMemoList.clear();

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
      Memo item = Memo();

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

      // 메모 내용 추출 (제목과 작성일은 제외)
      String content = lines.skipWhile((line) => line.startsWith('#')).join('\n').trim();
      item.setContent(content);

      // 위젯 리스트에 추가
      currentMemoList.add(item);
    }

    Provider.of<DataClass>(context, listen: false).memoList = currentMemoList;

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
                    margin: const EdgeInsets.all(15),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Text(
                          '메모 목록',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, NoteEditRoute).then((value) {
                                  refreshMemoList();
                                });
                              },
                              style: IconButton.styleFrom(
                                elevation: 5,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.grey,
                                surfaceTintColor: Colors.white,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              icon: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '새 메모',
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, SettingRoute);
                                },
                                style: IconButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.grey,
                                  surfaceTintColor: Colors.white,
                                  shadowColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: Colors.black, width: 1),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                ),
                // 리스트
                Expanded(
                    child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 15
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            context.watch<DataClass>().memoList.isNotEmpty ?
                            noteList(
                              context.watch<DataClass>().memoList
                            ) : emptyList(),
                            Positioned.fill(
                              child: Visibility(
                                visible: currentMemoList != context.watch<DataClass>().memoList,
                                child: Container(
                                  color: Colors.white,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    )
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget noteList(List<Memo> dataList) {
    return Positioned.fill(
      child: Column(
        children: [
          isDeleteMode ? deleteBar() : normalBar(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: setMemoList(
                    context.watch<DataClass>().memoList
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$dataList.length 개의 메모 조회됨',
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget emptyList() {
    return const Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off_outlined,
            size: 50,
            color: Colors.grey,
          ),
          SizedBox(height: 15),
          Text(
            '아직 메모가 없습니다.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            '새 메모를 작성해보세요.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  Widget normalBar() {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: IconButton(
            onPressed: () {

            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.grey,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
            icon: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.sort_outlined,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '정렬',
                  style: TextStyle(fontSize: 13, color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 9,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Icon(
                    Icons.search,
                    size: 15,
                    color: Colors.black,
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: TextField(
                    style: TextStyle( // 입력 내용의 스타일 설정
                      fontSize: 11, // 폰트 크기
                      color: Colors.black, // 폰트 색상
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none, // 테두리 없애기
                      hintText: '검색어 입력...',
                      hintStyle: TextStyle(
                        fontSize: 10,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.all(0),
                    ),
                    textAlign: TextAlign.right, // 입력 방향을 우측으로 설정
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget deleteBar() {
    return Row(
      children: [
        Expanded(
          child: IconButton(
            onPressed: () {
              /*setState(() {
                isDeleteMode = false;
              });*/
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.withAlpha(50),
              foregroundColor: Colors.grey,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
            icon: const Text(
              '탭해서 삭제',
              style: TextStyle(fontSize: 13, color: Colors.black),
            )
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              isDeleteMode = false;
            });
          },
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Colors.black, width: 1),
            ),
          ),
          icon: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.close,
                color: Colors.black,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '취소',
                style: TextStyle(fontSize: 13, color: Colors.black),
              )
            ],
          ),
        ),
      ],
    );
  }
}

// 메모 아이템
class MemoItem extends StatefulWidget {
  // final User user;
  final Memo item;
  final VoidCallback action;
  final VoidCallback longAction;
  final bool isSelectMode;

  const MemoItem(
      {Key? key,
        required this.action, required this.longAction, required this.isSelectMode, required this.item})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MemoItem();
}
class _MemoItem extends State<MemoItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.black.withAlpha(50),
            width: 1
        ),
      ),
      elevation: 4.0, //그림자 깊이
      child: InkWell(
        onTap: () {
          setState(() {
            isChecked = !isChecked;
          });
        },
        onLongPress: widget.isSelectMode ? null : widget.longAction,
        child: Container(
          height: 130,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                            flex: 4,
                            child: Container(
                                width: double.infinity,
                                child: Text(
                                  widget.item.getTitle(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis
                                  ),
                                )
                            )
                        ),
                        Flexible(
                            flex: 4,
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    SystemUtil.getDate(widget.item.getDate()),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.text_fields_outlined,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.item.getRemoveHtmlTags().length.toString(),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                ],
                              ),
                            )
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10
                      ),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          widget.item.getRemoveHtmlTags(),
                          maxLines: 3,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.isSelectMode,
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(150),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Visibility(
                    visible: isChecked,
                    child: const Icon(
                      Icons.check,
                      size: 50,
                      color: Colors.green,
                    ),
                  )
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}