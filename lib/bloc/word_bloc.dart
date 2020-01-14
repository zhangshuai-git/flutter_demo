import 'package:english_words/english_words.dart';
import 'package:flutter_demo1/model/entity.dart';

class WordBloc {
  final List<Word> suggestions = [];

  Set<WordPair> get saved => suggestions
      .where((it) => it.isFavorite.value)
      .map((it) => it.wordPair)
      .toSet();

  void dispose() {
    suggestions.forEach((it) => it.isFavorite.close());
  }
}
