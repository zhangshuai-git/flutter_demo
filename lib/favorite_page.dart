import 'package:flutter/material.dart';
import 'package:flutter_demo1/word_bloc.dart';
import 'package:flutter_demo1/word_provider.dart';

class FavoritePage extends StatelessWidget {

  static const String routeName = '/favorite';

  @override
  Widget build(BuildContext context) {
    final WordBloc wordBloc = WordProvider.of(context);
    final Iterable<ListTile> tiles = wordBloc.saved.map((pair) => ListTile(
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
        title: Text('Saved Suggestions'),
      ),
      body: ListView(children: divided),
    );
  }
}
