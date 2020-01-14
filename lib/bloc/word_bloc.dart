import 'package:english_words/english_words.dart';
import 'package:flutter_demo1/model/entity.dart';

class WordBloc {
  final List<Word> wordList = [];

  Set<WordPair> get favoriteList => wordList
      .where((it) => it.isFavorite.value)
      .map((it) => it.wordPair)
      .toSet();

  void dispose() {
    wordList.forEach((it) => it.isFavorite.close());
  }
}
