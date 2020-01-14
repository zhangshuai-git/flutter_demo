import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_demo1/entity.dart';
import 'package:flutter_demo1/favorite_page.dart';
import 'package:flutter_demo1/word_bloc.dart';
import 'package:flutter_demo1/word_provider.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WordBloc wordBloc = WordProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () =>
                Navigator.of(context).pushNamed(FavoritePage.routeName),
          )
        ],
      ),
      body: _buildListView(wordBloc.suggestions),
    );
  }

  Widget _buildListView(List<Word> suggestions) => ListView.builder(
//      itemCount: wordBloc.suggestions.length * 2,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        if (index >= suggestions.length) {
          suggestions.addAll(generateWordPairs().take(10).map((wordPair) => Word(wordPair, BehaviorSubject.seeded(false))));
        }
        return _buildRow(suggestions[index]);
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
