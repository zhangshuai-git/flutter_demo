import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class WordBloc {
  final List<WordPair> suggestions = List<WordPair>.from(generateWordPairs().take(30));

  final Set<WordPair> saved = Set<WordPair>();

  final TextStyle biggerFont = const TextStyle(fontSize: 18.0);
}