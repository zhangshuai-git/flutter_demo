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
      body: _buildListView(wordBloc),
    );
  }

  Widget _buildListView(WordBloc wordBloc) => ListView.builder(
      itemCount: wordBloc.suggestions.length * 2,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // 在每一列之前，添加一个1像素高的分隔线widget
        if (i.isOdd) return Divider();
        // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
        // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
        final index = i ~/ 2;
        print('i:$i, index: $index, pair: ${wordBloc.suggestions[index].wordPair}, isFavorite: ${wordBloc.suggestions[index].isFavorite.value}');
        return _buildRow(wordBloc, wordBloc.suggestions[index]);
//        return StreamBuilder<Word>(
//          stream: wordBloc.suggestions[index].stream,
//          builder: (BuildContext context, AsyncSnapshot<Word> snapshot) {
//            return _buildRow(wordBloc, snapshot.data, wordBloc.suggestions[index]);
//          },
//        );
      });

  Widget _buildRow(WordBloc wordBloc, Word word) {
    return StreamBuilder<bool>(
        stream: word.isFavorite.stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          print('pair: ${word.wordPair}, isFavorite: ${word.isFavorite.value}');
          return ListTile(
            title: Text(
              word.wordPair.asPascalCase,
              style: wordBloc.biggerFont,
            ),
            trailing: Icon(
              snapshot.data ? Icons.favorite : Icons.favorite_border,
              color: snapshot.data ? Colors.red : null,
            ),
            onTap: () => word.isFavorite.add(!snapshot.data),
          );
        });
  }
}
