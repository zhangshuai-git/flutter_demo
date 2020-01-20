import 'package:english_words/english_words.dart';
import 'package:flutter_demo1/model/entity.dart';
import 'package:rxdart/rxdart.dart';

class WordBloc {
  final List<Word> wordList = List<Word>.from(generateWordPairs().take(10).map((wordPair) => Word(wordPair, BehaviorSubject.seeded(false))));

  Set<WordPair> get favoriteList => wordList
    .where((it) => it.isFavorite.value)
    .map((it) => it.wordPair)
    .toSet();
}
