import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_demo1/bloc/word_bloc.dart';
import 'package:flutter_demo1/model/entity.dart';
import 'package:flutter_demo1/service/network_service.dart';
import 'package:flutter_demo1/view/favorite_page.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatelessWidget {
  final WordBloc wordBloc = WordBloc();
  final BehaviorSubject<void> refreshFinished = BehaviorSubject.seeded(null);
  final BehaviorSubject<Repositories> newData = BehaviorSubject.seeded(Repositories());

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      brightness: Brightness.dark,
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

  Widget _buildListView(final List<Word> wordList) => StreamBuilder<void>(
    stream: MergeStream([refreshFinished.stream, newData.stream]),
    builder: (context, snapshot) => EasyRefresh(
      child: ListView.builder(
        itemCount: wordBloc.wordList.length * 2,
        padding: EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) return Divider();
          final int index = i ~/ 2;
          return _buildRow(wordList[index]);
        }),
//      onRefresh: () async {
//        await Future.delayed(Duration(seconds: 2), () {
//          wordList.removeRange(0, wordList.length);
//          wordList.addAll(generateWordPairs().take(10).map((wordPair) => Word(wordPair, BehaviorSubject.seeded(false))));
//          NetworkService.searchRepositories("zs").listen(
//              (it) => it.items.forEach(
//                  (it) => print(it.toJson())
//              )
//          );
//          refreshFinished.add(null);
//        });
//      },
      onRefresh: () async => NetworkService.searchRepositories("zs").listen((it) => newData.add(it)),
      onLoad: () async {
        await Future.delayed(Duration(seconds: 2), () {
          if (wordList.length < 30) {
            wordList.addAll(generateWordPairs().take(10).map((wordPair) => Word(wordPair, BehaviorSubject.seeded(false))));
          }
          refreshFinished.add(null);
        });
      },
      footer: ClassicalFooter(loadedText: wordList.length < 30 ? "Load completed" : "No more"),
    ),
  );

  Widget _buildRow(final Word word) => StreamBuilder<bool>(
    stream: word.isFavorite.stream,
    builder: (context, snapshot) => ListTile(
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
