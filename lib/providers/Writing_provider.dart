import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_hub/model/Writing.dart';
import 'package:game_hub/data/database_helper.dart';

class WritingNotifier extends StateNotifier<List<Writing>> {
  WritingNotifier() : super([]) {
    getWritings();
  }

  Future<void> getWritings() async {
    final articles = await DatabaseHelper.instance.getAllArticles();
    state = articles.map((article) => Writing.fromMap(article)).toList();
  }

  Future<void> addWriting(Writing writing) async {
    await DatabaseHelper.instance.insertArticle(writing.toMap());
    await getWritings(); // 데이터 추가 후, 다시 데이터를 불러옵니다.
  }

  Future<void> deleteWriting(int id) async {
    await DatabaseHelper.instance.deleteArticle(id);
    await getWritings(); // 삭제 후, 다시 데이터를 불러옵니다.
  }
}

// 이 부분에서 writingProvider 정의
final writingProvider = StateNotifierProvider<WritingNotifier, List<Writing>>((ref) {
  return WritingNotifier();
});
