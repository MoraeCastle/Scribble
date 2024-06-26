// 홈에서 탭들에서 접근 가능한 데이터 관리 클래스.
import 'package:flutter/foundation.dart';
import 'package:scribble/models/Memo.dart';
import 'package:scribble/screens/note_list_screen.dart';

class DataClass with ChangeNotifier {
  // 본 메모 데이터 리스트.
  late List<Memo> _memoList;

  // 검색이나 정렬 메모 데이터 리스트.
  late List<Memo> _searchMemoList;

  DataClass() {
    _memoList = [
    ];
    _searchMemoList = [];
  }

  // 데이터 접근자(getter)
  List<Memo> get memoList => _memoList;
  List<Memo> get searchMemoList => _searchMemoList;

  // 데이터 설정자(setter)
  set memoList(List<Memo> value) {
    _memoList = value;

    notifyListeners();
  }
  set searchMemoList(List<Memo> value) {
    _searchMemoList = value;

    notifyListeners();
  }
}
