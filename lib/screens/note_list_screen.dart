import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:keyboard_service/keyboard_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribble/models/Memo.dart';
import 'package:scribble/providers/data_provider.dart';
import 'package:scribble/service/routing_service.dart';
import 'package:provider/provider.dart';
import 'package:scribble/utils/routeObserver.dart';
import 'package:scribble/utils/string.dart';
import 'package:scribble/utils/system_util.dart';

/// 메인 씬
class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> implements RouteAware {
  bool isDeleteMode = false;
  List<Memo> currentMemoList = [];
  /// TODO: 남은 기능
  /// 정렬 및 검색 기능....
  List<Memo> searchMemoList = [];

  List<String> selectMemos = [];
  TextEditingController searchController = TextEditingController();

  // 기본값은 최근 데이터...
  String sortType = SystemData.koSortType[1];

  @override
  void initState() {
    super.initState();
    debugPrint('>>> NoteListView: initState');

   /* currentMemoList = context.read<DataClass>().memoList;
    searchMemoList.addAll(currentMemoList);*/

    readMemoFiles();

    routeObserver.subscribe(this);
  }

  @override
  void dispose() {
    debugPrint('>>> NoteListView: dispose');

    routeObserver.unsubscribe(this);

    super.dispose();
  }


  @override
  void didPop() {
    debugPrint('didPop..........');

    // 화면으로 다시 돌아온 경우.
    readMemoFiles();
  }
  @override
  void didPopNext() {
    debugPrint('didPopNext..........');
  }
  @override
  void didPush() {
    debugPrint('didPush..........');
  }
  @override
  void didPushNext() {
    debugPrint('didPushNext..........');
  }

  /// 메모 데이터 정렬.
  List<Memo> sortMemos(List<Memo> memoList, String sortType) {
    // 리스트 복제.
    List<Memo> sortedList = List.from(memoList);

    // 아직은 한국어만....
    switch (sortType) {
      case '가나다순':
        sortedList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case '최근':
        sortedList.sort((a, b) => b.date.compareTo(a.date));
        break;
      case '처음':
        sortedList.sort((a, b) => a.date.compareTo(b.date));
        break;
      case '내용':
        sortedList.sort((a, b) => b.content.length.compareTo(a.content.length));
        break;
    }

    return sortedList;
  }

