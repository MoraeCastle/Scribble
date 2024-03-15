// 홈에서 탭들에서 접근 가능한 데이터 관리 클래스.
import 'package:flutter/foundation.dart';
import 'package:scribble/models/Memo.dart';
import 'package:scribble/screens/note_list_screen.dart';

class DataClass with ChangeNotifier {
  // 데이터 필드들
  late List<Memo> _memoList;

  DataClass() {
    _memoList = [
    ];
  }

  // 데이터 접근자(getter)
  List<Memo> get memoList => _memoList;

  // 데이터 설정자(setter)
  set memoList(List<Memo> value) {
    _memoList = value;

    notifyListeners();
  }
}
