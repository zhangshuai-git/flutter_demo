import 'package:english_words/english_words.dart';
import 'package:rxdart/rxdart.dart';

class Word {
  WordPair wordPair;
  BehaviorSubject<bool> isFavorite;

  Word(this.wordPair, this.isFavorite);
}
