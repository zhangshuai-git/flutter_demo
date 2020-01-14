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
    final wordBloc = WordProvider.of(context);
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
        // 在每一列之前，添加一个1像素高的分隔线widget
        if (i.isOdd) return Divider();
        // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
        // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
        final index = i ~/ 2;
//        print('i:$i, index: $index, pair: ${wordBloc.suggestions[index].wordPair}, isFavorite: ${wordBloc.suggestions[index].isFavorite.value}');
        if (index >= suggestions.length) {
          // ...接着再生成10个单词对，然后添加到建议列表
          suggestions.addAll(generateWordPairs().take(10).map((wordPair) => Word(wordPair, BehaviorSubject.seeded(false))));
        }
        return _buildRow(suggestions[index]);
//        return StreamBuilder<Word>(
//          stream: wordBloc.suggestions[index].stream,
//          builder: (BuildContext context, AsyncSnapshot<Word> snapshot) {
//            return _buildRow(wordBloc, snapshot.data, wordBloc.suggestions[index]);
//          },
//        );
      });

  Widget _buildRow(Word word) {
    return StreamBuilder<bool>(
        stream: word.isFavorite.stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//          print('pair: ${word.wordPair}, isFavorite: ${word.isFavorite.value}, snapshot.data: ${snapshot.data}');
          return ListTile(
            title: Text(
              word.wordPair.asPascalCase,
              style: const TextStyle(fontSize: 18.0),
            ),
            trailing: Icon(
              word.isFavorite.value ? Icons.favorite : Icons.favorite_border,
              color: word.isFavorite.value ? Colors.red : null,
            ),
            onTap: () => word.isFavorite.add(!word.isFavorite.value),
          );
        });
  }
}
