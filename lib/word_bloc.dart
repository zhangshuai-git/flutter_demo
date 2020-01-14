import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/entity.dart';
import 'package:rxdart/rxdart.dart';

class WordBloc {
  final List<Word> suggestions = [];

  final Set<WordPair> saved = Set<WordPair>();

//  final TextStyle biggerFont = const TextStyle(fontSize: 18.0);

  void dispose() {
    suggestions.forEach((it) => it.isFavorite.close());
  }
}