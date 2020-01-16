import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_demo1/bloc/word_bloc.dart';
import 'package:flutter_demo1/model/entity.dart';
import 'package:flutter_demo1/view/favorite_page.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatelessWidget {
  final WordBloc wordBloc = WordBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Startup Name Generator',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pushNamed(FavoritePage.routeName, arguments: wordBloc.favoriteList),
          )
        ],
      ),
      body: _buildListView(wordBloc.wordList),
    );
  }

  Widget _buildListView(List<Word> wordList) => ListView.builder(
//      itemCount: wordBloc.suggestions.length * 2,
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final int index = i ~/ 2;
        if (index >= wordList.length) {
          wordList.addAll(generateWordPairs().take(10).map((wordPair) => Word(wordPair, BehaviorSubject.seeded(false))));
        }
        return _buildRow(wordList[index]);
      });

  Widget _buildRow(Word word) => StreamBuilder<bool>(
      stream: word.isFavorite.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) => ListTile(
            title: Text(
              word.wordPair.asPascalCase,
              style: TextStyle(fontSize: 18.0),
            ),
            trailing: Icon(
              word.isFavorite.value ? Icons.favorite : Icons.favorite_border,
              color: word.isFavorite.value ? Colors.red : null,
            ),
            onTap: () => word.isFavorite.add(!word.isFavorite.value),
          ));
}
