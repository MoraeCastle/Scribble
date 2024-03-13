import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:keyboard_service/keyboard_service.dart';

/// 메인 씬
class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  bool isDeleteMode = false;

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
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      isDeleteMode ? deleteBar() : normalBar(),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                MemoItem(
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '조회된 메모가 없습니다.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey
                            ),
                          ),
                        ],
                      )
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
                side: BorderSide(color: Colors.black, width: 1),
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
        SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 9,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
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
                side: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            icon: Text(
              '탭해서 삭제',
              style: TextStyle(fontSize: 13, color: Colors.black),
            )
          ),
        ),
        SizedBox(
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
              side: BorderSide(color: Colors.black, width: 1),
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
  final VoidCallback action;
  final VoidCallback longAction;
  final bool isSelectMode;

  const MemoItem(
      {Key? key,
        required this.action, required this.longAction, required this.isSelectMode})
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
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                            flex: 6,
                            child: Container(
                                width: double.infinity,
                                child: const Text(
                                  '이 메모는 테스트 입니다.',
                                  style: TextStyle(
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
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '2024.03.21',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.text_fields_outlined,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '210',
                                    style: TextStyle(
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
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 10
                      ),
                      child: Text(
                        '아무렇게나 끄적거리는 메모는 정말 좋은 습관이다. 또한 이 앱은 오프라인으로, 기기 내에 저장되므로 좋다. 정말 좋은 습관이므로 모두 실천하자.',
                        maxLines: 3,
                        style: TextStyle(
                            color: Colors.grey,
                            overflow: TextOverflow.ellipsis
                        ),
                      ),
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