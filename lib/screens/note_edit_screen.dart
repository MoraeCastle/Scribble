import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:keyboard_service/keyboard_service.dart';

/// 메인 씬
class NoteEditView extends StatefulWidget {
  const NoteEditView({super.key});

  @override
  State<NoteEditView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteEditView> {
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
                        child: const TextField(
                          style: TextStyle( // 입력 내용의 스타일 설정
                            fontSize: 12, // 폰트 크기
                            color: Colors.black, // 폰트 색상
                          ),
                          decoration: InputDecoration(
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle( // 입력 내용의 스타일 설정
                              color: Colors.black, // 폰트 색상
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none, // 테두리 없애기
                              hintText: '입력...',
                              hintStyle: TextStyle(
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                            ),
                          ),
                        ],
                      ),
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
}