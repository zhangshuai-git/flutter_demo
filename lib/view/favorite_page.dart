import 'package:flutter/material.dart';
import 'package:flutter_demo1/model/entity.dart';

class FavoritePage extends StatelessWidget {
  static const String routeName = '/favorite';

  @override
  Widget build(BuildContext context) {
    final List<Repository> favoriteList = ModalRoute.of(context).settings.arguments;
    final Iterable<ListTile> tiles = favoriteList.map((repository) => ListTile(
      title: Text(
        repository.name,
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
