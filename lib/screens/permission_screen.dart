import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:keyboard_service/keyboard_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scribble/service/routing_service.dart';
import 'package:scribble/utils/system_util.dart';
import 'package:scribble/utils/widgetBuilder.dart';
import 'package:url_launcher/url_launcher.dart';

/// 권한 요청 씬
class PermissionView extends StatefulWidget {
  const PermissionView({super.key});

  @override
  State<PermissionView> createState() => _PermissionViewState();
}

class _PermissionViewState extends State<PermissionView> {
  void permissionCheck() async {
    bool permission = await SystemUtil.requestPermission();

    // 권한을 승인하지 않는다면 안내.
    if (!permission) {
      if (await SystemUtil.isPermanentlyDenied()) {
        CustomDialog.doubleButton(context, Icons.warning_outlined, '안내', '거부한 권한을 허용하기 위해 설정으로 이동합니다.\n권한 탭을 확인해주세요.',
            null, '이동', () {
              SystemNavigator.pop();
              openAppSettings();
            }, '나가기', () {
              SystemNavigator.pop();
            }, true);
      } else {
        CustomDialog.doubleButton(context, Icons.warning_outlined, '안내', '메모앱을 사용하려면 권한을 허용해주세요.',
            null, '허용', () {
              Navigator.pop(context);
              permissionCheck();
            }, '나가기', () {
              SystemNavigator.pop();
            }, true);
      }

      return;
    }
    await SystemUtil.checkDirectory();

    // 씬 이동.
    Navigator.pushNamed(context, HomeViewRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                // color: Colors.green,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '권한 요청',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 15),
                      child: Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ),
                    const Text(
                      '앱을 사용하기 위해 아래의 권한이 필요합니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
                      child: Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                          ),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.folder_outlined,
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '폴더 접근',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                child: Divider(
                                  color: Colors.grey,
                                  height: 1,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                child: const Text(
                                  '- 메모 파일을 저장 및 수정하기 위해 사용됩니다.\n- 앱 삭제 시 메모 파일도 삭제됩니다.',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: OutlinedButton(
                  onPressed: () => permissionCheck(),
                  style: OutlinedButton.styleFrom(
                    // backgroundColor: Color.fromARGB(255, 159, 195, 255),
                    backgroundColor: Colors.white,
                    elevation: 10,
                    side: const BorderSide(
                        color: Colors.black,
                        width: 1
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}