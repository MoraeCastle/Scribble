import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:keyboard_service/keyboard_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// 메인 씬
class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  bool isDeleteMode = false;
  String emailAddress = 'gotogetherqna@gmail.com';

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
                        '설정',
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
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // 테마 설정
                          /*Container(
                            height: 70,
                            margin: EdgeInsets.only(bottom: 10),
                            child: IconButton(
                              onPressed: () {
                              },
                              style: IconButton.styleFrom(
                                elevation: 5,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.grey,
                                surfaceTintColor: Colors.white,
                                padding: EdgeInsets.all(15),
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              icon: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.palette_outlined,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '테마 설정',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '라이트 모드',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ),*/
                          // 메모파일 폴더 이동
                          // 이 기능은 현재 메모파일이 앱 폴더 내에 있으므로 불가한 기능.
                          Visibility(
                            visible: false,
                            child: Container(
                              height: 70,
                              margin: EdgeInsets.only(bottom: 10),
                              child: IconButton(
                                  onPressed: () {
                                  },
                                  style: IconButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.grey,
                                    surfaceTintColor: Colors.white,
                                    padding: EdgeInsets.all(15),
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.black, width: 1),
                                    ),
                                  ),
                                  icon: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.folder_copy_outlined,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '저장된 메모파일로 이동하기',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ),
                          // 개발자 문의
                          Container(
                            height: 70,
                            child: IconButton(
                                onPressed: () => contactUs(),
                                style: IconButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.grey,
                                  surfaceTintColor: Colors.white,
                                  padding: EdgeInsets.all(15),
                                  shadowColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.black, width: 1),
                                  ),
                                ),
                                icon: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.mail_outline,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          '개발자에게 문의하기',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
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

  /// 문의하기.
  contactUs() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: encodeQueryParameters(<String, String>{
        'subject': '끄적끄적 - 문의',
        'body': '문의 내용: ',
      }),
    );

    launchUrl(emailLaunchUri);
  }
}