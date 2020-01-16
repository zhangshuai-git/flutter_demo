import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  static const String routeName = '/favorite';

  @override
  Widget build(BuildContext context) {
    final Set<WordPair> favoriteList = ModalRoute.of(context).settings.arguments;
    final Iterable<ListTile> tiles = favoriteList.map((pair) => ListTile(
          title: Text(
            pair.asPascalCase,
            style: TextStyle(fontSize: 18.0),
          ),
        ));
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Saved Suggestions',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(children: divided),
    );
  }
}
