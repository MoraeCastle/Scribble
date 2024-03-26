// 메모 아이템 객체
import 'package:intl/intl.dart';
import 'package:html/parser.dart' as htmlParser;

class Memo {
  late String title;
  late DateTime date;
  late String content;

  Memo() {
    title = '';
    date = DateTime.now();
    content = '';
  }

  setTitle(String value) {
    title = value;
  }
  String getTitle() {
    return title;
  }

  setDate(DateTime value) {
    date = value;
  }
  DateTime getDate() {
    return date;
  }

  setContent(String value) {
    content = value;
  }
  String getContent() {
    return content;
  }
  String getRemoveHtmlTags() {
    var document = htmlParser.parse(content);
    return document.body!.text;
  }
}