  /// 메모 데이터를 위젯으로 변환....
  /// 내부에 검색 조건있음.
  List<Widget> setMemoList(List<Memo> dataList) {
    List<Widget> resultList = [];

    debugPrint('갯수는...' + dataList.length.toString());

    searchMemoList.clear();
    searchMemoList.addAll(sortMemos(dataList, sortType));

    for (Memo item in searchMemoList) {
      resultList.add(
          MemoItem(
            item: item,
            action: () {
              Navigator.pushNamed(context, NoteViewRoute, arguments: item.title);
            },
            deleteAction: () {
              // 중복데이터 방지.
              if (!selectMemos.contains(item.title)) {
                selectMemos.add(item.title);
              } else {
                selectMemos.remove(item.title);
              }
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

  /// 메모 파일 읽기...
  Future<void> readMemoFiles() async {
    currentMemoList.clear();

    // 앱의 디렉토리 경로 가져오기
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String appPath = appDirectory.path;

    // 메모 파일이 있는 경로
    String memoFolderPath = '$appPath/ScribbleMemo';

    // 디렉토리 열기
    Directory memoDirectory = Directory(memoFolderPath);

    if (await memoDirectory.exists() == false) {
      await memoDirectory.create(recursive: true);
    }

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
    Provider.of<DataClass>(context, listen: false).searchMemoList = getSearchMemoList(
      searchController.text
    );

    setState(() {
    });
  }

  /// 메모 삭제.
  Future<void> deleteMemo(String fileName) async {
    try {
      // 메모 파일이 있는 경로
      Directory appDirectory = await getApplicationDocumentsDirectory();
      String appPath = appDirectory.path;
      String memoFolderPath = '$appPath/ScribbleMemo';
      String filePath = '$memoFolderPath/$fileName.md';

      // 파일 삭제
      File memoFile = File(filePath);
      await memoFile.delete();

      debugPrint('$fileName 이 삭제되었습니다.');
    } catch (e) {
      debugPrint('삭제증 오류가 발생했습니다.... : $e');
    }
  }

  // 선택한 메모 파일들 삭제.
  Future<void> deleteMemos(List<String> targetMemos) async {
    for (String target in targetMemos) {
      await deleteMemo(target);
    }

    setState(() {
      selectMemos.clear();

      isDeleteMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${targetMemos.length} 개의 메모가 삭제되었습니다.'))
    );

    readMemoFiles();
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
                                  // 메모 수정 -> 홈으로 돌아왔을 때...
                                  //readMemoFiles();
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
                            noteList(
                              context.watch<DataClass>().searchMemoList
                            ),
                            /// 로딩창
                            Positioned.fill(
                              child: Visibility(
                                visible: !mounted,
                                // visible: context.watch<DataClass>().memoList.isEmpty,
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

  /// 메모 리스트
  Widget noteList(List<Memo> dataList) {
    // 메모 데이터가 아무것도 없을 때.
    if (context.watch<DataClass>().memoList.isEmpty) {
      return emptyList();
    }

    return Positioned.fill(
      child: Column(
        children: [
          isDeleteMode ? deleteBar() : normalBar(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: setMemoList(dataList),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${dataList.length} 개의 메모 조회됨',
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
          flex: 4,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: const Row(
                children: [
                  Icon(
                    Icons.sort_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      '정렬',
                      style: TextStyle(fontSize: 13, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: SystemData.koSortType
                  .map((String type) => DropdownMenuItem<String>(
                value: type,
                child: Text(
                  type,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
                  .toList(),
              value: sortType,
              onChanged: (value) {
                setState(() {
                  sortType = value ?? '최근';
                });
              },
              buttonStyleData: ButtonStyleData(
                padding: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  ),
                  color: Colors.white,
                ),
                // elevation: 2,
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                ),
                iconSize: 14,
                iconEnabledColor: Colors.black,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                // maxHeight: 200,
                // width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: Colors.black,
                      width: 1
                  ),
                  color: Colors.white,
                ),
                // offset: const Offset(-20, 0),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all(6),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          ),
          /*child: IconButton(
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
          ),*/
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 9,
          child: Container(
            width: double.infinity,
            height: 40,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      Provider.of<DataClass>(context, listen: false).searchMemoList =
                          getSearchMemoList(searchController.text);
                    },
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.search,
                      size: 15,
                      color: Colors.black,
                    ),
                  )
                ),
                Flexible(
                  flex: 8,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        Provider.of<DataClass>(context, listen: false).searchMemoList =
                            getSearchMemoList(value);
                      }
                      /// 메모 데이터 다시 정렬....
                      /*Provider.of<DataClass>(context, listen: false).searchMemoList =
                          getSearchMemoList(value);*/
                    },
                    /*onSubmitted: (value) {
                      debugPrint('onSubmitted.......................');
                    },*/
                    onEditingComplete: () {
                      Provider.of<DataClass>(context, listen: false).searchMemoList =
                          getSearchMemoList(searchController.text);
                    },
                    style: TextStyle( // 입력 내용의 스타일 설정
                      fontSize: 11, // 폰트 크기
                      color: Colors.black, // 폰트 색상
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none, // 테두리 없애기
                      hintText: '입력 후 검색 버튼을 누르세요...',
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

  /// 검색어에 따라 새로운 메모 데이터 리스트를 반환합니다.
  List<Memo> getSearchMemoList(String temp) {
    List<Memo> answer = [];
    List<Memo> searchList = [];
    searchList.addAll(context.read<DataClass>().memoList);

    // 타이틀이나 내용 중에 검색어가 들어가면 추가.
    for (Memo item in searchList) {
      if (item.title.contains(temp) || item.getRemoveHtmlTags().contains(temp)) {
        answer.add(item);
      }
    }

    debugPrint('${answer.length} 개의 데이터 변환');
    
    return answer;
  }


  Widget deleteBar() {
    return Row(
      children: [
        Expanded(
          child: IconButton(
            onPressed: () {
              // 선택한 메모들 삭제...
              deleteMemos(selectMemos);
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
  final VoidCallback deleteAction;
  final VoidCallback longAction;
  final bool isSelectMode;

  const MemoItem(
      {Key? key,
        required this.action, required this.longAction, required this.isSelectMode, required this.item, required this.deleteAction})
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
        onTap: widget.isSelectMode ? () {
          // 다른 줄과 사용 중일 때에는 () 사용 주의 !!!
          widget.deleteAction();

          setState(() {
            isChecked = !isChecked;
          });
        } : widget.action,
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
                          flex: 6,
                          child: Row(
                            children: [
                              Text(
                                widget.item.getTitle(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis
                                ),
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 11,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                SystemUtil.getDate(widget.item.getDate()),
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.text_fields_outlined,
                                size: 11,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.item.getRemoveHtmlTags().length.toString(),
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      child: Divider(
                        height: 1,
                        color: Colors.grey.withAlpha(50),
                      ),
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